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
