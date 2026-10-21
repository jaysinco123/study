<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/21
  Time: 17:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login"/>
</c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户管理 · 人生管理系统</title>
    <style>
            * { box-sizing: border-box; }
            body { margin: 0; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; background: #f2f5f9; color: #22303f; }
            .top { display: flex; align-items: center; justify-content: space-between; padding: 13px 28px; background: #1f2a44; color: #fff; }
            .top h1 { margin: 0; font-size: 17px; font-weight: 600; }
            .top .right { display: flex; align-items: center; gap: 16px; font-size: 13px; }
            .top a { color: #cfe0f5; text-decoration: none; }
            .top a:hover { color: #fff; }
            .tag { display: inline-block; margin-left: 8px; padding: 2px 8px; border-radius: 999px; background: rgba(47, 111, 176, .35); color: #dbe9f9; font-size: 12px; }
            .wrap { max-width: 900px; margin: 26px auto 60px; padding: 0 20px; }
            .card { background: #fff; border-radius: 12px; padding: 22px 24px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); }
            .card h2 { margin: 0 0 6px; font-size: 17px; }
            .muted { color: #8494a4; font-size: 13px; margin: 0 0 16px; }
            table { width: 100%; border-collapse: collapse; font-size: 14px; }
            th { padding: 8px 10px; text-align: left; color: #8494a4; font-size: 12px; font-weight: normal; border-bottom: 1px solid #e6edf4; }
            td { padding: 10px; border-bottom: 1px solid #f0f4f8; }
            .badge { display: inline-block; padding: 2px 9px; border-radius: 999px; font-size: 12px; }
            .on { background: #e6f6ec; color: #1f7a3d; }
            .off { background: #fdecec; color: #b4322b; }
            .role { background: #eef2f6; color: #40505f; }
            .role.admin { background: #e8f1fb; color: #2f6fb0; }
            button { border: 0; border-radius: 8px; cursor: pointer; font-size: 13px; padding: 6px 12px; }
            .danger { background: #fdecec; color: #b4322b; }
            .ok { background: #e6f6ec; color: #1f7a3d; }
            .err { margin-bottom: 14px; padding: 9px 12px; background: #fdecec; color: #b4322b; border-radius: 6px; font-size: 13px; }
            .self { color: #8494a4; font-size: 12px; }
            .back { margin-top: 16px; font-size: 13px; }
            a { color: #2f6fb0; text-decoration: none; }
        </style>
</head>
<body>
<div class="top">
    <h1>人生管理系统 · 后台</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}<span class="tag">管理员</span></span>
        <a href="${ctx}/tasks">我的任务</a>
        <a href="${ctx}/logout">退出登录</a>
    </div>
</div>

<div class="wrap">
    <div class="card">
        <h2>用户管理</h2>
        <p class="muted">禁用后该用户将无法登录。</p>

        <c:if test="${not empty error}">
            <div class="err">${error}</div>
        </c:if>

        <table>
            <thead>
            <tr>
                <th style="width:60px">ID</th>
                <th>账号</th>
                <th>昵称</th>
                <th style="width:90px">角色</th>
                <th style="width:90px">状态</th>
                <th style="width:100px">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.nickname}</td>
                    <td>
                        <span class="badge role ${u.admin ? 'admin' : ''}">
                            ${u.admin ? '管理员' : '普通用户'}
                        </span>
                    </td>
                    <td>
                        <span class="badge ${u.status == 1 ? 'on' : 'off'}">
                            ${u.status == 1 ? '正常' : '已禁用'}
                        </span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${u.id == sessionScope.user.id}">
                                <span class="self">当前账号</span>
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="${ctx}/admin/users" class="inline">
                                    <input type="hidden" name="id" value="${u.id}">
                                    <input type="hidden" name="status" value="${u.status == 1 ? 0 : 1}">
                                    <button class="${u.status == 1 ? 'danger' : 'ok'}" type="submit">
                                        ${u.status == 1 ? '禁用' : '启用'}
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <p class="back"><a href="${ctx}/tasks">← 返回我的任务</a></p>
    </div>
</div>
</body>
</html>
