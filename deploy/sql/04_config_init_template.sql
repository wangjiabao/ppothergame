-- config 初始数据待填模板；基于两个项目的 Go AST，排除被注释掉的读取语句。
-- 共 120 个仍在代码中调用 GetConfigByKeys 的配置键；不判断接口是否被前端使用。
-- NULL 表示尚未提供历史/新参数：保持 NULL 的配置会被跳过，不写入虚假的 0。
-- 使用：先编辑下方 SET，把需要恢复的 NULL 改为字符串，如 '0.03' 或时间文本；再执行。
-- box_start / box_end 格式：YYYY-MM-DD HH:MM:SS，代码使用 time.Parse 的 UTC 解释。
-- 可直接保留不用接口对应的 NULL 项；模板没有配置服务或宝塔任务。
-- 固定 ID：16=box_start、17=box_end、18=box_amount、19=box_num、20=box_max、21=box_sell_num。
-- 固定 ID 26=u_price：后台 AdminSetConfig 的 id=26 分支执行价格变动记录逻辑。
-- 其余 ID 的历史编号无法从后端代码还原，此模板从 100 开始分配新编号。
-- 如果旧前端硬编码其他 config ID，需要按其对应关系替换下方的新编号。
-- name 使用配置键作为临时展示名称；原中文显示名称不在代码中，必要时自行替换。
-- 仅插入缺失项；已存在同 key_name 或同 id 的记录不会覆盖。用于单次、串行空库初始化。
-- 完全未填的原始模板执行后不会插入任何 config 记录。
-- 核对补充：120 个键中 104 个有活动读取分支，16 个仅出现在查询参数中。
-- 仅查询项仍保留，不能把其未知类型、默认值或用途当作已确认业务规则。
-- 固定 ID / key_name 若在已有库中不匹配，本模板会跳过该项；请先核对，不会自动纠正。
-- withdraw_amount_min_two / max_two 同时被整数和小数方式读取，需填写整数字符串。
-- rate_r_9 当前读取分支误比较 rate_r_8，补配置记录不会修正该代码问题。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;

-- box_start；ID=16；读取类型：时间文本 YYYY-MM-DD HH:MM:SS，代码按 UTC 解析
-- 使用位置：ppothergame/BuyBox:3961
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetBox:6141
-- 使用位置：ppothergameadmin/BuyBox:2143
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_box_start = NULL;

-- box_end；ID=17；读取类型：时间文本 YYYY-MM-DD HH:MM:SS，代码按 UTC 解析
-- 使用位置：ppothergame/BuyBox:3961
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetBox:6141
-- 使用位置：ppothergameadmin/BuyBox:2143
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_box_end = NULL;

-- box_amount；ID=18；读取类型：小数
-- 使用位置：ppothergame/BuyBox:3961
-- 使用位置：ppothergame/OpenBox:4166
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetBox:6141
-- 使用位置：ppothergameadmin/BuyBox:2143
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_box_amount = NULL;

-- box_num；ID=19；读取类型：无符号整数
-- 使用位置：ppothergame/BuyBox:3961
-- 使用位置：ppothergame/UserBoxList:2250
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetBox:6141
-- 使用位置：ppothergameadmin/AdminSetBox:6194
-- 使用位置：ppothergameadmin/BuyBox:2143
-- 使用位置：ppothergameadmin/UserBoxList:1303
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_box_num = NULL;

-- box_max；ID=20；读取类型：无符号整数
-- 使用位置：ppothergame/BuyBox:3961
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetBox:6141
-- 使用位置：ppothergameadmin/BuyBox:2143
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_box_max = NULL;

-- box_sell_num；ID=21；读取类型：无符号整数
-- 使用位置：ppothergame/BuyBox:3961
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetBox:6141
-- 使用位置：ppothergameadmin/BuyBox:2143
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_box_sell_num = NULL;

-- u_price；ID=26；读取类型：小数
-- 使用位置：ppothergame/BuyBox:3961
-- 使用位置：ppothergame/BuyTwo:9113
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergame/UserBuy:742
-- 使用位置：ppothergame/UserBuyL:1868
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 使用位置：ppothergameadmin/AdminRewardListTwo:9545
-- 使用位置：ppothergameadmin/AdminSetConfig:6487
-- 使用位置：ppothergameadmin/AdminUserBuy:9765
-- 使用位置：ppothergameadmin/DepositNewThree:9395
-- 代码状态：有活动读取分支
SET @cfg_u_price = NULL;

