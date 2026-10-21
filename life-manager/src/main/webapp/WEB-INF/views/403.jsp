<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/21
  Time: 16:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>403 · 没有访问权限</title>
    <style>
        /* 从参考代码 403.jsp 复制 <style> 整段到这里 */
    </style>
</head>
<body>
<div class="box">
    <div class="code">403</div>
    <h1>没有访问权限</h1>
    <p>该页面只允许管理员访问，请使用管理员账号登录。</p>
    <a href="${pageContext.request.contextPath}/tasks">返回我的任务</a>
</div>
</body>
</html>