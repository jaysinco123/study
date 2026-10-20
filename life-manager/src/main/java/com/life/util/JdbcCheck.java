package com.life.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * JDBC 自检：不启动 Tomcat，直接验证数据库连接和种子数据。
 * 运行方式：IDEA 里右键 Run 'JdbcCheck.main()'。
 */
public class JdbcCheck {

    public static void main(String[] args) throws Exception {
        String sql = "SELECT COUNT(*) AS n FROM t_user";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                System.out.println("连接成功，用户数 = " + rs.getInt("n"));
            }
        }

        String demo = "SELECT username, nickname, role, status FROM t_user WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(demo)) {
            ps.setString(1, "demo");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("demo = " + rs.getString("nickname")
                            + ", role=" + rs.getInt("role")
                            + ", status=" + rs.getInt("status"));
                } else {
                    System.out.println("没有找到 demo，检查 init.sql 是否执行");
                }
            }
        }
    }
}
