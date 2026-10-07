-- 种子/土地/道具基础记录初始化；已填调试占位值，建表后可直接执行。
-- 原来的每类价格、产量、概率、成熟时长、土地期限不保存在 Go 代码中，不能还原其历史数值。
-- seed_info 预留 ID 1~10：盲盒中奖编号 1~10 为种子、11~15 为道具。
-- land_info 预留 level 1~10：App GetLand 由 1 级开始合成，10 级停止。
-- prop_info 预留 prop_type 11~15：11化肥、12水、13手套、14除虫剂、15铲子。
-- 16盲盒由 box_record 管理；17地契由代码直接处理，无须为了它们新增 prop_info。
-- 后台的三个配置修改接口均为 UPDATE，只能修改已存在的基础记录，不能从空表新增。
-- 参数来源：土地增产量/肥沃度/消耗量，以及道具次数/效果沿用模型 DEFAULT。
-- 调试占位：种子名称为“调试种子1~10”，产出随机基值 [1,3)，实际随机得到整数 1 或 2，成熟时间 300 秒。
-- 代码先把产出上下限转成 int64；小于 1 的小数会截断成 0，所以调试上下限采用整数。
-- 调试占位：10 类种子、5 类道具的 get_rate 均设为 1；它是相对权重，不是 1%。
-- 调试占位：10 级土地使用期限均设为 30 天。
-- 当前后台土地配置接口只更新增产、肥沃度和消耗量；期限及出租产出参数需在导入前改 SET，导入后用 UPDATE。
-- 当前后台道具接口更新权重及水/手套/除虫剂/铲子的次数；化肥效果及铲子比例不在其更新范围内。
-- 土地 out_put_rate_min/max=100 是模型原默认，代码用于乘产出基值，不在这里改动其单位。
-- 这些占位值用于先补齐基础记录，并非还原原来的价格、概率或收益规则。
-- 首次执行会补齐 25 条基础记录；重复执行保留已有值，不会重置调试中改过的参数。
-- 后续调整已存在记录：接口支持的字段可通过后台修改，其余用明确的 UPDATE；改 SET 后重跑不会覆盖旧行。
-- 如果手动把参数改为 NULL，对应行仍会跳过。
-- seed_info.get_rate 是盲盒相对权重（会归一化）；产出代码先转整数，再取 [out_min_amount, out_max_amount)。
-- App 当前把道具读取/加入盲盒池的代码注释掉了，因此补 prop_info 记录不会让 App 盲盒自动抽出道具。
-- 土地参数保留模型默认 100；当前种植代码直接乘这个值，种子基值 1/2 对应种植产出上限 100/200，收获另受业务参数影响。
-- land_info.limit_date_max 在 App 中按天乘 3600*24；seed_info.out_over_time 按秒使用。
-- 仅插入缺失记录，不覆盖任何已有基础数据。
-- 若使用 00 合并文件导入，请直接改 00 中对应 SET，或改本文件后重新合并；本文件的编辑不会自动同步到 00。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;

SET @seed_1_name = '调试种子1';
SET @seed_1_out_min_amount = 1;
SET @seed_1_out_max_amount = 3;
SET @seed_1_get_rate = 1;
SET @seed_1_out_over_time = 300;

SET @seed_2_name = '调试种子2';
SET @seed_2_out_min_amount = 1;
SET @seed_2_out_max_amount = 3;
SET @seed_2_get_rate = 1;
SET @seed_2_out_over_time = 300;

SET @seed_3_name = '调试种子3';
SET @seed_3_out_min_amount = 1;
SET @seed_3_out_max_amount = 3;
SET @seed_3_get_rate = 1;
SET @seed_3_out_over_time = 300;

SET @seed_4_name = '调试种子4';
SET @seed_4_out_min_amount = 1;
SET @seed_4_out_max_amount = 3;
SET @seed_4_get_rate = 1;
SET @seed_4_out_over_time = 300;

SET @seed_5_name = '调试种子5';
SET @seed_5_out_min_amount = 1;
SET @seed_5_out_max_amount = 3;
SET @seed_5_get_rate = 1;
SET @seed_5_out_over_time = 300;

SET @seed_6_name = '调试种子6';
SET @seed_6_out_min_amount = 1;
SET @seed_6_out_max_amount = 3;
SET @seed_6_get_rate = 1;
SET @seed_6_out_over_time = 300;

