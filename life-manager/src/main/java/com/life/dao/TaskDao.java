package com.life.dao;

import com.life.bean.Task;
import com.life.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * 任务数据访问层。
 * 所有修改/删除/单条查询都带 user_id 条件，保证 A 用户不能操作 B 用户的数据。
 */
public class TaskDao {

    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    /**
     * 当前用户的任务列表，支持按完成状态和优先级筛选。
     * filter：all / todo / done；priority：0 表示不筛选，1-3 精确筛选。
     * 排序：未完成在前 → 优先级高在前 → 有截止日期的在前 → 截止日期近的在前 → 新建在前。
     */
    public List<Task> findByUser(int userId, String filter, int priority) {
        StringBuilder sql = new StringBuilder(
                "SELECT id, user_id, title, content, is_done, priority, due_date, create_time "
                        + "FROM t_task WHERE user_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);
        if ("todo".equals(filter)) {
            sql.append(" AND is_done = 0");
        } else if ("done".equals(filter)) {
            sql.append(" AND is_done = 1");
        }
        if (priority >= 1 && priority <= 3) {
            sql.append(" AND priority = ?");
            params.add(priority);
        }
        sql.append(" ORDER BY is_done ASC, priority ASC, (due_date IS NULL), due_date ASC, id DESC");

        List<Task> tasks = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapRow(rs));
                }
            }
            return tasks;
        } catch (SQLException e) {
            throw new RuntimeException("查询任务列表失败", e);
        }
    }

    /** 统计当前用户的任务：返回 [总数, 已完成数]，用于顶部统计卡片 */
    public int[] countByUser(int userId) {
        String sql = "SELECT COUNT(*) AS total, COALESCE(SUM(is_done = 1), 0) AS done "
                + "FROM t_task WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new int[]{rs.getInt("total"), rs.getInt("done")};
                }
                return new int[]{0, 0};
            }
        } catch (SQLException e) {
            throw new RuntimeException("统计任务失败", e);
        }
    }

    /** 按 id + userId 查询，查不到说明任务不存在或不属于当前用户 */
    public Task findById(int id, int userId) {
        String sql = "SELECT id, user_id, title, content, is_done, priority, due_date, create_time "
                + "FROM t_task WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("查询任务失败", e);
        }
    }
    public void insert(Task task) {
        String sql = "INSERT INTO t_task (user_id, title, content, priority, due_date, is_done) "
                + "VALUES (?, ?, ?, ?, ?, 0)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, task.getUserId());
            ps.setString(2, task.getTitle());
            ps.setString(3, task.getContent());
            ps.setInt(4, task.getPriority());
            if (task.getDueDate() == null || task.getDueDate().isEmpty()) {
                ps.setNull(5, Types.DATE);
            } else {
                ps.setString(5, task.getDueDate());
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("新增任务失败", e);
        }
    }

    /** 返回受影响行数：0 表示任务不存在或不属于当前用户 */
    public int update(int id, int userId, String title, String content, int priority, String dueDate) {
        String sql = "UPDATE t_task SET title = ?, content = ?, priority = ?, due_date = ? "
                + "WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, priority);
            if (dueDate == null || dueDate.isEmpty()) {
                ps.setNull(4, Types.DATE);
            } else {
                ps.setString(4, dueDate);
            }
            ps.setInt(5, id);
            ps.setInt(6, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("修改任务失败", e);
        }
    }

    public int delete(int id, int userId) {
        String sql = "DELETE FROM t_task WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("删除任务失败", e);
        }
    }

    public int updateDone(int id, int userId, int done) {
        String sql = "UPDATE t_task SET is_done = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, done);
            ps.setInt(2, id);
            ps.setInt(3, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("切换任务状态失败", e);
        }
    }

    private Task mapRow(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setId(rs.getInt("id"));
        task.setUserId(rs.getInt("user_id"));
        task.setTitle(rs.getString("title"));
        task.setContent(rs.getString("content"));
        task.setDone(rs.getInt("is_done"));
        task.setPriority(rs.getInt("priority"));
        java.sql.Date due = rs.getDate("due_date");
        task.setDueDate(due == null ? "" : due.toLocalDate().toString());
        Timestamp ts = rs.getTimestamp("create_time");
        task.setCreateTime(ts == null ? "" : ts.toLocalDateTime().format(TIME_FORMAT));
        return task;
    }
}