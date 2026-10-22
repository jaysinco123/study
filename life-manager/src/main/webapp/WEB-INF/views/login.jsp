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
           * { box-sizing: border-box; }
                  body {
                      margin: 0; min-height: 100vh; display: flex; align-items: center; justify-content: center;
                      font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
                      background: linear-gradient(135deg, #1f2a44, #2f4a6d); color: #22303f;
                  }
                  .box { width: 390px; padding: 36px 38px; background: #fff; border-radius: 14px; box-shadow: 0 18px 48px rgba(0, 0, 0, .28); }
                  h1 { margin: 0 0 6px; font-size: 44px; text-align: center; }
                    .sub { margin: 0 0 20px; color: #8494a4; font-size: 15px; letter-spacing: 2px; text-align: center; }
                  label { display: block; margin: 14px 0 6px; font-size: 13px; color: #55657a; }
                  input { width: 100%; padding: 10px 12px; border: 1px solid #d3dce6; border-radius: 8px; font-size: 14px; outline: none; }
                  input:focus { border-color: #2f6fb0; box-shadow: 0 0 0 3px rgba(47, 111, 176, .12); }
                  button { width: 100%; margin-top: 22px; padding: 11px; border: 0; border-radius: 8px; background: #2f6fb0; color: #fff; font-size: 15px; cursor: pointer; }
                  button:hover { background: #265b93; }
                  .err { margin-top: 14px; padding: 9px 12px; background: #fdecec; color: #b4322b; border-radius: 6px; font-size: 13px; }
                  .ok { margin-top: 14px; padding: 9px 12px; background: #eaf7ee; color: #1f7a3d; border-radius: 6px; font-size: 13px; }
                  .link { margin-top: 18px; text-align: center; font-size: 13px; color: #7b8a9a; }
                  a { color: #2f6fb0; text-decoration: none; }
     </style>
</head>
<body>
<div class="box">
    <h1>人生管理系统</h1>
    <p class="sub">像建设国家一样建设自己-治己如治国</p>

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
