游戏项目 MySQL 空库重建和调试初始化说明
更新日期：2026-10-02

2026-10-03 最新入口说明
空库在宝塔导入时，优先使用08_restore_all_for_baota.sql；它已经包括建表、基础记录、config待填项、五分钟事件和只读检查。
下方00配合04/02/07的顺序是分步导入方案，并非当前推荐的单文件入口。两种方案选择一种。
已导入旧版时按现有结构选择09补字段、10补索引、14补默认值、15补地址唯一约束；重跑08不升级已有表。
两个聊天的最终决定、前后端对应关系、充值链路和待处理事项，见16_项目进展整合_20261003.txt。
此前game-mysql-restore-20261002.zip是旧快照，缺少08~15等后续文件；本次请使用game-mysql-restore-latest-20261003.zip。
SQL本身未因本次整合被改写，Go和前端代码也未修改；真实MySQL执行、服务器部署与链上充值验收仍未完成。

代码依据
App：ppothergame main f29548c52fb2805ac8f657717f9ca04209e0d40a
后台：ppothergameadmin main f5d6e8cb8ae2430e03a9012fbb0ca764f8e7166d
当前两份配置的数据库名都是 othergame；也可以使用 game，但需要同步修改服务连接配置。
本包不含数据库密码、管理员密码、用户钱包或旧业务数据。

文件用途
00_restore_schema_and_base.sql：01 + 03 + 05 的完整合并文件。空库建立38张表、386个字段，并补29条基础记录。
01_restore_game_tables.sql：单独建表文件。
02_ev_refresh_land_count.sql：用户提供的五分钟有效土地数量刷新事件。
03_init_base_records.sql：random_seeds场景1/2/3，以及stake_get_total.id=1。
04_config_init_template.sql：120个配置键的写入模板；仍有120个NULL待填变量。原样执行不会插入config记录。
05_catalog_init_template.sql：已填好调试占位值的10类种子、10级土地、5类道具初始化。
06_config_records.sql：120项配置清单，只有SELECT，不写入数据库。
06_config_records.json：每个配置的查询/读取代码位置、类型、编号依据。
07_check_restore_readonly.sql：只读检查缺表、缺字段、基础编号、重复键、固定配置编号、配置状态、事件状态和land_count差异。
SHA256SUMS.txt：文件完整性摘要。

建议顺序
1. 在MySQL客户端创建或选择目标空库。
2. 导入00合并文件；不用再单独导入01/03/05。
3. 填写04中要使用的功能参数，再导入04。
00是合并快照：改05不会自动同步00。首次调整基础参数时可直接改00中的SET，或分别导入01、03、05。
4. 导入02创建五分钟事件，并确认event_scheduler=ON。
5. 导入07查看结果。导入报错时先处理报错，不使用忽略错误继续执行的方式。

本机路径示例（自己执行，不在密码参数后直接写密码）
mysql -u root -p
CREATE DATABASE IF NOT EXISTS `othergame` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `othergame`;
SOURCE /Users/wangjiabao/Documents/ppothergame/deploy/sql/00_restore_schema_and_base.sql;
-- 编辑并填好04后才执行下一条：
SOURCE /Users/wangjiabao/Documents/ppothergame/deploy/sql/04_config_init_template.sql;
SOURCE /Users/wangjiabao/Documents/ppothergame/deploy/sql/02_ev_refresh_land_count.sql;
SOURCE /Users/wangjiabao/Documents/ppothergame/deploy/sql/07_check_restore_readonly.sql;

上传服务器或宝塔后，SOURCE路径换成服务器上实际文件路径。
02不会自动修改全局event_scheduler。手动核对：SHOW VARIABLES LIKE 'event_scheduler';
需要启动且当前为OFF时，可由有权限的账号执行：SET GLOBAL event_scheduler=ON;
这个全局开关会影响服务器上的全部已启用事件。重启后的持久设置需在实际MySQL配置中确认。

空库初始化后预期
seed_info=10；land_info=10；prop_info=5；random_seeds=3；stake_get_total=1。
config=0，直到填写并导入04。它不是已填好120个业务值的配置文件。
user、land、seed、prop、业务流水和admin账号记录都不在基础初始化中创建。
info表是商品/等级参数；不代表给用户直接发了10块土地或10个种子。

基础参数及真实代码行为
seed_info.id=1~10；名称为调试种子1~10；out_min_amount=1；out_max_amount=3；out_over_time=300秒；get_rate=1。
开盲盒代码先转int64再随机，实际随机基值为1或2。此前0.01/0.02会被截成0，已修正。
land_info.level=1~10；out_put_rate_min/max=100，rent_out_put_rate_max=0，max_health=100，per_health=10，limit_date_max=30天。
100/0/100/10来自模型默认；30天是调试占位。当前种植代码直接将种子基值乘土地参数100，产出上限会是100或200，收获仍受其他参数影响。
当前后台土地修改接口支持增产/肥沃度/消耗量，不支持期限和出租产出参数。
prop_info.prop_type：11化肥、12水、13手套、14除虫剂、15铲子。
道具效果沿用PropInfo模型默认：化肥增加20肥沃度、加速14400秒；水7次；手套20次；除虫剂7次；铲子7次、比例参数20。
道具get_rate=1是调试权重。当前App开盲盒读取道具池的代码被注释，补记录不会自动启用道具抽奖。
get_rate是相对权重，不是百分比；当前App仅10类种子且权重相同时，各类约占1/10。
所有等级和种子使用同样占位参数，暂未设定递增收益或正式经济模型。