-- all_each；ID=100；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_all_each = NULL;

-- area_five；ID=101；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_area_five = NULL;

-- area_four；ID=102；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_area_four = NULL;

-- area_one；ID=103；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_area_one = NULL;

-- area_three；ID=104；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_area_three = NULL;

-- area_two；ID=105；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_area_two = NULL;

-- area_zero；ID=106；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_area_zero = NULL;

-- b_price；ID=107；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_b_price = NULL;

-- buy_eight；ID=108；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_eight = NULL;

-- buy_five；ID=109；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_five = NULL;

-- buy_four；ID=110；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_four = NULL;

-- buy_land_one；ID=111；读取类型：小数
-- 使用位置：ppothergame/Buy:6387
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_buy_land_one = NULL;

-- buy_land_three；ID=112；读取类型：小数
-- 使用位置：ppothergame/Buy:6387
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_buy_land_three = NULL;

-- buy_land_two；ID=113；读取类型：小数
-- 使用位置：ppothergame/Buy:6387
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_buy_land_two = NULL;

-- buy_one；ID=114；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_one = NULL;

-- buy_seven；ID=115；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_seven = NULL;

-- buy_six；ID=116；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_six = NULL;

-- buy_three；ID=117；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_three = NULL;

-- buy_two；ID=118；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_buy_two = NULL;

-- can_withdraw；ID=119；读取类型：无符号整数
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_can_withdraw = NULL;

-- exchange_fee_rate；ID=120；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/Exchange:5165
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_exchange_fee_rate = NULL;

-- exchange_fee_rate_two；ID=121；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_exchange_fee_rate_two = NULL;

-- exchange_max_three；ID=122；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_exchange_max_three = NULL;

-- exchange_min_three；ID=123；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_exchange_min_three = NULL;

-- exchange_price；ID=124；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_exchange_price = NULL;

-- exchange_price_open；ID=125；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_exchange_price_open = NULL;

-- exchange_stake_rate；ID=126；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_exchange_stake_rate = NULL;

-- exchange_three；ID=127；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_exchange_three = NULL;

-- exchange_three_rate；ID=128；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_exchange_three_rate = NULL;

-- g_1；ID=129；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_1 = NULL;

-- g_2；ID=130；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_2 = NULL;

-- g_3；ID=131；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_3 = NULL;

-- g_4；ID=132；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_4 = NULL;

-- g_5；ID=133；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_5 = NULL;

-- g_6；ID=134；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_6 = NULL;

-- g_7；ID=135；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_7 = NULL;

-- g_8；ID=136；读取类型：小数
-- 使用位置：ppothergame/UserRankList:3459
-- 使用位置：ppothergameadmin/AdminDaily:8139
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_g_8 = NULL;

-- low_reward_u；ID=137；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/LandPlaySix:5635
-- 代码状态：仅出现在活动查询参数中
SET @cfg_low_reward_u = NULL;

-- max_play；ID=138；读取类型：小数
-- 使用位置：ppothergame/StakeGetPlay:8535
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_max_play = NULL;

-- max_stake；ID=139；读取类型：小数
-- 使用位置：ppothergame/StakeGet:8337
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_max_stake = NULL;

-- min_play；ID=140；读取类型：小数
-- 使用位置：ppothergame/StakeGetPlay:8535
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_min_play = NULL;

-- min_stake；ID=141；读取类型：小数
-- 使用位置：ppothergame/StakeGet:8337
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_min_stake = NULL;

-- min_stake_two；ID=142；读取类型：小数
-- 使用位置：ppothergame/StakeGet:8337
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_min_stake_two = NULL;

-- one；ID=143；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_one = NULL;

-- one_rate；ID=144；读取类型：小数
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/LandPlaySix:3424
-- 使用位置：ppothergameadmin/LandPlayTwo:2692
-- 代码状态：有活动读取分支
SET @cfg_one_rate = NULL;

-- one_rate_new；ID=145；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_one_rate_new = NULL;

-- open_box_price；ID=146；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergame/OpenBox:4166
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_open_box_price = NULL;

-- open_box_price_use；ID=147；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergame/OpenBox:4166
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_open_box_price_use = NULL;

-- play_one_rate；ID=148；读取类型：小数
-- 使用位置：ppothergame/LandPlayOne:4579
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_play_one_rate = NULL;

-- play_two_rate；ID=149；读取类型：小数
-- 使用位置：ppothergame/LandPlayOne:4579
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_play_two_rate = NULL;

