-- 游戏恢复只读验收 SQL：先 USE 目标数据库，再执行。
-- 本文件只有 SET NAMES / SELECT，不创建、写入、修改或删除业务数据。
-- 缺表、缺字段、缺基础编号、重复键、固定编号冲突查询应返回 0 行。
-- config 未填项会列出，不代表建表失败；它们需要按所用功能填写 04 模板。
-- 只检查当前代码要求的表/字段存在性，不代替完整 SHOW CREATE TABLE 类型/约束核对。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;
SELECT DATABASE() AS selected_database, VERSION() AS mysql_version,
       @@GLOBAL.event_scheduler AS event_scheduler;

-- 1. 缺少的表（应为空；期望 38 张业务表）
SELECT e.table_name AS missing_table
FROM (
SELECT 'user' AS `table_name`
UNION ALL SELECT 'user_recommend'
UNION ALL SELECT 'admin'
UNION ALL SELECT 'admin_set_balance'
UNION ALL SELECT 'config'
UNION ALL SELECT 'notice'
UNION ALL SELECT 'message'
UNION ALL SELECT 'admin_message'
UNION ALL SELECT 'land'
UNION ALL SELECT 'land_user_use'
UNION ALL SELECT 'seed'
UNION ALL SELECT 'prop'
UNION ALL SELECT 'land_info'
UNION ALL SELECT 'seed_info'
UNION ALL SELECT 'prop_info'
UNION ALL SELECT 'random_seeds'
UNION ALL SELECT 'box_record'
UNION ALL SELECT 'market'
UNION ALL SELECT 'buy_land'
UNION ALL SELECT 'buy_land_record'
UNION ALL SELECT 'reward'
UNION ALL SELECT 'reward_two'
UNION ALL SELECT 'reward_four'
UNION ALL SELECT 'stake_get'
UNION ALL SELECT 'stake_get_record'
UNION ALL SELECT 'stake_get_play_record'
UNION ALL SELECT 'stake_get_total'
UNION ALL SELECT 'stake_git'
UNION ALL SELECT 'stake_git_record'
UNION ALL SELECT 'stake_git_record_ispay'
UNION ALL SELECT 'stake_git_record_ispay_queue'
UNION ALL SELECT 'withdraw'
UNION ALL SELECT 'exchange'
UNION ALL SELECT 'exchange_record'
UNION ALL SELECT 'eth_record'
UNION ALL SELECT 'eth_record_two'
UNION ALL SELECT 'eth_record_three'
UNION ALL SELECT 'price_change'
) e
LEFT JOIN information_schema.tables t ON t.table_schema=DATABASE() AND t.table_name=e.table_name
WHERE t.table_name IS NULL;

