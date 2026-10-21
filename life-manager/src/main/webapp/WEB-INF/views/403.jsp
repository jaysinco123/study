<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>403 · 没有访问权限</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh; display: flex; align-items: center; justify-content: center;
            font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
            background: linear-gradient(135deg, #1f2a44, #2f4a6d); color: #22303f;
        }
        .box { width: 420px; padding: 40px; background: #fff; border-radius: 14px; text-align: center; box-shadow: 0 18px 48px rgba(0, 0, 0, .28); }
        .code { font-size: 56px; font-weight: 700; color: #b4322b; line-height: 1; }
        h1 { margin: 14px 0 8px; font-size: 20px; }
        p { margin: 0 0 24px; color: #7b8a9a; font-size: 14px; }
        a { display: inline-block; padding: 10px 22px; border-radius: 8px; background: #2f6fb0; color: #fff; font-size: 14px; text-decoration: none; }
        a:hover { background: #265b93; }
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
