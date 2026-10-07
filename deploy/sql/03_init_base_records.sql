-- 空库基础记录初始化；先执行 01_restore_game_tables.sql，选定目标数据库。
-- 仅补缺失记录，不重置已经存在的随机种子和资金池；不插入用户余额或收益。
-- random_seeds.scene：1=盲盒，2=种植，3=粮仓游戏。
-- 证据：App internal/biz/app.go:4317、4610、8612；后台也使用场景 1、2。
-- seed_value=0 是新库初始化值，不是原历史随机种子。
-- 对应功能首次使用时，代码检测 seedInt<=0，写入 time.Now().UnixNano() 后建立 RNG。
-- UpdateSeedValue 只 UPDATE，不 INSERT，因此提前建场景记录保证写回能够持久化。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;
START TRANSACTION;

-- 场景 1：盲盒
INSERT INTO `random_seeds` (`scene`, `seed_value`, `created_at`, `updated_at`)
SELECT 1, 0, CURRENT_TIMESTAMP(3), CURRENT_TIMESTAMP(3)
WHERE NOT EXISTS (SELECT 1 FROM `random_seeds` WHERE `scene` = 1);

-- 场景 2：种植
INSERT INTO `random_seeds` (`scene`, `seed_value`, `created_at`, `updated_at`)
SELECT 2, 0, CURRENT_TIMESTAMP(3), CURRENT_TIMESTAMP(3)
WHERE NOT EXISTS (SELECT 1 FROM `random_seeds` WHERE `scene` = 2);

-- 场景 3：粮仓游戏
INSERT INTO `random_seeds` (`scene`, `seed_value`, `created_at`, `updated_at`)
SELECT 3, 0, CURRENT_TIMESTAMP(3), CURRENT_TIMESTAMP(3)
WHERE NOT EXISTS (SELECT 1 FROM `random_seeds` WHERE `scene` = 3);

-- 全局粮仓/质押资金池：查询取 First，但所有加减操作固定 WHERE id=1。
-- 证据：两端 internal/data/user.go 的 GetStakeGetTotal、SetStakeGetTotal / Sub。
-- 这是全新空池的零值初始化，不还原旧池余额或旧份额。
INSERT INTO `stake_get_total` (`id`, `amount`, `balance`, `created_at`, `updated_at`)
SELECT 1, 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM `stake_get_total` WHERE `id` = 1);

COMMIT;
