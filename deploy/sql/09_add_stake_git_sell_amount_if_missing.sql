-- 已经导入旧版建表 SQL 时补充 stake_git.sell_amount。
-- 先选定目标数据库；已存在该列时跳过；不修改或重置现有金额。
-- 两端 internal/data/user.go 的 stakeGit 函数均写 sell_amount，但模型未声明该字段。
-- 类型沿用项目其他 sell_amount：DECIMAL(65,20)，缺省 0。
SET @game_restore_patch_sql = IF(
    EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'stake_git'
          AND column_name = 'sell_amount'
    ),
    'SELECT ''stake_git.sell_amount already exists'' AS result',
    'ALTER TABLE `stake_git` ADD COLUMN `sell_amount` DECIMAL(65,20) NOT NULL DEFAULT 0 COMMENT ''由两端 stakeGit 写入代码推导的售卖金额'' AFTER `status`'
);
PREPARE game_restore_patch_stmt FROM @game_restore_patch_sql;
EXECUTE game_restore_patch_stmt;
DEALLOCATE PREPARE game_restore_patch_stmt;