-- prop_two_two；ID=150；读取类型：小数
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_prop_two_two = NULL;

-- queue_amount；ID=151；读取类型：小数
-- 使用位置：ppothergame/UserStakeGitStakeList:2062
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminSetQueue:6555
-- 代码状态：有活动读取分支
SET @cfg_queue_amount = NULL;

-- rate_r_1；ID=152；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_1 = NULL;

-- rate_r_10；ID=153；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_10 = NULL;

-- rate_r_2；ID=154；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_2 = NULL;

-- rate_r_3；ID=155；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_3 = NULL;

-- rate_r_4；ID=156；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_4 = NULL;

-- rate_r_5；ID=157；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_5 = NULL;

-- rate_r_6；ID=158；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_6 = NULL;

-- rate_r_7；ID=159；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_7 = NULL;

-- rate_r_8；ID=160；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_rate_r_8 = NULL;

-- rate_r_9；ID=161；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：仅出现在活动查询参数中
SET @cfg_rate_r_9 = NULL;

-- recommend；ID=162；读取类型：小数
-- 使用位置：ppothergame/BuyTwo:9113
-- 代码状态：有活动读取分支
SET @cfg_recommend = NULL;

-- recommend_two；ID=163；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_recommend_two = NULL;

-- recommend_two_sub；ID=164；读取类型：小数
-- 使用位置：ppothergameadmin/AdminDailyReward:6740
-- 代码状态：有活动读取分支
SET @cfg_recommend_two_sub = NULL;

-- rent_rate_one；ID=165；读取类型：小数
-- 使用位置：ppothergame/RentLand:7421
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_rent_rate_one = NULL;

-- rent_rate_three；ID=166；读取类型：小数
-- 使用位置：ppothergame/RentLand:7421
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_rent_rate_three = NULL;

-- rent_rate_two；ID=167；读取类型：小数
-- 使用位置：ppothergame/RentLand:7421
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_rent_rate_two = NULL;

-- reward_land；ID=168；读取类型：小数
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminLandReward:6274
-- 代码状态：有活动读取分支
SET @cfg_reward_land = NULL;

-- reward_stake_rate；ID=169；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_reward_stake_rate = NULL;

-- s_rate；ID=170；读取类型：小数
-- 使用位置：ppothergame/LandPlaySeven:6124
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_s_rate = NULL;

-- self_sub；ID=171；读取类型：无符号整数
-- 使用位置：ppothergame/LandPlaySeven:6124
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_self_sub = NULL;

-- sell_fee_rate；ID=172；读取类型：小数
-- 使用位置：ppothergame/Buy:6387
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/Buy:3703
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_sell_fee_rate = NULL;

-- sell_land；ID=173；读取类型：无符号整数
-- 使用位置：ppothergame/Sell:6941
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_sell_land = NULL;

-- stake_ispay_five；ID=174；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/UserInfo:965
-- 代码状态：仅出现在活动查询参数中
SET @cfg_stake_ispay_five = NULL;

-- stake_ispay_four；ID=175；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/UserInfo:965
-- 代码状态：仅出现在活动查询参数中
SET @cfg_stake_ispay_four = NULL;

-- stake_ispay_one；ID=176；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_stake_ispay_one = NULL;

-- stake_ispay_three；ID=177；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/UserInfo:965
-- 代码状态：仅出现在活动查询参数中
SET @cfg_stake_ispay_three = NULL;

-- stake_ispay_two；ID=178；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/UserInfo:965
-- 代码状态：仅出现在活动查询参数中
SET @cfg_stake_ispay_two = NULL;

-- stake_over_rate；ID=179；读取类型：小数
-- 使用位置：ppothergame/StakeGetPlay:8535
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/StakeGetPlay:4970
-- 使用位置：ppothergameadmin/UserInfo:799
-- 代码状态：有活动读取分支
SET @cfg_stake_over_rate = NULL;

-- stake_price；ID=180；读取类型：小数
-- 使用位置：ppothergame/OpenBox:4166
-- 使用位置：ppothergame/StakeGit:7208
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_stake_price = NULL;

-- stake_price_on；ID=181；读取类型：无符号整数
-- 使用位置：ppothergame/OpenBox:4166
-- 使用位置：ppothergame/StakeGit:7208
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_stake_price_on = NULL;

-- stake_rate_new；ID=182；读取类型：小数
-- 使用位置：ppothergame/StakeGit:7208
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_stake_rate_new = NULL;

