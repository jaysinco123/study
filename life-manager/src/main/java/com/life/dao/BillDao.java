package com.life.dao;

import com.life.bean.Bill;
import com.life.util.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 账单数据访问层。
 * 所有 SQL 都带 user_id，保证只能看到/操作自己的账目。
 * month 参数形如 2026-10，用 DATE_FORMAT(bill_date,'%Y-%m') 比较，便于按月统计。
 */
public class BillDao {

    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final String COLUMNS = "id, user_id, type, amount, category, bill_date, remark, create_time ";

    /** type 传 0 表示不筛选；month 为空表示不按月筛选 */
    public List<Bill> findByUser(int userId, int type, String month) {
        StringBuilder sql = new StringBuilder("SELECT " + COLUMNS + "FROM t_bill WHERE user_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);
        if (type == 1 || type == 2) {
            sql.append(" AND type = ?");
            params.add(type);
        }
        if (month != null && !month.isBlank()) {
            sql.append(" AND DATE_FORMAT(bill_date, '%Y-%m') = ?");
            params.add(month);
        }
        sql.append(" ORDER BY bill_date DESC, id DESC");

        List<Bill> bills = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bills.add(mapRow(rs));
                }
            }
            return bills;
        } catch (SQLException e) {
            throw new RuntimeException("查询账单列表失败", e);
        }
    }

    public Bill findById(int id, int userId) {
        String sql = "SELECT " + COLUMNS + "FROM t_bill WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("查询账单失败", e);
        }
    }

    public void insert(Bill bill) {
        String sql = "INSERT INTO t_bill (user_id, type, amount, category, bill_date, remark) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bill.getUserId());
            ps.setInt(2, bill.getType());
            ps.setBigDecimal(3, bill.getAmount());
            ps.setString(4, bill.getCategory());
            ps.setDate(5, Date.valueOf(bill.getBillDate()));
            ps.setString(6, bill.getRemark());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("新增账单失败", e);
        }
    }

    /** 返回受影响行数：0 表示账单不存在或不属于当前用户 */
    public int update(Bill bill) {
        String sql = "UPDATE t_bill SET type = ?, amount = ?, category = ?, bill_date = ?, remark = ? "
                + "WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bill.getType());
            ps.setBigDecimal(2, bill.getAmount());
            ps.setString(3, bill.getCategory());
            ps.setDate(4, Date.valueOf(bill.getBillDate()));
            ps.setString(5, bill.getRemark());
            ps.setInt(6, bill.getId());
            ps.setInt(7, bill.getUserId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("修改账单失败", e);
        }
    }
    public int delete(int id, int userId) {
        String sql = "DELETE FROM t_bill WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("删除账单失败", e);
        }
    }

    /** 某月某一类型的合计金额，没有记录时返回 0 */
    public BigDecimal sum(int userId, int type, String month) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM t_bill "
                + "WHERE user_id = ? AND type = ? AND DATE_FORMAT(bill_date, '%Y-%m') = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, type);
            ps.setString(3, month);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            throw new RuntimeException("统计账单金额失败", e);
        }
    }

    /** 某月某一类型的分类合计，金额从大到小，供页面画占比条 */
    public Map<String, BigDecimal> sumByCategory(int userId, int type, String month) {
        String sql = "SELECT category, SUM(amount) AS total FROM t_bill "
                + "WHERE user_id = ? AND type = ? AND DATE_FORMAT(bill_date, '%Y-%m') = ? "
                + "GROUP BY category ORDER BY total DESC";
        Map<String, BigDecimal> result = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, type);
            ps.setString(3, month);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("category"), rs.getBigDecimal("total"));
                }
            }
            return result;
        } catch (SQLException e) {
            throw new RuntimeException("分类统计失败", e);
        }
    }

    private Bill mapRow(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setId(rs.getInt("id"));
        bill.setUserId(rs.getInt("user_id"));
        bill.setType(rs.getInt("type"));
        bill.setAmount(rs.getBigDecimal("amount"));
        bill.setCategory(rs.getString("category"));
        Date date = rs.getDate("bill_date");
        bill.setBillDate(date == null ? "" : date.toLocalDate().toString());
        bill.setRemark(rs.getString("remark"));
        Timestamp ts = rs.getTimestamp("create_time");
        bill.setCreateTime(ts == null ? "" : ts.toLocalDateTime().format(TIME_FORMAT));
        return bill;
    }
}