package com.life.servlet;

import com.life.service.ServiceException;
import com.life.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 注册控制器：GET 显示注册页，POST 注册成功后跳登录页。
 */
@WebServlet("/register")
public class RegisterServlet extends BaseServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forward(request, response, "register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = param(request, "username");
        String nickname = param(request, "nickname");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        try {
            userService.register(username, password, confirm, nickname);
            redirect(request, response, "/login?registered=1");
        } catch (ServiceException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("nickname", nickname);
            forward(request, response, "register.jsp");
        }
    }
}