配置细节
120个不同键：104个存在活动读取分支，16个仅留在活动查询参数中。所有键均保留，不按前端是否使用删减。
固定ID：16 box_start；17 box_end；18 box_amount；19 box_num；20 box_max；21 box_sell_num；26 u_price。
其他ID从100起新分配，name暂用key_name。这不是历史编号或历史中文名称恢复。
box_start/end使用YYYY-MM-DD HH:MM:SS文本，当前代码按UTC解释。
withdraw_amount_min_two/max_two同时被整数和小数方式读取，应填写整数字符串。
后台DepositNewTwo查询rate_r_9，但给r9赋值的分支比较rate_r_8；补SQL不能修正这个代码问题。
原样执行04：NULL项跳过；已存在同id或同key_name时跳过，不覆盖，也不修正编号冲突。

表结构规则
实际Table表名，不使用自动复数猜测；大多数为单数，random_seeds为复数。
两端同表取字段并集，shared默认值优先App，任一模型允许NULL时保留可空。
land.one/two/three默认采用App的1；后台模型为0。
数值列没有模型默认值时补0；必填VARCHAR补空字符串；必填DATETIME补CURRENT_TIMESTAMP；这些是兼容补充。
withdraw.coin的模型标签缺少结束引号，按标签意图修为VARCHAR(45)。
金额列按模型保留DECIMAL(65,20)或DECIMAL(65,18)。应用float64并不因此获得同等计算精度。
普通索引按现有查询补充，不声称恢复历史手工索引；不新增模型未声明的外键/业务唯一约束。
CREATE TABLE IF NOT EXISTS不升级已有表，也不验证已有结构一致；适合空库。

五分钟事件
每五分钟按land.user_id统计status<=4且limit_date>UNIX_TIMESTAMP()的土地。
回填user.land_count；没有有效土地的用户设置为0。不会创建土地，不计算收益/充值/提现/分红。
保留原STARTS '2025-12-24 06:37:20'、SYSTEM时区和原筛选条件。
省略旧root@localhost的DEFINER，使用创建事件的账号，运行权限需满足读land/更新user。
同名事件已存在时不会被覆盖；需要核对SHOW CREATE EVENT和实际调度器状态。

与SQL相关的代码边界
App BackUserGit使用ammount_usdt，模型列是amount_usdt；SQL保留正确模型字段，此代码路径仍需要处理。
本地当前CreateUser仍明确写AmountUsdt=100；数据库DEFAULT 0不会覆盖应用显式写入。这里只交付SQL，没有应用其他聊天中的Go补丁。
后台登录从admin查账号和密码，当前代码对输入密码取MD5后比较；本包没有放默认管理员或通用密码。

验证状态
已完成当前两端模型字段/类型和全部显式表名覆盖核对；120项配置去重和编号检查。
合并文件经过MySQL方言离线解析；基础INSERT通过内存模拟，初次插29条、重复执行不覆盖改过的参数、种子值和资金池余额。
种子占位范围按当前整数随机逻辑检查，结果为1或2。
07只读检查通过离线解析。事件业务体和周期与用户提供的定义核对一致。
未连接真实MySQL执行；这些证据不等于目标MySQL版本、账号权限和真实接口联调已通过。

2026-10-02 读写、争议字段和索引复核补充
08_restore_all_for_baota.sql：最新完整单文件，38表386字段，新增63个查询普通索引已内置。未导入时直接用08。
09_add_stake_git_sell_amount_if_missing.sql：已导入旧版385字段时补模型外sell_amount；有列会跳过。
10_add_query_indexes_if_missing.sql：已存在表时补63个查询索引；不会删除旧索引。同名定义不符报告REVIEW；等价定义会跳过。
11_恢复争议与调用链.md：不能确认历史定义的全部事项、222列补默认值清单、模型缺字段和service/biz/data链路。
12_索引依据与查询清单.md：63个索引依据、取舍、EXPLAIN示例和509处读写清单。
13_字段恢复依据.json：386列对应的模型声明、默认值推定、显式写入及调用链，附索引证据。
新增索引都是新设计建议，不是旧库SHOW INDEX恢复；包括原有索引共93个二级索引（91普通+2唯一：user.address、random_seeds.scene）。
未修改Go代码；BackUserGit余额字段拼错的问题仍在；未连接真实MySQL执行或进行性能验收。

2026-10-02 全字段默认值更新
348个非自增字段都有非NULL默认值；38个主键继续AUTO_INCREMENT自动生成。
14_set_all_column_defaults.sql：为已有38张表设置348个字段默认值，只改默认值，不改类型/NULL约束/索引或已有行。若缺sell_amount先09。
原有业务默认值保留；14个原DEFAULT NULL改为4个字符串空串、10个时间CURRENT_TIMESTAMP（DATETIME(3)使用CURRENT_TIMESTAMP(3)）。
默认值防止省略字段导致的缺默认值INSERT错误，显式NULL、类型错误、列名错误和重复唯一键仍按MySQL规则处理。

2026-10-02 地址唯一索引更新
user.address已改为uq_user_address完整列唯一索引，默认空串保留，空串只能有一行。
15_make_user_address_unique.sql：已建库的地址唯一索引补丁，先检查重复；不删除/修改用户记录。
最新08已内置；充值等流水表address仍是普通索引。
