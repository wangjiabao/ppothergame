-- 从两个项目当前代码提取的全部 120 个 config 键；生成日期 2026-10-02。
-- 本文件只是 SELECT 清单，不会写入或修改 config；不需要选择数据库。
-- 104 个键有活动读取分支；16 个键仅保留在活动查询参数中。
-- id=16~21、26 保留代码依赖；其余从 100 起新分配，不能声称是历史编号。
-- name 暂用 key_name；value=NULL 表示历史值无法由代码推出。
-- 真正写入配置使用 04_config_init_template.sql，先填写需要的值。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;

-- box_start；代码固定对应关系
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/BuyBox:3961
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/BuyBox:2143
-- 查询：ppothergameadmin/AdminGetBox:6141
SELECT 16 AS `id`, 'box_start' AS `name`, 'box_start' AS `key_name`, NULL AS `value`, '时间文本 YYYY-MM-DD HH:MM:SS，代码按 UTC 解析' AS `read_type`, '有活动读取分支' AS `usage_status`, '代码固定对应关系' AS `id_basis`

-- box_end；代码固定对应关系
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/BuyBox:3961
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/BuyBox:2143
-- 查询：ppothergameadmin/AdminGetBox:6141
UNION ALL SELECT 17, 'box_end', 'box_end', NULL, '时间文本 YYYY-MM-DD HH:MM:SS，代码按 UTC 解析', '有活动读取分支', '代码固定对应关系'

-- box_amount；代码固定对应关系
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/BuyBox:3961
-- 查询：ppothergame/OpenBox:4166
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/BuyBox:2143
-- 查询：ppothergameadmin/AdminGetBox:6141
UNION ALL SELECT 18, 'box_amount', 'box_amount', NULL, '小数', '有活动读取分支', '代码固定对应关系'

-- box_num；代码固定对应关系
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserBoxList:2250
-- 查询：ppothergame/BuyBox:3961
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/UserBoxList:1303
-- 查询：ppothergameadmin/BuyBox:2143
-- 查询：ppothergameadmin/AdminGetBox:6141
-- 查询：ppothergameadmin/AdminSetBox:6194
UNION ALL SELECT 19, 'box_num', 'box_num', NULL, '无符号整数', '有活动读取分支', '代码固定对应关系'

-- box_max；代码固定对应关系
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/BuyBox:3961
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/BuyBox:2143
-- 查询：ppothergameadmin/AdminGetBox:6141
UNION ALL SELECT 20, 'box_max', 'box_max', NULL, '无符号整数', '有活动读取分支', '代码固定对应关系'

-- box_sell_num；代码固定对应关系
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/BuyBox:3961
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/BuyBox:2143
-- 查询：ppothergameadmin/AdminGetBox:6141
UNION ALL SELECT 21, 'box_sell_num', 'box_sell_num', NULL, '无符号整数', '有活动读取分支', '代码固定对应关系'

-- u_price；代码固定对应关系
-- 查询：ppothergame/UserBuy:742
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserBuyL:1868
-- 查询：ppothergame/BuyBox:3961
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergame/BuyTwo:9113
-- 查询：ppothergameadmin/AdminSetConfig:6487
-- 查询：ppothergameadmin/AdminDailyReward:6740
-- 查询：ppothergameadmin/DepositNewThree:9395
-- 查询：ppothergameadmin/AdminRewardListTwo:9545
-- 查询：ppothergameadmin/AdminUserBuy:9765
UNION ALL SELECT 26, 'u_price', 'u_price', NULL, '小数', '有活动读取分支', '代码固定对应关系'