SET @seed_7_name = '调试种子7';
SET @seed_7_out_min_amount = 1;
SET @seed_7_out_max_amount = 3;
SET @seed_7_get_rate = 1;
SET @seed_7_out_over_time = 300;

SET @seed_8_name = '调试种子8';
SET @seed_8_out_min_amount = 1;
SET @seed_8_out_max_amount = 3;
SET @seed_8_get_rate = 1;
SET @seed_8_out_over_time = 300;

SET @seed_9_name = '调试种子9';
SET @seed_9_out_min_amount = 1;
SET @seed_9_out_max_amount = 3;
SET @seed_9_get_rate = 1;
SET @seed_9_out_over_time = 300;

SET @seed_10_name = '调试种子10';
SET @seed_10_out_min_amount = 1;
SET @seed_10_out_max_amount = 3;
SET @seed_10_get_rate = 1;
SET @seed_10_out_over_time = 300;

SET @land_1_out_put_rate_max = 100;
SET @land_1_out_put_rate_min = 100;
SET @land_1_rent_out_put_rate_max = 0;
SET @land_1_max_health = 100;
SET @land_1_per_health = 10;
SET @land_1_limit_date_max = 30;

SET @land_2_out_put_rate_max = 100;
SET @land_2_out_put_rate_min = 100;
SET @land_2_rent_out_put_rate_max = 0;
SET @land_2_max_health = 100;
SET @land_2_per_health = 10;
SET @land_2_limit_date_max = 30;

SET @land_3_out_put_rate_max = 100;
SET @land_3_out_put_rate_min = 100;
SET @land_3_rent_out_put_rate_max = 0;
SET @land_3_max_health = 100;
SET @land_3_per_health = 10;
SET @land_3_limit_date_max = 30;

SET @land_4_out_put_rate_max = 100;
SET @land_4_out_put_rate_min = 100;
SET @land_4_rent_out_put_rate_max = 0;
SET @land_4_max_health = 100;
SET @land_4_per_health = 10;
SET @land_4_limit_date_max = 30;

SET @land_5_out_put_rate_max = 100;
SET @land_5_out_put_rate_min = 100;
SET @land_5_rent_out_put_rate_max = 0;
SET @land_5_max_health = 100;
SET @land_5_per_health = 10;
SET @land_5_limit_date_max = 30;

SET @land_6_out_put_rate_max = 100;
SET @land_6_out_put_rate_min = 100;
SET @land_6_rent_out_put_rate_max = 0;
SET @land_6_max_health = 100;
SET @land_6_per_health = 10;
SET @land_6_limit_date_max = 30;

SET @land_7_out_put_rate_max = 100;
SET @land_7_out_put_rate_min = 100;
SET @land_7_rent_out_put_rate_max = 0;
SET @land_7_max_health = 100;
SET @land_7_per_health = 10;
SET @land_7_limit_date_max = 30;

SET @land_8_out_put_rate_max = 100;
SET @land_8_out_put_rate_min = 100;
SET @land_8_rent_out_put_rate_max = 0;
SET @land_8_max_health = 100;
SET @land_8_per_health = 10;
SET @land_8_limit_date_max = 30;

SET @land_9_out_put_rate_max = 100;
SET @land_9_out_put_rate_min = 100;
SET @land_9_rent_out_put_rate_max = 0;
SET @land_9_max_health = 100;
SET @land_9_per_health = 10;
SET @land_9_limit_date_max = 30;

SET @land_10_out_put_rate_max = 100;
SET @land_10_out_put_rate_min = 100;
SET @land_10_rent_out_put_rate_max = 0;
SET @land_10_max_health = 100;
SET @land_10_per_health = 10;
SET @land_10_limit_date_max = 30;

-- 化肥；下面次数/效果为模型默认值，旧值请替换。
SET @prop_11_one_one = 20;
SET @prop_11_one_two = 14400;
SET @prop_11_two_one = 7;
SET @prop_11_two_two = 20;
SET @prop_11_three_one = 7;
SET @prop_11_four_one = 7;
SET @prop_11_five_one = 20;
SET @prop_11_get_rate = 1;

-- 水；下面次数/效果为模型默认值，旧值请替换。
SET @prop_12_one_one = 20;
SET @prop_12_one_two = 14400;
SET @prop_12_two_one = 7;
SET @prop_12_two_two = 20;
SET @prop_12_three_one = 7;
SET @prop_12_four_one = 7;
SET @prop_12_five_one = 20;
SET @prop_12_get_rate = 1;

