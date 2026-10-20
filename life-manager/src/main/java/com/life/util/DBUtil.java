package com.life.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 数据库工具类：加载驱动、获取连接、释放资源。
 * 精简版把配置写成常量，少一个配置文件；换电脑只改这里的三行。
 */
public final class DBUtil {

    private static final String URL =
            "jdbc:mysql://127.0.0.1:3306/life_db"
                    + "?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
                    + "&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai";
    private static final String USERNAME = "life_app";
    private static final String PASSWORD = "Life@2026";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL 驱动加载失败，请检查 pom.xml 依赖");
        }
    }

    private DBUtil() {
    }

    /** 获取连接，调用方用 try-with-resources 自动关闭 */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /** 按“后打开先关闭”的顺序安静释放资源，关闭异常不覆盖业务异常 */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception ignored) {
                    // 忽略关闭异常
                }
            }
        }
    }
}
