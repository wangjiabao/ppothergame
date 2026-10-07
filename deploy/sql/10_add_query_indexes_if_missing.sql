-- 现有表的索引补充；先选定目标库。用于MySQL 5.7/8.0语法，不依赖存储过程或DELIMITER。
-- 所有索引来自当前查询推导，非旧库索引恢复；详细证据见12。
-- 空库首次导入最新08已内置这些索引，无需再执行本文件。
-- 只加缺失索引、不删除旧索引、不改表字段；大表ALTER耗时取决于服务器和数据。
-- 同名不同定义会明确报告REVIEW并跳过；其他同列同顺序索引视作已存在。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;

-- user.idx_created_at：新增用户按时间统计
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND INDEX_NAME = 'idx_created_at');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS user.idx_created_at'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW user.idx_created_at 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `user` ADD INDEX `idx_created_at` (`created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- user.idx_amount_usdt_total：累计充值排行榜
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'amount_usdt_total');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND INDEX_NAME = 'idx_amount_usdt_total');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS user.idx_amount_usdt_total'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW user.idx_amount_usdt_total 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `user` ADD INDEX `idx_amount_usdt_total` (`amount_usdt_total`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- user.idx_amount_usdt：后台按USDT余额排序；与土地数量排序是互斥分支
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'amount_usdt');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND INDEX_NAME = 'idx_amount_usdt');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS user.idx_amount_usdt'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW user.idx_amount_usdt 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `user` ADD INDEX `idx_amount_usdt` (`amount_usdt`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- user.idx_land_count：后台按土地数量排序；事件每5分钟更新该列会维护索引
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'land_count');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND INDEX_NAME = 'idx_land_count');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS user.idx_land_count'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW user.idx_land_count 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `user` ADD INDEX `idx_land_count` (`land_count`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- user.idx_git：GIT正余额筛选及排行榜
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'git');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND INDEX_NAME = 'idx_git');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS user.idx_git'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW user.idx_git 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `user` ADD INDEX `idx_git` (`git`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- user_recommend.idx_recommend_code_prefix：推荐链等值及前缀LIKE；191字符只是本次选择，长链仍回表精确过滤
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user_recommend'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'recommend_code(191)');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user_recommend' AND INDEX_NAME = 'idx_recommend_code_prefix');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS user_recommend.idx_recommend_code_prefix'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW user_recommend.idx_recommend_code_prefix 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `user_recommend` ADD INDEX `idx_recommend_code_prefix` (`recommend_code`(191))'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- admin.idx_account：登录账户等值定位；密码由原WHERE继续过滤
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'account');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin' AND INDEX_NAME = 'idx_account');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS admin.idx_account'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW admin.idx_account 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `admin` ADD INDEX `idx_account` (`account`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- message.idx_status：状态筛选及id倒序分页；InnoDB二级索引带主键id
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'message'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'message' AND INDEX_NAME = 'idx_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS message.idx_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW message.idx_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `message` ADD INDEX `idx_status` (`status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- message.idx_user_created：用户每日消息计数
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'message'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'message' AND INDEX_NAME = 'idx_user_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS message.idx_user_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW message.idx_user_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `message` ADD INDEX `idx_user_created` (`user_id`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- admin_message.idx_status：App公告状态筛选和id倒序
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin_message'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin_message' AND INDEX_NAME = 'idx_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS admin_message.idx_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW admin_message.idx_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `admin_message` ADD INDEX `idx_status` (`status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land.idx_user_status_limit：用户有效土地；status多值时id排序可能仍需filesort
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,status,limit_date');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land' AND INDEX_NAME = 'idx_user_status_limit');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land.idx_user_status_limit'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land.idx_user_status_limit 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land` ADD INDEX `idx_user_status_limit` (`user_id`, `status`, `limit_date`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land.idx_location_user_num：首页使用者定位及格子查询
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'location_user_id,location_num');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land' AND INDEX_NAME = 'idx_location_user_num');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land.idx_location_user_num'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land.idx_location_user_num 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land` ADD INDEX `idx_location_user_num` (`location_user_id`, `location_num`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land.idx_user_location_num：拥有者、使用者、格子组合定位
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,location_user_id,location_num');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land' AND INDEX_NAME = 'idx_user_location_num');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land.idx_user_location_num'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land.idx_user_location_num 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land` ADD INDEX `idx_user_location_num` (`user_id`, `location_user_id`, `location_num`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land.idx_user_admin_status：后台查看管理员发放的土地
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,admin_add,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land' AND INDEX_NAME = 'idx_user_admin_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land.idx_user_admin_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land.idx_user_admin_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land` ADD INDEX `idx_user_admin_status` (`user_id`, `admin_add`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land.idx_reward_limit：分红任务查询可分红且未到期土地
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'can_reward,limit_date');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land' AND INDEX_NAME = 'idx_reward_limit');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land.idx_reward_limit'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land.idx_reward_limit 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land` ADD INDEX `idx_reward_limit` (`can_reward`, `limit_date`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land_user_use.idx_user_status：用户当前种植记录
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use' AND INDEX_NAME = 'idx_user_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land_user_use.idx_user_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land_user_use.idx_user_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land_user_use` ADD INDEX `idx_user_status` (`user_id`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land_user_use.idx_land_status：批量土地当前种植记录
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'land_id,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use' AND INDEX_NAME = 'idx_land_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land_user_use.idx_land_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land_user_use.idx_land_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land_user_use` ADD INDEX `idx_land_status` (`land_id`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land_user_use.idx_owner_status_land：后台按拥有者及土地批量读取
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'owner_user_id,status,land_id');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use' AND INDEX_NAME = 'idx_owner_status_land');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land_user_use.idx_owner_status_land'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land_user_use.idx_owner_status_land 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land_user_use` ADD INDEX `idx_owner_status_land` (`owner_user_id`, `status`, `land_id`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land_user_use.idx_maturity：成熟列表以等值条件后接结束时间；sub_time后置过滤，不能同时优化两个范围
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status,one,two,over_time,sub_time');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_user_use' AND INDEX_NAME = 'idx_maturity');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land_user_use.idx_maturity'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land_user_use.idx_maturity 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land_user_use` ADD INDEX `idx_maturity` (`status`, `one`, `two`, `over_time`, `sub_time`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- seed.idx_user_status：用户种子库存状态
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'seed'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'seed' AND INDEX_NAME = 'idx_user_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS seed.idx_user_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW seed.idx_user_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `seed` ADD INDEX `idx_user_status` (`user_id`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- seed.idx_user_admin_status：后台管理员发放记录
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'seed'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,admin_add,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'seed' AND INDEX_NAME = 'idx_user_admin_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS seed.idx_user_admin_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW seed.idx_user_admin_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `seed` ADD INDEX `idx_user_admin_status` (`user_id`, `admin_add`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- seed.idx_status：全局上架库存及数量；保留user_id!=时剩余过滤
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'seed'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'seed' AND INDEX_NAME = 'idx_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS seed.idx_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW seed.idx_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `seed` ADD INDEX `idx_status` (`status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- prop.idx_user_type_status：用户道具类型及状态库存
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,prop_type,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop' AND INDEX_NAME = 'idx_user_type_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS prop.idx_user_type_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW prop.idx_user_type_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `prop` ADD INDEX `idx_user_type_status` (`user_id`, `prop_type`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- prop.idx_user_admin_status：后台管理员发放道具
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,admin_add,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop' AND INDEX_NAME = 'idx_user_admin_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS prop.idx_user_admin_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW prop.idx_user_admin_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `prop` ADD INDEX `idx_user_admin_status` (`user_id`, `admin_add`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- prop.idx_status_type：全局上架道具与类型计数
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status,prop_type');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop' AND INDEX_NAME = 'idx_status_type');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS prop.idx_status_type'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW prop.idx_status_type 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `prop` ADD INDEX `idx_status_type` (`status`, `prop_type`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- land_info.idx_level：等级排序和按等级修改；不推断唯一约束
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_info'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'level');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'land_info' AND INDEX_NAME = 'idx_level');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS land_info.idx_level'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW land_info.idx_level 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `land_info` ADD INDEX `idx_level` (`level`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- prop_info.idx_prop_type：按类型修改；不推断唯一约束
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop_info'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'prop_type');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prop_info' AND INDEX_NAME = 'idx_prop_type');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS prop_info.idx_prop_type'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW prop_info.idx_prop_type 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `prop_info` ADD INDEX `idx_prop_type` (`prop_type`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- box_record.idx_num：批次盲盒库存及总数
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'num');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record' AND INDEX_NAME = 'idx_num');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS box_record.idx_num'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW box_record.idx_num 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `box_record` ADD INDEX `idx_num` (`num`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- box_record.idx_user_num：用户按批次倒序查询
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,num');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record' AND INDEX_NAME = 'idx_user_num');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS box_record.idx_user_num'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW box_record.idx_user_num 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `box_record` ADD INDEX `idx_user_num` (`user_id`, `num`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- box_record.idx_user_good：用户已开盲盒数量
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,good_id');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record' AND INDEX_NAME = 'idx_user_good');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS box_record.idx_user_good'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW box_record.idx_user_good 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `box_record` ADD INDEX `idx_user_good` (`user_id`, `good_id`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- box_record.idx_user_updated_good：用户时间范围查询；good_id作为索引过滤，不保证两范围都缩小扫描
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,updated_at,good_id');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'box_record' AND INDEX_NAME = 'idx_user_updated_good');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS box_record.idx_user_updated_good'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW box_record.idx_user_updated_good 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `box_record` ADD INDEX `idx_user_updated_good` (`user_id`, `updated_at`, `good_id`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- market.idx_user_status：用户市场状态列表
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'market'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'market' AND INDEX_NAME = 'idx_user_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS market.idx_user_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW market.idx_user_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `market` ADD INDEX `idx_user_status` (`user_id`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- buy_land.idx_status：竞拍状态查询；status<=条件与id顺序存在取舍
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'buy_land'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'buy_land' AND INDEX_NAME = 'idx_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS buy_land.idx_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW buy_land.idx_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `buy_land` ADD INDEX `idx_status` (`status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- buy_land_record.idx_auction_amount：竞拍ID内按出价倒序取最高报价
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'buy_land_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'buy_land_id,amount');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'buy_land_record' AND INDEX_NAME = 'idx_auction_amount');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS buy_land_record.idx_auction_amount'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW buy_land_record.idx_auction_amount 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `buy_land_record` ADD INDEX `idx_auction_amount` (`buy_land_id`, `amount`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- notice.idx_user_created：App按消息时间倒序；原user_id索引保留供后台id排序
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'notice'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'notice' AND INDEX_NAME = 'idx_user_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS notice.idx_user_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW notice.idx_user_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `notice` ADD INDEX `idx_user_created` (`user_id`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- reward.idx_user_reason：用户收益类型分页；单reason等值支持隐含id顺序，多值IN可能排序
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,reason');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward' AND INDEX_NAME = 'idx_user_reason');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS reward.idx_user_reason'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW reward.idx_user_reason 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `reward` ADD INDEX `idx_user_reason` (`user_id`, `reason`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- reward.idx_user_reason_created：用户指定类型日计数
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,reason,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward' AND INDEX_NAME = 'idx_user_reason_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS reward.idx_user_reason_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW reward.idx_user_reason_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `reward` ADD INDEX `idx_user_reason_created` (`user_id`, `reason`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- reward.idx_user_reason_two：指定用户、原因、two编号批量匹配
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,reason,two');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward' AND INDEX_NAME = 'idx_user_reason_two');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS reward.idx_user_reason_two'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW reward.idx_user_reason_two 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `reward` ADD INDEX `idx_user_reason_two` (`user_id`, `reason`, `two`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- reward_two.idx_user_reason：用户分红记录按类型分页
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward_two'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,reason');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward_two' AND INDEX_NAME = 'idx_user_reason');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS reward_two.idx_user_reason'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW reward_two.idx_user_reason 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `reward_two` ADD INDEX `idx_user_reason` (`user_id`, `reason`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- reward_two.idx_reason_created：后台指定原因及时间窗口任务
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward_two'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'reason,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward_two' AND INDEX_NAME = 'idx_reason_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS reward_two.idx_reason_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW reward_two.idx_reason_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `reward_two` ADD INDEX `idx_reason_created` (`reason`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- reward_four.idx_user_created：用户时间范围收益SUM
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward_four'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reward_four' AND INDEX_NAME = 'idx_user_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS reward_four.idx_user_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW reward_four.idx_user_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `reward_four` ADD INDEX `idx_user_created` (`user_id`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_get_play_record.idx_user_status：用户游戏状态计数与后台列表
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_get_play_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_get_play_record' AND INDEX_NAME = 'idx_user_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_get_play_record.idx_user_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_get_play_record.idx_user_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_get_play_record` ADD INDEX `idx_user_status` (`user_id`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_get_play_record.idx_status：App该函数实际未加user_id过滤，按全局status倒序；索引不改变其逻辑
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_get_play_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_get_play_record' AND INDEX_NAME = 'idx_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_get_play_record.idx_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_get_play_record.idx_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_get_play_record` ADD INDEX `idx_status` (`status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_git.idx_user_status：用户质押状态更新；函数未查到调用点，仍兼容保留
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git' AND INDEX_NAME = 'idx_user_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_git.idx_user_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_git.idx_user_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_git` ADD INDEX `idx_user_status` (`user_id`, `status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_git_record.idx_user_stake_type：用户历史GIT质押操作类型分页
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,stake_type');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record' AND INDEX_NAME = 'idx_user_stake_type');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_git_record.idx_user_stake_type'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_git_record.idx_user_stake_type 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_git_record` ADD INDEX `idx_user_stake_type` (`user_id`, `stake_type`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_git_record_ispay.idx_user_stake_type：ISPAY质押按用户及类型分页
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,stake_type');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay' AND INDEX_NAME = 'idx_user_stake_type');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_git_record_ispay.idx_user_stake_type'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_git_record_ispay.idx_user_stake_type 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_git_record_ispay` ADD INDEX `idx_user_stake_type` (`user_id`, `stake_type`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_git_record_ispay.idx_type_created：后台批量时间范围处理
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'stake_type,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay' AND INDEX_NAME = 'idx_type_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_git_record_ispay.idx_type_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_git_record_ispay.idx_type_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_git_record_ispay` ADD INDEX `idx_type_created` (`stake_type`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_git_record_ispay_queue.idx_user_type：队列用户类型记录及id分页
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay_queue'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,stake_type');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay_queue' AND INDEX_NAME = 'idx_user_type');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_git_record_ispay_queue.idx_user_type'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_git_record_ispay_queue.idx_user_type 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_git_record_ispay_queue` ADD INDEX `idx_user_type` (`user_id`, `stake_type`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_git_record_ispay_queue.idx_user_type_created：App用户队列日期范围
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay_queue'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,stake_type,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay_queue' AND INDEX_NAME = 'idx_user_type_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_git_record_ispay_queue.idx_user_type_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_git_record_ispay_queue.idx_user_type_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_git_record_ispay_queue` ADD INDEX `idx_user_type_created` (`user_id`, `stake_type`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- stake_git_record_ispay_queue.idx_type_updated：每日队列统计及全局待处理类型；覆盖type左前缀
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay_queue'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'stake_type,updated_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stake_git_record_ispay_queue' AND INDEX_NAME = 'idx_type_updated');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS stake_git_record_ispay_queue.idx_type_updated'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW stake_git_record_ispay_queue.idx_type_updated 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `stake_git_record_ispay_queue` ADD INDEX `idx_type_updated` (`stake_type`, `updated_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- withdraw.idx_user_created：用户每日提现计数
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw' AND INDEX_NAME = 'idx_user_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS withdraw.idx_user_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW withdraw.idx_user_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `withdraw` ADD INDEX `idx_user_created` (`user_id`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- withdraw.idx_user_coin_created：用户币种日提现限制
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,coin,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw' AND INDEX_NAME = 'idx_user_coin_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS withdraw.idx_user_coin_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW withdraw.idx_user_coin_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `withdraw` ADD INDEX `idx_user_coin_created` (`user_id`, `coin`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- withdraw.idx_coin_created：币种时间窗口SUM
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'coin,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw' AND INDEX_NAME = 'idx_coin_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS withdraw.idx_coin_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW withdraw.idx_coin_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `withdraw` ADD INDEX `idx_coin_created` (`coin`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- withdraw.idx_status：后台待处理提现队列First，默认主键顺序
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'withdraw' AND INDEX_NAME = 'idx_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS withdraw.idx_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW withdraw.idx_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `withdraw` ADD INDEX `idx_status` (`status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- exchange.idx_user_created：用户每日兑换记录
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'exchange'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'user_id,created_at');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'exchange' AND INDEX_NAME = 'idx_user_created');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS exchange.idx_user_created'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW exchange.idx_user_created 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `exchange` ADD INDEX `idx_user_created` (`user_id`, `created_at`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- eth_record.idx_address：后台地址流水及id分页
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'address');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record' AND INDEX_NAME = 'idx_address');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS eth_record.idx_address'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW eth_record.idx_address 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `eth_record` ADD INDEX `idx_address` (`address`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- eth_record.idx_last：充值扫描最大last游标；该字段含义按代码保留
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'last');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record' AND INDEX_NAME = 'idx_last');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS eth_record.idx_last'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW eth_record.idx_last 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `eth_record` ADD INDEX `idx_last` (`last`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- eth_record_two.idx_address：后台地址流水及id分页
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_two'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'address');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_two' AND INDEX_NAME = 'idx_address');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS eth_record_two.idx_address'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW eth_record_two.idx_address 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `eth_record_two` ADD INDEX `idx_address` (`address`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- eth_record_two.idx_last：充值扫描最大last游标；该字段含义按代码保留
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_two'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'last');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_two' AND INDEX_NAME = 'idx_last');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS eth_record_two.idx_last'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW eth_record_two.idx_last 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `eth_record_two` ADD INDEX `idx_last` (`last`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- eth_record_three.idx_address：后台地址流水及id分页
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_three'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'address');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_three' AND INDEX_NAME = 'idx_address');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS eth_record_three.idx_address'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW eth_record_three.idx_address 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `eth_record_three` ADD INDEX `idx_address` (`address`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- eth_record_three.idx_last：充值扫描最大last游标；该字段含义按代码保留
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_three'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'last');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_three' AND INDEX_NAME = 'idx_last');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS eth_record_three.idx_last'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW eth_record_three.idx_last 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `eth_record_three` ADD INDEX `idx_last` (`last`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- eth_record_two.idx_recommend_code_prefix：App推荐链前缀LIKE；不能同时保证id全局倒序免排序
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_two'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'recommend_code(191)');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'eth_record_two' AND INDEX_NAME = 'idx_recommend_code_prefix');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS eth_record_two.idx_recommend_code_prefix'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW eth_record_two.idx_recommend_code_prefix 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `eth_record_two` ADD INDEX `idx_recommend_code_prefix` (`recommend_code`(191))'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- price_change.idx_status：价格任务状态及id排序
SET @game_idx_equivalent = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS col_signature
  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'price_change'
  GROUP BY INDEX_NAME) AS existing_indexes WHERE col_signature = 'status');
SET @game_idx_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'price_change' AND INDEX_NAME = 'idx_status');
SET @game_idx_sql = IF(@game_idx_equivalent > 0, 'SELECT ''EXISTS price_change.idx_status'' AS index_result',
  IF(@game_idx_named > 0, 'SELECT ''REVIEW price_change.idx_status 同名索引定义不同，请人工核对'' AS index_result', 'ALTER TABLE `price_change` ADD INDEX `idx_status` (`status`)'));
PREPARE game_idx_stmt FROM @game_idx_sql;
EXECUTE game_idx_stmt;
DEALLOCATE PREPARE game_idx_stmt;

-- 核对当前全部索引（只读）
SELECT TABLE_NAME, INDEX_NAME, NON_UNIQUE, GROUP_CONCAT(CONCAT(COLUMN_NAME, IF(SUB_PART IS NULL, '', CONCAT('(', SUB_PART, ')'))) ORDER BY SEQ_IN_INDEX SEPARATOR ',') AS index_columns
FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() GROUP BY TABLE_NAME, INDEX_NAME, NON_UNIQUE ORDER BY TABLE_NAME, INDEX_NAME;
