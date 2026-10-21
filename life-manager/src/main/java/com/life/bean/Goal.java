package com.life.bean;

/**
 * 长期目标实体类：字段与 t_goal 表一一对应。
 * 五位一体维度：1经济 2政治 3文化 4社会 5生态；层级：1五年 2年度 3季度。
 */
public class Goal {

    private int id;
    private int userId;
    private String title;
    private String description;
    private int dimension;
    private int level;
    private String period;
    private int progress;   // 0-100
    private int status;     // 0 进行中，1 已完成
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDimension() {
        return dimension;
    }

    public void setDimension(int dimension) {
        this.dimension = dimension;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public int getProgress() {
        return progress;
    }

    public void setProgress(int progress) {
        this.progress = progress;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    /** 五位一体维度中文名，JSP 中写 ${g.dimensionText} */
    public String getDimensionText() {
        return switch (dimension) {
            case 1 -> "经济";
            case 2 -> "政治";
            case 3 -> "文化";
            case 4 -> "社会";
            case 5 -> "生态";
            default -> "其他";
        };
    }

    /** 目标层级中文名 */
    public String getLevelText() {
        return switch (level) {
            case 1 -> "五年规划";
            case 3 -> "季度里程碑";
            default -> "年度 OKR";
        };
    }

    /** 进度到 100 或状态为 1 都视为已完成 */
    public boolean isFinished() {
        return status == 1 || progress >= 100;
    }
}