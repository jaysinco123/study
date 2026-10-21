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
 * 个人中心：修改昵称/邮箱、修改密码。
 * GET  /profile                 显示资料页
 * POST /profile action=info     保存基本资料
 * POST /profile action=password 修改密码
 */
@WebServlet("/profile")
public class ProfileServlet extends BaseServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (currentUser(request) == null) {
            redirect(request, response, "/login");
            return;
        }
        String ok = param(request, "ok");
        if ("info".equals(ok)) {
            request.setAttribute("ok", "个人资料已保存");
        } else if ("password".equals(ok)) {
            request.setAttribute("ok", "密码修改成功，下次登录请使用新密码");
        }
        forward(request, response, "profile.jsp");
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
                case "info" -> {
                    User updated = userService.updateProfile(user.getId(),
                            param(request, "nickname"), param(request, "email"));
                    // 刷新 Session，页面右上角昵称立即变化
                    request.getSession().setAttribute(SESSION_USER, updated);
                    redirect(request, response, "/profile?ok=info");
                }
                case "password" -> {
                    userService.changePassword(user.getId(), param(request, "oldPassword"),
                            param(request, "newPassword"), param(request, "confirm"));
                    redirect(request, response, "/profile?ok=password");
                }
                default -> throw new ServiceException("不支持的操作");
            }
        } catch (ServiceException e) {
            request.setAttribute("error", e.getMessage());
            // 保存失败时回显已填写的内容
            request.setAttribute("formNickname", param(request, "nickname"));
            request.setAttribute("formEmail", param(request, "email"));
            forward(request, response, "profile.jsp");
        }
    }
}