-- stake_recommend_one；ID=183；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_stake_recommend_one = NULL;

-- stake_recommend_three；ID=184；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_stake_recommend_three = NULL;

-- stake_recommend_two；ID=185；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_stake_recommend_two = NULL;

-- sys_content；ID=186；读取类型：文本
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_sys_content = NULL;

-- sys_content_e；ID=187；读取类型：文本
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_sys_content_e = NULL;

-- three；ID=188；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_three = NULL;

-- three_rate；ID=189；读取类型：小数
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/LandPlaySix:3424
-- 使用位置：ppothergameadmin/LandPlayTwo:2692
-- 代码状态：有活动读取分支
SET @cfg_three_rate = NULL;

-- two；ID=190；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_two = NULL;

-- two_rate；ID=191；读取类型：小数
-- 使用位置：ppothergame/LandPlaySix:5635
-- 使用位置：ppothergame/LandPlayTwo:4749
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/LandPlaySix:3424
-- 使用位置：ppothergameadmin/LandPlayTwo:2692
-- 代码状态：有活动读取分支
SET @cfg_two_rate = NULL;

-- two_sub_reward；ID=192；读取类型：小数
-- 使用位置：ppothergame/LandPlayFour:5356
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_two_sub_reward = NULL;

-- v_1；ID=193；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_1 = NULL;

-- v_10；ID=194；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_10 = NULL;

-- v_2；ID=195；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_2 = NULL;

-- v_3；ID=196；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_3 = NULL;

-- v_4；ID=197；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_4 = NULL;

-- v_5；ID=198；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_5 = NULL;

-- v_6；ID=199；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_6 = NULL;

-- v_7；ID=200；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_7 = NULL;

-- v_8；ID=201；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_8 = NULL;

-- v_9；ID=202；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/UserRecommend:1627
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/AdminUserList:5487
-- 使用位置：ppothergameadmin/DepositNewTwo:9001
-- 代码状态：有活动读取分支
SET @cfg_v_9 = NULL;

-- win_rate；ID=203；读取类型：小数
-- 使用位置：ppothergame/StakeGetPlay:8535
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_win_rate = NULL;

-- withdraw_amount_max；ID=204；读取类型：无符号整数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/UserInfo:799
-- 使用位置：ppothergameadmin/Withdraw:5214
-- 代码状态：有活动读取分支
SET @cfg_withdraw_amount_max = NULL;

-- withdraw_amount_max_three；ID=205；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_withdraw_amount_max_three = NULL;

-- withdraw_amount_max_two；ID=206；读取类型：小数 / 无符号整数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_withdraw_amount_max_two = NULL;

-- withdraw_amount_min；ID=207；读取类型：无符号整数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 使用位置：ppothergameadmin/UserInfo:799
-- 使用位置：ppothergameadmin/Withdraw:5214
-- 代码状态：有活动读取分支
SET @cfg_withdraw_amount_min = NULL;

-- withdraw_amount_min_three；ID=208；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_withdraw_amount_min_three = NULL;

-- withdraw_amount_min_two；ID=209；读取类型：小数 / 无符号整数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_withdraw_amount_min_two = NULL;

-- withdraw_rate；ID=210；读取类型：当前代码仅查询，未实际解析，值类型待确认
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：仅出现在活动查询参数中
SET @cfg_withdraw_rate = NULL;

-- withdraw_rate_three；ID=211；读取类型：小数
-- 使用位置：ppothergame/UserInfo:965
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_withdraw_rate_three = NULL;

-- withdraw_rate_two；ID=212；读取类型：小数
-- 使用位置：ppothergame/Withdraw:9435
-- 使用位置：ppothergameadmin/AdminGetConfig:6353
-- 代码状态：有活动读取分支
SET @cfg_withdraw_rate_two = NULL;

