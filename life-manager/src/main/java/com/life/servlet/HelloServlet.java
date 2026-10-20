package com.life.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;

/**
 * 第一个 Servlet：验证 Tomcat、注解映射、JSP 转发是否正常。
 */
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. 准备数据（Model）
        request.setAttribute("now", LocalDateTime.now().toString());
        request.setAttribute("message", "Hello, JavaWeb!");

        // 2. 转发到 /WEB-INF/views/hello.jsp（View）
        //    WEB-INF 下的 JSP 不能被浏览器直接访问，只能由 Servlet 转发
        request.getRequestDispatcher("/WEB-INF/views/hello.jsp")
                .forward(request, response);
    }
}