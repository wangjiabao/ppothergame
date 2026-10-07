import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
import { Workbook, SpreadsheetFile } from '@oai/artifact-tool';

const root='/Users/wangjiabao/Documents/ppothergame/deploy';
const out=`${root}/outputs/01a0fb64-2725-7363-bf84-c8e9bf3f28d4`;
const preview=`${root}/tools/workbook-previews`;
const data=JSON.parse(await fs.readFile(`${root}/待确认参数表单_20261003.json`,'utf8'));
await fs.mkdir(out,{recursive:true});
await fs.mkdir(preview,{recursive:true});
const wb=Workbook.create();
const main=wb.worksheets.add('参数确认');
const code=wb.worksheets.add('代码与表说明');
const ink='#263247',navy='#203B61',amber='#FFF2CC';
function base(sheet,range,widths,title){
  sheet.showGridLines=false;
  sheet.getRange(range).format.font={name:'Arial',size:10,color:ink};
  sheet.getRange(range).format.verticalAlignment='center';
  sheet.getRange(range).format.rowHeight=24;
  for(const [col,width] of Object.entries(widths))sheet.getRange(`${col}1:${col}${range.match(/\d+$/)[0]}`).format.columnWidth=width;
  sheet.getRange('A2').values=[[title]];
  sheet.getRange('A2').format.font={name:'Arial',size:16,bold:true,color:navy};
  sheet.getRange('A2').format.rowHeight=30;
  sheet.getRange('A3:H3').format.borders={bottom:{style:'thin',color:'#CBD5E1'}};
}
function header(sheet,range){
  sheet.getRange(range).format={fill:navy,font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},horizontalAlignment:'center',verticalAlignment:'center',rowHeight:32};
  sheet.getRange(range).format.borders={insideVertical:{style:'thin',color:'#FFFFFF'}};
}
function numberIfActual(value,row){
  if(row.group!=='config' && typeof value==='string' && /^-?\d+(\.\d+)?$/.test(value))return Number(value);
  return value ?? '';
}
base(main,'A1:P299',{A:14,B:12,C:23,D:21,E:35,F:20,G:29,H:34,I:65,J:60,K:44,L:85,M:64,N:34,O:13,P:22},'游戏参数确认表（2026-10-03）');
main.tabColor=navy;
main.getRange('A4:B4').values=[['总字段数',data.rows.length]];
main.getRange('D4:E4').values=[['已确认',null]];
main.getRange('G4:H4').values=[['暂不启用',null]];
main.getRange('J4:K4').values=[['待确认',null]];
main.getRange('E4').formulas=[['=COUNTIFS(A10:A299,"已确认")']];
main.getRange('H4').formulas=[['=COUNTIFS(A10:A299,"暂不启用")']];
main.getRange('K4').formulas=[['=COUNTIFS(A10:A299,"待确认")']];
main.getRange('B4').setNumberFormat('0');
main.getRange('A5').values=[['填写黄色列“确认值”，再选择确认状态。当前值来自恢复 SQL，未读取线上数据库。表单不连接数据库。']];
main.getRange('A6').values=[['config 120 项（104 项有读取分支，16 项仅查询）。种子 50、土地 60、道具 40、其他 20。']];
main.getRange('A7').values=[['来源：08_restore_all_for_baota.sql；App 与后台 internal/biz/app.go；后台 internal/service/app.go。逐项方法和单位见 I、J 列。']];
main.getRange('A5:A7').format.font={name:'Arial',size:10,italic:true,color:'#526277'};
const headings=['确认状态','分类','确认时点','表名','记录定位','字段','恢复 SQL 当前值','你确认后的值','biz 方法／写入方法','类型、单位及换算','用途','需要确认的细节','修改入口','SQL 变量','模板 ID','源码使用状态'];
const rows=data.rows.map(r=>['待确认',r.group,r.priority,r.table,r.record,r.field,numberIfActual(r.current,r),r.sensitive?'请在数据库设置，表单不填写密码':'',r.methods.length?r.methods.join('\n'):'未发现当前 biz 直接使用，见细节说明',r.type,r.purpose,r.notes,r.change,r.sql_variable||'',r.template_id??'',r.status||'']);
main.getRange('A9:P299').values=[headings,...rows];
main.tables.add('A9:P299',true,'SettingsConfirmation');
header(main,'A9:P9');
main.getRange('A10:P299').format.wrapText=true;
main.getRange('A10:P299').format.verticalAlignment='top';
main.getRange('A10:A299').format.fill=amber;
main.getRange('H10:H299').format.fill=amber;
main.getRange('G10:G299').setNumberFormat('0.####################');
main.getRange('O10:O299').setNumberFormat('0');
main.getRange('A10:A299').dataValidation={rule:{type:'list',values:['待确认','已确认','暂不启用']}};
main.getRange('A10:A299').conditionalFormats.addCustom('$A10="已确认"',{fill:'#E2E8F0',font:{color:'#334155'}});
main.getRange('A10:A299').conditionalFormats.addCustom('$A10="暂不启用"',{fill:'#F1F5F9',font:{color:'#64748B'}});
for(let i=0;i<rows.length;i++){
  const row=rows[i];
  const lines=Math.max(...row.map((v,j)=>String(v).split('\n').reduce((n,x)=>n+Math.max(1,Math.ceil([...x].length/(Object.values({A:14,B:12,C:23,D:21,E:35,F:20,G:29,H:34,I:65,J:60,K:44,L:85,M:64,N:34,O:13,P:22})[j]*.65))),0)));
  main.getRange(`A${i+10}:P${i+10}`).format.rowHeight=Math.max(44,lines*15+10);
}
main.freezePanes.freezeRows(9);
main.freezePanes.freezeColumns(3);

