package com.life.service;

import com.life.bean.Bill;
import com.life.bean.BillCategory;
import com.life.dao.BillDao;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 记账业务层：校验类型/金额/分类/日期，并计算月度收支与分类占比。
 * DAO 返回 0 行时抛 ServiceException，页面统一提示“账单不存在或无权操作”。
 */
public class BillService {

    private final BillDao billDao = new BillDao();

    public List<Bill> list(int userId, int type, String month) {
        return billDao.findByUser(userId, type, month);
    }

    public Bill find(int userId, int id) {
        Bill bill = billDao.findById(id, userId);
        if (bill == null) {
            throw new ServiceException("账单不存在，或无权查看");
        }
        return bill;
    }

    public void add(int userId, int type, String amountText, String category, String billDate, String remark) {
        Bill bill = new Bill();
        bill.setUserId(userId);
        bill.setType(checkType(type));
        bill.setAmount(checkAmount(amountText));
        bill.setCategory(checkCategory(category));
        bill.setBillDate(checkDate(billDate));
        bill.setRemark(checkRemark(remark));
        billDao.insert(bill);
    }

    public void update(int userId, int id, int type, String amountText, String category,
                       String billDate, String remark) {
        Bill bill = new Bill();
        bill.setId(id);
        bill.setUserId(userId);
        bill.setType(checkType(type));
        bill.setAmount(checkAmount(amountText));
        bill.setCategory(checkCategory(category));
        bill.setBillDate(checkDate(billDate));
        bill.setRemark(checkRemark(remark));
        if (billDao.update(bill) == 0) {
            throw new ServiceException("账单不存在，或无权修改");
        }
    }

    public void delete(int userId, int id) {
        if (billDao.delete(id, userId) == 0) {
            throw new ServiceException("账单不存在，或无权删除");
        }
    }

    /** 某月收入合计 */
    public BigDecimal income(int userId, String month) {
        return billDao.sum(userId, 1, month);
    }

    /** 某月支出合计 */
    public BigDecimal expense(int userId, String month) {
        return billDao.sum(userId, 2, month);
    }

    /** 某月结余 = 收入 - 支出 */
    public BigDecimal balance(int userId, String month) {
        return income(userId, month).subtract(expense(userId, month));
    }

    /** 某月支出分类占比，按金额从大到小 */
    public List<BillCategory> expenseByCategory(int userId, String month) {
        Map<String, BigDecimal> totals = billDao.sumByCategory(userId, 2, month);
        BigDecimal all = expense(userId, month);
        List<BillCategory> list = new ArrayList<>();
        for (Map.Entry<String, BigDecimal> entry : totals.entrySet()) {
            int percent = all.signum() == 0 ? 0
                    : entry.getValue().multiply(BigDecimal.valueOf(100))
                    .divide(all, 0, RoundingMode.HALF_UP).intValue();
            list.add(new BillCategory(entry.getKey(), entry.getValue(), percent));
        }
        return list;
    }
    private int checkType(int type) {
        if (type != 1 && type != 2) {
            throw new ServiceException("类型只能是 1收入 或 2支出");
        }
        return type;
    }

    private BigDecimal checkAmount(String amountText) {
        if (amountText == null || amountText.isBlank()) {
            throw new ServiceException("金额不能为空");
        }
        BigDecimal amount;
        try {
            amount = new BigDecimal(amountText.trim());
        } catch (NumberFormatException e) {
            throw new ServiceException("金额必须是数字");
        }
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ServiceException("金额必须大于 0");
        }
        if (amount.compareTo(new BigDecimal("9999999.99")) > 0) {
            throw new ServiceException("金额不能超过 9999999.99");
        }
        if (amount.scale() > 2) {
            throw new ServiceException("金额最多保留两位小数");
        }
        return amount.setScale(2, RoundingMode.HALF_UP);
    }

    private String checkCategory(String category) {
        if (category == null || category.isBlank()) {
            throw new ServiceException("分类不能为空");
        }
        String value = category.trim();
        if (value.length() > 30) {
            throw new ServiceException("分类不能超过 30 个字符");
        }
        return value;
    }

    private String checkDate(String billDate) {
        if (billDate == null || billDate.isBlank()) {
            throw new ServiceException("请选择账单日期");
        }
        try {
            return LocalDate.parse(billDate.trim()).toString();
        } catch (DateTimeParseException e) {
            throw new ServiceException("日期格式必须是 yyyy-MM-dd");
        }
    }

    private String checkRemark(String remark) {
        if (remark != null && remark.length() > 200) {
            throw new ServiceException("备注不能超过 200 个字符");
        }
        return remark;
    }
}