-- 2. 缺少的字段（应为空；期望覆盖 386 个字段）
SELECT e.table_name, e.column_name AS missing_column
FROM (
SELECT 'user' AS `table_name`, 'id' AS `column_name`
UNION ALL SELECT 'user', 'address'
UNION ALL SELECT 'user', 'level'
UNION ALL SELECT 'user', 'giw'
UNION ALL SELECT 'user', 'giw_add'
UNION ALL SELECT 'user', 'git'
UNION ALL SELECT 'user', 'total'
UNION ALL SELECT 'user', 'total_one'
UNION ALL SELECT 'user', 'total_two'
UNION ALL SELECT 'user', 'total_three'
UNION ALL SELECT 'user', 'reward_one'
UNION ALL SELECT 'user', 'reward_two'
UNION ALL SELECT 'user', 'reward_three'
UNION ALL SELECT 'user', 'reward_two_one'
UNION ALL SELECT 'user', 'reward_two_two'
UNION ALL SELECT 'user', 'reward_two_three'
UNION ALL SELECT 'user', 'reward_three_one'
UNION ALL SELECT 'user', 'reward_three_two'
UNION ALL SELECT 'user', 'reward_three_three'
UNION ALL SELECT 'user', 'location'
UNION ALL SELECT 'user', 'recommend'
UNION ALL SELECT 'user', 'recommend_two'
UNION ALL SELECT 'user', 'area'
UNION ALL SELECT 'user', 'area_two'
UNION ALL SELECT 'user', 'all'
UNION ALL SELECT 'user', 'all_num'
UNION ALL SELECT 'user', 'amount'
UNION ALL SELECT 'user', 'amount_get'
UNION ALL SELECT 'user', 'amount_usdt'
UNION ALL SELECT 'user', 'amount_usdt_total'
UNION ALL SELECT 'user', 'my_total_amount'
UNION ALL SELECT 'user', 'my_total_amount_new'
UNION ALL SELECT 'user', 'out_num'
UNION ALL SELECT 'user', 'vip'
UNION ALL SELECT 'user', 'vip_admin'
UNION ALL SELECT 'user', 'lock_use'
UNION ALL SELECT 'user', 'lock_reward'
UNION ALL SELECT 'user', 'usdt_two'
UNION ALL SELECT 'user', 'giw_two'
UNION ALL SELECT 'user', 'created_at'
UNION ALL SELECT 'user', 'updated_at'
UNION ALL SELECT 'user', 'can_sell'
UNION ALL SELECT 'user', 'can_rent'
UNION ALL SELECT 'user', 'can_land'
UNION ALL SELECT 'user', 'withdraw_max'
UNION ALL SELECT 'user', 'can_sell_prop'
UNION ALL SELECT 'user', 'can_play_add'
UNION ALL SELECT 'user', 'can_play_six'
UNION ALL SELECT 'user', 'git_new'
UNION ALL SELECT 'user', 'git_new_new'
UNION ALL SELECT 'user', 'one'
UNION ALL SELECT 'user', 'two'
UNION ALL SELECT 'user', 'three'
UNION ALL SELECT 'user', 'ispay_amount'
UNION ALL SELECT 'user', 'stake_ispay_amount'
UNION ALL SELECT 'user', 'open_box_amount'
UNION ALL SELECT 'user', 'land_count'
UNION ALL SELECT 'user', 'last_reward_total'
UNION ALL SELECT 'user', 'land_reward'
UNION ALL SELECT 'user', 'recommend_one'
UNION ALL SELECT 'user_recommend', 'id'
UNION ALL SELECT 'user_recommend', 'user_id'
UNION ALL SELECT 'user_recommend', 'recommend_code'
UNION ALL SELECT 'user_recommend', 'created_at'
UNION ALL SELECT 'user_recommend', 'updated_at'
UNION ALL SELECT 'admin', 'id'
UNION ALL SELECT 'admin', 'account'
UNION ALL SELECT 'admin', 'password'
UNION ALL SELECT 'admin', 'type'
UNION ALL SELECT 'admin_set_balance', 'id'
UNION ALL SELECT 'admin_set_balance', 'address'
UNION ALL SELECT 'admin_set_balance', 'coin'
UNION ALL SELECT 'admin_set_balance', 'amount'
UNION ALL SELECT 'admin_set_balance', 'created_at'
UNION ALL SELECT 'admin_set_balance', 'updated_at'
UNION ALL SELECT 'config', 'id'
UNION ALL SELECT 'config', 'name'
UNION ALL SELECT 'config', 'key_name'
UNION ALL SELECT 'config', 'value'
UNION ALL SELECT 'config', 'created_at'
UNION ALL SELECT 'config', 'updated_at'
UNION ALL SELECT 'notice', 'id'
UNION ALL SELECT 'notice', 'user_id'
UNION ALL SELECT 'notice', 'notice_content'
UNION ALL SELECT 'notice', 'notice_content_two'
UNION ALL SELECT 'notice', 'created_at'
UNION ALL SELECT 'notice', 'updated_at'
UNION ALL SELECT 'message', 'id'
UNION ALL SELECT 'message', 'content'
UNION ALL SELECT 'message', 'user_id'
UNION ALL SELECT 'message', 'status'
UNION ALL SELECT 'message', 'created_at'
UNION ALL SELECT 'message', 'updated_at'
UNION ALL SELECT 'admin_message', 'id'
UNION ALL SELECT 'admin_message', 'content'
UNION ALL SELECT 'admin_message', 'content_two'
UNION ALL SELECT 'admin_message', 'status'
UNION ALL SELECT 'admin_message', 'created_at'
UNION ALL SELECT 'admin_message', 'updated_at'
UNION ALL SELECT 'land', 'id'
UNION ALL SELECT 'land', 'user_id'
UNION ALL SELECT 'land', 'level'
UNION ALL SELECT 'land', 'out_put_rate'
UNION ALL SELECT 'land', 'rent_out_put_rate'
UNION ALL SELECT 'land', 'max_health'
UNION ALL SELECT 'land', 'per_health'
UNION ALL SELECT 'land', 'limit_date'
UNION ALL SELECT 'land', 'status'
UNION ALL SELECT 'land', 'location_num'
UNION ALL SELECT 'land', 'one'
UNION ALL SELECT 'land', 'two'
UNION ALL SELECT 'land', 'three'
UNION ALL SELECT 'land', 'sell_amount'
UNION ALL SELECT 'land', 'created_at'
UNION ALL SELECT 'land', 'updated_at'
UNION ALL SELECT 'land', 'admin_add'
UNION ALL SELECT 'land', 'location_user_id'
UNION ALL SELECT 'land', 'can_reward'
UNION ALL SELECT 'land_user_use', 'id'
UNION ALL SELECT 'land_user_use', 'land_id'
UNION ALL SELECT 'land_user_use', 'level'
UNION ALL SELECT 'land_user_use', 'user_id'
UNION ALL SELECT 'land_user_use', 'owner_user_id'
UNION ALL SELECT 'land_user_use', 'seed_id'
UNION ALL SELECT 'land_user_use', 'seed_type_id'
UNION ALL SELECT 'land_user_use', 'status'
UNION ALL SELECT 'land_user_use', 'begin_time'
UNION ALL SELECT 'land_user_use', 'total_time'
UNION ALL SELECT 'land_user_use', 'over_time'
UNION ALL SELECT 'land_user_use', 'out_max_num'
UNION ALL SELECT 'land_user_use', 'out_num'
UNION ALL SELECT 'land_user_use', 'insect_status'
UNION ALL SELECT 'land_user_use', 'out_sub_num'
UNION ALL SELECT 'land_user_use', 'steal_num'
UNION ALL SELECT 'land_user_use', 'stop_status'
UNION ALL SELECT 'land_user_use', 'stop_time'
UNION ALL SELECT 'land_user_use', 'sub_time'
UNION ALL SELECT 'land_user_use', 'use_chan'
UNION ALL SELECT 'land_user_use', 'created_at'
UNION ALL SELECT 'land_user_use', 'updated_at'
UNION ALL SELECT 'land_user_use', 'one'
UNION ALL SELECT 'land_user_use', 'two'
UNION ALL SELECT 'land_user_use', 'is_use_other'
UNION ALL SELECT 'seed', 'id'
UNION ALL SELECT 'seed', 'user_id'
UNION ALL SELECT 'seed', 'seed_id'
UNION ALL SELECT 'seed', 'name'
UNION ALL SELECT 'seed', 'out_amount'
UNION ALL SELECT 'seed', 'out_over_time'
UNION ALL SELECT 'seed', 'out_max_amount'
UNION ALL SELECT 'seed', 'out_min_amount'
UNION ALL SELECT 'seed', 'status'
UNION ALL SELECT 'seed', 'sell_amount'
UNION ALL SELECT 'seed', 'created_at'
UNION ALL SELECT 'seed', 'updated_at'
UNION ALL SELECT 'seed', 'admin_add'
UNION ALL SELECT 'prop', 'id'
UNION ALL SELECT 'prop', 'user_id'
UNION ALL SELECT 'prop', 'status'
UNION ALL SELECT 'prop', 'prop_type'
UNION ALL SELECT 'prop', 'one_one'
UNION ALL SELECT 'prop', 'one_two'
UNION ALL SELECT 'prop', 'two_one'
UNION ALL SELECT 'prop', 'two_two'
UNION ALL SELECT 'prop', 'three_one'
UNION ALL SELECT 'prop', 'four_one'
UNION ALL SELECT 'prop', 'five_one'
UNION ALL SELECT 'prop', 'sell_amount'
UNION ALL SELECT 'prop', 'created_at'
UNION ALL SELECT 'prop', 'updated_at'
UNION ALL SELECT 'prop', 'admin_add'
UNION ALL SELECT 'land_info', 'id'
UNION ALL SELECT 'land_info', 'level'
UNION ALL SELECT 'land_info', 'out_put_rate_max'
UNION ALL SELECT 'land_info', 'out_put_rate_min'
UNION ALL SELECT 'land_info', 'rent_out_put_rate_max'
UNION ALL SELECT 'land_info', 'max_health'
UNION ALL SELECT 'land_info', 'per_health'
UNION ALL SELECT 'land_info', 'limit_date_max'
UNION ALL SELECT 'land_info', 'created_at'
UNION ALL SELECT 'land_info', 'updated_at'
UNION ALL SELECT 'seed_info', 'id'
UNION ALL SELECT 'seed_info', 'name'
UNION ALL SELECT 'seed_info', 'out_min_amount'
UNION ALL SELECT 'seed_info', 'out_max_amount'
UNION ALL SELECT 'seed_info', 'get_rate'
UNION ALL SELECT 'seed_info', 'out_over_time'
UNION ALL SELECT 'seed_info', 'created_at'
UNION ALL SELECT 'seed_info', 'updated_at'
UNION ALL SELECT 'prop_info', 'id'
UNION ALL SELECT 'prop_info', 'prop_type'
UNION ALL SELECT 'prop_info', 'one_one'
UNION ALL SELECT 'prop_info', 'one_two'
UNION ALL SELECT 'prop_info', 'two_one'
UNION ALL SELECT 'prop_info', 'two_two'
UNION ALL SELECT 'prop_info', 'three_one'
UNION ALL SELECT 'prop_info', 'four_one'
UNION ALL SELECT 'prop_info', 'five_one'
UNION ALL SELECT 'prop_info', 'get_rate'
UNION ALL SELECT 'prop_info', 'created_at'
UNION ALL SELECT 'prop_info', 'updated_at'
UNION ALL SELECT 'random_seeds', 'id'
UNION ALL SELECT 'random_seeds', 'scene'
UNION ALL SELECT 'random_seeds', 'seed_value'
UNION ALL SELECT 'random_seeds', 'updated_at'
UNION ALL SELECT 'random_seeds', 'created_at'
UNION ALL SELECT 'box_record', 'id'
UNION ALL SELECT 'box_record', 'user_id'
UNION ALL SELECT 'box_record', 'num'
UNION ALL SELECT 'box_record', 'good_id'
UNION ALL SELECT 'box_record', 'good_type'
UNION ALL SELECT 'box_record', 'content'
UNION ALL SELECT 'box_record', 'created_at'
UNION ALL SELECT 'box_record', 'updated_at'
UNION ALL SELECT 'market', 'id'
UNION ALL SELECT 'market', 'user_id'
UNION ALL SELECT 'market', 'good_id'
UNION ALL SELECT 'market', 'good_type'
UNION ALL SELECT 'market', 'amount'
UNION ALL SELECT 'market', 'status'
UNION ALL SELECT 'market', 'get_user_id'
UNION ALL SELECT 'market', 'created_at'
UNION ALL SELECT 'market', 'updated_at'
UNION ALL SELECT 'buy_land', 'id'
UNION ALL SELECT 'buy_land', 'amount'
UNION ALL SELECT 'buy_land', 'status'
UNION ALL SELECT 'buy_land', 'created_at'
UNION ALL SELECT 'buy_land', 'updated_at'
UNION ALL SELECT 'buy_land', 'amount_two'
UNION ALL SELECT 'buy_land', 'limit'
UNION ALL SELECT 'buy_land', 'level'
UNION ALL SELECT 'buy_land_record', 'id'
UNION ALL SELECT 'buy_land_record', 'buy_land_id'
UNION ALL SELECT 'buy_land_record', 'amount'
UNION ALL SELECT 'buy_land_record', 'created_at'
UNION ALL SELECT 'buy_land_record', 'updated_at'
UNION ALL SELECT 'buy_land_record', 'status'
UNION ALL SELECT 'buy_land_record', 'user_id'
UNION ALL SELECT 'reward', 'id'
UNION ALL SELECT 'reward', 'user_id'
UNION ALL SELECT 'reward', 'reason'
UNION ALL SELECT 'reward', 'one'
UNION ALL SELECT 'reward', 'two'
UNION ALL SELECT 'reward', 'three'
UNION ALL SELECT 'reward', 'amount'
UNION ALL SELECT 'reward', 'created_at'
UNION ALL SELECT 'reward', 'updated_at'
UNION ALL SELECT 'reward_two', 'id'
UNION ALL SELECT 'reward_two', 'user_id'
UNION ALL SELECT 'reward_two', 'reason'
UNION ALL SELECT 'reward_two', 'one'
UNION ALL SELECT 'reward_two', 'two'
UNION ALL SELECT 'reward_two', 'three'
UNION ALL SELECT 'reward_two', 'amount'
UNION ALL SELECT 'reward_two', 'four'
UNION ALL SELECT 'reward_two', 'five'
UNION ALL SELECT 'reward_two', 'created_at'
UNION ALL SELECT 'reward_two', 'updated_at'
UNION ALL SELECT 'reward_four', 'id'
UNION ALL SELECT 'reward_four', 'user_id'
UNION ALL SELECT 'reward_four', 'reason'
UNION ALL SELECT 'reward_four', 'one'
UNION ALL SELECT 'reward_four', 'two'
UNION ALL SELECT 'reward_four', 'three'
UNION ALL SELECT 'reward_four', 'amount'
UNION ALL SELECT 'reward_four', 'created_at'
UNION ALL SELECT 'reward_four', 'updated_at'
UNION ALL SELECT 'stake_get', 'id'
UNION ALL SELECT 'stake_get', 'user_id'
UNION ALL SELECT 'stake_get', 'status'
UNION ALL SELECT 'stake_get', 'stake_rate'
UNION ALL SELECT 'stake_get', 'created_at'
UNION ALL SELECT 'stake_get', 'updated_at'
UNION ALL SELECT 'stake_get_record', 'id'
UNION ALL SELECT 'stake_get_record', 'user_id'
UNION ALL SELECT 'stake_get_record', 'amount'
UNION ALL SELECT 'stake_get_record', 'stake_rate'
UNION ALL SELECT 'stake_get_record', 'total'
UNION ALL SELECT 'stake_get_record', 'stake_type'
UNION ALL SELECT 'stake_get_record', 'created_at'
UNION ALL SELECT 'stake_get_record', 'updated_at'
UNION ALL SELECT 'stake_get_play_record', 'id'
UNION ALL SELECT 'stake_get_play_record', 'user_id'
UNION ALL SELECT 'stake_get_play_record', 'amount'
UNION ALL SELECT 'stake_get_play_record', 'reward'
UNION ALL SELECT 'stake_get_play_record', 'status'
UNION ALL SELECT 'stake_get_play_record', 'created_at'
UNION ALL SELECT 'stake_get_play_record', 'updated_at'
UNION ALL SELECT 'stake_get_total', 'id'
UNION ALL SELECT 'stake_get_total', 'amount'
UNION ALL SELECT 'stake_get_total', 'balance'
UNION ALL SELECT 'stake_get_total', 'created_at'
UNION ALL SELECT 'stake_get_total', 'updated_at'
UNION ALL SELECT 'stake_git', 'id'
UNION ALL SELECT 'stake_git', 'user_id'
UNION ALL SELECT 'stake_git', 'amount'
UNION ALL SELECT 'stake_git', 'reward'
UNION ALL SELECT 'stake_git', 'status'
UNION ALL SELECT 'stake_git', 'sell_amount'
UNION ALL SELECT 'stake_git', 'created_at'
UNION ALL SELECT 'stake_git', 'updated_at'
UNION ALL SELECT 'stake_git_record', 'id'
UNION ALL SELECT 'stake_git_record', 'user_id'
UNION ALL SELECT 'stake_git_record', 'amount'
UNION ALL SELECT 'stake_git_record', 'amount_two'
UNION ALL SELECT 'stake_git_record', 'stake_type'
UNION ALL SELECT 'stake_git_record', 'created_at'
UNION ALL SELECT 'stake_git_record', 'updated_at'
UNION ALL SELECT 'stake_git_record', 'day'
UNION ALL SELECT 'stake_git_record', 'price'
UNION ALL SELECT 'stake_git_record_ispay', 'id'
UNION ALL SELECT 'stake_git_record_ispay', 'user_id'
UNION ALL SELECT 'stake_git_record_ispay', 'amount'
UNION ALL SELECT 'stake_git_record_ispay', 'amount_two'
UNION ALL SELECT 'stake_git_record_ispay', 'stake_type'
UNION ALL SELECT 'stake_git_record_ispay', 'created_at'
UNION ALL SELECT 'stake_git_record_ispay', 'updated_at'
UNION ALL SELECT 'stake_git_record_ispay', 'day'
UNION ALL SELECT 'stake_git_record_ispay', 'price'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'id'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'user_id'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'amount'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'amount_two'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'amount_three'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'stake_type'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'created_at'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'updated_at'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'day'
UNION ALL SELECT 'stake_git_record_ispay_queue', 'price'
UNION ALL SELECT 'withdraw', 'id'
UNION ALL SELECT 'withdraw', 'user_id'
UNION ALL SELECT 'withdraw', 'amount'
UNION ALL SELECT 'withdraw', 'rel_amount'
UNION ALL SELECT 'withdraw', 'status'
UNION ALL SELECT 'withdraw', 'amount_float'
UNION ALL SELECT 'withdraw', 'rel_amount_float'
UNION ALL SELECT 'withdraw', 'coin'
UNION ALL SELECT 'withdraw', 'created_at'
UNION ALL SELECT 'withdraw', 'updated_at'
UNION ALL SELECT 'exchange', 'id'
UNION ALL SELECT 'exchange', 'user_id'
UNION ALL SELECT 'exchange', 'amount_float'
UNION ALL SELECT 'exchange', 'rel_amount_float'
UNION ALL SELECT 'exchange', 'amount_float_usdt'
UNION ALL SELECT 'exchange', 'created_at'
UNION ALL SELECT 'exchange', 'updated_at'
UNION ALL SELECT 'exchange_record', 'id'
UNION ALL SELECT 'exchange_record', 'user_id'
UNION ALL SELECT 'exchange_record', 'git'
UNION ALL SELECT 'exchange_record', 'giw'
UNION ALL SELECT 'exchange_record', 'fee'
UNION ALL SELECT 'exchange_record', 'created_at'
UNION ALL SELECT 'exchange_record', 'updated_at'
UNION ALL SELECT 'eth_record', 'id'
UNION ALL SELECT 'eth_record', 'user_id'
UNION ALL SELECT 'eth_record', 'amount'
UNION ALL SELECT 'eth_record', 'last'
UNION ALL SELECT 'eth_record', 'address'
UNION ALL SELECT 'eth_record', 'coin'
UNION ALL SELECT 'eth_record', 'created_at'
UNION ALL SELECT 'eth_record', 'updated_at'
UNION ALL SELECT 'eth_record', 'amount_float'
UNION ALL SELECT 'eth_record_two', 'id'
UNION ALL SELECT 'eth_record_two', 'user_id'
UNION ALL SELECT 'eth_record_two', 'amount'
UNION ALL SELECT 'eth_record_two', 'last'
UNION ALL SELECT 'eth_record_two', 'address'
UNION ALL SELECT 'eth_record_two', 'coin'
UNION ALL SELECT 'eth_record_two', 'recommend_code'
UNION ALL SELECT 'eth_record_two', 'created_at'
UNION ALL SELECT 'eth_record_two', 'updated_at'
UNION ALL SELECT 'eth_record_three', 'id'
UNION ALL SELECT 'eth_record_three', 'user_id'
UNION ALL SELECT 'eth_record_three', 'amount'
UNION ALL SELECT 'eth_record_three', 'amount_biw'
UNION ALL SELECT 'eth_record_three', 'last'
UNION ALL SELECT 'eth_record_three', 'address'
UNION ALL SELECT 'eth_record_three', 'coin'
UNION ALL SELECT 'eth_record_three', 'created_at'
UNION ALL SELECT 'eth_record_three', 'updated_at'
UNION ALL SELECT 'price_change', 'id'
UNION ALL SELECT 'price_change', 'price'
UNION ALL SELECT 'price_change', 'price_new'
UNION ALL SELECT 'price_change', 'status'
UNION ALL SELECT 'price_change', 'created_at'
UNION ALL SELECT 'price_change', 'updated_at'
) e
LEFT JOIN information_schema.columns c ON c.table_schema=DATABASE()
 AND c.table_name=e.table_name AND c.column_name=e.column_name
