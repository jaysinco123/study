package com.life.bean;

import java.math.BigDecimal;

/**
 * 分类汇总结果：用于“本月支出分类”条形图。
 * percent 为占该月同类总额的百分比（0-100 的整数），由 Service 计算好，JSP 直接当宽度用。
 */
public class BillCategory {

    private final String category;
    private final BigDecimal amount;
    private final int percent;

    public BillCategory(String category, BigDecimal amount, int percent) {
        this.category = category;
        this.amount = amount;
        this.percent = percent;
    }

    public String getCategory() {
        return category;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public int getPercent() {
        return percent;
    }
}