-- all_each；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 100, 'all_each', 'all_each', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- area_five；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 101, 'area_five', 'area_five', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- area_four；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 102, 'area_four', 'area_four', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- area_one；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 103, 'area_one', 'area_one', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- area_three；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 104, 'area_three', 'area_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- area_two；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 105, 'area_two', 'area_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- area_zero；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 106, 'area_zero', 'area_zero', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- b_price；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 107, 'b_price', 'b_price', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_eight；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 108, 'buy_eight', 'buy_eight', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_five；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 109, 'buy_five', 'buy_five', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_four；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 110, 'buy_four', 'buy_four', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_land_one；空库新分配，非历史编号
-- 查询：ppothergame/Buy:6387
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 111, 'buy_land_one', 'buy_land_one', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_land_three；空库新分配，非历史编号
-- 查询：ppothergame/Buy:6387
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 112, 'buy_land_three', 'buy_land_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_land_two；空库新分配，非历史编号
-- 查询：ppothergame/Buy:6387
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 113, 'buy_land_two', 'buy_land_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_one；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 114, 'buy_one', 'buy_one', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_seven；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 115, 'buy_seven', 'buy_seven', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_six；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 116, 'buy_six', 'buy_six', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_three；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 117, 'buy_three', 'buy_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- buy_two；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 118, 'buy_two', 'buy_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- can_withdraw；空库新分配，非历史编号
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 119, 'can_withdraw', 'can_withdraw', NULL, '无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- exchange_fee_rate；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/Exchange:5165
UNION ALL SELECT 120, 'exchange_fee_rate', 'exchange_fee_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- exchange_fee_rate_two；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 121, 'exchange_fee_rate_two', 'exchange_fee_rate_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- exchange_max_three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 122, 'exchange_max_three', 'exchange_max_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- exchange_min_three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 123, 'exchange_min_three', 'exchange_min_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- exchange_price；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 124, 'exchange_price', 'exchange_price', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- exchange_price_open；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 125, 'exchange_price_open', 'exchange_price_open', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- exchange_stake_rate；空库新分配，非历史编号
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 126, 'exchange_stake_rate', 'exchange_stake_rate', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- exchange_three；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 127, 'exchange_three', 'exchange_three', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- exchange_three_rate；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 128, 'exchange_three_rate', 'exchange_three_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_1；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 129, 'g_1', 'g_1', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_2；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 130, 'g_2', 'g_2', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_3；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 131, 'g_3', 'g_3', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_4；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 132, 'g_4', 'g_4', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_5；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 133, 'g_5', 'g_5', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_6；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 134, 'g_6', 'g_6', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_7；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 135, 'g_7', 'g_7', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- g_8；空库新分配，非历史编号
-- 查询：ppothergame/UserRankList:3459
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminDaily:8139
UNION ALL SELECT 136, 'g_8', 'g_8', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- low_reward_u；空库新分配，非历史编号
-- 查询：ppothergame/LandPlaySix:5635
UNION ALL SELECT 137, 'low_reward_u', 'low_reward_u', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- max_play；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/StakeGetPlay:8535
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 138, 'max_play', 'max_play', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- max_stake；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/StakeGet:8337
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 139, 'max_stake', 'max_stake', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- min_play；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/StakeGetPlay:8535
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 140, 'min_play', 'min_play', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- min_stake；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/StakeGet:8337
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 141, 'min_stake', 'min_stake', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- min_stake_two；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/StakeGet:8337
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 142, 'min_stake_two', 'min_stake_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- one；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 143, 'one', 'one', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- one_rate；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergameadmin/LandPlayTwo:2692
-- 查询：ppothergameadmin/LandPlaySix:3424
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 144, 'one_rate', 'one_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- one_rate_new；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 145, 'one_rate_new', 'one_rate_new', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- open_box_price；空库新分配，非历史编号
-- 查询：ppothergame/OpenBox:4166
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 146, 'open_box_price', 'open_box_price', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- open_box_price_use；空库新分配，非历史编号
-- 查询：ppothergame/OpenBox:4166
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 147, 'open_box_price_use', 'open_box_price_use', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- play_one_rate；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayOne:4579
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 148, 'play_one_rate', 'play_one_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- play_two_rate；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayOne:4579
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 149, 'play_two_rate', 'play_two_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- prop_two_two；空库新分配，非历史编号
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 150, 'prop_two_two', 'prop_two_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- queue_amount；空库新分配，非历史编号
-- 查询：ppothergame/UserStakeGitStakeList:2062
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/AdminSetQueue:6555
UNION ALL SELECT 151, 'queue_amount', 'queue_amount', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_1；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 152, 'rate_r_1', 'rate_r_1', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_10；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 153, 'rate_r_10', 'rate_r_10', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_2；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 154, 'rate_r_2', 'rate_r_2', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_3；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 155, 'rate_r_3', 'rate_r_3', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_4；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 156, 'rate_r_4', 'rate_r_4', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_5；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 157, 'rate_r_5', 'rate_r_5', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_6；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 158, 'rate_r_6', 'rate_r_6', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_7；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 159, 'rate_r_7', 'rate_r_7', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_8；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 160, 'rate_r_8', 'rate_r_8', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rate_r_9；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
-- 后台 DepositNewTwo 查询 rate_r_9，但 r9 分支比较的是 rate_r_8；建记录不能修正此代码问题。
UNION ALL SELECT 161, 'rate_r_9', 'rate_r_9', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- recommend；空库新分配，非历史编号
-- 查询：ppothergame/BuyTwo:9113
UNION ALL SELECT 162, 'recommend', 'recommend', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- recommend_two；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 163, 'recommend_two', 'recommend_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- recommend_two_sub；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminDailyReward:6740
UNION ALL SELECT 164, 'recommend_two_sub', 'recommend_two_sub', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rent_rate_one；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/RentLand:7421
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 165, 'rent_rate_one', 'rent_rate_one', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rent_rate_three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/RentLand:7421
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 166, 'rent_rate_three', 'rent_rate_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- rent_rate_two；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/RentLand:7421
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 167, 'rent_rate_two', 'rent_rate_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- reward_land；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminLandReward:6274
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 168, 'reward_land', 'reward_land', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- reward_stake_rate；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 169, 'reward_stake_rate', 'reward_stake_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- s_rate；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergame/LandPlaySeven:6124
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 170, 's_rate', 's_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- self_sub；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergame/LandPlaySeven:6124
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 171, 'self_sub', 'self_sub', NULL, '无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- sell_fee_rate；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Buy:6387
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/Buy:3703
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 172, 'sell_fee_rate', 'sell_fee_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- sell_land；空库新分配，非历史编号
-- 查询：ppothergame/Sell:6941
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 173, 'sell_land', 'sell_land', NULL, '无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- stake_ispay_five；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
UNION ALL SELECT 174, 'stake_ispay_five', 'stake_ispay_five', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- stake_ispay_four；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
UNION ALL SELECT 175, 'stake_ispay_four', 'stake_ispay_four', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- stake_ispay_one；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 176, 'stake_ispay_one', 'stake_ispay_one', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- stake_ispay_three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
UNION ALL SELECT 177, 'stake_ispay_three', 'stake_ispay_three', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- stake_ispay_two；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
UNION ALL SELECT 178, 'stake_ispay_two', 'stake_ispay_two', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- stake_over_rate；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/StakeGetPlay:8535
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/StakeGetPlay:4970
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 179, 'stake_over_rate', 'stake_over_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- stake_price；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/OpenBox:4166
-- 查询：ppothergame/StakeGit:7208
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 180, 'stake_price', 'stake_price', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- stake_price_on；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/OpenBox:4166
-- 查询：ppothergame/StakeGit:7208
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 181, 'stake_price_on', 'stake_price_on', NULL, '无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- stake_rate_new；空库新分配，非历史编号
-- 查询：ppothergame/StakeGit:7208
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 182, 'stake_rate_new', 'stake_rate_new', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- stake_recommend_one；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 183, 'stake_recommend_one', 'stake_recommend_one', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- stake_recommend_three；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 184, 'stake_recommend_three', 'stake_recommend_three', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- stake_recommend_two；空库新分配，非历史编号
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 185, 'stake_recommend_two', 'stake_recommend_two', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- sys_content；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 186, 'sys_content', 'sys_content', NULL, '文本', '有活动读取分支', '空库新分配，非历史编号'

