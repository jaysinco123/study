<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/20
  Time: 23:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 · 人生管理系统</title>
    <style>
        /* 把参考代码 login.jsp 的 <style> 整段复制到这里 */
    </style>
</head>
<body>
<div class="box">
    <h1>人生管理系统</h1>
    <p class="sub">LIKE BUILDING A COUNTRY, BUILD YOURSELF</p>

    <c:if test="${param.registered eq '1'}">
        <div class="ok">注册成功，请使用新账号登录</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="err">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <label for="username">账号</label>
        <input id="username" name="username" value="${username}" placeholder="请输入账号" required>

        <label for="password">密码</label>
        <input id="password" type="password" name="password" placeholder="请输入密码" required>

        <button type="submit">登 录</button>
    </form>

    <p class="link">还没有账号？<a href="${pageContext.request.contextPath}/register">立即注册</a></p>
</div>
</body>
</html>
