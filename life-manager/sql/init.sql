-- ============================================================
-- 人生管理系统（精简版）数据库脚本  v8
-- 用法：mysql -uroot -p < init.sql
-- 说明：共 4 张表，满足"数据库至少 2 张表"的要求
-- ============================================================

DROP DATABASE IF EXISTS life_db;
CREATE DATABASE life_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE life_db;

-- 应用专用账号（项目中不用 root 连库）
CREATE USER IF NOT EXISTS 'life_app'@'%' IDENTIFIED BY 'Life@2026';
ALTER USER 'life_app'@'%' IDENTIFIED BY 'Life@2026';
GRANT ALL PRIVILEGES ON life_db.* TO 'life_app'@'%';

CREATE USER IF NOT EXISTS 'life_app'@'localhost' IDENTIFIED BY 'Life@2026';
ALTER USER 'life_app'@'localhost' IDENTIFIED BY 'Life@2026';
GRANT ALL PRIVILEGES ON life_db.* TO 'life_app'@'localhost';
FLUSH PRIVILEGES;

CREATE TABLE t_user (
                        id          INT          PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
                        username    VARCHAR(30)  NOT NULL COMMENT '登录账号',
                        password    VARCHAR(100) NOT NULL COMMENT 'BCrypt 加密后的密码',
                        nickname    VARCHAR(30)  NOT NULL COMMENT '昵称',
                        email       VARCHAR(80)  DEFAULT NULL COMMENT '邮箱',
                        role        TINYINT      NOT NULL DEFAULT 0 COMMENT '角色：0普通用户 1管理员',
                        status      TINYINT      NOT NULL DEFAULT 1 COMMENT '状态：1正常 0禁用',
                        create_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
                        UNIQUE KEY uk_user_username (username)
) ENGINE = InnoDB COMMENT ='用户表';