WHERE c.column_name IS NULL;

-- 3. 基础记录数量（空库初始化后：10/10/5/3/1，共 29 条）
SELECT 'seed_info' AS table_name, COUNT(*) AS actual_rows, 10 AS expected_rows FROM seed_info
UNION ALL SELECT 'land_info', COUNT(*), 10 FROM land_info
UNION ALL SELECT 'prop_info', COUNT(*), 5 FROM prop_info
UNION ALL SELECT 'random_seeds', COUNT(*), 3 FROM random_seeds
UNION ALL SELECT 'stake_get_total', COUNT(*), 1 FROM stake_get_total;

-- 4. 缺少的基础编号（应为空）
SELECT e.table_name, e.record_key AS missing_record_key FROM (
SELECT 'seed_info' AS `table_name`, 1 AS `record_key`
UNION ALL SELECT 'seed_info', 2
UNION ALL SELECT 'seed_info', 3
UNION ALL SELECT 'seed_info', 4
UNION ALL SELECT 'seed_info', 5
UNION ALL SELECT 'seed_info', 6
UNION ALL SELECT 'seed_info', 7
UNION ALL SELECT 'seed_info', 8
UNION ALL SELECT 'seed_info', 9
UNION ALL SELECT 'seed_info', 10
UNION ALL SELECT 'land_info', 1
UNION ALL SELECT 'land_info', 2
UNION ALL SELECT 'land_info', 3
UNION ALL SELECT 'land_info', 4
UNION ALL SELECT 'land_info', 5
UNION ALL SELECT 'land_info', 6
UNION ALL SELECT 'land_info', 7
UNION ALL SELECT 'land_info', 8
UNION ALL SELECT 'land_info', 9
UNION ALL SELECT 'land_info', 10
UNION ALL SELECT 'prop_info', 11
UNION ALL SELECT 'prop_info', 12
UNION ALL SELECT 'prop_info', 13
UNION ALL SELECT 'prop_info', 14
UNION ALL SELECT 'prop_info', 15
UNION ALL SELECT 'random_seeds', 1
UNION ALL SELECT 'random_seeds', 2
UNION ALL SELECT 'random_seeds', 3
UNION ALL SELECT 'stake_get_total', 1
) e LEFT JOIN (
SELECT 'seed_info' AS table_name, id AS record_key FROM seed_info
UNION ALL SELECT 'land_info', level FROM land_info
UNION ALL SELECT 'prop_info', prop_type FROM prop_info
UNION ALL SELECT 'random_seeds', scene FROM random_seeds
UNION ALL SELECT 'stake_get_total', id FROM stake_get_total
) a ON a.table_name=e.table_name AND a.record_key=e.record_key
WHERE a.record_key IS NULL;

