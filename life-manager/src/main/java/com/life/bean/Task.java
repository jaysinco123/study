package com.life.bean;

import java.time.LocalDate;

/**
 * 每日任务实体类（JavaBean）：字段与 t_task 表一一对应。
 * createTime / dueDate 都保存成字符串，页面展示时不用再格式化。
 */
public class Task {

    private int id;
    private int userId;
    private String title;
    private String content;
    private int done;          // 0 未完成，1 已完成
    private int priority;      // 1 高，2 中，3 低
    private String dueDate;    // 截止日期 yyyy-MM-dd，可为空
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getDone() {
        return done;
    }

    public void setDone(int done) {
        this.done = done;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getDueDate() {
        return dueDate;
    }

    public void setDueDate(String dueDate) {
        this.dueDate = dueDate;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    /** JSP 中用 ${task.doneFlag} 判断是否已完成 */
    public boolean isDoneFlag() {
        return done == 1;
    }

    /** 优先级中文标签，JSP 中写 ${task.priorityText} 即可 */
    public String getPriorityText() {
        return switch (priority) {
            case 1 -> "高";
            case 3 -> "低";
            default -> "中";
        };
    }

    /** 未完成且截止日期早于今天 → 逾期（页面标红） */
    public boolean isOverdue() {
        if (done == 1 || dueDate == null || dueDate.isEmpty()) {
            return false;
        }
        return dueDate.compareTo(LocalDate.now().toString()) < 0;
    }
}