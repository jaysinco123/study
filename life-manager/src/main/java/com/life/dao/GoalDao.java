package com.life.dao;

import com.life.bean.Goal;
import com.life.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * 目标数据访问层。
 * 查询、修改、删除都带 user_id 条件，保证只能操作自己的目标。
 */
public class GoalDao {

    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final String COLUMNS =
            "id, user_id, title, description, dimension, level, period, progress, status, create_time ";

    /** level / status 传 0 表示不筛选；排序：进行中在前，再按维度、创建时间倒序 */
    public List<Goal> findByUser(int userId, int level, int status) {
        StringBuilder sql = new StringBuilder("SELECT " + COLUMNS + "FROM t_goal WHERE user_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);
        if (level >= 1 && level <= 3) {
            sql.append(" AND level = ?");
            params.add(level);
        }
        if (status == 0 || status == 1) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        sql.append(" ORDER BY status ASC, dimension ASC, id DESC");

        List<Goal> goals = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    goals.add(mapRow(rs));
                }
            }
            return goals;
        } catch (SQLException e) {
            throw new RuntimeException("查询目标列表失败", e);
        }
    }

    public Goal findById(int id, int userId) {
        String sql = "SELECT " + COLUMNS + "FROM t_goal WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("查询目标失败", e);
        }
    }
    public void insert(Goal goal) {
        String sql = "INSERT INTO t_goal (user_id, title, description, dimension, level, period, progress, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, goal.getUserId());
            ps.setString(2, goal.getTitle());
            ps.setString(3, goal.getDescription());
            ps.setInt(4, goal.getDimension());
            ps.setInt(5, goal.getLevel());
            ps.setString(6, goal.getPeriod());
            ps.setInt(7, goal.getProgress());
            ps.setInt(8, goal.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("新增目标失败", e);
        }
    }

    /** 返回受影响行数：0 表示目标不存在或不属于当前用户 */
    public int update(Goal goal) {
        String sql = "UPDATE t_goal SET title = ?, description = ?, dimension = ?, level = ?, "
                + "period = ?, progress = ?, status = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, goal.getTitle());
            ps.setString(2, goal.getDescription());
            ps.setInt(3, goal.getDimension());
            ps.setInt(4, goal.getLevel());
            ps.setString(5, goal.getPeriod());
            ps.setInt(6, goal.getProgress());
            ps.setInt(7, goal.getStatus());
            ps.setInt(8, goal.getId());
            ps.setInt(9, goal.getUserId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("修改目标失败", e);
        }
    }

    /** 只改进度：进度到 100 时状态自动置为已完成 */
    public int updateProgress(int id, int userId, int progress) {
        String sql = "UPDATE t_goal SET progress = ?, status = CASE WHEN ? >= 100 THEN 1 ELSE 0 END "
                + "WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, progress);
            ps.setInt(2, progress);
            ps.setInt(3, id);
            ps.setInt(4, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("更新目标进度失败", e);
        }
    }

    public int delete(int id, int userId) {
        String sql = "DELETE FROM t_goal WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("删除目标失败", e);
        }
    }

    private Goal mapRow(ResultSet rs) throws SQLException {
        Goal goal = new Goal();
        goal.setId(rs.getInt("id"));
        goal.setUserId(rs.getInt("user_id"));
        goal.setTitle(rs.getString("title"));
        goal.setDescription(rs.getString("description"));
        goal.setDimension(rs.getInt("dimension"));
        goal.setLevel(rs.getInt("level"));
        goal.setPeriod(rs.getString("period"));
        goal.setProgress(rs.getInt("progress"));
        goal.setStatus(rs.getInt("status"));
        Timestamp ts = rs.getTimestamp("create_time");
        goal.setCreateTime(ts == null ? "" : ts.toLocalDateTime().format(TIME_FORMAT));
        return goal;
    }
}