-- 手套；下面次数/效果为模型默认值，旧值请替换。
SET @prop_13_one_one = 20;
SET @prop_13_one_two = 14400;
SET @prop_13_two_one = 7;
SET @prop_13_two_two = 20;
SET @prop_13_three_one = 7;
SET @prop_13_four_one = 7;
SET @prop_13_five_one = 20;
SET @prop_13_get_rate = 1;

-- 除虫剂；下面次数/效果为模型默认值，旧值请替换。
SET @prop_14_one_one = 20;
SET @prop_14_one_two = 14400;
SET @prop_14_two_one = 7;
SET @prop_14_two_two = 20;
SET @prop_14_three_one = 7;
SET @prop_14_four_one = 7;
SET @prop_14_five_one = 20;
SET @prop_14_get_rate = 1;

-- 铲子；下面次数/效果为模型默认值，旧值请替换。
SET @prop_15_one_one = 20;
SET @prop_15_one_two = 14400;
SET @prop_15_two_one = 7;
SET @prop_15_two_two = 20;
SET @prop_15_three_one = 7;
SET @prop_15_four_one = 7;
SET @prop_15_five_one = 20;
SET @prop_15_get_rate = 1;

START TRANSACTION;

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 1, @seed_1_name, @seed_1_out_min_amount, @seed_1_out_max_amount, @seed_1_get_rate, @seed_1_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_1_name IS NOT NULL
  AND @seed_1_out_min_amount IS NOT NULL
  AND @seed_1_out_min_amount >= 0
  AND @seed_1_out_max_amount IS NOT NULL
  AND @seed_1_out_max_amount >= @seed_1_out_min_amount
  AND @seed_1_get_rate IS NOT NULL
  AND @seed_1_get_rate >= 0
  AND @seed_1_out_over_time IS NOT NULL
  AND @seed_1_out_over_time > 0
  AND CHAR_LENGTH(@seed_1_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 1);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 2, @seed_2_name, @seed_2_out_min_amount, @seed_2_out_max_amount, @seed_2_get_rate, @seed_2_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_2_name IS NOT NULL
  AND @seed_2_out_min_amount IS NOT NULL
  AND @seed_2_out_min_amount >= 0
  AND @seed_2_out_max_amount IS NOT NULL
  AND @seed_2_out_max_amount >= @seed_2_out_min_amount
  AND @seed_2_get_rate IS NOT NULL
  AND @seed_2_get_rate >= 0
  AND @seed_2_out_over_time IS NOT NULL
  AND @seed_2_out_over_time > 0
  AND CHAR_LENGTH(@seed_2_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 2);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 3, @seed_3_name, @seed_3_out_min_amount, @seed_3_out_max_amount, @seed_3_get_rate, @seed_3_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_3_name IS NOT NULL
  AND @seed_3_out_min_amount IS NOT NULL
  AND @seed_3_out_min_amount >= 0
  AND @seed_3_out_max_amount IS NOT NULL
  AND @seed_3_out_max_amount >= @seed_3_out_min_amount
  AND @seed_3_get_rate IS NOT NULL
  AND @seed_3_get_rate >= 0
  AND @seed_3_out_over_time IS NOT NULL
  AND @seed_3_out_over_time > 0
  AND CHAR_LENGTH(@seed_3_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 3);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 4, @seed_4_name, @seed_4_out_min_amount, @seed_4_out_max_amount, @seed_4_get_rate, @seed_4_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_4_name IS NOT NULL
  AND @seed_4_out_min_amount IS NOT NULL
  AND @seed_4_out_min_amount >= 0
  AND @seed_4_out_max_amount IS NOT NULL
  AND @seed_4_out_max_amount >= @seed_4_out_min_amount
  AND @seed_4_get_rate IS NOT NULL
  AND @seed_4_get_rate >= 0
  AND @seed_4_out_over_time IS NOT NULL
  AND @seed_4_out_over_time > 0
  AND CHAR_LENGTH(@seed_4_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 4);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 5, @seed_5_name, @seed_5_out_min_amount, @seed_5_out_max_amount, @seed_5_get_rate, @seed_5_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_5_name IS NOT NULL
  AND @seed_5_out_min_amount IS NOT NULL
  AND @seed_5_out_min_amount >= 0
  AND @seed_5_out_max_amount IS NOT NULL
  AND @seed_5_out_max_amount >= @seed_5_out_min_amount
  AND @seed_5_get_rate IS NOT NULL
  AND @seed_5_get_rate >= 0
  AND @seed_5_out_over_time IS NOT NULL
  AND @seed_5_out_over_time > 0
  AND CHAR_LENGTH(@seed_5_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 5);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 6, @seed_6_name, @seed_6_out_min_amount, @seed_6_out_max_amount, @seed_6_get_rate, @seed_6_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_6_name IS NOT NULL
  AND @seed_6_out_min_amount IS NOT NULL
  AND @seed_6_out_min_amount >= 0
  AND @seed_6_out_max_amount IS NOT NULL
  AND @seed_6_out_max_amount >= @seed_6_out_min_amount
  AND @seed_6_get_rate IS NOT NULL
  AND @seed_6_get_rate >= 0
  AND @seed_6_out_over_time IS NOT NULL
  AND @seed_6_out_over_time > 0
  AND CHAR_LENGTH(@seed_6_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 6);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 7, @seed_7_name, @seed_7_out_min_amount, @seed_7_out_max_amount, @seed_7_get_rate, @seed_7_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_7_name IS NOT NULL
  AND @seed_7_out_min_amount IS NOT NULL
  AND @seed_7_out_min_amount >= 0
  AND @seed_7_out_max_amount IS NOT NULL
  AND @seed_7_out_max_amount >= @seed_7_out_min_amount
  AND @seed_7_get_rate IS NOT NULL
  AND @seed_7_get_rate >= 0
  AND @seed_7_out_over_time IS NOT NULL
  AND @seed_7_out_over_time > 0
  AND CHAR_LENGTH(@seed_7_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 7);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 8, @seed_8_name, @seed_8_out_min_amount, @seed_8_out_max_amount, @seed_8_get_rate, @seed_8_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_8_name IS NOT NULL
  AND @seed_8_out_min_amount IS NOT NULL
  AND @seed_8_out_min_amount >= 0
  AND @seed_8_out_max_amount IS NOT NULL
  AND @seed_8_out_max_amount >= @seed_8_out_min_amount
  AND @seed_8_get_rate IS NOT NULL
  AND @seed_8_get_rate >= 0
  AND @seed_8_out_over_time IS NOT NULL
  AND @seed_8_out_over_time > 0
  AND CHAR_LENGTH(@seed_8_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 8);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 9, @seed_9_name, @seed_9_out_min_amount, @seed_9_out_max_amount, @seed_9_get_rate, @seed_9_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_9_name IS NOT NULL
  AND @seed_9_out_min_amount IS NOT NULL
  AND @seed_9_out_min_amount >= 0
  AND @seed_9_out_max_amount IS NOT NULL
  AND @seed_9_out_max_amount >= @seed_9_out_min_amount
  AND @seed_9_get_rate IS NOT NULL
  AND @seed_9_get_rate >= 0
  AND @seed_9_out_over_time IS NOT NULL
  AND @seed_9_out_over_time > 0
  AND CHAR_LENGTH(@seed_9_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 9);