CREATE TABLE t_task (
                        id          INT          PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
                        user_id     INT          NOT NULL COMMENT '所属用户',
                        title       VARCHAR(100) NOT NULL COMMENT '任务标题',
                        content     VARCHAR(500) DEFAULT NULL COMMENT '任务描述',
                        is_done     TINYINT      NOT NULL DEFAULT 0 COMMENT '0未完成 1已完成',
                        priority    TINYINT      NOT NULL DEFAULT 2 COMMENT '优先级：1高 2中 3低',
                        due_date    DATE         DEFAULT NULL COMMENT '截止日期',
                        create_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        KEY idx_task_user (user_id),
                        CONSTRAINT fk_task_user FOREIGN KEY (user_id) REFERENCES t_user (id) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT ='每日任务表';

CREATE TABLE t_goal (
                        id          INT          PRIMARY KEY AUTO_INCREMENT COMMENT '目标ID',
                        user_id     INT          NOT NULL COMMENT '所属用户',
                        title       VARCHAR(100) NOT NULL COMMENT '目标标题',
                        description VARCHAR(500) DEFAULT NULL COMMENT '目标说明',
                        dimension   TINYINT      NOT NULL DEFAULT 1 COMMENT '五位一体维度：1经济 2政治 3文化 4社会 5生态',
                        level       TINYINT      NOT NULL DEFAULT 2 COMMENT '层级：1五年 2年度 3季度',
                        period      VARCHAR(30)  DEFAULT NULL COMMENT '周期，如 2026 / 2026Q4',
                        progress    INT          NOT NULL DEFAULT 0 COMMENT '进度 0-100',
                        status      TINYINT      NOT NULL DEFAULT 0 COMMENT '0进行中 1已完成',
                        create_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        KEY idx_goal_user (user_id),
                        CONSTRAINT fk_goal_user FOREIGN KEY (user_id) REFERENCES t_user (id) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT ='长期目标表';

CREATE TABLE t_bill (
                        id          INT            PRIMARY KEY AUTO_INCREMENT COMMENT '账单ID',
                        user_id     INT            NOT NULL COMMENT '所属用户',
                        type        TINYINT        NOT NULL COMMENT '类型：1收入 2支出',
                        amount      DECIMAL(12, 2) NOT NULL COMMENT '金额',
                        category    VARCHAR(30)    NOT NULL COMMENT '分类，如 餐饮 / 工资',
                        bill_date   DATE           NOT NULL COMMENT '发生日期',
                        remark      VARCHAR(200)   DEFAULT NULL COMMENT '备注',
                        create_time DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        KEY idx_bill_user_date (user_id, bill_date),
                        CONSTRAINT fk_bill_user FOREIGN KEY (user_id) REFERENCES t_user (id) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT ='收支账单表';

-- 初始管理员：admin / Admin@123（密码为 BCrypt 哈希，库里不存明文）
INSERT INTO t_user (username, password, nickname, email, role) VALUES
                                                                   ('admin', '$2a$10$bYclRRUtbLHKEVviumAL4.nXADJwWF8hFyOKa.IYmeVO0b4noLynq', '系统管理员', 'admin@life.local', 1),
                                                                   ('demo',  '$2a$10$UWxz3KXBuXV/8nr9sEow0uxtHoS/X9SJu4Y7ia9SfyQQx19bypyTW', '演示用户', 'demo@life.local', 0);

-- demo 的三条任务：含高优先级与一条逾期任务
INSERT INTO t_task (user_id, title, content, priority, due_date)
SELECT id, '跑通 v1 项目骨架', 'mvn package 成功并部署到 Tomcat', 3, NULL FROM t_user WHERE username = 'demo';
INSERT INTO t_task (user_id, title, content, priority, due_date)
SELECT id, '完成登录注册模块', 'Session 保存登录状态', 2, CURRENT_DATE FROM t_user WHERE username = 'demo';
INSERT INTO t_task (user_id, title, content, priority, due_date)
SELECT id, '提交课程设计文档', '高优先级任务，用于演示逾期提醒', 1, DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY) FROM t_user WHERE username = 'demo';

-- demo 的三个目标：覆盖五年/年度/季度与不同维度
INSERT INTO t_goal (user_id, title, description, dimension, level, period, progress, status)
SELECT id, '毕业前拿到一份 Java 后端 offer', '五年规划第一年：补齐 Spring Boot 与项目经验', 1, 1, '2026-2030', 25, 0
FROM t_user WHERE username = 'demo';
INSERT INTO t_goal (user_id, title, description, dimension, level, period, progress, status)
SELECT id, '读完 12 本专业以外的书', '每月一本，写读书笔记', 3, 2, '2026', 50, 0
FROM t_user WHERE username = 'demo';
INSERT INTO t_goal (user_id, title, description, dimension, level, period, progress, status)
SELECT id, '每周至少运动三次', '跑步或游泳，已完成本季度目标', 4, 3, '2026Q4', 100, 1
FROM t_user WHERE username = 'demo';

SET @month_start = STR_TO_DATE(DATE_FORMAT(CURRENT_DATE, '%Y-%m-01'), '%Y-%m-%d');
INSERT INTO t_bill (user_id, type, amount, category, bill_date, remark)
SELECT id, 1, 8000.00, '工资', @month_start, '本月工资' FROM t_user WHERE username = 'demo';
INSERT INTO t_bill (user_id, type, amount, category, bill_date, remark)
SELECT id, 2, 2200.00, '房租', DATE_ADD(@month_start, INTERVAL 1 DAY), '合租单间' FROM t_user WHERE username = 'demo';
INSERT INTO t_bill (user_id, type, amount, category, bill_date, remark)
SELECT id, 2, 45.50, '餐饮', DATE_ADD(@month_start, INTERVAL 4 DAY), '工作日午饭' FROM t_user WHERE username = 'demo';
INSERT INTO t_bill (user_id, type, amount, category, bill_date, remark)
SELECT id, 2, 12.00, '交通', DATE_ADD(@month_start, INTERVAL 7 DAY), '地铁' FROM t_user WHERE username = 'demo';
INSERT INTO t_bill (user_id, type, amount, category, bill_date, remark)
SELECT id, 2, 89.00, '学习', DATE_ADD(@month_start, INTERVAL 10 DAY), '技术书' FROM t_user WHERE username = 'demo';
INSERT INTO t_bill (user_id, type, amount, category, bill_date, remark)
SELECT id, 2, 120.00, '餐饮', DATE_SUB(@month_start, INTERVAL 15 DAY), '上月聚餐' FROM t_user WHERE username = 'demo';

SELECT '数据库初始化完成' AS result,
       (SELECT COUNT(*) FROM t_user) AS users,
       (SELECT COUNT(*) FROM t_task) AS tasks,
       (SELECT COUNT(*) FROM t_goal) AS goals,
       (SELECT COUNT(*) FROM t_bill) AS bills;