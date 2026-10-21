package com.life.servlet;

import com.life.bean.User;
import com.life.service.GoalService;
import com.life.service.ServiceException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 目标控制器：列表、新增/编辑表单、进度调整、删除。
 * GET  /goals                    列表（可按 level/status 筛选）
 * GET  /goals?action=new         新增表单
 * GET  /goals?action=edit&id=1   编辑表单
 * POST /goals action=add|save|progress|delete
 */
@WebServlet("/goals")
public class GoalServlet extends BaseServlet {

    private final GoalService goalService = new GoalService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            redirect(request, response, "/login");
            return;
        }

        String action = param(request, "action");
        if ("new".equals(action)) {
            forward(request, response, "goal/form.jsp");
            return;
        }
        if ("edit".equals(action)) {
            request.setAttribute("goal", goalService.find(user.getId(), intParam(request, "id", 0)));
            forward(request, response, "goal/form.jsp");
            return;
        }

        Object flash = request.getSession().getAttribute("flash");
        if (flash != null) {
            request.setAttribute("error", flash);
            request.getSession().removeAttribute("flash");
        }

        int level = intParam(request, "level", 0);
        int status = intParam(request, "status", -1);
        request.setAttribute("level", level);
        request.setAttribute("status", status);
        request.setAttribute("goals", goalService.list(user.getId(), level, status));
        forward(request, response, "goal/list.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            redirect(request, response, "/login");
            return;
        }

        try {
            switch (param(request, "action")) {
                case "add" -> goalService.add(user.getId(), param(request, "title"),
                        param(request, "description"), intParam(request, "dimension", 1),
                        intParam(request, "level", 2), param(request, "period"));
                case "save" -> goalService.update(user.getId(), intParam(request, "id", 0),
                        param(request, "title"), param(request, "description"),
                        intParam(request, "dimension", 1), intParam(request, "level", 2),
                        param(request, "period"), intParam(request, "progress", 0));
                case "progress" -> goalService.changeProgress(user.getId(),
                        intParam(request, "id", 0), intParam(request, "delta", 0));
                case "delete" -> goalService.delete(user.getId(), intParam(request, "id", 0));
                default -> throw new ServiceException("不支持的操作");
            }
        } catch (ServiceException e) {
            request.getSession().setAttribute("flash", e.getMessage());
        } catch (RuntimeException e) {
            request.getSession().setAttribute("flash", "操作失败：" + e.getMessage());
        }
        redirect(request, response, "/goals");
    }

    /** 取整数参数，缺失或格式错误时返回默认值 */
    private int intParam(HttpServletRequest request, String name, int defaultValue) {
        try {
            return Integer.parseInt(param(request, name));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