INSERT INTO `seed_info` (`id`, `name`, `out_min_amount`, `out_max_amount`, `get_rate`, `out_over_time`, `created_at`, `updated_at`)
SELECT 10, @seed_10_name, @seed_10_out_min_amount, @seed_10_out_max_amount, @seed_10_get_rate, @seed_10_out_over_time, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @seed_10_name IS NOT NULL
  AND @seed_10_out_min_amount IS NOT NULL
  AND @seed_10_out_min_amount >= 0
  AND @seed_10_out_max_amount IS NOT NULL
  AND @seed_10_out_max_amount >= @seed_10_out_min_amount
  AND @seed_10_get_rate IS NOT NULL
  AND @seed_10_get_rate >= 0
  AND @seed_10_out_over_time IS NOT NULL
  AND @seed_10_out_over_time > 0
  AND CHAR_LENGTH(@seed_10_name) BETWEEN 1 AND 45
  AND NOT EXISTS (SELECT 1 FROM `seed_info` WHERE `id` = 10);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 1, 1, @land_1_out_put_rate_max, @land_1_out_put_rate_min, @land_1_rent_out_put_rate_max, @land_1_max_health, @land_1_per_health, @land_1_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_1_out_put_rate_max IS NOT NULL
  AND @land_1_out_put_rate_max >= @land_1_out_put_rate_min
  AND @land_1_out_put_rate_min IS NOT NULL
  AND @land_1_out_put_rate_min > 0
  AND @land_1_rent_out_put_rate_max IS NOT NULL
  AND @land_1_max_health IS NOT NULL
  AND @land_1_max_health > 0
  AND @land_1_per_health IS NOT NULL
  AND @land_1_per_health > 0
  AND @land_1_limit_date_max IS NOT NULL
  AND @land_1_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 1 OR `level` = 1);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 2, 2, @land_2_out_put_rate_max, @land_2_out_put_rate_min, @land_2_rent_out_put_rate_max, @land_2_max_health, @land_2_per_health, @land_2_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_2_out_put_rate_max IS NOT NULL
  AND @land_2_out_put_rate_max >= @land_2_out_put_rate_min
  AND @land_2_out_put_rate_min IS NOT NULL
  AND @land_2_out_put_rate_min > 0
  AND @land_2_rent_out_put_rate_max IS NOT NULL
  AND @land_2_max_health IS NOT NULL
  AND @land_2_max_health > 0
  AND @land_2_per_health IS NOT NULL
  AND @land_2_per_health > 0
  AND @land_2_limit_date_max IS NOT NULL
  AND @land_2_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 2 OR `level` = 2);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 3, 3, @land_3_out_put_rate_max, @land_3_out_put_rate_min, @land_3_rent_out_put_rate_max, @land_3_max_health, @land_3_per_health, @land_3_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_3_out_put_rate_max IS NOT NULL
  AND @land_3_out_put_rate_max >= @land_3_out_put_rate_min
  AND @land_3_out_put_rate_min IS NOT NULL
  AND @land_3_out_put_rate_min > 0
  AND @land_3_rent_out_put_rate_max IS NOT NULL
  AND @land_3_max_health IS NOT NULL
  AND @land_3_max_health > 0
  AND @land_3_per_health IS NOT NULL
  AND @land_3_per_health > 0
  AND @land_3_limit_date_max IS NOT NULL
  AND @land_3_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 3 OR `level` = 3);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 4, 4, @land_4_out_put_rate_max, @land_4_out_put_rate_min, @land_4_rent_out_put_rate_max, @land_4_max_health, @land_4_per_health, @land_4_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_4_out_put_rate_max IS NOT NULL
  AND @land_4_out_put_rate_max >= @land_4_out_put_rate_min
  AND @land_4_out_put_rate_min IS NOT NULL
  AND @land_4_out_put_rate_min > 0
  AND @land_4_rent_out_put_rate_max IS NOT NULL
  AND @land_4_max_health IS NOT NULL
  AND @land_4_max_health > 0
  AND @land_4_per_health IS NOT NULL
  AND @land_4_per_health > 0
  AND @land_4_limit_date_max IS NOT NULL
  AND @land_4_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 4 OR `level` = 4);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 5, 5, @land_5_out_put_rate_max, @land_5_out_put_rate_min, @land_5_rent_out_put_rate_max, @land_5_max_health, @land_5_per_health, @land_5_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_5_out_put_rate_max IS NOT NULL
  AND @land_5_out_put_rate_max >= @land_5_out_put_rate_min
  AND @land_5_out_put_rate_min IS NOT NULL
  AND @land_5_out_put_rate_min > 0
  AND @land_5_rent_out_put_rate_max IS NOT NULL
  AND @land_5_max_health IS NOT NULL
  AND @land_5_max_health > 0
  AND @land_5_per_health IS NOT NULL
  AND @land_5_per_health > 0
  AND @land_5_limit_date_max IS NOT NULL
  AND @land_5_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 5 OR `level` = 5);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 6, 6, @land_6_out_put_rate_max, @land_6_out_put_rate_min, @land_6_rent_out_put_rate_max, @land_6_max_health, @land_6_per_health, @land_6_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_6_out_put_rate_max IS NOT NULL
  AND @land_6_out_put_rate_max >= @land_6_out_put_rate_min
  AND @land_6_out_put_rate_min IS NOT NULL
  AND @land_6_out_put_rate_min > 0
  AND @land_6_rent_out_put_rate_max IS NOT NULL
  AND @land_6_max_health IS NOT NULL
  AND @land_6_max_health > 0
  AND @land_6_per_health IS NOT NULL
  AND @land_6_per_health > 0
  AND @land_6_limit_date_max IS NOT NULL
  AND @land_6_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 6 OR `level` = 6);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 7, 7, @land_7_out_put_rate_max, @land_7_out_put_rate_min, @land_7_rent_out_put_rate_max, @land_7_max_health, @land_7_per_health, @land_7_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_7_out_put_rate_max IS NOT NULL
  AND @land_7_out_put_rate_max >= @land_7_out_put_rate_min
  AND @land_7_out_put_rate_min IS NOT NULL
  AND @land_7_out_put_rate_min > 0
  AND @land_7_rent_out_put_rate_max IS NOT NULL
  AND @land_7_max_health IS NOT NULL
  AND @land_7_max_health > 0
  AND @land_7_per_health IS NOT NULL
  AND @land_7_per_health > 0
  AND @land_7_limit_date_max IS NOT NULL
  AND @land_7_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 7 OR `level` = 7);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 8, 8, @land_8_out_put_rate_max, @land_8_out_put_rate_min, @land_8_rent_out_put_rate_max, @land_8_max_health, @land_8_per_health, @land_8_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_8_out_put_rate_max IS NOT NULL
  AND @land_8_out_put_rate_max >= @land_8_out_put_rate_min
  AND @land_8_out_put_rate_min IS NOT NULL
  AND @land_8_out_put_rate_min > 0
  AND @land_8_rent_out_put_rate_max IS NOT NULL
  AND @land_8_max_health IS NOT NULL
  AND @land_8_max_health > 0
  AND @land_8_per_health IS NOT NULL
  AND @land_8_per_health > 0
  AND @land_8_limit_date_max IS NOT NULL
  AND @land_8_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 8 OR `level` = 8);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 9, 9, @land_9_out_put_rate_max, @land_9_out_put_rate_min, @land_9_rent_out_put_rate_max, @land_9_max_health, @land_9_per_health, @land_9_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_9_out_put_rate_max IS NOT NULL
  AND @land_9_out_put_rate_max >= @land_9_out_put_rate_min
  AND @land_9_out_put_rate_min IS NOT NULL
  AND @land_9_out_put_rate_min > 0
  AND @land_9_rent_out_put_rate_max IS NOT NULL
  AND @land_9_max_health IS NOT NULL
  AND @land_9_max_health > 0
  AND @land_9_per_health IS NOT NULL
  AND @land_9_per_health > 0
  AND @land_9_limit_date_max IS NOT NULL
  AND @land_9_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 9 OR `level` = 9);

