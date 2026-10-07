const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const read = p => fs.readFileSync(path.join(root, p), 'utf8');
const configs = JSON.parse(read('sql/06_config_records.json'));
const usage = JSON.parse(read('settings-usage-20261003.json'));
const basis = JSON.parse(read('sql/13_字段恢复依据.json'));
const sql = read('sql/08_restore_all_for_baota.sql');
const values = Object.fromEntries([...sql.matchAll(/^SET @(\w+)\s*=\s*(.+?);\s*$/gm)].map(m => [m[1], m[2]]));
const rows = [];
const unique = xs => [...new Set(xs)];
const repoLabel = r => r === 'ppothergame' ? 'App' : '后台';
const methods = sites => unique(sites.map(s => repoLabel(s.repo) + '：' + (s.method || s.function)));
const normalize = xs => unique(xs.map(s => s.repo + ':' + (s.method || s.function))).sort();
const queried = unique(usage.config_queries.map(s => s.key)).sort();
if (JSON.stringify(queried) !== JSON.stringify(configs.records.map(r => r.key_name).sort())) throw Error('Config key coverage changed');
for (const c of configs.records) {
  if (JSON.stringify(normalize(usage.config_reads.filter(s => s.key === c.key_name).map(s => s.site))) !== JSON.stringify(normalize(c.read_sites))) throw Error('Config usage changed: ' + c.key_name);
}

