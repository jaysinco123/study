package com.life.service;

import com.life.bean.Goal;
import com.life.dao.GoalDao;

import java.util.List;

/**
 * 目标业务层：校验标题/维度/层级/进度，处理 +10% 快捷更新。
 * DAO 返回 0 行时统一抛 ServiceException，页面直接显示“无权操作”。
 */
public class GoalService {

    private final GoalDao goalDao = new GoalDao();

    public List<Goal> list(int userId, int level, int status) {
        return goalDao.findByUser(userId, level, status);
    }

    public Goal find(int userId, int id) {
        Goal goal = goalDao.findById(id, userId);
        if (goal == null) {
            throw new ServiceException("目标不存在，或无权查看");
        }
        return goal;
    }

    public void add(int userId, String title, String description, int dimension, int level, String period) {
        checkTitle(title);
        checkDescription(description);
        checkDimension(dimension);
        checkLevel(level);
        checkPeriod(period);

        Goal goal = new Goal();
        goal.setUserId(userId);
        goal.setTitle(title);
        goal.setDescription(description);
        goal.setDimension(dimension);
        goal.setLevel(level);
        goal.setPeriod(period);
        goal.setProgress(0);
        goal.setStatus(0);
        goalDao.insert(goal);
    }

    public void update(int userId, int id, String title, String description, int dimension,
                       int level, String period, int progress) {
        checkTitle(title);
        checkDescription(description);
        checkDimension(dimension);
        checkLevel(level);
        checkPeriod(period);
        checkProgress(progress);

        Goal goal = new Goal();
        goal.setId(id);
        goal.setUserId(userId);
        goal.setTitle(title);
        goal.setDescription(description);
        goal.setDimension(dimension);
        goal.setLevel(level);
        goal.setPeriod(period);
        goal.setProgress(progress);
        goal.setStatus(progress >= 100 ? 1 : 0);
        if (goalDao.update(goal) == 0) {
            throw new ServiceException("目标不存在，或无权修改");
        }
    }

    /** 快捷调整进度：delta 限制在 -50~50，结果限制在 0-100 */
    public void changeProgress(int userId, int id, int delta) {
        if (delta == 0 || delta < -50 || delta > 50) {
            throw new ServiceException("进度调整幅度不合法");
        }
        Goal goal = find(userId, id);
        int next = Math.max(0, Math.min(100, goal.getProgress() + delta));
        if (goalDao.updateProgress(id, userId, next) == 0) {
            throw new ServiceException("目标不存在，或无权修改");
        }
    }

    public void delete(int userId, int id) {
        if (goalDao.delete(id, userId) == 0) {
            throw new ServiceException("目标不存在，或无权删除");
        }
    }

    private void checkTitle(String title) {
        if (title == null || title.isBlank()) {
            throw new ServiceException("目标标题不能为空");
        }
        if (title.length() > 100) {
            throw new ServiceException("目标标题不能超过 100 个字符");
        }
    }

    private void checkDescription(String description) {
        if (description != null && description.length() > 500) {
            throw new ServiceException("目标说明不能超过 500 个字符");
        }
    }

    private void checkDimension(int dimension) {
        if (dimension < 1 || dimension > 5) {
            throw new ServiceException("维度只能在 1-5 之间");
        }
    }

    private void checkLevel(int level) {
        if (level < 1 || level > 3) {
            throw new ServiceException("层级只能是 1五年 / 2年度 / 3季度");
        }
    }

    private void checkPeriod(String period) {
        if (period != null && period.length() > 30) {
            throw new ServiceException("周期不能超过 30 个字符");
        }
    }

    private void checkProgress(int progress) {
        if (progress < 0 || progress > 100) {
            throw new ServiceException("进度必须在 0-100 之间");
        }
    }
}