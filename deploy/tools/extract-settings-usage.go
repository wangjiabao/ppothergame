package main

import (
 "encoding/json"
 "go/ast"
 "go/parser"
 "go/token"
 "os"
 "strconv"
)

type Site struct { Repo string `json:"repo"`; Method string `json:"method"`; Line int `json:"line"`; Field string `json:"field,omitempty"` }
type Read struct { Key string `json:"key"`; Site Site `json:"site"` }
type Result struct { Fields map[string][]Site `json:"fields"`; ConfigReads []Read `json:"config_reads"`; ConfigQueries []Read `json:"config_queries"`; Ranges map[string][2]int `json:"function_ranges"` }
type Extractor struct { fset *token.FileSet; repo, method string; out *Result; columns map[string]map[string]string; seen map[string]bool }
var types = map[string]string{"SeedInfo":"seed_info", "LandInfo":"land_info", "PropInfo":"prop_info", "RandomSeed":"random_seeds", "StakeGetTotal":"stake_get_total", "Admin":"admin", "AdminMessage":"admin_message"}
var calls = map[string]string{"GetAllSeedInfo":"seed_info", "GetLandInfoByLevels":"land_info", "GetLandInfo":"land_info", "GetAllPropInfo":"prop_info", "GetAllRandomSeeds":"random_seeds", "GetStakeGetTotal":"stake_get_total", "GetAdminMessages":"admin_message", "GetAdminByAccount":"admin"}
func clone(e map[string]string) map[string]string { n:=map[string]string{}; for k,v:=range e {n[k]=v}; return n }
func typ(x ast.Expr) string { switch v:=x.(type) {case *ast.Ident:return types[v.Name];case *ast.StarExpr:return typ(v.X);case *ast.ArrayType:return typ(v.Elt);case *ast.MapType:return typ(v.Value)};return "" }
func infer(x ast.Expr,e map[string]string) string {switch v:=x.(type) {case *ast.Ident:return e[v.Name];case *ast.IndexExpr:return infer(v.X,e);case *ast.ParenExpr:return infer(v.X,e);case *ast.UnaryExpr:return infer(v.X,e);case *ast.CompositeLit:return typ(v.Type);case *ast.CallExpr:if s,ok:=v.Fun.(*ast.SelectorExpr);ok{return calls[s.Sel.Name]};if n,ok:=v.Fun.(*ast.Ident);ok&&n.Name=="make"&&len(v.Args)>0{return typ(v.Args[0])}};return ""}
func (a *Extractor) site(p token.Pos) Site {return Site{Repo:a.repo,Method:a.method,Line:a.fset.Position(p).Line}}
func (a *Extractor) inspect(n ast.Node,e map[string]string) {
 if n==nil{return};ast.Inspect(n,func(n ast.Node)bool {
  if s,ok:=n.(*ast.SelectorExpr);ok {table:=infer(s.X,e);if col:=a.columns[table][s.Sel.Name];col!="" {site:=a.site(s.Pos());site.Field=s.Sel.Name;k:=table+"."+col;dedup:=k+a.repo+a.method+strconv.Itoa(site.Line);if !a.seen[dedup] {a.seen[dedup]=true;a.out.Fields[k]=append(a.out.Fields[k],site)}}}
  if c,ok:=n.(*ast.CallExpr);ok {if s,ok:=c.Fun.(*ast.SelectorExpr);ok&&s.Sel.Name=="GetConfigByKeys" {for _,arg:=range c.Args {if lit,ok:=arg.(*ast.BasicLit);ok&&lit.Kind==token.STRING {key,err:=strconv.Unquote(lit.Value);if err==nil {a.out.ConfigQueries=append(a.out.ConfigQueries,Read{Key:key,Site:a.site(c.Pos())})}}}}}
  return true
 })
}
func (a *Extractor) block(b *ast.BlockStmt,e map[string]string) {if b==nil{return};for _,s:=range b.List {a.stmt(s,e)}}
func (a *Extractor) stmt(s ast.Stmt,e map[string]string) {
 switch v:=s.(type) {
 case *ast.DeclStmt:
  if d,ok:=v.Decl.(*ast.GenDecl);ok {for _,spec:=range d.Specs {if value,ok:=spec.(*ast.ValueSpec);ok {for i,n:=range value.Names {t:=typ(value.Type);if t==""&&i<len(value.Values){t=infer(value.Values[i],e)};if t!=""{e[n.Name]=t}};for _,x:=range value.Values {a.inspect(x,e)}}}}
 case *ast.AssignStmt:
  for _,x:=range v.Rhs {a.inspect(x,e)};for i,x:=range v.Lhs {if n,ok:=x.(*ast.Ident);ok {if i<len(v.Rhs){if t:=infer(v.Rhs[i],e);t!=""{e[n.Name]=t}}}else{a.inspect(x,e)}}
 case *ast.RangeStmt:
  a.inspect(v.X,e);n:=clone(e);if id,ok:=v.Value.(*ast.Ident);ok {n[id.Name]=infer(v.X,e)};a.block(v.Body,n)
 case *ast.IfStmt:
  n:=clone(e);if v.Init!=nil{a.stmt(v.Init,n)};a.inspect(v.Cond,n)
  ast.Inspect(v.Cond,func(node ast.Node)bool {if b,ok:=node.(*ast.BinaryExpr);ok&&b.Op==token.EQL {for _,pair:=range [][2]ast.Expr{{b.X,b.Y},{b.Y,b.X}} {lit,lok:=pair[0].(*ast.BasicLit);sel,sok:=pair[1].(*ast.SelectorExpr);if lok&&sok&&lit.Kind==token.STRING&&sel.Sel.Name=="KeyName" {key,err:=strconv.Unquote(lit.Value);if err==nil{a.out.ConfigReads=append(a.out.ConfigReads,Read{Key:key,Site:a.site(v.Pos())})}}}};return true})
  a.block(v.Body,clone(n));if v.Else!=nil{a.stmt(v.Else,clone(n))}
 case *ast.ForStmt:
  n:=clone(e);if v.Init!=nil{a.stmt(v.Init,n)};a.inspect(v.Cond,n);a.block(v.Body,n);if v.Post!=nil{a.stmt(v.Post,n)}
 case *ast.BlockStmt:a.block(v,clone(e))
 case *ast.SwitchStmt:
  n:=clone(e);if v.Init!=nil{a.stmt(v.Init,n)};a.inspect(v.Tag,n);for _,s:=range v.Body.List {c:=s.(*ast.CaseClause);for _,x:=range c.List {a.inspect(x,n)};inner:=clone(n);for _,x:=range c.Body {a.stmt(x,inner)}}
 default:a.inspect(s,e)
 }
}
func main(){
 if len(os.Args)!=3 {panic("usage: extract-settings-usage columns.json output.json")}
 var basis struct{Columns []struct{Table string `json:"table"`;Column string `json:"column"`;Sources []struct{Field string `json:"field"`} `json:"model_sources"`} `json:"columns"`}
 b,err:=os.ReadFile(os.Args[1]);if err!=nil{panic(err)};if err=json.Unmarshal(b,&basis);err!=nil{panic(err)}
 out:=Result{Fields:map[string][]Site{}, Ranges:map[string][2]int{}};cols:=map[string]map[string]string{}
 for _,c:=range basis.Columns {if cols[c.Table]==nil{cols[c.Table]=map[string]string{}};for _,s:=range c.Sources{cols[c.Table][s.Field]=c.Column}}
 for _,repo:=range []string{"ppothergame","ppothergameadmin"}{file:="/Users/wangjiabao/Documents/"+repo+"/internal/biz/app.go";fset:=token.NewFileSet();node,err:=parser.ParseFile(fset,file,nil,0);if err!=nil{panic(err)};a:=Extractor{fset:fset,repo:repo,out:&out,columns:cols,seen:map[string]bool{}};for _,d:=range node.Decls {if f,ok:=d.(*ast.FuncDecl);ok&&f.Body!=nil {a.method=f.Name.Name;out.Ranges[repo+":"+a.method]=[2]int{fset.Position(f.Pos()).Line,fset.Position(f.End()).Line};a.block(f.Body,map[string]string{})}}}
 b,err=json.MarshalIndent(out,"","  ");if err!=nil{panic(err)};if err=os.WriteFile(os.Args[2],append(b,'\n'),0644);err!=nil{panic(err)}
}