-- 5. 按代码要求的身份键查重复（应为空）
SELECT 'config.key_name' AS checked_key, key_name AS duplicate_value, COUNT(*) AS copies
FROM config GROUP BY key_name HAVING COUNT(*)>1
UNION ALL SELECT 'land_info.level', CAST(level AS CHAR), COUNT(*) FROM land_info GROUP BY level HAVING COUNT(*)>1
UNION ALL SELECT 'prop_info.prop_type', CAST(prop_type AS CHAR), COUNT(*) FROM prop_info GROUP BY prop_type HAVING COUNT(*)>1
UNION ALL SELECT 'random_seeds.scene', CAST(scene AS CHAR), COUNT(*) FROM random_seeds GROUP BY scene HAVING COUNT(*)>1;

-- 6. 固定 config ID / key_name 缺失或冲突（需要的项应正确对应）
SELECT e.required_id, e.key_name AS required_key,
       by_id.key_name AS actual_key_at_id, by_key.id AS actual_id_for_key
FROM (
SELECT 16 AS `required_id`, 'box_start' AS `key_name`
UNION ALL SELECT 17, 'box_end'
UNION ALL SELECT 18, 'box_amount'
UNION ALL SELECT 19, 'box_num'
UNION ALL SELECT 20, 'box_max'
UNION ALL SELECT 21, 'box_sell_num'
UNION ALL SELECT 26, 'u_price'
) e LEFT JOIN config by_id ON by_id.id=e.required_id
LEFT JOIN config by_key ON by_key.key_name=e.key_name
WHERE by_id.id IS NULL OR by_key.id IS NULL
   OR by_id.key_name<>e.key_name OR by_key.id<>e.required_id;