const descriptions = {
 box_start:'盲盒购买开始时间', box_end:'盲盒购买结束时间', box_amount:'盲盒金额参数',
 box_num:'盲盒数量/购买数量参数', box_max:'盲盒数量上限参数', box_sell_num:'盲盒已售数量计数',
 u_price:'u_price 定价/换算参数', all_each:'每日奖励全局分配参数', b_price:'UserInfo 返回的 b_price 价格展示参数',
 can_withdraw:'提现开关：1 允许，其他值被 Withdraw 拒绝',
 exchange_fee_rate:'兑换手续费参数', exchange_fee_rate_two:'第二组兑换手续费展示参数',
 exchange_max_three:'第三组兑换金额上限展示参数', exchange_min_three:'第三组兑换金额下限展示参数',
 exchange_price:'旧兑换定价参数', exchange_price_open:'旧兑换定价开关', exchange_stake_rate:'旧兑换质押比例参数',
 exchange_three:'旧兑换第三组参数', exchange_three_rate:'第三组兑换比例展示参数',
 low_reward_u:'旧奖励下限参数', max_play:'粮仓游戏单次最大金额', min_play:'粮仓游戏单次最小金额',
 max_stake:'粮仓质押最大金额', min_stake:'粮仓质押下限参数', min_stake_two:'粮仓另一操作的下限参数',
 one:'UserInfo 返回的 one 参数', two:'UserInfo 返回的 two 参数', three:'UserInfo 返回的 three 参数',
 one_rate_new:'USDT 充值奖励中的 oneRate 参数', open_box_price:'旧开盒价格参数', open_box_price_use:'旧开盒价格使用参数',
 play_one_rate:'种植事件参数 playOneRate', play_two_rate:'种植事件参数 playTwoRate',
 prop_two_two:'App 铲子结算比例：LandPlaySix 直接乘此值', queue_amount:'质押队列金额参数',
 recommend:'BuyTwo 购买推荐奖励参数', recommend_two:'每日推荐奖励参数', recommend_two_sub:'每日推荐奖励扣减参数',
 reward_land:'管理员土地奖励参数', reward_stake_rate:'后台 UserInfo 的质押奖励展示参数',
 s_rate:'收获、铲子、手套结算的乘法系数', self_sub:'结算扣减模式：代码以 selfSub==1 判断',
 sell_fee_rate:'交易市场买入/卖出手续费系数', sell_land:'土地出售开关：0 被 Sell 拒绝',
 stake_over_rate:'粮仓游戏结束/收益分配比例参数', stake_price:'ISPAY 固定价格，开启固定价时用作除数',
 stake_price_on:'ISPAY 固定价开关：1 使用 stake_price，否则读取链上价格', stake_rate_new:'StakeGit 质押参数',
 sys_content:'UserInfo 返回的中文系统文案', sys_content_e:'UserInfo 返回的英文系统文案',
 two_sub_reward:'LandPlayFour 除虫相关收益参数', win_rate:'粮仓游戏随机胜率参数',
 withdraw_amount_max:'旧后台提现最大金额', withdraw_amount_min:'旧后台提现最小金额',
 withdraw_amount_max_three:'App 第三种提现金额上限', withdraw_amount_min_three:'App 第三种提现金额下限',
 withdraw_amount_max_two:'App 第二种提现金额上限', withdraw_amount_min_two:'App 第二种提现金额下限',
 withdraw_rate:'旧提现比例参数', withdraw_rate_three:'App 第三种提现比例', withdraw_rate_two:'App 第二种提现比例',
};
const chinese = {zero:'0',one:'1',two:'2',three:'3',four:'4',five:'5',six:'6',seven:'7',eight:'8',nine:'9',ten:'10'};
function describe(k) {
 if (descriptions[k]) return descriptions[k];
 let m;
 if ((m=k.match(/^v_(\d+)$/))) return '第 '+m[1]+' 级用户/团队门槛参数';
 if ((m=k.match(/^g_(\d+)$/))) return '第 '+m[1]+' 档排行榜展示与每日结算参数';
 if ((m=k.match(/^rate_r_(\d+)$/))) return 'USDT 充值第 '+m[1]+' 级推荐奖励参数';
 if ((m=k.match(/^area_(\w+)$/))) return '每日区域第 '+chinese[m[1]]+' 档参数';
 if ((m=k.match(/^buy_(one|two|three|four|five|six|seven|eight)$/))) return '每日买入第 '+chinese[m[1]]+' 档参数';
 if ((m=k.match(/^buy_land_(\w+)$/))) return '购买土地第 '+chinese[m[1]]+' 组分配参数';
 if ((m=k.match(/^rent_rate_(\w+)$/))) return '出租土地第 '+chinese[m[1]]+' 组比例参数';
 if ((m=k.match(/^(one|two|three)_rate$/))) return '后台收获/铲子第 '+chinese[m[1]]+' 组推荐比例';
 if ((m=k.match(/^stake_ispay_(\w+)$/))) return 'ISPAY 质押第 '+chinese[m[1]]+' 组参数';
 if ((m=k.match(/^stake_recommend_(\w+)$/))) return '旧质押推荐第 '+chinese[m[1]]+' 组参数';
 throw Error('Missing description: '+k);
}
const sources = Object.fromEntries(['ppothergame','ppothergameadmin'].map(repo => [repo,fs.readFileSync('/Users/wangjiabao/Documents/'+repo+'/internal/biz/app.go','utf8').split('\n')]));
function evidence(c) {
 const snippets=[];
 for(const s of c.read_sites) {
  const match=s.body.match(/\b([A-Za-z]\w*)\s*(?:,\s*_)?\s*=\s*(?:strconv\.|vConfig\.Value)/);
  if(!match)continue;
  const variable=match[1],range=usage.function_ranges[s.repo+':'+s.function];
  if(!range)throw Error('Missing function range');
  const matches=[];
  for(let line=range[0];line<=range[1];line++){
   const text=sources[s.repo][line-1].trim();
   if(text.startsWith('//')||!new RegExp('\\b'+variable+'\\b').test(text)||text.includes('strconv.')||text.includes('vConfig.Value'))continue;
   if(/[*/<>=]/.test(text)&&!/^\w+\s+(?:float64|uint64|string)/.test(text))matches.push({line,text});
  }
  snippets.push({repo:s.repo,method:s.function,variable,parser:s.body.trim(),references:matches.slice(0,4)});
 }
 return snippets;
}
for(const c of configs.records) {
 const k=c.key_name,active=c.read_sites.length>0,notes=[];
 if(!active)notes.push('当前只有查询参数，没有有效 value 读取分支；仅填值不会让旧逻辑生效。');
 if(c.id_basis!=='代码固定对应关系')notes.push('ID 为恢复模板新分配，非历史 ID；修改已有库时优先按 key_name 定位。');
 if(k==='rate_r_9')notes.push('DepositNewTwo 中对应分支重复比较 rate_r_8；不能靠填写 rate_r_9 修复。');
 if(/^rent_rate_(two|three)$/.test(k)||['b_price','one','two','three','exchange_fee_rate_two','exchange_max_three','exchange_min_three','exchange_three_rate','stake_ispay_one','reward_stake_rate'].includes(k))notes.push('当前主要/仅用于 UserInfo 展示，不能仅凭名称认定参与当前 App 结算。');
 if(k==='box_start'||k==='box_end')notes.push('代码按 UTC 解析 YYYY-MM-DD HH:MM:SS；需确保结束时间晚于开始时间。');
 if(k==='box_sell_num')notes.push('这是已售计数，BuyBox 会更新；空库起点由你确认，运行后不要随意重置。');
 if(k==='stake_price')notes.push('stake_price_on=1 时需大于 0；该值会参与开盒、质押与 USDT 充值推荐奖励换算。');
 if(k==='prop_two_two')notes.push('App LandPlaySix 用此 config 值；后台 LandPlaySix 使用发放到 prop.two_two 的模板值，二者不是同一来源。');
 if(k==='withdraw_amount_min_two'||k==='withdraw_amount_max_two')notes.push('部分位置按无符号整数读取，部分按小数；跨功能统一时先确认是否使用整数。');
 notes.push('比例/金额单位以本行代码片段为准，不统一按百分数猜测；业务正式值由你确定。');
 const critical=active&&(c.read_sites.some(s=>['DepositNewTwo','BuyBox','OpenBox','LandPlayOne','LandPlayTwo','LandPlaySix','LandPlaySeven','Withdraw','StakeGet','StakeGetPlay','GetLand'].includes(s.function))||k==='u_price');
 rows.push({uid:'config:'+k,group:'config',priority:!active?'按需保留':critical?'上线前确认':'对应功能启用前',table:'config',record:'key_name='+k,field:'value',template_id:c.id,sql_variable:'@cfg_'+k,purpose:describe(k),type:c.read_types.join('；'),current:'未插入（'+values['cfg_'+k]+' 跳过）',template_value:null,methods:methods(c.read_sites),query_methods:methods(c.query_sites),change:'首次导入修改 08 的 '+('@cfg_'+k)+'；已存在记录按 key_name UPDATE；缺失记录参考 04/08 的条件 INSERT。',notes:notes.join(' '),evidence:evidence(c),name_current:c.name,id_basis:c.id_basis,status:active?'有读取分支':'仅查询，无读取分支'});
}
function fieldSites(table,column) {
 const sites=[...(usage.fields[table+'.'+column]||[])];
 const col=basis.columns.find(c=>c.table===table&&c.column===column);
 for(const w of col?.explicit_writes||[])for(const route of w.routes||[])for(const node of route)if(node.file==='internal/biz/app.go')sites.push({repo:node.repo,method:node.func,line:node.line});
 return sites;
}
const catalog = {
 seed:{table:'seed_info',group:'种子',ids:Array.from({length:10},(_,i)=>i+1),selector:'id',fields:{name:['种子发放时复制的名称','文字，最长45字符'],out_min_amount:['种子随机产出基值下限','先转 int64，含下限'],out_max_amount:['种子随机产出基值上限','先转 int64，不含上限'],get_rate:['盲盒种子相对权重','权重；会归一化，不是百分数'],out_over_time:['种子成熟时长','秒']}},
 land:{table:'land_info',group:'土地',ids:Array.from({length:10},(_,i)=>i+1),selector:'level',fields:{out_put_rate_max:['新土地增产系数上限','代码直接相乘，未除以100'],out_put_rate_min:['新土地增产系数下限','随机系数先转 int64'],rent_out_put_rate_max:['预留出租产出比率','未发现当前 biz 字段读取'],max_health:['新土地初始肥沃度','无符号整数'],per_health:['每次种植消耗肥沃度','无符号整数'],limit_date_max:['新土地使用期限','天；代码乘3600×24']}},
 prop:{table:'prop_info',group:'道具',ids:[11,12,13,14,15],selector:'prop_type',fields:{one_one:['化肥预留参数','复制到道具；未见 OneOne 消耗逻辑'],one_two:['化肥缩短成熟时间','秒'],two_one:['铲子使用次数','无符号整数'],two_two:['铲子结算比例模板','后台直接相乘；App 使用 config.prop_two_two'],three_one:['水使用次数','无符号整数'],four_one:['除虫剂使用次数','无符号整数'],five_one:['手套使用次数','无符号整数'],get_rate:['盲盒道具相对权重','App 当前不把道具加入盲盒池']}},
};
const seedNames=['西红柿','哈密瓜','葡萄','橘子树','芒果树','苹果树','柚子','椰子树','枣椰树','红杉'];
const propNames={11:'化肥',12:'水',13:'手套',14:'除虫剂',15:'铲子'};
for(const [prefix,c] of Object.entries(catalog))for(const id of c.ids)for(const [field,[purpose,type]] of Object.entries(c.fields)){
 const variable=prefix+'_'+id+'_'+field;
 if(!(variable in values))throw Error('Missing SQL variable '+variable);
 const value=values[variable],sites=fieldSites(c.table,field),notes=[];
 const writable=basis.columns.find(x=>x.table===c.table&&x.column===field)?.explicit_writes.some(x=>(x.routes||[]).some(r=>r.some(n=>n.file==='internal/biz/app.go')));
 if(prefix==='seed')notes.push('ID 1~10 与盲盒编号、前端图片对应，保留编号。改模板影响后续发放，不回写已有 seed。');
 if(prefix==='seed'&&field==='name')notes.push('前端现有词条为“'+seedNames[id-1]+'”，这是可参照的名称，不是恢复出来的原库名称。');
 if(prefix==='seed'&&field==='get_rate')notes.push('App 当前仅10种种子且权重都为1时，每种归一化概率为10%；启用道具池后分母会变化。');
 if(prefix==='seed'&&/out_(min|max)_amount/.test(field))notes.push('1/3 当前随机得到整数1或2；请确认范围及产出单位。');
 if(prefix==='land')notes.push('level 保留1~10；100系数乘种子基值1或2得到种植产出上限100或200，最终收获还受结算参数影响。已有 land 不自动回写。');
 if(prefix==='prop'){
  notes.push('同一行保留全部效果字段，相应 prop_type 只使用对应效果；改模板不回写已有 prop。App 道具盲盒池读取被注释。');
  const relevant={11:['one_one','one_two','get_rate'],12:['three_one','get_rate'],13:['five_one','get_rate'],14:['four_one','get_rate'],15:['two_one','two_two','get_rate']}[id];
  if(!relevant.includes(field))notes.push('此字段不是本种道具的主要参数，属于复制保留字段。');
  if(field==='one_two'&&id===11)notes.push('14400秒=4小时；目前种子成熟300秒，确认是否希望使用化肥后立即成熟。使用方法 LandPlayThree。');
  if(field==='two_two'&&id===15)notes.push('后台 LandPlaySix 直接乘20会表示20倍，并非20%；必须确认正式比例。App 对应值另在 config.prop_two_two。');
  const consumer={one_two:'LandPlayThree',two_one:'LandPlaySix',two_two:'后台 LandPlaySix；App LandPlaySix 使用 config',three_one:'LandPlayFive',four_one:'LandPlayFour',five_one:'LandPlaySeven'}[field];
  if(consumer&&relevant.includes(field))notes.push('发放到 prop 后的使用方法：'+consumer+'。');
 }
 if(!sites.length)notes.push('未发现当前 biz 直接使用该模板字段，不擅自认定它已生效。');
 rows.push({uid:c.table+':'+id+':'+field,group:c.group,priority:prefix==='land'&&field==='rent_out_put_rate_max'?'按需保留':'对应功能启用前',table:c.table,record:c.selector+'='+id+(prefix==='prop'?'（'+propNames[id]+'）':''),field,sql_variable:'@'+variable,purpose,type,current:value.replace(/^'(.*)'$/,'$1'),template_value:value,methods:methods(sites),query_methods:[],change:writable?'首次导入修改08对应SET；已导入可用表列出的后台配置方法或明确UPDATE。':'首次导入修改08对应SET；后台配置接口未覆盖此字段，已导入后需明确UPDATE。',notes:notes.join(' '),evidence:sites,status:sites.length?'模板字段有使用':'未见业务读取'});
}

