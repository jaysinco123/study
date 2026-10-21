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

/**
 * 管理员拦截：/admin/* 只有 role=1 能进，
 * 普通用户返回 403，由 web.xml 的 error-page 跳转到友好提示页。
 */
@WebFilter(filterName = "adminFilter", urlPatterns = "/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute(BaseServlet.SESSION_USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        chain.doFilter(request, response);
    }
}