-- 7. 120 个配置键的当前状态（未填写 04 前会显示为待填）
SELECT e.key_name, c.id AS actual_id, c.value,
 CASE WHEN c.id IS NULL THEN '未插入：填写 04 模板'
      WHEN c.value='' THEN '空字符串：检查取值'
      ELSE '已有记录：仍需按业务规则检查值' END AS config_status
FROM (
SELECT 'box_start' AS `key_name`
UNION ALL SELECT 'box_end'
UNION ALL SELECT 'box_amount'
UNION ALL SELECT 'box_num'
UNION ALL SELECT 'box_max'
UNION ALL SELECT 'box_sell_num'
UNION ALL SELECT 'u_price'
UNION ALL SELECT 'all_each'
UNION ALL SELECT 'area_five'
UNION ALL SELECT 'area_four'
UNION ALL SELECT 'area_one'
UNION ALL SELECT 'area_three'
UNION ALL SELECT 'area_two'
UNION ALL SELECT 'area_zero'
UNION ALL SELECT 'b_price'
UNION ALL SELECT 'buy_eight'
UNION ALL SELECT 'buy_five'
UNION ALL SELECT 'buy_four'
UNION ALL SELECT 'buy_land_one'
UNION ALL SELECT 'buy_land_three'
UNION ALL SELECT 'buy_land_two'
UNION ALL SELECT 'buy_one'
UNION ALL SELECT 'buy_seven'
UNION ALL SELECT 'buy_six'
UNION ALL SELECT 'buy_three'
UNION ALL SELECT 'buy_two'
UNION ALL SELECT 'can_withdraw'
UNION ALL SELECT 'exchange_fee_rate'
UNION ALL SELECT 'exchange_fee_rate_two'
UNION ALL SELECT 'exchange_max_three'
UNION ALL SELECT 'exchange_min_three'
UNION ALL SELECT 'exchange_price'
UNION ALL SELECT 'exchange_price_open'
UNION ALL SELECT 'exchange_stake_rate'
UNION ALL SELECT 'exchange_three'
UNION ALL SELECT 'exchange_three_rate'
UNION ALL SELECT 'g_1'
UNION ALL SELECT 'g_2'
UNION ALL SELECT 'g_3'
UNION ALL SELECT 'g_4'
UNION ALL SELECT 'g_5'
UNION ALL SELECT 'g_6'
UNION ALL SELECT 'g_7'
UNION ALL SELECT 'g_8'
UNION ALL SELECT 'low_reward_u'
UNION ALL SELECT 'max_play'
UNION ALL SELECT 'max_stake'
UNION ALL SELECT 'min_play'
UNION ALL SELECT 'min_stake'
UNION ALL SELECT 'min_stake_two'
UNION ALL SELECT 'one'
UNION ALL SELECT 'one_rate'
UNION ALL SELECT 'one_rate_new'
UNION ALL SELECT 'open_box_price'
UNION ALL SELECT 'open_box_price_use'
UNION ALL SELECT 'play_one_rate'
UNION ALL SELECT 'play_two_rate'
UNION ALL SELECT 'prop_two_two'
UNION ALL SELECT 'queue_amount'
UNION ALL SELECT 'rate_r_1'
UNION ALL SELECT 'rate_r_10'
UNION ALL SELECT 'rate_r_2'
UNION ALL SELECT 'rate_r_3'
UNION ALL SELECT 'rate_r_4'
UNION ALL SELECT 'rate_r_5'
UNION ALL SELECT 'rate_r_6'
UNION ALL SELECT 'rate_r_7'
UNION ALL SELECT 'rate_r_8'
UNION ALL SELECT 'rate_r_9'
UNION ALL SELECT 'recommend'
UNION ALL SELECT 'recommend_two'
UNION ALL SELECT 'recommend_two_sub'
UNION ALL SELECT 'rent_rate_one'
UNION ALL SELECT 'rent_rate_three'
UNION ALL SELECT 'rent_rate_two'
UNION ALL SELECT 'reward_land'
UNION ALL SELECT 'reward_stake_rate'
UNION ALL SELECT 's_rate'
UNION ALL SELECT 'self_sub'
UNION ALL SELECT 'sell_fee_rate'
UNION ALL SELECT 'sell_land'
UNION ALL SELECT 'stake_ispay_five'
UNION ALL SELECT 'stake_ispay_four'
UNION ALL SELECT 'stake_ispay_one'
UNION ALL SELECT 'stake_ispay_three'
UNION ALL SELECT 'stake_ispay_two'
UNION ALL SELECT 'stake_over_rate'
UNION ALL SELECT 'stake_price'
UNION ALL SELECT 'stake_price_on'
UNION ALL SELECT 'stake_rate_new'
UNION ALL SELECT 'stake_recommend_one'
UNION ALL SELECT 'stake_recommend_three'
UNION ALL SELECT 'stake_recommend_two'
UNION ALL SELECT 'sys_content'
UNION ALL SELECT 'sys_content_e'
UNION ALL SELECT 'three'
UNION ALL SELECT 'three_rate'
UNION ALL SELECT 'two'
UNION ALL SELECT 'two_rate'
UNION ALL SELECT 'two_sub_reward'
UNION ALL SELECT 'v_1'
UNION ALL SELECT 'v_10'
UNION ALL SELECT 'v_2'
UNION ALL SELECT 'v_3'
UNION ALL SELECT 'v_4'
UNION ALL SELECT 'v_5'
UNION ALL SELECT 'v_6'
UNION ALL SELECT 'v_7'
UNION ALL SELECT 'v_8'
UNION ALL SELECT 'v_9'
UNION ALL SELECT 'win_rate'
UNION ALL SELECT 'withdraw_amount_max'
UNION ALL SELECT 'withdraw_amount_max_three'
UNION ALL SELECT 'withdraw_amount_max_two'
UNION ALL SELECT 'withdraw_amount_min'
UNION ALL SELECT 'withdraw_amount_min_three'
UNION ALL SELECT 'withdraw_amount_min_two'
UNION ALL SELECT 'withdraw_rate'
UNION ALL SELECT 'withdraw_rate_three'
UNION ALL SELECT 'withdraw_rate_two'
) e LEFT JOIN config c ON c.key_name=e.key_name ORDER BY e.key_name;

