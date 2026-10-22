package com.life.bean;

import java.math.BigDecimal;

/* 收支账单实体类：字段与 t_bill 表一一对应。 type：1 收入，2 支出；金额用 BigDecimal 避免浮点误差。 */
public class Bill {

    private int id;
    private int userId;
    private int type;              // 1 收入，2 支出
    private BigDecimal amount;
    private String category;
    private String billDate;       // yyyy-MM-dd
    private String remark;
    private String createTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getBillDate() {
        return billDate;
    }

    public void setBillDate(String billDate) {
        this.billDate = billDate;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    /** 类型中文名，JSP 中写 ${b.typeText} */
    public String getTypeText() {
        return type == 1 ? "收入" : "支出";
    }

    /** 是否收入，页面上用于决定颜色 */
    public boolean isIncome() {
        return type == 1;
    }
}
