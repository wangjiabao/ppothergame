-- 空库建表和基础记录初始化合并文件，生成日期：2026-10-02。
-- 使用：先在 MySQL 中选定已创建的目标数据库，再执行本文件。
-- 来源：ppothergame f29548c + ppothergameadmin f5d6e8c。
-- 包含 01 建表 + 03 随机种子/资金池 + 05 种子/土地/道具基础参数。
-- 将建立 38 张表、386 个字段，并在空库补 29 条基础记录。
-- config 业务值仍需要填写 04_config_init_template.sql；事件单独执行 02；07 是只读验收。
-- 使用本文件后不必再单独导入 01/03/05。
-- 这是按当前代码重建的空库及调试基础记录，不恢复旧用户、余额、业务流水。
-- 01 不升级已有表；03/05 仅插入缺失项，不覆盖已有值。DDL 与各初始化事务独立，不是全文件原子事务。

-- 00 是分文件内容的合并快照；首次导入调参请直接改本文件中的 SET，或分别导入 01/03/05。

-- 开始 01_restore_game_tables.sql
-- 游戏项目空库表结构恢复 SQL，生成日期：2026-10-02。
-- 来源：ppothergame main f29548c + ppothergameadmin main f5d6e8c。
-- 先选定目标数据库再执行；本文件不创建数据库，不写死 game / othergame。
-- 覆盖两端实际引用的 38 个表；不插入业务数据，不修改 Go 代码。
-- CREATE TABLE IF NOT EXISTS 不会升级已有表，本文件用于空库恢复。
-- 合并规则：同名表取两端字段并集；列名及类型按当前 GORM v1.24.2 / MySQL 驱动推导。
-- 两端均存在的字段：默认值优先 App；任一模型允许 NULL 时保留可空。
-- land.one / two / three 的冲突默认值采用 App 的 1（后台模型为 0）。
-- 兼容补充：没有模型默认值的数值列补 DEFAULT 0；必填 VARCHAR 补 DEFAULT ''；
-- 按用户要求：全部非自增列有非NULL默认值；字符串空串，时间CURRENT_TIMESTAMP（保持精度）。
-- 原有模型业务默认值保留；14个旧DEFAULT NULL改为具体值；仍保留原有NULL/NOT NULL约束。
-- withdraw.coin 的 GORM 标签缺少结束引号，按其明确写出的意图恢复为 VARCHAR(45)。
-- 保留 random_seeds.scene 的模型唯一约束；额外普通索引按现有查询和事件推导。
-- 按用户要求新增user.address唯一约束；其余不推断额外外键或业务唯一约束。
-- 已知代码拼写问题：App BackUserGit 使用 ammount_usdt；模型为 amount_usdt。
-- 此处只恢复模型 amount_usdt，不新建另一个余额列；该代码路径仍需单独处理。
-- 读写复核补充：stake_git.sell_amount 不在模型中，但两端 stakeGit 函数均写入它。
-- 按项目其他 sell_amount 金额列采用 DECIMAL(65,20) DEFAULT 0；未发现该函数调用点也保留字段。
-- 已静态追踪两端 509 处数据库读写，表/列覆盖除上述 ammount_usdt 拼写问题外已核对。
-- 本次按读写条件补充 63 个普通索引；全部是重建建议，不能确认原库索引。
-- 调用证据和多范围/排序限制见12；user.address唯一性来自用户明确要求。
-- address仍默认空串；唯一约束下空地址最多一行，创建用户应显式传入真实地址。
SET NAMES utf8mb4 COLLATE utf8mb4_general_ci;