-- sys_content_e；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 187, 'sys_content_e', 'sys_content_e', NULL, '文本', '有活动读取分支', '空库新分配，非历史编号'

-- three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 188, 'three', 'three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- three_rate；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergameadmin/LandPlayTwo:2692
-- 查询：ppothergameadmin/LandPlaySix:3424
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 189, 'three_rate', 'three_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- two；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 190, 'two', 'two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- two_rate；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayTwo:4749
-- 查询：ppothergame/LandPlaySix:5635
-- 查询：ppothergameadmin/LandPlayTwo:2692
-- 查询：ppothergameadmin/LandPlaySix:3424
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 191, 'two_rate', 'two_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- two_sub_reward；空库新分配，非历史编号
-- 查询：ppothergame/LandPlayFour:5356
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 192, 'two_sub_reward', 'two_sub_reward', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_1；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 193, 'v_1', 'v_1', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_10；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 194, 'v_10', 'v_10', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_2；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 195, 'v_2', 'v_2', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_3；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 196, 'v_3', 'v_3', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_4；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 197, 'v_4', 'v_4', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_5；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 198, 'v_5', 'v_5', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_6；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 199, 'v_6', 'v_6', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_7；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 200, 'v_7', 'v_7', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_8；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 201, 'v_8', 'v_8', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- v_9；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/UserRecommend:1627
-- 查询：ppothergameadmin/AdminUserList:5487
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 查询：ppothergameadmin/DepositNewTwo:9001
UNION ALL SELECT 202, 'v_9', 'v_9', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- win_rate；空库新分配，非历史编号
-- 查询：ppothergame/StakeGetPlay:8535
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 203, 'win_rate', 'win_rate', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_amount_max；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/Withdraw:5214
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 204, 'withdraw_amount_max', 'withdraw_amount_max', NULL, '无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_amount_max_three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 205, 'withdraw_amount_max_three', 'withdraw_amount_max_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_amount_max_two；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 同一个键分别被 ParseUint 和 ParseFloat 读取；填写整数字符串才能同时满足当前两种读取。
UNION ALL SELECT 206, 'withdraw_amount_max_two', 'withdraw_amount_max_two', NULL, '小数 / 无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_amount_min；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/UserInfo:799
-- 查询：ppothergameadmin/Withdraw:5214
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 207, 'withdraw_amount_min', 'withdraw_amount_min', NULL, '无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_amount_min_three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 208, 'withdraw_amount_min_three', 'withdraw_amount_min_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_amount_min_two；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
-- 同一个键分别被 ParseUint 和 ParseFloat 读取；填写整数字符串才能同时满足当前两种读取。
UNION ALL SELECT 209, 'withdraw_amount_min_two', 'withdraw_amount_min_two', NULL, '小数 / 无符号整数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_rate；空库新分配，非历史编号
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 210, 'withdraw_rate', 'withdraw_rate', NULL, '当前代码仅查询，未实际解析，值类型待确认', '仅出现在活动查询参数中', '空库新分配，非历史编号'

-- withdraw_rate_three；空库新分配，非历史编号
-- 查询：ppothergame/UserInfo:965
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 211, 'withdraw_rate_three', 'withdraw_rate_three', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'

-- withdraw_rate_two；空库新分配，非历史编号
-- 查询：ppothergame/Withdraw:9435
-- 查询：ppothergameadmin/AdminGetConfig:6353
UNION ALL SELECT 212, 'withdraw_rate_two', 'withdraw_rate_two', NULL, '小数', '有活动读取分支', '空库新分配，非历史编号'
;
