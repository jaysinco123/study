package com.life.servlet;

import com.life.bean.User;
import com.life.service.ServiceException;
import com.life.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 管理员用户管理：查看全部用户、启用/禁用账号。
 * 权限由 AdminFilter 保证（普通用户请求在这里之前就被 403 拦掉）。
 */
@WebServlet("/admin/users")
public class AdminUserServlet extends BaseServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User me = currentUser(request);
        if (me == null) {
            redirect(request, response, "/login");
            return;
        }

        HttpSession session = request.getSession();
        Object flash = session.getAttribute("flash");
        if (flash != null) {
            request.setAttribute("error", flash);
            session.removeAttribute("flash");
        }
        request.setAttribute("users", userService.listAll());
        forward(request, response, "admin/users.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User me = currentUser(request);
        if (me == null) {
            redirect(request, response, "/login");
            return;
        }

        try {
            int id = Integer.parseInt(param(request, "id"));
            int status = Integer.parseInt(param(request, "status"));
            userService.changeStatus(me.getId(), id, status);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("flash", "参数不合法");
        } catch (ServiceException e) {
            request.getSession().setAttribute("flash", e.getMessage());
        }
        redirect(request, response, "/admin/users");
    }
}