START TRANSACTION;

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 16, 'box_start', 'box_start', CAST(@cfg_box_start AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_box_start IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 16 OR `key_name` = 'box_start');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 17, 'box_end', 'box_end', CAST(@cfg_box_end AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_box_end IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 17 OR `key_name` = 'box_end');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 18, 'box_amount', 'box_amount', CAST(@cfg_box_amount AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_box_amount IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 18 OR `key_name` = 'box_amount');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 19, 'box_num', 'box_num', CAST(@cfg_box_num AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_box_num IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 19 OR `key_name` = 'box_num');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 20, 'box_max', 'box_max', CAST(@cfg_box_max AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_box_max IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 20 OR `key_name` = 'box_max');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 21, 'box_sell_num', 'box_sell_num', CAST(@cfg_box_sell_num AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_box_sell_num IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 21 OR `key_name` = 'box_sell_num');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 26, 'u_price', 'u_price', CAST(@cfg_u_price AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_u_price IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 26 OR `key_name` = 'u_price');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 100, 'all_each', 'all_each', CAST(@cfg_all_each AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_all_each IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 100 OR `key_name` = 'all_each');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 101, 'area_five', 'area_five', CAST(@cfg_area_five AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_area_five IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 101 OR `key_name` = 'area_five');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 102, 'area_four', 'area_four', CAST(@cfg_area_four AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_area_four IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 102 OR `key_name` = 'area_four');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 103, 'area_one', 'area_one', CAST(@cfg_area_one AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_area_one IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 103 OR `key_name` = 'area_one');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 104, 'area_three', 'area_three', CAST(@cfg_area_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_area_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 104 OR `key_name` = 'area_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 105, 'area_two', 'area_two', CAST(@cfg_area_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_area_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 105 OR `key_name` = 'area_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 106, 'area_zero', 'area_zero', CAST(@cfg_area_zero AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_area_zero IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 106 OR `key_name` = 'area_zero');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 107, 'b_price', 'b_price', CAST(@cfg_b_price AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_b_price IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 107 OR `key_name` = 'b_price');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 108, 'buy_eight', 'buy_eight', CAST(@cfg_buy_eight AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_eight IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 108 OR `key_name` = 'buy_eight');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 109, 'buy_five', 'buy_five', CAST(@cfg_buy_five AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_five IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 109 OR `key_name` = 'buy_five');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 110, 'buy_four', 'buy_four', CAST(@cfg_buy_four AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_four IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 110 OR `key_name` = 'buy_four');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 111, 'buy_land_one', 'buy_land_one', CAST(@cfg_buy_land_one AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_land_one IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 111 OR `key_name` = 'buy_land_one');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 112, 'buy_land_three', 'buy_land_three', CAST(@cfg_buy_land_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_land_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 112 OR `key_name` = 'buy_land_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 113, 'buy_land_two', 'buy_land_two', CAST(@cfg_buy_land_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_land_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 113 OR `key_name` = 'buy_land_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 114, 'buy_one', 'buy_one', CAST(@cfg_buy_one AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_one IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 114 OR `key_name` = 'buy_one');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 115, 'buy_seven', 'buy_seven', CAST(@cfg_buy_seven AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_seven IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 115 OR `key_name` = 'buy_seven');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 116, 'buy_six', 'buy_six', CAST(@cfg_buy_six AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_six IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 116 OR `key_name` = 'buy_six');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 117, 'buy_three', 'buy_three', CAST(@cfg_buy_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 117 OR `key_name` = 'buy_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 118, 'buy_two', 'buy_two', CAST(@cfg_buy_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_buy_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 118 OR `key_name` = 'buy_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 119, 'can_withdraw', 'can_withdraw', CAST(@cfg_can_withdraw AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_can_withdraw IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 119 OR `key_name` = 'can_withdraw');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 120, 'exchange_fee_rate', 'exchange_fee_rate', CAST(@cfg_exchange_fee_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_fee_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 120 OR `key_name` = 'exchange_fee_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 121, 'exchange_fee_rate_two', 'exchange_fee_rate_two', CAST(@cfg_exchange_fee_rate_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_fee_rate_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 121 OR `key_name` = 'exchange_fee_rate_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 122, 'exchange_max_three', 'exchange_max_three', CAST(@cfg_exchange_max_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_max_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 122 OR `key_name` = 'exchange_max_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 123, 'exchange_min_three', 'exchange_min_three', CAST(@cfg_exchange_min_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_min_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 123 OR `key_name` = 'exchange_min_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 124, 'exchange_price', 'exchange_price', CAST(@cfg_exchange_price AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_price IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 124 OR `key_name` = 'exchange_price');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 125, 'exchange_price_open', 'exchange_price_open', CAST(@cfg_exchange_price_open AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_price_open IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 125 OR `key_name` = 'exchange_price_open');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 126, 'exchange_stake_rate', 'exchange_stake_rate', CAST(@cfg_exchange_stake_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_stake_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 126 OR `key_name` = 'exchange_stake_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 127, 'exchange_three', 'exchange_three', CAST(@cfg_exchange_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 127 OR `key_name` = 'exchange_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 128, 'exchange_three_rate', 'exchange_three_rate', CAST(@cfg_exchange_three_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_exchange_three_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 128 OR `key_name` = 'exchange_three_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 129, 'g_1', 'g_1', CAST(@cfg_g_1 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_1 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 129 OR `key_name` = 'g_1');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 130, 'g_2', 'g_2', CAST(@cfg_g_2 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_2 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 130 OR `key_name` = 'g_2');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 131, 'g_3', 'g_3', CAST(@cfg_g_3 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_3 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 131 OR `key_name` = 'g_3');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 132, 'g_4', 'g_4', CAST(@cfg_g_4 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_4 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 132 OR `key_name` = 'g_4');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 133, 'g_5', 'g_5', CAST(@cfg_g_5 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_5 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 133 OR `key_name` = 'g_5');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 134, 'g_6', 'g_6', CAST(@cfg_g_6 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_6 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 134 OR `key_name` = 'g_6');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 135, 'g_7', 'g_7', CAST(@cfg_g_7 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_7 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 135 OR `key_name` = 'g_7');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 136, 'g_8', 'g_8', CAST(@cfg_g_8 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_g_8 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 136 OR `key_name` = 'g_8');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 137, 'low_reward_u', 'low_reward_u', CAST(@cfg_low_reward_u AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_low_reward_u IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 137 OR `key_name` = 'low_reward_u');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 138, 'max_play', 'max_play', CAST(@cfg_max_play AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_max_play IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 138 OR `key_name` = 'max_play');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 139, 'max_stake', 'max_stake', CAST(@cfg_max_stake AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_max_stake IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 139 OR `key_name` = 'max_stake');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 140, 'min_play', 'min_play', CAST(@cfg_min_play AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_min_play IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 140 OR `key_name` = 'min_play');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 141, 'min_stake', 'min_stake', CAST(@cfg_min_stake AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_min_stake IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 141 OR `key_name` = 'min_stake');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 142, 'min_stake_two', 'min_stake_two', CAST(@cfg_min_stake_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_min_stake_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 142 OR `key_name` = 'min_stake_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 143, 'one', 'one', CAST(@cfg_one AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_one IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 143 OR `key_name` = 'one');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 144, 'one_rate', 'one_rate', CAST(@cfg_one_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_one_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 144 OR `key_name` = 'one_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 145, 'one_rate_new', 'one_rate_new', CAST(@cfg_one_rate_new AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_one_rate_new IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 145 OR `key_name` = 'one_rate_new');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 146, 'open_box_price', 'open_box_price', CAST(@cfg_open_box_price AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_open_box_price IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 146 OR `key_name` = 'open_box_price');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 147, 'open_box_price_use', 'open_box_price_use', CAST(@cfg_open_box_price_use AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_open_box_price_use IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 147 OR `key_name` = 'open_box_price_use');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 148, 'play_one_rate', 'play_one_rate', CAST(@cfg_play_one_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_play_one_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 148 OR `key_name` = 'play_one_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 149, 'play_two_rate', 'play_two_rate', CAST(@cfg_play_two_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_play_two_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 149 OR `key_name` = 'play_two_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 150, 'prop_two_two', 'prop_two_two', CAST(@cfg_prop_two_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_prop_two_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 150 OR `key_name` = 'prop_two_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 151, 'queue_amount', 'queue_amount', CAST(@cfg_queue_amount AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_queue_amount IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 151 OR `key_name` = 'queue_amount');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 152, 'rate_r_1', 'rate_r_1', CAST(@cfg_rate_r_1 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_1 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 152 OR `key_name` = 'rate_r_1');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 153, 'rate_r_10', 'rate_r_10', CAST(@cfg_rate_r_10 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_10 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 153 OR `key_name` = 'rate_r_10');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 154, 'rate_r_2', 'rate_r_2', CAST(@cfg_rate_r_2 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_2 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 154 OR `key_name` = 'rate_r_2');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 155, 'rate_r_3', 'rate_r_3', CAST(@cfg_rate_r_3 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_3 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 155 OR `key_name` = 'rate_r_3');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 156, 'rate_r_4', 'rate_r_4', CAST(@cfg_rate_r_4 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_4 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 156 OR `key_name` = 'rate_r_4');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 157, 'rate_r_5', 'rate_r_5', CAST(@cfg_rate_r_5 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_5 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 157 OR `key_name` = 'rate_r_5');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 158, 'rate_r_6', 'rate_r_6', CAST(@cfg_rate_r_6 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_6 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 158 OR `key_name` = 'rate_r_6');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 159, 'rate_r_7', 'rate_r_7', CAST(@cfg_rate_r_7 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_7 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 159 OR `key_name` = 'rate_r_7');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 160, 'rate_r_8', 'rate_r_8', CAST(@cfg_rate_r_8 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_8 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 160 OR `key_name` = 'rate_r_8');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 161, 'rate_r_9', 'rate_r_9', CAST(@cfg_rate_r_9 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rate_r_9 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 161 OR `key_name` = 'rate_r_9');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 162, 'recommend', 'recommend', CAST(@cfg_recommend AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_recommend IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 162 OR `key_name` = 'recommend');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 163, 'recommend_two', 'recommend_two', CAST(@cfg_recommend_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_recommend_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 163 OR `key_name` = 'recommend_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 164, 'recommend_two_sub', 'recommend_two_sub', CAST(@cfg_recommend_two_sub AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_recommend_two_sub IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 164 OR `key_name` = 'recommend_two_sub');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 165, 'rent_rate_one', 'rent_rate_one', CAST(@cfg_rent_rate_one AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rent_rate_one IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 165 OR `key_name` = 'rent_rate_one');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 166, 'rent_rate_three', 'rent_rate_three', CAST(@cfg_rent_rate_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rent_rate_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 166 OR `key_name` = 'rent_rate_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 167, 'rent_rate_two', 'rent_rate_two', CAST(@cfg_rent_rate_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_rent_rate_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 167 OR `key_name` = 'rent_rate_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 168, 'reward_land', 'reward_land', CAST(@cfg_reward_land AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_reward_land IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 168 OR `key_name` = 'reward_land');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 169, 'reward_stake_rate', 'reward_stake_rate', CAST(@cfg_reward_stake_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_reward_stake_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 169 OR `key_name` = 'reward_stake_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 170, 's_rate', 's_rate', CAST(@cfg_s_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_s_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 170 OR `key_name` = 's_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 171, 'self_sub', 'self_sub', CAST(@cfg_self_sub AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_self_sub IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 171 OR `key_name` = 'self_sub');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 172, 'sell_fee_rate', 'sell_fee_rate', CAST(@cfg_sell_fee_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_sell_fee_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 172 OR `key_name` = 'sell_fee_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 173, 'sell_land', 'sell_land', CAST(@cfg_sell_land AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_sell_land IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 173 OR `key_name` = 'sell_land');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 174, 'stake_ispay_five', 'stake_ispay_five', CAST(@cfg_stake_ispay_five AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_ispay_five IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 174 OR `key_name` = 'stake_ispay_five');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 175, 'stake_ispay_four', 'stake_ispay_four', CAST(@cfg_stake_ispay_four AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_ispay_four IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 175 OR `key_name` = 'stake_ispay_four');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 176, 'stake_ispay_one', 'stake_ispay_one', CAST(@cfg_stake_ispay_one AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_ispay_one IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 176 OR `key_name` = 'stake_ispay_one');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 177, 'stake_ispay_three', 'stake_ispay_three', CAST(@cfg_stake_ispay_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_ispay_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 177 OR `key_name` = 'stake_ispay_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 178, 'stake_ispay_two', 'stake_ispay_two', CAST(@cfg_stake_ispay_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_ispay_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 178 OR `key_name` = 'stake_ispay_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 179, 'stake_over_rate', 'stake_over_rate', CAST(@cfg_stake_over_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_over_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 179 OR `key_name` = 'stake_over_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 180, 'stake_price', 'stake_price', CAST(@cfg_stake_price AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_price IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 180 OR `key_name` = 'stake_price');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 181, 'stake_price_on', 'stake_price_on', CAST(@cfg_stake_price_on AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_price_on IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 181 OR `key_name` = 'stake_price_on');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 182, 'stake_rate_new', 'stake_rate_new', CAST(@cfg_stake_rate_new AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_rate_new IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 182 OR `key_name` = 'stake_rate_new');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 183, 'stake_recommend_one', 'stake_recommend_one', CAST(@cfg_stake_recommend_one AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_recommend_one IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 183 OR `key_name` = 'stake_recommend_one');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 184, 'stake_recommend_three', 'stake_recommend_three', CAST(@cfg_stake_recommend_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_recommend_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 184 OR `key_name` = 'stake_recommend_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 185, 'stake_recommend_two', 'stake_recommend_two', CAST(@cfg_stake_recommend_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_stake_recommend_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 185 OR `key_name` = 'stake_recommend_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 186, 'sys_content', 'sys_content', CAST(@cfg_sys_content AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_sys_content IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 186 OR `key_name` = 'sys_content');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 187, 'sys_content_e', 'sys_content_e', CAST(@cfg_sys_content_e AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_sys_content_e IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 187 OR `key_name` = 'sys_content_e');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 188, 'three', 'three', CAST(@cfg_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 188 OR `key_name` = 'three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 189, 'three_rate', 'three_rate', CAST(@cfg_three_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_three_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 189 OR `key_name` = 'three_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 190, 'two', 'two', CAST(@cfg_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 190 OR `key_name` = 'two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 191, 'two_rate', 'two_rate', CAST(@cfg_two_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_two_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 191 OR `key_name` = 'two_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 192, 'two_sub_reward', 'two_sub_reward', CAST(@cfg_two_sub_reward AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_two_sub_reward IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 192 OR `key_name` = 'two_sub_reward');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 193, 'v_1', 'v_1', CAST(@cfg_v_1 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_1 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 193 OR `key_name` = 'v_1');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 194, 'v_10', 'v_10', CAST(@cfg_v_10 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_10 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 194 OR `key_name` = 'v_10');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 195, 'v_2', 'v_2', CAST(@cfg_v_2 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_2 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 195 OR `key_name` = 'v_2');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 196, 'v_3', 'v_3', CAST(@cfg_v_3 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_3 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 196 OR `key_name` = 'v_3');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 197, 'v_4', 'v_4', CAST(@cfg_v_4 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_4 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 197 OR `key_name` = 'v_4');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 198, 'v_5', 'v_5', CAST(@cfg_v_5 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_5 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 198 OR `key_name` = 'v_5');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 199, 'v_6', 'v_6', CAST(@cfg_v_6 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_6 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 199 OR `key_name` = 'v_6');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 200, 'v_7', 'v_7', CAST(@cfg_v_7 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_7 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 200 OR `key_name` = 'v_7');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 201, 'v_8', 'v_8', CAST(@cfg_v_8 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_8 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 201 OR `key_name` = 'v_8');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 202, 'v_9', 'v_9', CAST(@cfg_v_9 AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_v_9 IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 202 OR `key_name` = 'v_9');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 203, 'win_rate', 'win_rate', CAST(@cfg_win_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_win_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 203 OR `key_name` = 'win_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 204, 'withdraw_amount_max', 'withdraw_amount_max', CAST(@cfg_withdraw_amount_max AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_amount_max IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 204 OR `key_name` = 'withdraw_amount_max');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 205, 'withdraw_amount_max_three', 'withdraw_amount_max_three', CAST(@cfg_withdraw_amount_max_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_amount_max_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 205 OR `key_name` = 'withdraw_amount_max_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 206, 'withdraw_amount_max_two', 'withdraw_amount_max_two', CAST(@cfg_withdraw_amount_max_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_amount_max_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 206 OR `key_name` = 'withdraw_amount_max_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 207, 'withdraw_amount_min', 'withdraw_amount_min', CAST(@cfg_withdraw_amount_min AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_amount_min IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 207 OR `key_name` = 'withdraw_amount_min');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 208, 'withdraw_amount_min_three', 'withdraw_amount_min_three', CAST(@cfg_withdraw_amount_min_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_amount_min_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 208 OR `key_name` = 'withdraw_amount_min_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 209, 'withdraw_amount_min_two', 'withdraw_amount_min_two', CAST(@cfg_withdraw_amount_min_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_amount_min_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 209 OR `key_name` = 'withdraw_amount_min_two');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 210, 'withdraw_rate', 'withdraw_rate', CAST(@cfg_withdraw_rate AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_rate IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 210 OR `key_name` = 'withdraw_rate');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 211, 'withdraw_rate_three', 'withdraw_rate_three', CAST(@cfg_withdraw_rate_three AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_rate_three IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 211 OR `key_name` = 'withdraw_rate_three');

INSERT INTO `config` (`id`, `name`, `key_name`, `value`, `created_at`, `updated_at`)
SELECT 212, 'withdraw_rate_two', 'withdraw_rate_two', CAST(@cfg_withdraw_rate_two AS CHAR), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @cfg_withdraw_rate_two IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `config` WHERE `id` = 212 OR `key_name` = 'withdraw_rate_two');

COMMIT;
