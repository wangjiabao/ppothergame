-- 按用户要求：user.address改为完整列唯一索引。先选定目标数据库。
-- 最新08空库导入已包含；已有表才执行本文件。地址流水表允许同地址多条，不改它们。
-- 如有重复地址（按当前列排序规则比较），报告BLOCKED，不删除或改写用户数据。
-- 等价完整列唯一索引已存在则跳过；同名不同定义报告REVIEW。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;

-- 先列出重复项；应返回0行。
SELECT address, COUNT(*) AS duplicate_count FROM `user` GROUP BY address HAVING COUNT(*) > 1;

SET @game_addr_duplicates = (SELECT COUNT(*) FROM (SELECT address FROM `user` GROUP BY address HAVING COUNT(*) > 1) AS duplicated_addresses);
SET @game_addr_unique = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='user'
  GROUP BY INDEX_NAME HAVING COUNT(*)=1 AND MAX(NON_UNIQUE)=0
    AND MAX(COLUMN_NAME)='address' AND MAX(SUB_PART) IS NULL
) AS exact_unique_indexes);
SET @game_addr_named = (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='user' AND INDEX_NAME='uq_user_address');
SET @game_addr_old_normal = (SELECT COUNT(*) FROM (
  SELECT INDEX_NAME FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='user' AND INDEX_NAME='idx_address'
  GROUP BY INDEX_NAME HAVING COUNT(*)=1 AND MAX(NON_UNIQUE)=1
    AND MAX(COLUMN_NAME)='address' AND MAX(SUB_PART) IS NULL
) AS old_normal_indexes);
SET @game_addr_sql = IF(@game_addr_unique > 0,
  'SELECT ''EXISTS user.address完整列唯一索引已存在'' AS address_index_result',
  IF(@game_addr_duplicates > 0,
    'SELECT ''BLOCKED 存在重复地址，请先人工核对处理后再执行'' AS address_index_result',
    IF(@game_addr_named > 0,
      'SELECT ''REVIEW uq_user_address同名索引定义不同，请人工核对'' AS address_index_result',
      IF(@game_addr_old_normal > 0,
        'ALTER TABLE `user` DROP INDEX `idx_address`, ADD UNIQUE INDEX `uq_user_address` (`address`)',
        'ALTER TABLE `user` ADD UNIQUE INDEX `uq_user_address` (`address`)'
      )
    )
  )
);
PREPARE game_addr_stmt FROM @game_addr_sql;
EXECUTE game_addr_stmt;
DEALLOCATE PREPARE game_addr_stmt;

-- 核对索引。
SELECT INDEX_NAME, NON_UNIQUE, COLUMN_NAME, SUB_PART, SEQ_IN_INDEX
FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='user'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;
