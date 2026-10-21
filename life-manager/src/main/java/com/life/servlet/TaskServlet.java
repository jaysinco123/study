package com.life.servlet;

import com.life.bean.User;
import com.life.service.ServiceException;
import com.life.service.TaskService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 任务控制器：一个 Servlet 覆盖增删改查。
 * GET  /tasks            查询列表
 * POST /tasks action=add      新增
 * POST /tasks action=update   修改
 * POST /tasks action=delete   删除
 * POST /tasks action=toggle   切换完成状态
 */
@WebServlet({"/tasks", "/dashboard"})
public class TaskServlet extends BaseServlet {

    private final TaskService taskService = new TaskService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            redirect(request, response, "/login");
            return;
        }

        HttpSession session = request.getSession();
        Object flash = session.getAttribute("flash");
        if (flash != null) {
            request.setAttribute("error", flash);
            session.removeAttribute("flash");
        }

        String filter = param(request, "filter");
        if (!"todo".equals(filter) && !"done".equals(filter)) {
            filter = "all";
        }
        int priority = filterPriority(param(request, "priority"));

        request.setAttribute("tasks", taskService.list(user.getId(), filter, priority));
        request.setAttribute("filter", filter);
        request.setAttribute("priority", priority);

        // 顶部统计卡片：总任务 / 已完成 / 待办 / 完成率
        int[] count = taskService.count(user.getId());
        request.setAttribute("total", count[0]);
        request.setAttribute("doneCount", count[1]);
        request.setAttribute("todoCount", count[0] - count[1]);
        request.setAttribute("rate", count[0] == 0 ? 0 : count[1] * 100 / count[0]);

        forward(request, response, "dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            redirect(request, response, "/login");
            return;
        }

        String action = param(request, "action");
        try {
            switch (action) {
                case "add" -> taskService.add(user.getId(), param(request, "title"), param(request, "content"),
                        parsePriority(param(request, "priority")), param(request, "dueDate"));
                case "update" -> taskService.update(user.getId(), idParam(request), param(request, "title"),
                        param(request, "content"), parsePriority(param(request, "priority")),
                        param(request, "dueDate"));
                case "delete" -> taskService.delete(user.getId(), idParam(request));
                case "toggle" -> taskService.toggle(user.getId(), idParam(request), idParam(request, "done"));
                default -> throw new ServiceException("不支持的操作：" + action);
            }
        } catch (ServiceException e) {
            // 重定向后要显示消息，只能先放进 Session（PRG 模式，避免刷新重复提交）
            request.getSession().setAttribute("flash", e.getMessage());
        } catch (RuntimeException e) {
            request.getSession().setAttribute("flash", "操作失败：" + e.getMessage());
        }
        redirect(request, response, "/tasks");
    }

    /** 列表页的优先级筛选：0 或非法值都表示“全部” */
    private int filterPriority(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return (parsed >= 1 && parsed <= 3) ? parsed : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    /** 新增/修改时的优先级：缺省按“中”处理 */
    private int parsePriority(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return (parsed >= 1 && parsed <= 3) ? parsed : 2;
        } catch (NumberFormatException e) {
            return 2;
        }
    }

    private int idParam(HttpServletRequest request) {
        return idParam(request, "id");
    }

    private int idParam(HttpServletRequest request, String name) {
        try {
            return Integer.parseInt(param(request, name));
        } catch (NumberFormatException e) {
            throw new ServiceException("任务参数不合法");
        }
    }
}