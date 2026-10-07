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