function extra(table,record,field,current,purpose,type,methodList,change,notes,priority='上线前确认',sensitive=false){rows.push({uid:table+':'+record+':'+field,group:'其他记录',priority,table,record,field,current,purpose,type,methods:methodList,query_methods:[],change,notes,status:'待确认',sensitive});}
extra('config','全部120条','name','暂用 key_name','配置显示名称','文字≤45字符',['后台：AdminGetConfig'],'已有记录可修改 name；不要改变 key_name。','原中文名称无法从代码恢复；表单用途说明不等于原名称。','按需保留');
extra('config','全部120条','id / key_name','固定ID16~21、26；其余100起','配置键与ID定位','固定关联',['后台：AdminSetConfig','后台：AdminSetBox'],'保留固定ID与准确key_name；非固定ID只用于新空库模板。','config.key_name 没有唯一约束；每键保持一条，避免两条值被循环覆盖。');
extra('config','历史ID66、67','key_name / value','无法恢复对应键','后台文本编辑兼容项','待你提供原关联',[],'确认历史对应关系后再决定；不要把66/67随意指派给其他键。','管理前端 only ID66/67 打开文本编辑框；模板 sys_content/sys_content_e 的新ID为186/187。正式文本请先用SQL修改。','按需保留');
extra('admin','你创建的管理员','account','未创建记录','后台登录账号','文字≤100字符',['后台：AdminLogin'],'手动创建管理员记录；不要只建表不建账号。','SQL 08 不生成任何管理员账户。');
extra('admin','你创建的管理员','password','未创建记录','管理员密码的32位小写MD5','只在数据库填写',['后台：AdminLogin'],'由你本地计算并写入；本表不保存密码或密码摘要。','AdminLogin 对输入密码计算 fmt.Sprintf("%x",md5.Sum(...)) 后匹配；无需在本表输入任何密码。','上线前确认',true);
extra('admin','你创建的管理员','type','表默认空字符串','预留管理员类型','文字≤40字符',[],'按你实际账号规则确认。','当前 AdminLogin 不以 type 做权限判断；不能仅靠填写此字段建立角色权限。','按需保留');
for(const [field,current,purpose] of [['content','无记录','中文公告'],['content_two','无记录','英文公告'],['status','新公告0','公告状态：0有效，1删除']])extra('admin_message','运营公告',field,current,purpose,field==='status'?'整数':'文字≤2000字符',['App：UserInfo','后台：SetAdminMessages','后台：DeleteAdminMessages','后台：AdminMessagesList'],'可用后台公告页面创建/删除，或按字段手动写入。','管理页面要求中英文都填写；App 展示未删除公告。','对应功能启用前');
for(const scene of [1,2,3]){
 const m=scene===1?['App：OpenBox','后台：OpenBox']:scene===2?['App：LandPlayOne','后台：LandPlayOne']:['App：StakeGetPlay'];
 extra('random_seeds','scene='+scene,'scene',String(scene),['','盲盒随机场景','种植随机场景','粮仓随机场景'][scene],'固定整数',m,'08 已补齐场景；保留scene编号。','唯一约束按scene；无需新建重复场景。','保留初始化');
 extra('random_seeds','scene='+scene,'seed_value','0','随机种子初值','uint64',m,'新库保留0；运行后由方法自动初始化并持久化。','初次 seedInt<=0 时写入 UnixNano；不要把运行中的值当普通业务参数重置。','保留初始化');
}
for(const [field,current,purpose] of [['id','1','全局池固定行'],['amount','0','粮仓/质押池份额'],['balance','0','粮仓/质押池余额']])extra('stake_get_total','id=1',field,current,purpose,field==='id'?'固定整数':'DECIMAL(65,18)',field==='id'?['App：StakeGet','App：StakeGetPlay','后台：StakeGet']:methods(fieldSites('stake_get_total',field)),'新空库保持id=1且amount/balance=0；历史池只能按对账结果恢复。','查询取First，更新固定id=1；不要添加第二条池记录或随意改运行中余额。','保留初始化');
for(const [table,method] of [['eth_record','AdminDeposit / DepositNewNew'],['eth_record_two','AdminDepositUsdt / DepositNewTwo']])extra(table,'新充值合约扫描进度','last','空表时扫描起点0','充值扫描起点','链上记录序号',[method],'新的两份合约初始化记录数为0；启动前核对现有库旧last，不手工捏造充值流水。','同表现有最大last如果来自旧合约会跳过新合约前部记录；需保存旧流水并明确迁移/分合约起点方案。','上线前确认');

