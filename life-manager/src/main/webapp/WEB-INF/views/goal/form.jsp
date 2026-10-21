<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login"/>
</c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="editing" value="${not empty goal}"/>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${editing ? '编辑目标' : '新增目标'} · 人生管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; background: #f2f5f9; color: #22303f; }
        .top { display: flex; align-items: center; justify-content: space-between; padding: 13px 28px; background: #1f2a44; color: #fff; }
        .top h1 { margin: 0; font-size: 17px; font-weight: 600; }
        .top .right { display: flex; align-items: center; gap: 16px; font-size: 13px; }
        .top a { color: #cfe0f5; text-decoration: none; }
        .top a:hover { color: #fff; }
        .tag { display: inline-block; margin-left: 8px; padding: 2px 8px; border-radius: 999px; background: rgba(47, 111, 176, .35); color: #dbe9f9; font-size: 12px; }
        .wrap { max-width: 720px; margin: 26px auto 60px; padding: 0 20px; }
        .card { background: #fff; border-radius: 12px; padding: 22px 24px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); }
        .card h2 { margin: 0 0 18px; font-size: 18px; }
        .row { display: grid; grid-template-columns: 110px 1fr; align-items: start; gap: 12px; margin-bottom: 15px; }
        .row > label { padding-top: 10px; color: #5b6b7b; font-size: 14px; }
        input, select, textarea { padding: 10px 12px; border: 1px solid #d3dce6; border-radius: 8px; font-size: 14px; outline: none; width: 100%; font-family: inherit; }
        input:focus, select:focus, textarea:focus { border-color: #2f6fb0; box-shadow: 0 0 0 3px rgba(47, 111, 176, .12); }
        textarea { min-height: 90px; resize: vertical; }
        .ops { display: flex; gap: 10px; align-items: center; }
        button { border: 0; border-radius: 8px; cursor: pointer; padding: 10px 22px; background: #2f6fb0; color: #fff; font-size: 14px; }
        button:hover { background: #265b93; }
        .cancel { padding: 10px 20px; border-radius: 8px; background: #eef2f6; color: #40505f; text-decoration: none; font-size: 14px; }
        .hint { color: #8494a4; font-size: 12px; margin-top: 6px; }
    </style>
</head>
<body>

<div class="top">
    <h1>人生管理系统</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}<span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span></span>
        <a href="${ctx}/tasks">我的任务</a>
        <a href="${ctx}/goals">长期目标</a>
        <a href="${ctx}/profile">个人中心</a>
        <a href="${ctx}/logout">退出</a>
    </div>
</div>

<div class="wrap">
    <div class="card">
        <h2>${editing ? '编辑目标' : '新增目标'}</h2>
        <form method="post" action="${ctx}/goals">
            <input type="hidden" name="action" value="${editing ? 'save' : 'add'}">
            <c:if test="${editing}">
                <input type="hidden" name="id" value="${goal.id}">
            </c:if>
            <div class="row">
                <label>目标标题</label>
                <input name="title" maxlength="100" required
                       value="${fn:escapeXml(editing ? goal.title : '')}" placeholder="例如：2026 年攒下 6 个月生活费">
            </div>
            <div class="row">
                <label>目标说明</label>
                <textarea name="description" maxlength="500" placeholder="为什么定这个目标？打算怎么做？">${editing ? fn:escapeXml(goal.description) : ''}</textarea>
            </div>
            <div class="row">
                <label>五位一体维度</label>
                <select name="dimension">
                    <option value="1" ${editing && goal.dimension == 1 ? 'selected' : ''}>经济建设</option>
                    <option value="2" ${editing && goal.dimension == 2 ? 'selected' : ''}>政治建设</option>
                    <option value="3" ${editing && goal.dimension == 3 ? 'selected' : ''}>文化建设</option>
                    <option value="4" ${editing && goal.dimension == 4 ? 'selected' : ''}>社会建设</option>
                    <option value="5" ${editing && goal.dimension == 5 ? 'selected' : ''}>生态文明</option>
                </select>
            </div>
            <div class="row">
                <label>目标层级</label>
                <select name="level">
                    <option value="1" ${editing && goal.level == 1 ? 'selected' : ''}>五年规划</option>
                    <option value="2" ${not editing || goal.level == 2 ? 'selected' : ''}>年度 OKR</option>
                    <option value="3" ${editing && goal.level == 3 ? 'selected' : ''}>季度里程碑</option>
                </select>
            </div>
            <div class="row">
                <label>周期</label>
                <input name="period" maxlength="30" value="${editing ? fn:escapeXml(goal.period) : ''}" placeholder="例如：2026 或 2026Q4">
            </div>
            <c:if test="${editing}">
                <div class="row">
                    <label>当前进度</label>
                    <div>
                        <input type="number" name="progress" min="0" max="100" value="${goal.progress}">
                        <div class="hint">0-100；填 100 会自动标记为已完成</div>
                    </div>
                </div>
            </c:if>
            <div class="row">
                <label></label>
                <div class="ops">
                    <button type="submit">${editing ? '保存修改' : '创建目标'}</button>
                    <a class="cancel" href="${ctx}/goals">取消</a>
                </div>
            </div>
        </form>
    </div>
</div>

</body>
</html>