INSERT INTO `land_info` (`id`, `level`, `out_put_rate_max`, `out_put_rate_min`, `rent_out_put_rate_max`, `max_health`, `per_health`, `limit_date_max`, `created_at`, `updated_at`)
SELECT 10, 10, @land_10_out_put_rate_max, @land_10_out_put_rate_min, @land_10_rent_out_put_rate_max, @land_10_max_health, @land_10_per_health, @land_10_limit_date_max, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @land_10_out_put_rate_max IS NOT NULL
  AND @land_10_out_put_rate_max >= @land_10_out_put_rate_min
  AND @land_10_out_put_rate_min IS NOT NULL
  AND @land_10_out_put_rate_min > 0
  AND @land_10_rent_out_put_rate_max IS NOT NULL
  AND @land_10_max_health IS NOT NULL
  AND @land_10_max_health > 0
  AND @land_10_per_health IS NOT NULL
  AND @land_10_per_health > 0
  AND @land_10_limit_date_max IS NOT NULL
  AND @land_10_limit_date_max > 0
  AND NOT EXISTS (SELECT 1 FROM `land_info` WHERE `id` = 10 OR `level` = 10);

INSERT INTO `prop_info` (`id`, `prop_type`, `one_one`, `one_two`, `two_one`, `two_two`, `three_one`, `four_one`, `five_one`, `get_rate`, `created_at`, `updated_at`)
SELECT 11, 11, @prop_11_one_one, @prop_11_one_two, @prop_11_two_one, @prop_11_two_two, @prop_11_three_one, @prop_11_four_one, @prop_11_five_one, @prop_11_get_rate, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @prop_11_one_one IS NOT NULL
  AND @prop_11_one_two IS NOT NULL
  AND @prop_11_two_one IS NOT NULL
  AND @prop_11_two_two IS NOT NULL
  AND @prop_11_three_one IS NOT NULL
  AND @prop_11_four_one IS NOT NULL
  AND @prop_11_five_one IS NOT NULL
  AND @prop_11_get_rate IS NOT NULL
  AND @prop_11_get_rate >= 0
  AND NOT EXISTS (SELECT 1 FROM `prop_info` WHERE `id` = 11 OR `prop_type` = 11);

