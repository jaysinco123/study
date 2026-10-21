<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login"/>
</c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>个人中心 · 人生管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; background: #f2f5f9; color: #22303f; }
        .top { display: flex; align-items: center; justify-content: space-between; padding: 13px 28px; background: #1f2a44; color: #fff; }
        .top h1 { margin: 0; font-size: 17px; font-weight: 600; }
        .top .right { display: flex; align-items: center; gap: 16px; font-size: 13px; }
        .top a { color: #cfe0f5; text-decoration: none; }
        .top a:hover { color: #fff; }
        .tag { display: inline-block; margin-left: 8px; padding: 2px 8px; border-radius: 999px; background: rgba(47, 111, 176, .35); color: #dbe9f9; font-size: 12px; }
        .wrap { max-width: 760px; margin: 26px auto 60px; padding: 0 20px; }
        .card { background: #fff; border-radius: 12px; padding: 22px 24px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); margin-bottom: 18px; }
        .card h2 { margin: 0 0 6px; font-size: 17px; }
        .hint { margin: 0 0 16px; color: #8494a4; font-size: 13px; }
        .row { display: grid; grid-template-columns: 120px 1fr; align-items: center; gap: 12px; margin-bottom: 14px; }
        .row label { color: #5b6b7b; font-size: 14px; }
        input { padding: 10px 12px; border: 1px solid #d3dce6; border-radius: 8px; font-size: 14px; outline: none; width: 100%; }
        input:focus { border-color: #2f6fb0; box-shadow: 0 0 0 3px rgba(47, 111, 176, .12); }
        input[readonly] { background: #f4f7fa; color: #8494a4; }
        button { border: 0; border-radius: 8px; cursor: pointer; padding: 10px 22px; background: #2f6fb0; color: #fff; font-size: 14px; }
        button:hover { background: #265b93; }
        .ok { margin-bottom: 16px; padding: 10px 14px; background: #e6f6ec; color: #1f7a3d; border-radius: 8px; font-size: 13px; }
        .err { margin-bottom: 16px; padding: 10px 14px; background: #fdecec; color: #b4322b; border-radius: 8px; font-size: 13px; }
        .foot { margin-top: 8px; font-size: 13px; }
        .foot a { color: #2f6fb0; text-decoration: none; }
        .foot a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="top">
    <h1>人生管理系统</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}<span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span></span>
        <a href="${ctx}/tasks">我的任务</a>
        <a href="${ctx}/goals">长期目标</a>
        <a href="${ctx}/bills">记账本</a>
        <c:if test="${sessionScope.user.admin}">
            <a href="${ctx}/admin/users">用户管理</a>
        </c:if>
        <a href="${ctx}/profile">个人中心</a>
        <a href="${ctx}/logout">退出</a>
    </div>
</div>

<div class="wrap">
    <c:if test="${not empty ok}">
        <div class="ok">${ok}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="err">${error}</div>
    </c:if>

    <div class="card">
        <h2>基本资料</h2>
        <p class="hint">账号用于登录，不可修改；昵称会显示在页面右上角。</p>
        <form method="post" action="${ctx}/profile">
            <input type="hidden" name="action" value="info">
            <div class="row">
                <label>登录账号</label>
                <input value="${fn:escapeXml(sessionScope.user.username)}" readonly>
            </div>
            <div class="row">
                <label>昵称</label>
                <input name="nickname" maxlength="30" required
                       value="${fn:escapeXml(empty formNickname ? sessionScope.user.nickname : formNickname)}">
            </div>
            <div class="row">
                <label>邮箱</label>
                <input type="email" name="email" maxlength="80" placeholder="选填，例如 you@example.com"
                       value="${fn:escapeXml(empty formEmail ? sessionScope.user.email : formEmail)}">
            </div>
            <div class="row">
                <label></label>
                <div><button type="submit">保存资料</button></div>
            </div>
        </form>
    </div>

    <div class="card">
        <h2>修改密码</h2>
        <p class="hint">需要先输入原密码；新密码 6-20 位，提交后立即生效。</p>
        <form method="post" action="${ctx}/profile">
            <input type="hidden" name="action" value="password">
            <div class="row">
                <label>原密码</label>
                <input type="password" name="oldPassword" maxlength="20" required>
            </div>
            <div class="row">
                <label>新密码</label>
                <input type="password" name="newPassword" maxlength="20" minlength="6" required>
            </div>
            <div class="row">
                <label>确认新密码</label>
                <input type="password" name="confirm" maxlength="20" minlength="6" required>
            </div>
            <div class="row">
                <label></label>
                <div><button type="submit">修改密码</button></div>
            </div>
        </form>
    </div>

    <p class="foot"><a href="${ctx}/tasks">← 返回任务列表</a></p>
</div>

</body>
</html>