-- user；模型来源：ppothergame:User, ppothergameadmin:User
CREATE TABLE IF NOT EXISTS `user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(100) NOT NULL DEFAULT '',
  `level` BIGINT NOT NULL DEFAULT 0,
  `giw` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `giw_add` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `git` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `total` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `total_one` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `total_two` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `total_three` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_one` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_two` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_three` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_two_one` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_two_two` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_two_three` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_three_one` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_three_two` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `reward_three_three` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `location` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `recommend` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `recommend_two` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `area` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `area_two` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `all` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `all_num` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `amount` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `amount_get` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `amount_usdt` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `amount_usdt_total` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `my_total_amount` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `my_total_amount_new` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `out_num` BIGINT NULL DEFAULT 0,
  `vip` BIGINT NULL DEFAULT 0,
  `vip_admin` BIGINT NULL DEFAULT 0,
  `lock_use` BIGINT NULL DEFAULT 0,
  `lock_reward` BIGINT NULL DEFAULT 0,
  `usdt_two` DECIMAL(65,20) NULL DEFAULT 0,
  `giw_two` DECIMAL(65,20) NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `can_sell` BIGINT NULL DEFAULT 0,
  `can_rent` BIGINT NULL DEFAULT 0,
  `can_land` BIGINT NULL DEFAULT 0,
  `withdraw_max` BIGINT NULL DEFAULT 0,
  `can_sell_prop` BIGINT NULL DEFAULT 0,
  `can_play_add` BIGINT NULL DEFAULT 0,
  `can_play_six` BIGINT NULL DEFAULT 0,
  `git_new` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `git_new_new` DECIMAL(65,20) NULL DEFAULT 0.00000000000000000000,
  `one` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `two` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `three` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `ispay_amount` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `stake_ispay_amount` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `open_box_amount` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `land_count` BIGINT NULL DEFAULT 0,
  `last_reward_total` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `land_reward` DECIMAL(65,20) NULL DEFAULT 0,
  `recommend_one` BIGINT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_address` (`address`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_amount_usdt_total` (`amount_usdt_total`),
  KEY `idx_amount_usdt` (`amount_usdt`),
  KEY `idx_land_count` (`land_count`),
  KEY `idx_git` (`git`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- user_recommend；模型来源：ppothergame:UserRecommend, ppothergameadmin:UserRecommend
CREATE TABLE IF NOT EXISTS `user_recommend` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0,
  `recommend_code` VARCHAR(1000) NOT NULL DEFAULT '',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_recommend_code_prefix` (`recommend_code`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- admin；模型来源：ppothergameadmin:Admin
CREATE TABLE IF NOT EXISTS `admin` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `account` VARCHAR(100) NOT NULL DEFAULT '',
  `password` VARCHAR(100) NOT NULL DEFAULT '',
  `type` VARCHAR(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- admin_set_balance；模型来源：ppothergameadmin:AdminSetBalance
CREATE TABLE IF NOT EXISTS `admin_set_balance` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(100) NOT NULL DEFAULT '',
  `coin` BIGINT NOT NULL DEFAULT 0,
  `amount` BIGINT(20) NOT NULL DEFAULT 0 COMMENT '金额',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- config；模型来源：ppothergame:Config, ppothergameadmin:Config
CREATE TABLE IF NOT EXISTS `config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT '',
  `key_name` VARCHAR(45) NOT NULL DEFAULT '',
  `value` VARCHAR(1000) NOT NULL DEFAULT '',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_key_name` (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- notice；模型来源：ppothergame:Notice, ppothergameadmin:Notice
CREATE TABLE IF NOT EXISTS `notice` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `notice_content` VARCHAR(500) NOT NULL DEFAULT '' COMMENT '消息内容',
  `notice_content_two` VARCHAR(500) NOT NULL DEFAULT '' COMMENT '消息内容',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_created` (`user_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- message；模型来源：ppothergame:Message
CREATE TABLE IF NOT EXISTS `message` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `content` VARCHAR(200) NOT NULL DEFAULT '' COMMENT '消息内容',
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `status` BIGINT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_user_created` (`user_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- admin_message；模型来源：ppothergame:AdminMessage, ppothergameadmin:AdminMessage
CREATE TABLE IF NOT EXISTS `admin_message` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `content` VARCHAR(2000) NOT NULL DEFAULT '' COMMENT '消息内容',
  `content_two` VARCHAR(2000) NOT NULL DEFAULT '' COMMENT '消息内容',
  `status` BIGINT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- land；模型来源：ppothergame:Land, ppothergameadmin:Land
CREATE TABLE IF NOT EXISTS `land` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `level` BIGINT NOT NULL DEFAULT 1 COMMENT '级别',
  `out_put_rate` DECIMAL(65,20) NOT NULL DEFAULT 100.00000000000000000000 COMMENT '增产率',
  `rent_out_put_rate` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '出租产出比率',
  `max_health` BIGINT NOT NULL DEFAULT 100 COMMENT '最大可消耗肥沃度',
  `per_health` BIGINT NOT NULL DEFAULT 10 COMMENT '每次消耗肥沃度',
  `limit_date` BIGINT NOT NULL DEFAULT 0 COMMENT '使用期限',
  `status` BIGINT NOT NULL DEFAULT 0 COMMENT '状态',
  `location_num` BIGINT NOT NULL DEFAULT 0 COMMENT '首页位置',
  `one` BIGINT NOT NULL DEFAULT 1 COMMENT '可出租',
  `two` BIGINT NOT NULL DEFAULT 1 COMMENT '可合成',
  `three` BIGINT NOT NULL DEFAULT 1 COMMENT '可出售',
  `sell_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_add` BIGINT NULL DEFAULT 0,
  `location_user_id` BIGINT NULL DEFAULT 0,
  `can_reward` BIGINT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_refresh_land_count` (`status`, `limit_date`, `user_id`),
  KEY `idx_user_status_limit` (`user_id`, `status`, `limit_date`),
  KEY `idx_location_user_num` (`location_user_id`, `location_num`),
  KEY `idx_user_location_num` (`user_id`, `location_user_id`, `location_num`),
  KEY `idx_user_admin_status` (`user_id`, `admin_add`, `status`),
  KEY `idx_reward_limit` (`can_reward`, `limit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- land_user_use；模型来源：ppothergame:LandUserUse, ppothergameadmin:LandUserUse
CREATE TABLE IF NOT EXISTS `land_user_use` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `land_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户土地id',
  `level` BIGINT NOT NULL DEFAULT 0 COMMENT '级别',
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '使用用户id',
  `owner_user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '拥有者用户id',
  `seed_id` BIGINT NOT NULL DEFAULT 0 COMMENT '种子id',
  `seed_type_id` BIGINT NOT NULL DEFAULT 0,
  `status` BIGINT NOT NULL DEFAULT 1 COMMENT '状态',
  `begin_time` BIGINT NOT NULL DEFAULT 0 COMMENT '开始时间戳',
  `total_time` BIGINT NOT NULL DEFAULT 0 COMMENT '成熟总时长',
  `over_time` BIGINT NOT NULL DEFAULT 0 COMMENT '结束时间戳',
  `out_max_num` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '最大产出',
  `out_num` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '已产出',
  `insect_status` BIGINT NOT NULL DEFAULT 1 COMMENT '虫子状态',
  `out_sub_num` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '减产数',
  `steal_num` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '被偷走总数',
  `stop_status` BIGINT NOT NULL DEFAULT 1 COMMENT '生长状态',
  `stop_time` BIGINT NOT NULL DEFAULT 0 COMMENT '暂停时间',
  `sub_time` BIGINT NOT NULL DEFAULT 0 COMMENT '加速总时长',
  `use_chan` BIGINT NOT NULL DEFAULT 0 COMMENT '使用铲子次数',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `one` BIGINT NOT NULL DEFAULT 0,
  `two` BIGINT NOT NULL DEFAULT 0,
  `is_use_other` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_status` (`user_id`, `status`),
  KEY `idx_land_status` (`land_id`, `status`),
  KEY `idx_owner_status_land` (`owner_user_id`, `status`, `land_id`),
  KEY `idx_maturity` (`status`, `one`, `two`, `over_time`, `sub_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- seed；模型来源：ppothergame:Seed, ppothergameadmin:Seed
CREATE TABLE IF NOT EXISTS `seed` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `seed_id` BIGINT NOT NULL DEFAULT 0 COMMENT '种子信息id',
  `name` VARCHAR(45) NOT NULL DEFAULT '1' COMMENT '名字',
  `out_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '产出数量',
  `out_over_time` BIGINT NOT NULL DEFAULT 0 COMMENT '成熟时间',
  `out_max_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '最大产出数量',
  `out_min_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '最小产出数量',
  `status` BIGINT NOT NULL DEFAULT 0 COMMENT '状态：0未使用，1使用，出售中4，已售出5，不可用6',
  `sell_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_add` BIGINT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_status` (`user_id`, `status`),
  KEY `idx_user_admin_status` (`user_id`, `admin_add`, `status`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- prop；模型来源：ppothergame:Prop, ppothergameadmin:Prop
CREATE TABLE IF NOT EXISTS `prop` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `status` BIGINT NOT NULL DEFAULT 1 COMMENT '状态：未使用1，使用中2，已使用3，出售中4，已出售5，不可用11',
  `prop_type` BIGINT NOT NULL DEFAULT 0 COMMENT '道具类型：1化肥，2铲子，3水，4除虫剂，5手套，6盲盒',
  `one_one` BIGINT NOT NULL DEFAULT 20 COMMENT '化肥土地肥沃度增加量',
  `one_two` BIGINT NOT NULL DEFAULT 14400 COMMENT '化肥植物加速成熟时间戳',
  `two_one` BIGINT NOT NULL DEFAULT 7 COMMENT '铲子最大试用次数',
  `two_two` DECIMAL(65,20) NOT NULL DEFAULT 20.00000000000000000000 COMMENT '铲子使用之后获得百分比',
  `three_one` BIGINT NOT NULL DEFAULT 1 COMMENT '水最大试用次数',
  `four_one` BIGINT NOT NULL DEFAULT 10 COMMENT '除虫剂最大试用次数',
  `five_one` BIGINT NOT NULL DEFAULT 20 COMMENT '手套最大可偷植物次数',
  `sell_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_add` BIGINT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_type_status` (`user_id`, `prop_type`, `status`),
  KEY `idx_user_admin_status` (`user_id`, `admin_add`, `status`),
  KEY `idx_status_type` (`status`, `prop_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- land_info；模型来源：ppothergame:LandInfo, ppothergameadmin:LandInfo
CREATE TABLE IF NOT EXISTS `land_info` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `level` BIGINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '级别',
  `out_put_rate_max` DECIMAL(65,20) NOT NULL DEFAULT 100.00000000000000000000 COMMENT '最大增产量',
  `out_put_rate_min` DECIMAL(65,20) NOT NULL DEFAULT 100.00000000000000000000 COMMENT '最小增产量',
  `rent_out_put_rate_max` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '最大出租产出比率',
  `max_health` BIGINT UNSIGNED NOT NULL DEFAULT 100 COMMENT '最大可消耗肥沃度',
  `per_health` BIGINT UNSIGNED NOT NULL DEFAULT 10 COMMENT '每次消耗肥沃度',
  `limit_date_max` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大使用期限',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- seed_info；模型来源：ppothergame:SeedInfo, ppothergameadmin:SeedInfo
CREATE TABLE IF NOT EXISTS `seed_info` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT '1',
  `out_min_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000,
  `out_max_amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000,
  `get_rate` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000,
  `out_over_time` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- prop_info；模型来源：ppothergame:PropInfo, ppothergameadmin:PropInfo
CREATE TABLE IF NOT EXISTS `prop_info` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `prop_type` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `one_one` BIGINT UNSIGNED NOT NULL DEFAULT 20,
  `one_two` BIGINT UNSIGNED NOT NULL DEFAULT 14400,
  `two_one` BIGINT UNSIGNED NOT NULL DEFAULT 7,
  `two_two` DECIMAL(65,20) NOT NULL DEFAULT 20.00000000000000000000,
  `three_one` BIGINT UNSIGNED NOT NULL DEFAULT 7,
  `four_one` BIGINT UNSIGNED NOT NULL DEFAULT 7,
  `five_one` BIGINT UNSIGNED NOT NULL DEFAULT 20,
  `get_rate` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000,
  `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_prop_type` (`prop_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- random_seeds；模型来源：ppothergame:RandomSeed, ppothergameadmin:RandomSeed
CREATE TABLE IF NOT EXISTS `random_seeds` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `scene` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `seed_value` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
  `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_random_seeds_scene` (`scene`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- box_record；模型来源：ppothergame:BoxRecord, ppothergameadmin:BoxRecord
CREATE TABLE IF NOT EXISTS `box_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0,
  `num` BIGINT NOT NULL DEFAULT 0,
  `good_id` BIGINT NOT NULL DEFAULT 0,
  `good_type` BIGINT NOT NULL DEFAULT 0,
  `content` VARCHAR(200) NOT NULL DEFAULT '',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_num` (`num`),
  KEY `idx_user_num` (`user_id`, `num`),
  KEY `idx_user_good` (`user_id`, `good_id`),
  KEY `idx_user_updated_good` (`user_id`, `updated_at`, `good_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- market；模型来源：ppothergame:Market, ppothergameadmin:Market
CREATE TABLE IF NOT EXISTS `market` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '售卖人用户id',
  `good_id` BIGINT NOT NULL DEFAULT 0 COMMENT '上级的商品各个表中的id',
  `good_type` BIGINT NOT NULL DEFAULT 0 COMMENT '商品类型：1土地，2种子，3道具',
  `amount` DECIMAL(65,20) NOT NULL DEFAULT 0.00000000000000000000 COMMENT '售价',
  `status` BIGINT NOT NULL DEFAULT 0 COMMENT '状态：0下架，1上架，2已出售',
  `get_user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '购买人id',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_status` (`user_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- buy_land；模型来源：ppothergame:BuyLand, ppothergameadmin:BuyLand
CREATE TABLE IF NOT EXISTS `buy_land` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(65,20) NOT NULL DEFAULT 0.0,
  `status` BIGINT NOT NULL DEFAULT 1,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `amount_two` DECIMAL(65,20) NOT NULL DEFAULT 0.0,
  `limit` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `level` BIGINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- buy_land_record；模型来源：ppothergame:BuyLandRecord, ppothergameadmin:BuyLandRecord
CREATE TABLE IF NOT EXISTS `buy_land_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `buy_land_id` BIGINT NOT NULL DEFAULT 0,
  `amount` DECIMAL(65,20) NOT NULL DEFAULT 0.0,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` BIGINT NOT NULL DEFAULT 1,
  `user_id` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_auction_amount` (`buy_land_id`, `amount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- reward；模型来源：ppothergame:Reward, ppothergameadmin:Reward
CREATE TABLE IF NOT EXISTS `reward` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0,
  `reason` BIGINT NOT NULL DEFAULT 0,
  `one` BIGINT NOT NULL DEFAULT 0,
  `two` BIGINT NOT NULL DEFAULT 0,
  `three` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `amount` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_reason` (`user_id`, `reason`),
  KEY `idx_user_reason_created` (`user_id`, `reason`, `created_at`),
  KEY `idx_user_reason_two` (`user_id`, `reason`, `two`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- reward_two；模型来源：ppothergame:RewardTwo, ppothergameadmin:RewardTwo
CREATE TABLE IF NOT EXISTS `reward_two` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0,
  `reason` BIGINT NOT NULL DEFAULT 0,
  `one` BIGINT NOT NULL DEFAULT 0,
  `two` BIGINT NOT NULL DEFAULT 0,
  `three` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `amount` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `four` VARCHAR(45) NOT NULL DEFAULT '',
  `five` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_reason` (`user_id`, `reason`),
  KEY `idx_reason_created` (`reason`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- reward_four；模型来源：ppothergame:Reward, ppothergameadmin:Reward
CREATE TABLE IF NOT EXISTS `reward_four` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0,
  `reason` BIGINT NOT NULL DEFAULT 0,
  `one` BIGINT NOT NULL DEFAULT 0,
  `two` BIGINT NOT NULL DEFAULT 0,
  `three` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `amount` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_created` (`user_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_get；模型来源：ppothergame:StakeGet, ppothergameadmin:StakeGet
CREATE TABLE IF NOT EXISTS `stake_get` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `status` BIGINT NOT NULL DEFAULT 1 COMMENT '状态：1质押，2已解压',
  `stake_rate` DECIMAL(65,18) NOT NULL DEFAULT 0 COMMENT '质押比率',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_get_record；模型来源：ppothergame:StakeGetRecord, ppothergameadmin:StakeGetRecord
CREATE TABLE IF NOT EXISTS `stake_get_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '操作金额',
  `stake_rate` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '比率',
  `total` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '操作后金额',
  `stake_type` BIGINT NOT NULL DEFAULT 0 COMMENT '操作类型：1质押，2解压',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_get_play_record；模型来源：ppothergame:StakeGetPlayRecord, ppothergameadmin:StakeGetPlayRecord
CREATE TABLE IF NOT EXISTS `stake_get_play_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '玩金额',
  `reward` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '收益',
  `status` BIGINT NOT NULL DEFAULT 0 COMMENT '状态：1赢了，2输',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_status` (`user_id`, `status`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_get_total；模型来源：ppothergame:StakeGetTotal, ppothergameadmin:StakeGetTotal
CREATE TABLE IF NOT EXISTS `stake_get_total` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '总数',
  `balance` DECIMAL(65,18) NOT NULL DEFAULT 0.0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_git；模型来源：ppothergame:StakeGit, ppothergameadmin:StakeGit
CREATE TABLE IF NOT EXISTS `stake_git` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '质押金额',
  `reward` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '收益总数',
  `status` BIGINT NOT NULL DEFAULT 0 COMMENT '状态：1质押，0解压',
  `sell_amount` DECIMAL(65,20) NOT NULL DEFAULT 0 COMMENT '由两端 stakeGit 写入代码推导的售卖金额',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_status` (`user_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_git_record；模型来源：ppothergame:StakeGitRecord, ppothergameadmin:StakeGitRecord
CREATE TABLE IF NOT EXISTS `stake_git_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '金额',
  `amount_two` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '金额',
  `stake_type` BIGINT NOT NULL DEFAULT 0 COMMENT '操作类型：1质押，2解压',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `day` BIGINT NOT NULL DEFAULT 0,
  `price` DECIMAL(65,18) NOT NULL DEFAULT 0.0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_stake_type` (`user_id`, `stake_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_git_record_ispay；模型来源：ppothergame:StakeGitRecord, ppothergameadmin:StakeGitRecord
CREATE TABLE IF NOT EXISTS `stake_git_record_ispay` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '金额',
  `amount_two` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '金额',
  `stake_type` BIGINT NOT NULL DEFAULT 0 COMMENT '操作类型：1质押，2解压',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `day` BIGINT NOT NULL DEFAULT 0,
  `price` DECIMAL(65,18) NOT NULL DEFAULT 0.0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_stake_type` (`user_id`, `stake_type`),
  KEY `idx_type_created` (`stake_type`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- stake_git_record_ispay_queue；模型来源：ppothergame:StakeGitRecordTwo, ppothergameadmin:StakeGitRecordTwo
CREATE TABLE IF NOT EXISTS `stake_git_record_ispay_queue` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '金额',
  `amount_two` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '金额',
  `amount_three` DECIMAL(65,18) NOT NULL DEFAULT 0.0 COMMENT '金额',
  `stake_type` BIGINT NOT NULL DEFAULT 0 COMMENT '操作类型：1质押，2解压',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `day` BIGINT NOT NULL DEFAULT 0,
  `price` DECIMAL(65,18) NOT NULL DEFAULT 0.0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_type` (`user_id`, `stake_type`),
  KEY `idx_user_type_created` (`user_id`, `stake_type`, `created_at`),
  KEY `idx_type_updated` (`stake_type`, `updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- withdraw；模型来源：ppothergame:Withdraw, ppothergameadmin:Withdraw
CREATE TABLE IF NOT EXISTS `withdraw` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` BIGINT(20) NOT NULL DEFAULT 0 COMMENT '金额',
  `rel_amount` BIGINT(20) NOT NULL DEFAULT 0 COMMENT '实际提现金额',
  `status` VARCHAR(45) NOT NULL DEFAULT 'default' COMMENT '状态',
  `amount_float` DECIMAL(65,18) NULL DEFAULT 0,
  `rel_amount_float` DECIMAL(65,18) NULL DEFAULT 0,
  `coin` VARCHAR(45) NULL DEFAULT '',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_created` (`user_id`, `created_at`),
  KEY `idx_user_coin_created` (`user_id`, `coin`, `created_at`),
  KEY `idx_coin_created` (`coin`, `created_at`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- exchange；模型来源：ppothergame:Exchange
CREATE TABLE IF NOT EXISTS `exchange` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount_float` DECIMAL(65,18) NULL DEFAULT 0,
  `rel_amount_float` DECIMAL(65,18) NULL DEFAULT 0,
  `amount_float_usdt` DECIMAL(65,18) NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_created` (`user_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- exchange_record；模型来源：ppothergame:ExchangeRecord, ppothergameadmin:ExchangeRecord
CREATE TABLE IF NOT EXISTS `exchange_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户ID',
  `git` DECIMAL(65,20) NOT NULL DEFAULT 0 COMMENT 'git数量',
  `giw` DECIMAL(65,20) NOT NULL DEFAULT 0 COMMENT 'giw数量',
  `fee` DECIMAL(65,20) NOT NULL DEFAULT 0 COMMENT '手续费',
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- eth_record；模型来源：ppothergameadmin:EthRecord, ppothergameadmin:EthRecordNew
CREATE TABLE IF NOT EXISTS `eth_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` BIGINT(20) NOT NULL DEFAULT 0,
  `last` BIGINT(20) NOT NULL DEFAULT 0,
  `address` VARCHAR(100) NOT NULL DEFAULT 'default',
  `coin` VARCHAR(100) NULL DEFAULT '',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount_float` DECIMAL(65,18) NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_address` (`address`),
  KEY `idx_last` (`last`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- eth_record_two；模型来源：ppothergame:EthRecordTwo, ppothergameadmin:EthRecordTwo
CREATE TABLE IF NOT EXISTS `eth_record_two` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` BIGINT(20) NOT NULL DEFAULT 0,
  `last` BIGINT(20) NOT NULL DEFAULT 0,
  `address` VARCHAR(100) NOT NULL DEFAULT 'default',
  `coin` VARCHAR(100) NULL DEFAULT '',
  `recommend_code` VARCHAR(1000) NOT NULL DEFAULT '',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_address` (`address`),
  KEY `idx_last` (`last`),
  KEY `idx_recommend_code_prefix` (`recommend_code`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- eth_record_three；模型来源：ppothergameadmin:EthRecordThree
CREATE TABLE IF NOT EXISTS `eth_record_three` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户id',
  `amount` BIGINT(20) NOT NULL DEFAULT 0,
  `amount_biw` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `last` BIGINT(20) NOT NULL DEFAULT 0,
  `address` VARCHAR(100) NOT NULL DEFAULT 'default',
  `coin` VARCHAR(100) NULL DEFAULT '',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_address` (`address`),
  KEY `idx_last` (`last`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- price_change；模型来源：ppothergameadmin:PriceChange
CREATE TABLE IF NOT EXISTS `price_change` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `price` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `price_new` DECIMAL(65,20) NOT NULL DEFAULT 0,
  `status` BIGINT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- 开始 03_init_base_records.sql
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

-- 开始 05_catalog_init_template.sql
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