INSERT INTO `prop_info` (`id`, `prop_type`, `one_one`, `one_two`, `two_one`, `two_two`, `three_one`, `four_one`, `five_one`, `get_rate`, `created_at`, `updated_at`)
SELECT 12, 12, @prop_12_one_one, @prop_12_one_two, @prop_12_two_one, @prop_12_two_two, @prop_12_three_one, @prop_12_four_one, @prop_12_five_one, @prop_12_get_rate, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @prop_12_one_one IS NOT NULL
  AND @prop_12_one_two IS NOT NULL
  AND @prop_12_two_one IS NOT NULL
  AND @prop_12_two_two IS NOT NULL
  AND @prop_12_three_one IS NOT NULL
  AND @prop_12_four_one IS NOT NULL
  AND @prop_12_five_one IS NOT NULL
  AND @prop_12_get_rate IS NOT NULL
  AND @prop_12_get_rate >= 0
  AND NOT EXISTS (SELECT 1 FROM `prop_info` WHERE `id` = 12 OR `prop_type` = 12);

INSERT INTO `prop_info` (`id`, `prop_type`, `one_one`, `one_two`, `two_one`, `two_two`, `three_one`, `four_one`, `five_one`, `get_rate`, `created_at`, `updated_at`)
SELECT 13, 13, @prop_13_one_one, @prop_13_one_two, @prop_13_two_one, @prop_13_two_two, @prop_13_three_one, @prop_13_four_one, @prop_13_five_one, @prop_13_get_rate, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @prop_13_one_one IS NOT NULL
  AND @prop_13_one_two IS NOT NULL
  AND @prop_13_two_one IS NOT NULL
  AND @prop_13_two_two IS NOT NULL
  AND @prop_13_three_one IS NOT NULL
  AND @prop_13_four_one IS NOT NULL
  AND @prop_13_five_one IS NOT NULL
  AND @prop_13_get_rate IS NOT NULL
  AND @prop_13_get_rate >= 0
  AND NOT EXISTS (SELECT 1 FROM `prop_info` WHERE `id` = 13 OR `prop_type` = 13);

