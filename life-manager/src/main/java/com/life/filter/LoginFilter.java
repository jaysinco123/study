package com.life.filter;

import com.life.bean.User;
import com.life.servlet.BaseServlet;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 * 登录拦截：除白名单外，所有请求都要求 Session 中有登录用户。
 * 未登录 -> 302 到 /login（游客只能看到登录、注册页）。
 */
@WebFilter(filterName = "loginFilter", urlPatterns = "/*")
public class LoginFilter implements Filter {

    /** 不需要登录就能访问的路径 */
    private static final Set<String> WHITE_LIST = Set.of(
            "/", "/index.jsp", "/login", "/register", "/favicon.ico");

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (path.isEmpty()) {
            path = "/";
        }
        if (WHITE_LIST.contains(path) || path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute(BaseServlet.SESSION_USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        chain.doFilter(request, response);
    }
}
