package com.life.dao;

import com.life.bean.User;
import com.life.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * 用户数据访问层：只负责 SQL，不写业务判断。
 * 全部使用 PreparedStatement + ? 占位符，防止 SQL 注入。
 */
public class UserDao {

    public User findByUsername(String username) {
        String sql = "SELECT id, username, password, nickname, email, role, status "
                + "FROM t_user WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("根据账号查询用户失败", e);
        }
    }

    public User findById(int id) {
        String sql = "SELECT id, username, password, nickname, email, role, status "
                + "FROM t_user WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("根据ID查询用户失败", e);
        }
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT 1 FROM t_user WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("检查账号是否存在失败", e);
        }
    }

    /** 注册：role 固定 0，status 固定 1 */
    public void insert(User user) {
        String sql = "INSERT INTO t_user (username, password, nickname, email, role, status) "
                + "VALUES (?, ?, ?, ?, 0, 1)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getNickname());
            if (user.getEmail() == null || user.getEmail().isEmpty()) {
                ps.setNull(4, Types.VARCHAR);
            } else {
                ps.setString(4, user.getEmail());
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("注册用户失败", e);
        }
    }
    public List<User> findAll() {
        String sql = "SELECT id, username, password, nickname, email, role, status "
                + "FROM t_user ORDER BY id";
        List<User> users = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapRow(rs));
            }
            return users;
        } catch (SQLException e) {
            throw new RuntimeException("查询用户列表失败", e);
        }
    }

    public void updateStatus(int id, int status) {
        String sql = "UPDATE t_user SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("修改用户状态失败", e);
        }
    }

    /** 修改昵称与邮箱；邮箱为空时写 NULL */
    public void updateProfile(int id, String nickname, String email) {
        String sql = "UPDATE t_user SET nickname = ?, email = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nickname);
            if (email == null || email.isEmpty()) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, email);
            }
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("修改个人资料失败", e);
        }
    }

    /** 修改密码：只存 BCrypt 哈希，明文不落库 */
    public void updatePassword(int id, String passwordHash) {
        String sql = "UPDATE t_user SET password = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("修改密码失败", e);
        }
    }

    /** ResultSet -> JavaBean，避免每个查询重复写 6 行 set */
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setNickname(rs.getString("nickname"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getInt("role"));
        user.setStatus(rs.getInt("status"));
        return user;
    }
}