-- 游戏项目完整恢复 SQL（宝塔单文件版），生成日期：2026-10-02。
-- 执行前：在宝塔数据库管理中选择已创建的目标空库；本文件不写死数据库名。
-- 本文件可独立执行，不使用 SOURCE，不需要上传分文件。
-- 默认值：348个非自增字段均有非NULL默认值，38个主键自动生成；缺省INSERT有明确回退值。
-- 内容：38 张表 / 386 个字段；3 条随机种子；1 条空资金池；25 条游戏基础参数；
--       120 个 config 待填项；ev_refresh_land_count 五分钟事件；末尾只读检查。
-- 原样空库执行预期：seed_info=10，land_info=10，prop_info=5，random_seeds=3，stake_get_total=1。
-- config 的 120 个变量当前为 NULL，未填项跳过插入，原样执行 config=0。
-- 填配置：在本文件搜索 SET @cfg_，将需要的 NULL 改为实际值后导入。
-- 固定配置 ID 16~21、26 已保留；其他 ID 从 100 开始新分配，非历史编号恢复。
-- 种子/土地/道具沿用当前分文件里的调试参数，具体数值在第三部分 SET 中可修改；
-- 这些调试值不是原来的正式业务参数，原参数不能仅从代码还原。
-- 修改本文件的 SET 即可调整本次初始化；编辑分文件不会自动同步到本文件。
-- 只补缺失的表/记录，保留已有值；CREATE TABLE IF NOT EXISTS 不升级已有表。
-- 重复执行不会用新 SET 覆盖已有记录；已有参数的后续修改应使用明确的 UPDATE。
-- 不创建管理员账户，不插入用户余额，不恢复历史业务流水，不修改 Go 代码。
-- DDL 与各段 INSERT 事务独立，整份文件不是原子事务；导入报错后先处理错误。
-- 事件使用导入账号作为 DEFINER，需要 EVENT 权限；本文件不更改全局 event_scheduler。
-- event_scheduler 必须为 ON，事件才能定时运行；末尾检查会显示该开关。
-- 建议在宝塔选定空库后通过导入功能上传本文件，或在同一 MySQL 会话执行全文。

-- 读写复核：两端共 509 处读写已静态追踪；补充非模型字段 stake_git.sell_amount。
-- 已知例外：BackUserGit 的 ammount_usdt 拼写与模型 amount_usdt 不一致，未改 Go 代码。
-- 如果已经导入旧版 385 字段建表文件，只重跑本文件不会升级表；请执行 09 补列文件。

-- =====================================================================
-- 争议定义见11：222列默认值是本次补设；sell_amount类型、残缺coin标签和两端默认冲突均非原DDL确认。
-- 索引见12：本次新增63个普通索引已内置建表，非历史索引；真实数据下仍需EXPLAIN验证。
-- 已导入旧版后可先09补列、再10补索引；重跑本文件不升级已有表。
-- 一、建立全部表结构
-- 原文件：01_restore_game_tables.sql
-- =====================================================================

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

-- =====================================================================
-- 二、初始化随机种子和空资金池
-- 原文件：03_init_base_records.sql
-- =====================================================================

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

-- =====================================================================
-- 三、初始化种子、土地和道具基础记录
-- 原文件：05_catalog_init_template.sql
-- =====================================================================

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

-- =====================================================================
-- 四、初始化 config 配置（NULL 项跳过）
-- 原文件：04_config_init_template.sql
-- =====================================================================

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

-- =====================================================================
-- 五、创建五分钟土地计数事件
-- 原文件：02_ev_refresh_land_count.sql
-- =====================================================================

-- 用户提供的 ev_refresh_land_count 原始业务定义。
-- 先选定与 user / land 表相同的数据库，再执行本文件。
-- 不写死旧服务器的 root@localhost DEFINER，事件使用执行者作为 DEFINER。
-- 保留原始周期、开始时间、ON COMPLETION NOT PRESERVE 和 ENABLE。
-- IF NOT EXISTS 不覆盖已经存在的同名事件。
-- 创建 ENABLE 事件不等于开启服务器 event_scheduler；本文件不修改全局设置。
SET @game_restore_old_sql_mode = @@SESSION.sql_mode;
SET @game_restore_old_time_zone = @@SESSION.time_zone;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
SET SESSION time_zone = 'SYSTEM';

CREATE EVENT IF NOT EXISTS `ev_refresh_land_count`
ON SCHEDULE EVERY 5 MINUTE
STARTS '2025-12-24 06:37:20'
ON COMPLETION NOT PRESERVE
ENABLE
DO
UPDATE `user` u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS land_cnt
    FROM land
    WHERE status <= 4
      AND limit_date > UNIX_TIMESTAMP()
    GROUP BY user_id
) x ON x.user_id = u.id
SET u.land_count = COALESCE(x.land_cnt, 0);

SET SESSION time_zone = @game_restore_old_time_zone;
SET SESSION sql_mode = @game_restore_old_sql_mode;

-- =====================================================================
-- 六、导入结果只读检查
-- 原文件：07_check_restore_readonly.sql
-- =====================================================================

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
