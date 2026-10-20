package com.life.servlet;

import com.life.bean.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet 基类：把"取当前登录用户、转发视图、重定向、取参数"这些重复动作集中起来。
 * 只做请求控制，不写业务逻辑。
 */
public abstract class BaseServlet extends HttpServlet {

    /** Session 中保存登录用户的 key，Filter 与 JSP 共用 */
    public static final String SESSION_USER = "user";

    protected User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute(SESSION_USER);
    }

    /** 转发到 /WEB-INF/views/ 下的 JSP（WEB-INF 下的页面不能被浏览器直接访问） */
    protected void forward(HttpServletRequest request, HttpServletResponse response, String view)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/" + view).forward(request, response);
    }

    protected void redirect(HttpServletRequest request, HttpServletResponse response, String path)
            throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }

    /** 取参数并去掉首尾空格，null 转成空串，省掉大量判空 */
    protected String param(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }
}