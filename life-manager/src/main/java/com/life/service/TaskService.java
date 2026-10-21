package com.life.service;

import com.life.bean.Task;
import com.life.dao.TaskDao;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * 任务业务层：标题/描述校验、越权保护。
 * DAO 返回受影响行数为 0 时，说明任务不存在或不属于当前用户，统一抛业务异常。
 */
public class TaskService {

    private final TaskDao taskDao = new TaskDao();

    public List<Task> list(int userId, String filter, int priority) {
        return taskDao.findByUser(userId, filter, priority);
    }

    /** 统计：返回 [总数, 已完成数] */
    public int[] count(int userId) {
        return taskDao.countByUser(userId);
    }

    public void add(int userId, String title, String content, int priority, String dueDate) {
        checkTitle(title);
        checkContent(content);
        checkPriority(priority);
        checkDueDate(dueDate);

        Task task = new Task();
        task.setUserId(userId);
        task.setTitle(title);
        task.setContent(content);
        task.setPriority(priority);
        task.setDueDate(dueDate);
        taskDao.insert(task);
    }

    public void update(int userId, int id, String title, String content, int priority, String dueDate) {
        checkTitle(title);
        checkContent(content);
        checkPriority(priority);
        checkDueDate(dueDate);
        if (taskDao.update(id, userId, title, content, priority, dueDate) == 0) {
            throw new ServiceException("任务不存在，或无权修改");
        }
    }

    public void delete(int userId, int id) {
        if (taskDao.delete(id, userId) == 0) {
            throw new ServiceException("任务不存在，或无权删除");
        }
    }

    public void toggle(int userId, int id, int done) {
        if (done != 0 && done != 1) {
            throw new ServiceException("任务状态值不合法");
        }
        if (taskDao.updateDone(id, userId, done) == 0) {
            throw new ServiceException("任务不存在，或无权修改");
        }
    }

    private void checkTitle(String title) {
        if (title == null || title.isBlank()) {
            throw new ServiceException("任务标题不能为空");
        }
        if (title.length() > 100) {
            throw new ServiceException("任务标题不能超过 100 个字符");
        }
    }

    private void checkContent(String content) {
        if (content != null && content.length() > 500) {
            throw new ServiceException("任务描述不能超过 500 个字符");
        }
    }

    private void checkPriority(int priority) {
        if (priority < 1 || priority > 3) {
            throw new ServiceException("优先级只能是 1（高）、2（中）、3（低）");
        }
    }

    /** 截止日期允许为空；填写时必须是 yyyy-MM-dd */
    private void checkDueDate(String dueDate) {
        if (dueDate == null || dueDate.isEmpty()) {
            return;
        }
        try {
            LocalDate.parse(dueDate);
        } catch (DateTimeParseException e) {
            throw new ServiceException("截止日期格式不正确，应为 yyyy-MM-dd");
        }
    }
}