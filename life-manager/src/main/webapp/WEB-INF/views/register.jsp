<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/20
  Time: 23:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>注册 · 人生管理系统</title>
    <style>
        /* 把参考代码 register.jsp 的 <style> 整段复制到这里 */
    </style>
</head>
<body>
<div class="box">
    <h1>创建账号</h1>
    <p class="sub">注册后即可管理自己的每日任务</p>

    <c:if test="${not empty error}">
        <div class="err">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/register">
        <label for="username">账号</label>
        <input id="username" name="username" value="${username}" placeholder="3-20 位字母、数字或下划线" required>

        <label for="nickname">昵称</label>
        <input id="nickname" name="nickname" value="${nickname}" placeholder="不填则使用账号">

        <label for="password">密码</label>
        <input id="password" type="password" name="password" placeholder="6-20 位" required>

        <label for="confirm">确认密码</label>
        <input id="confirm" type="password" name="confirm" placeholder="再输入一次密码" required>

        <p class="hint">密码使用 BCrypt 加盐哈希存储，数据库中不保存明文。</p>
        <button type="submit">注 册</button>
    </form>

    <p class="link">已有账号？<a href="${pageContext.request.contextPath}/login">返回登录</a></p>
</div>
</body>
</html>