base(code,'A1:G63',{A:25,B:58,C:29,D:62,E:62,F:105,G:18},'后端待调整项与 38 张表说明');
code.getRange('A4').values=[['先调整扫描地址及最低金额，再检查扫描起点与单笔入账。下列项目未自动修改后端源码。']];
code.getRange('A5').values=[['来源：当前两份 Go 后端、App 前端和 08 恢复 SQL。位置与业务方法均以本次静态核对为准。']];
code.getRange('A4:A5').format.font={name:'Arial',size:10,italic:true,color:'#526277'};
code.getRange('D8:E18').setNumberFormat('@');
const codeRows=data.manual.map(r=>[r.item,r.location,r.method,r.current,r.target,r.note].map(v=>/^0x[0-9a-fA-F]{40}$/.test(v)?`合约地址：${v}`:v));
code.getRange('A7:F18').values=[['待调整项','文件位置','对应方法','当前状态／当前值','目标／需要确定','具体说明'],...codeRows];
code.tables.add('A7:F18',true,'CodeChanges');
header(code,'A7:F7');
code.getRange('A8:F18').format.wrapText=true;
code.getRange('A8:F18').format.verticalAlignment='top';
for(let i=0;i<codeRows.length;i++){
  const widths=[25,58,29,62,62,105];
  const lines=Math.max(...codeRows[i].map((v,j)=>Math.ceil([...v].length/(widths[j]*.6))));
  code.getRange(`A${i+8}:F${i+8}`).format.rowHeight=Math.max(44,lines*15+10);
}
code.getRange('A21').values=[['恢复 SQL 的 38 张表']];
code.getRange('A21').format.font={name:'Arial',size:14,bold:true,color:navy};
code.getRange('A23:C61').values=[['表名','初始化／处理方式','字段数'],...data.inventory.map(r=>[r.table,r.handling,r.columns])];
code.tables.add('A23:C61',true,'TableInventory');
header(code,'A23:C23');
code.getRange('A24:C61').format.wrapText=true;
code.getRange('A24:C61').format.rowHeight=44;
code.getRange('C24:C61').setNumberFormat('0');
code.getRange('A63').values=[['填写后的参数不会覆盖既有数据库记录。现有记录按 key_name、等级、类型等定位后手动 UPDATE。']];
code.freezePanes.freezeRows(7);
code.freezePanes.freezeColumns(1);

// Check an actual status edit affects the summary, then restore the delivered blank confirmation state.
main.getRange('A10').values=[['已确认']];
assert.equal(main.getRange('E4').values[0][0],1);
main.getRange('A10').values=[['待确认']];
wb.recalculate();
assert.equal(main.getRange('B4').values[0][0],290);
assert.equal(main.getRange('E4').values[0][0],0);
assert.equal(main.getRange('H4').values[0][0],0);
assert.equal(main.getRange('K4').values[0][0],290);
assert.equal(rows.length,290);
assert.equal(data.manual.length,11);
assert.equal(data.inventory.length,38);
console.log((await wb.inspect({kind:'table',range:'参数确认!A4:K4',include:'values,formulas',tableMaxRows:1,tableMaxCols:11,maxChars:2200})).ndjson);
console.log((await wb.inspect({kind:'match',searchTerm:'#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A|#NUM!|#NULL!|#SPILL!|#CALC!',options:{useRegex:true,maxResults:20},summary:'formula error scan',maxChars:2000})).ndjson);
for(const [sheetName,range,name] of [['参数确认','A2:H12','parameters-left'],['参数确认','I9:K12','parameters-detail'],['参数确认','L9:M12','parameters-notes'],['代码与表说明','A7:C11','code-locations'],['代码与表说明','D7:E11','code-addresses'],['代码与表说明','F7:F11','code-detail'],['代码与表说明','A21:C27','table-inventory']]){
  const image=await wb.render({sheetName,range,scale:1.5,format:'png'});
  await fs.writeFile(`${preview}/${name}.png`,new Uint8Array(await image.arrayBuffer()));
}
await (await SpreadsheetFile.exportXlsx(wb)).save(`${out}/待确认参数表单_20261003.xlsx`);
console.log(JSON.stringify({output:`${out}/待确认参数表单_20261003.xlsx`,fields:rows.length,manual:data.manual.length,tables:data.inventory.length}));
