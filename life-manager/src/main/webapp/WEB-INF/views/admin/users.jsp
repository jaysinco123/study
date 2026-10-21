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
        /* 从参考代码 admin/users.jsp 复制 <style> 整段到这里 */
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
