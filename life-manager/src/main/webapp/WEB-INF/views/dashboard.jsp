<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/20
  Time: 23:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login"/>
</c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的主页 · 人生管理系统</title>
    <style>
        /* 把参考代码 v2 的 dashboard.jsp 样式复制到这里，或先不写样式 */
    </style>
</head>
<body>
<div class="top">
    <h1>人生管理系统</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}
            <span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span>
        </span>
        <a href="${pageContext.request.contextPath}/logout">退出登录</a>
    </div>
</div>

<div class="wrap">
    <div class="card">
        <h2>你好，${sessionScope.user.nickname}</h2>
        <p>登录状态已保存在 Session 中，当前账号：${sessionScope.user.username}</p>
        <p>当前为 v2：注册、登录、退出已跑通。下一版加入任务 CRUD。</p>
    </div>
</div>
</body>
</html>