-- 8. 事件状态及定义（执行 02 后应有 ENABLED 的五分钟事件；调度器另外要求 ON）
SELECT EVENT_NAME, STATUS, INTERVAL_VALUE, INTERVAL_FIELD, STARTS,
       LAST_EXECUTED, TIME_ZONE, DEFINER, EVENT_DEFINITION
FROM information_schema.events
WHERE EVENT_SCHEMA=DATABASE() AND EVENT_NAME='ev_refresh_land_count';

-- 9. 用户 land_count 与当前有效土地计数差异；事件运行后应收敛，业务并发可造成短暂差异。
SELECT u.id AS user_id, u.land_count AS stored_land_count, COALESCE(x.land_cnt,0) AS computed_land_count
FROM `user` u LEFT JOIN (
 SELECT user_id, COUNT(*) AS land_cnt FROM land
 WHERE status<=4 AND limit_date>UNIX_TIMESTAMP() GROUP BY user_id
) x ON x.user_id=u.id
WHERE NOT (u.land_count <=> COALESCE(x.land_cnt,0));

-- 查询索引覆盖检查（本次代码推导的63个新增普通索引）
-- 允许等价索引使用其他名称；同名不同列不会被当作匹配。
SELECT expected.table_name, expected.suggested_name, expected.expected_columns,
  IF(existing_indexes.index_name IS NULL, 'MISSING', 'OK') AS index_status, existing_indexes.index_name AS matched_index
