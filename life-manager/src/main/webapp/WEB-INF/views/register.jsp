<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>注册 · 人生管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh; display: flex; align-items: center; justify-content: center;
            font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
            background: linear-gradient(135deg, #1f2a44, #2f4a6d); color: #22303f; padding: 24px 0;
        }
        .box { width: 390px; padding: 34px 38px; background: #fff; border-radius: 14px; box-shadow: 0 18px 48px rgba(0, 0, 0, .28); }
        h1 { margin: 0 0 6px; font-size: 22px; }
        .sub { margin: 0 0 18px; color: #8494a4; font-size: 12px; letter-spacing: 2px; }
        label { display: block; margin: 12px 0 6px; font-size: 13px; color: #55657a; }
        input { width: 100%; padding: 10px 12px; border: 1px solid #d3dce6; border-radius: 8px; font-size: 14px; outline: none; }
        input:focus { border-color: #2f6fb0; box-shadow: 0 0 0 3px rgba(47, 111, 176, .12); }
        button { width: 100%; margin-top: 20px; padding: 11px; border: 0; border-radius: 8px; background: #2f6fb0; color: #fff; font-size: 15px; cursor: pointer; }
        button:hover { background: #265b93; }
        .err { margin-top: 12px; padding: 9px 12px; background: #fdecec; color: #b4322b; border-radius: 6px; font-size: 13px; }
        .hint { margin: 6px 0 0; font-size: 12px; color: #9aa8b6; }
        .link { margin-top: 18px; text-align: center; font-size: 13px; color: #7b8a9a; }
        a { color: #2f6fb0; text-decoration: none; }
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