const manual = [
 {item:'USDT扫描合约',location:'ppothergameadmin/internal/service/app.go:2319、2336',method:'AdminDepositUsdt',current:'0xD0c62c94F94c70E5f10169F59B0a5C3f84dAe800',target:'0xC769aDC38a427b569142A80ff5605f2F969db61E',note:'两处一起替换；biz入账方法DepositNewTwo。'},
 {item:'ISPAY扫描合约',location:'ppothergameadmin/internal/service/app.go:2220、2237',method:'AdminDeposit',current:'0x623Cf8DF68CD3AD201Ac925c0951694F6436E87b',target:'0x033aADea05aFa0a2c05850534702846F530f6FF2',note:'两处一起替换；biz入账方法DepositNewNew，记录num除1000。'},
 {item:'USDT最小金额对齐',location:'BuySomething.buy / service.AdminDepositUsdt:2368',method:'DepositNewTwo（service前置过滤）',current:'合约最低5；后台仅接受>=10',target:'由你决定统一最低5还是10',note:'当前5~9 USDT可进入合约但后台跳过。调整后台前务必确认该差异。'},
 {item:'前端充值入口',location:'farm-game5/src/views/game/pop/PopUserInfo.vue:587、600',method:'showWithdraw2Handler / showRechargeISPAYHandler',current:'step=4/8被注释，显示not_yet_open',target:'后台扫描和入账联调通过后按计划开放',note:'本次仅更换合约地址，保留入口状态。'},
 {item:'未配置的第二组USDT',location:'farm-game5/src/views/game/pop/PopUserInfo.vue:getRwbApproved',method:'getRwbApproved',current:'VITE_USDT2 / VITE_BUY_USDT2缺失，仍调用allowance',target:'按是否使用第二组充值决定配置或移除该查询',note:'不是config数据库项；登录/个人弹窗联调时核对。'},
 {item:'API域名',location:'App .env / game-admin .env.production',method:'前端API配置',current:'App www.ppflsc.com；后台 www.playgamefrane.com',target:'按实际服务器域名确认',note:'两个dist保留上述当前域名；改变环境变量要重新编译。'},
 {item:'新用户默认赠送余额',location:'ppothergame/internal/biz/app.go:CreateUser',method:'CreateUser',current:'代码明确AmountUsdt=100',target:'由你确认是否保留赠送100',note:'改数据库DEFAULT 0不能覆盖这段显式赋值。'},
 {item:'第9级推荐奖励分支',location:'ppothergameadmin/internal/biz/app.go:DepositNewTwo',method:'DepositNewTwo',current:'rate_r_9查询但分支重复rate_r_8',target:'启用第9级分配前由你核对代码',note:'填写config.rate_r_9不能修复该代码分支。'},
 {item:'竞拍退款字段拼写',location:'ppothergame/internal/biz/app.go:BackUserGit及数据层',method:'BackUserGit',current:'写ammount_usdt，模型amount_usdt',target:'此前你选择暂不处理；启用该功能前确认',note:'表单保留正确amount_usdt，不增加拼错列。'},
 {item:'充值扫描任务',location:'宝塔任务及充值扫描函数',method:'AdminDeposit / AdminDepositUsdt',current:'服务器任务配置未核对',target:'确认调用地址、频率和避免重叠执行',note:'批内last推进和失败补扫逻辑仍按原代码，部署成功不代表入账联调通过。'},
 {item:'土地统计事件',location:'ev_refresh_land_count / MySQL event_scheduler',method:'SQL事件，无biz方法',current:'08含五分钟事件，未修改全局开关',target:'确认EVENT权限、event_scheduler=ON',note:'与宝塔充值扫描是不同任务。'},
];
const inventory = unique([...sql.matchAll(/^CREATE TABLE IF NOT EXISTS `([^`]+)`/gm)].map(m=>m[1])).map(table=>({table,handling:rows.some(r=>r.table===table)?'有参数/初始化/扫描起点确认项，见对应表单':'运行中业务表：新空库保持空表；记录由方法产生，旧历史数据不能从代码伪造',columns:basis.columns.filter(c=>c.table===table).length}));
if(inventory.length!==38)throw Error('Expected 38 tables');
const expectedVariables=Object.keys(values).filter(k=>/^(cfg_|seed_\d+_|land_\d+_|prop_\d+_)/.test(k));
const covered=rows.filter(r=>r.sql_variable).map(r=>r.sql_variable.slice(1));
if(expectedVariables.length!==270||covered.length!==270||new Set(covered).size!==270||expectedVariables.some(k=>!covered.includes(k)))throw Error('Incomplete editable SQL coverage');
const data={date:'2026-10-03',basis:'当前两端Go源码与08恢复SQL；未查询线上数据库',counts:{config:120,config_read:104,config_query_only:16,seed_fields:50,land_fields:60,prop_fields:40,other_fields:rows.length-270,total_fields:rows.length,tables:38},sql_file:path.join(root,'sql','08_restore_all_for_baota.sql'),sql_sha256:crypto.createHash('sha256').update(sql).digest('hex'),rows,manual,inventory,deployments:{usdt:'0xC769aDC38a427b569142A80ff5605f2F969db61E',ispay:'0x033aADea05aFa0a2c05850534702846F530f6FF2'},dist:{app:'/Users/wangjiabao/Documents/farm-game5/dist',admin:'/Users/wangjiabao/Documents/game-admin/dist'}};
const target=path.join(root,'待确认参数表单_20261003.json');
fs.writeFileSync(target,JSON.stringify(data,null,2)+'\n');
const template=fs.readFileSync(path.join(__dirname,'settings-form-template.html'),'utf8');
fs.writeFileSync(path.join(root,'待确认参数表单_20261003.html'),template.replace('__SETTINGS_DATA__',JSON.stringify(data).replaceAll('<','\\u003c')));
console.log(JSON.stringify({counts:data.counts,json:target,html:path.join(root,'待确认参数表单_20261003.html')}));