FROM (
  SELECT 'user' AS table_name, 'idx_created_at' AS suggested_name, 'created_at' AS expected_columns
  UNION ALL
  SELECT 'user' AS table_name, 'idx_amount_usdt_total' AS suggested_name, 'amount_usdt_total' AS expected_columns
  UNION ALL
  SELECT 'user' AS table_name, 'idx_amount_usdt' AS suggested_name, 'amount_usdt' AS expected_columns
  UNION ALL
  SELECT 'user' AS table_name, 'idx_land_count' AS suggested_name, 'land_count' AS expected_columns
  UNION ALL
  SELECT 'user' AS table_name, 'idx_git' AS suggested_name, 'git' AS expected_columns
  UNION ALL
  SELECT 'user_recommend' AS table_name, 'idx_recommend_code_prefix' AS suggested_name, 'recommend_code(191)' AS expected_columns
  UNION ALL
  SELECT 'admin' AS table_name, 'idx_account' AS suggested_name, 'account' AS expected_columns
  UNION ALL
  SELECT 'message' AS table_name, 'idx_status' AS suggested_name, 'status' AS expected_columns
  UNION ALL
  SELECT 'message' AS table_name, 'idx_user_created' AS suggested_name, 'user_id,created_at' AS expected_columns
  UNION ALL
  SELECT 'admin_message' AS table_name, 'idx_status' AS suggested_name, 'status' AS expected_columns
  UNION ALL
  SELECT 'land' AS table_name, 'idx_user_status_limit' AS suggested_name, 'user_id,status,limit_date' AS expected_columns
  UNION ALL
  SELECT 'land' AS table_name, 'idx_location_user_num' AS suggested_name, 'location_user_id,location_num' AS expected_columns
  UNION ALL
  SELECT 'land' AS table_name, 'idx_user_location_num' AS suggested_name, 'user_id,location_user_id,location_num' AS expected_columns
  UNION ALL
  SELECT 'land' AS table_name, 'idx_user_admin_status' AS suggested_name, 'user_id,admin_add,status' AS expected_columns
  UNION ALL
  SELECT 'land' AS table_name, 'idx_reward_limit' AS suggested_name, 'can_reward,limit_date' AS expected_columns
  UNION ALL
  SELECT 'land_user_use' AS table_name, 'idx_user_status' AS suggested_name, 'user_id,status' AS expected_columns
  UNION ALL
  SELECT 'land_user_use' AS table_name, 'idx_land_status' AS suggested_name, 'land_id,status' AS expected_columns
  UNION ALL
  SELECT 'land_user_use' AS table_name, 'idx_owner_status_land' AS suggested_name, 'owner_user_id,status,land_id' AS expected_columns
  UNION ALL
  SELECT 'land_user_use' AS table_name, 'idx_maturity' AS suggested_name, 'status,one,two,over_time,sub_time' AS expected_columns
  UNION ALL
  SELECT 'seed' AS table_name, 'idx_user_status' AS suggested_name, 'user_id,status' AS expected_columns
  UNION ALL
  SELECT 'seed' AS table_name, 'idx_user_admin_status' AS suggested_name, 'user_id,admin_add,status' AS expected_columns
  UNION ALL
  SELECT 'seed' AS table_name, 'idx_status' AS suggested_name, 'status' AS expected_columns
  UNION ALL
  SELECT 'prop' AS table_name, 'idx_user_type_status' AS suggested_name, 'user_id,prop_type,status' AS expected_columns
  UNION ALL
  SELECT 'prop' AS table_name, 'idx_user_admin_status' AS suggested_name, 'user_id,admin_add,status' AS expected_columns
  UNION ALL
  SELECT 'prop' AS table_name, 'idx_status_type' AS suggested_name, 'status,prop_type' AS expected_columns
  UNION ALL
  SELECT 'land_info' AS table_name, 'idx_level' AS suggested_name, 'level' AS expected_columns
  UNION ALL
  SELECT 'prop_info' AS table_name, 'idx_prop_type' AS suggested_name, 'prop_type' AS expected_columns
  UNION ALL
  SELECT 'box_record' AS table_name, 'idx_num' AS suggested_name, 'num' AS expected_columns
  UNION ALL
  SELECT 'box_record' AS table_name, 'idx_user_num' AS suggested_name, 'user_id,num' AS expected_columns
  UNION ALL
  SELECT 'box_record' AS table_name, 'idx_user_good' AS suggested_name, 'user_id,good_id' AS expected_columns
  UNION ALL
  SELECT 'box_record' AS table_name, 'idx_user_updated_good' AS suggested_name, 'user_id,updated_at,good_id' AS expected_columns
  UNION ALL
  SELECT 'market' AS table_name, 'idx_user_status' AS suggested_name, 'user_id,status' AS expected_columns
  UNION ALL
  SELECT 'buy_land' AS table_name, 'idx_status' AS suggested_name, 'status' AS expected_columns
  UNION ALL
  SELECT 'buy_land_record' AS table_name, 'idx_auction_amount' AS suggested_name, 'buy_land_id,amount' AS expected_columns
  UNION ALL
  SELECT 'notice' AS table_name, 'idx_user_created' AS suggested_name, 'user_id,created_at' AS expected_columns
  UNION ALL
  SELECT 'reward' AS table_name, 'idx_user_reason' AS suggested_name, 'user_id,reason' AS expected_columns
  UNION ALL
  SELECT 'reward' AS table_name, 'idx_user_reason_created' AS suggested_name, 'user_id,reason,created_at' AS expected_columns
  UNION ALL
  SELECT 'reward' AS table_name, 'idx_user_reason_two' AS suggested_name, 'user_id,reason,two' AS expected_columns
  UNION ALL
  SELECT 'reward_two' AS table_name, 'idx_user_reason' AS suggested_name, 'user_id,reason' AS expected_columns
  UNION ALL
  SELECT 'reward_two' AS table_name, 'idx_reason_created' AS suggested_name, 'reason,created_at' AS expected_columns
  UNION ALL
  SELECT 'reward_four' AS table_name, 'idx_user_created' AS suggested_name, 'user_id,created_at' AS expected_columns
  UNION ALL
  SELECT 'stake_get_play_record' AS table_name, 'idx_user_status' AS suggested_name, 'user_id,status' AS expected_columns
  UNION ALL
  SELECT 'stake_get_play_record' AS table_name, 'idx_status' AS suggested_name, 'status' AS expected_columns
  UNION ALL
  SELECT 'stake_git' AS table_name, 'idx_user_status' AS suggested_name, 'user_id,status' AS expected_columns
  UNION ALL
  SELECT 'stake_git_record' AS table_name, 'idx_user_stake_type' AS suggested_name, 'user_id,stake_type' AS expected_columns
  UNION ALL
  SELECT 'stake_git_record_ispay' AS table_name, 'idx_user_stake_type' AS suggested_name, 'user_id,stake_type' AS expected_columns
  UNION ALL
  SELECT 'stake_git_record_ispay' AS table_name, 'idx_type_created' AS suggested_name, 'stake_type,created_at' AS expected_columns
  UNION ALL
  SELECT 'stake_git_record_ispay_queue' AS table_name, 'idx_user_type' AS suggested_name, 'user_id,stake_type' AS expected_columns
  UNION ALL
  SELECT 'stake_git_record_ispay_queue' AS table_name, 'idx_user_type_created' AS suggested_name, 'user_id,stake_type,created_at' AS expected_columns
  UNION ALL
  SELECT 'stake_git_record_ispay_queue' AS table_name, 'idx_type_updated' AS suggested_name, 'stake_type,updated_at' AS expected_columns
  UNION ALL
  SELECT 'withdraw' AS table_name, 'idx_user_created' AS suggested_name, 'user_id,created_at' AS expected_columns
  UNION ALL
  SELECT 'withdraw' AS table_name, 'idx_user_coin_created' AS suggested_name, 'user_id,coin,created_at' AS expected_columns
  UNION ALL
  SELECT 'withdraw' AS table_name, 'idx_coin_created' AS suggested_name, 'coin,created_at' AS expected_columns
  UNION ALL
  SELECT 'withdraw' AS table_name, 'idx_status' AS suggested_name, 'status' AS expected_columns
  UNION ALL
  SELECT 'exchange' AS table_name, 'idx_user_created' AS suggested_name, 'user_id,created_at' AS expected_columns
  UNION ALL
  SELECT 'eth_record' AS table_name, 'idx_address' AS suggested_name, 'address' AS expected_columns
  UNION ALL
  SELECT 'eth_record' AS table_name, 'idx_last' AS suggested_name, 'last' AS expected_columns
  UNION ALL
  SELECT 'eth_record_two' AS table_name, 'idx_address' AS suggested_name, 'address' AS expected_columns
  UNION ALL
  SELECT 'eth_record_two' AS table_name, 'idx_last' AS suggested_name, 'last' AS expected_columns
  UNION ALL
  SELECT 'eth_record_three' AS table_name, 'idx_address' AS suggested_name, 'address' AS expected_columns
  UNION ALL
  SELECT 'eth_record_three' AS table_name, 'idx_last' AS suggested_name, 'last' AS expected_columns
  UNION ALL
  SELECT 'eth_record_two' AS table_name, 'idx_recommend_code_prefix' AS suggested_name, 'recommend_code(191)' AS expected_columns
  UNION ALL
  SELECT 'price_change' AS table_name, 'idx_status' AS suggested_name, 'status' AS expected_columns
) AS expected
LEFT JOIN (
  SELECT TABLE_NAME, INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(',SUB_PART,')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS index_columns
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() GROUP BY TABLE_NAME, INDEX_NAME
) AS existing_indexes ON existing_indexes.TABLE_NAME = expected.table_name AND existing_indexes.index_columns = expected.expected_columns
ORDER BY expected.table_name, expected.suggested_name;

