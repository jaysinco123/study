<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/20
  Time: 20:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Hello · 人生管理系统</title>
</head>
<body style="font-family: sans-serif; padding: 40px;">
    <h1>${message}</h1>
    <p>服务器时间：${now}</p>
    <p>Servlet → JSP 转发成功</p>
    <p><a href="${pageContext.request.contextPath}/">返回首页</a></p>
</body>
</html>