INSERT INTO `prop_info` (`id`, `prop_type`, `one_one`, `one_two`, `two_one`, `two_two`, `three_one`, `four_one`, `five_one`, `get_rate`, `created_at`, `updated_at`)
SELECT 14, 14, @prop_14_one_one, @prop_14_one_two, @prop_14_two_one, @prop_14_two_two, @prop_14_three_one, @prop_14_four_one, @prop_14_five_one, @prop_14_get_rate, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @prop_14_one_one IS NOT NULL
  AND @prop_14_one_two IS NOT NULL
  AND @prop_14_two_one IS NOT NULL
  AND @prop_14_two_two IS NOT NULL
  AND @prop_14_three_one IS NOT NULL
  AND @prop_14_four_one IS NOT NULL
  AND @prop_14_five_one IS NOT NULL
  AND @prop_14_get_rate IS NOT NULL
  AND @prop_14_get_rate >= 0
  AND NOT EXISTS (SELECT 1 FROM `prop_info` WHERE `id` = 14 OR `prop_type` = 14);

INSERT INTO `prop_info` (`id`, `prop_type`, `one_one`, `one_two`, `two_one`, `two_two`, `three_one`, `four_one`, `five_one`, `get_rate`, `created_at`, `updated_at`)
SELECT 15, 15, @prop_15_one_one, @prop_15_one_two, @prop_15_two_one, @prop_15_two_two, @prop_15_three_one, @prop_15_four_one, @prop_15_five_one, @prop_15_get_rate, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE @prop_15_one_one IS NOT NULL
  AND @prop_15_one_two IS NOT NULL
  AND @prop_15_two_one IS NOT NULL
  AND @prop_15_two_two IS NOT NULL
  AND @prop_15_three_one IS NOT NULL
  AND @prop_15_four_one IS NOT NULL
  AND @prop_15_five_one IS NOT NULL
  AND @prop_15_get_rate IS NOT NULL
  AND @prop_15_get_rate >= 0
  AND NOT EXISTS (SELECT 1 FROM `prop_info` WHERE `id` = 15 OR `prop_type` = 15);

COMMIT;