-- 全字段默认值检查（用户要求，排除自增主键）
-- 默认值检查：应返回0行；排除自增主键。
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, EXTRA
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME IN ('user','user_recommend','admin','admin_set_balance','config','notice','message','admin_message','land','land_user_use','seed','prop','land_info','seed_info','prop_info','random_seeds','box_record','market','buy_land','buy_land_record','reward','reward_two','reward_four','stake_get','stake_get_record','stake_get_play_record','stake_get_total','stake_git','stake_git_record','stake_git_record_ispay','stake_git_record_ispay_queue','withdraw','exchange','exchange_record','eth_record','eth_record_two','eth_record_three','price_change')
  AND EXTRA NOT LIKE '%auto_increment%' AND COLUMN_DEFAULT IS NULL
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- 用户地址唯一约束检查（用户指定；须为完整列，不是前缀或复合唯一键）
SELECT IF(COUNT(*) > 0, 'OK', 'MISSING') AS user_address_unique_index FROM (
  SELECT INDEX_NAME FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='user'
  GROUP BY INDEX_NAME HAVING COUNT(*)=1 AND MAX(NON_UNIQUE)=0
    AND MAX(COLUMN_NAME)='address' AND MAX(SUB_PART) IS NULL
) AS exact_user_address_unique_indexes;
