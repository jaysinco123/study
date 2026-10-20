package com.life.servlet;

import com.life.bean.User;
import com.life.service.ServiceException;
import com.life.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 登录控制器：GET 显示登录页，POST 校验后把 User 放进 Session。
 */
@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (currentUser(request) != null) {
            redirect(request, response, "/dashboard");
            return;
        }
        forward(request, response, "login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = param(request, "username");
        String password = request.getParameter("password");

        try {
            User user = userService.login(username, password);
            // 登录状态保存在 Session 中，后续请求由 LoginFilter 从这里取
            request.getSession().setAttribute(SESSION_USER, user);
            redirect(request, response, "/dashboard");
        } catch (ServiceException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", username);
            forward(request, response, "login.jsp");
        }
    }
}