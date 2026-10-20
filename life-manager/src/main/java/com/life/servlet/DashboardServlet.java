package com.life.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 主页控制器：/dashboard 不直接暴露 JSP，
 * 必须先经过这里判断登录状态，再转发到 /WEB-INF/views/dashboard.jsp。
 */
@WebServlet("/dashboard")
public class DashboardServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (currentUser(request) == null) {
            redirect(request, response, "/login");
            return;
        }
        forward(request, response, "dashboard.jsp");
    }
}