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
    <title>我的任务 · 人生管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; background: #f2f5f9; color: #22303f; }
        .top { display: flex; align-items: center; justify-content: space-between; padding: 13px 28px; background: #1f2a44; color: #fff; }
        .top h1 { margin: 0; font-size: 17px; font-weight: 600; }
        .top .right { display: flex; align-items: center; gap: 16px; font-size: 13px; }
        .top a { color: #cfe0f5; text-decoration: none; }
        .top a:hover { color: #fff; }
        .tag { display: inline-block; margin-left: 8px; padding: 2px 8px; border-radius: 999px; background: rgba(47, 111, 176, .35); color: #dbe9f9; font-size: 12px; }
        .wrap { max-width: 1040px; margin: 24px auto 60px; padding: 0 20px; }
        .card { background: #fff; border-radius: 12px; padding: 20px 24px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); margin-bottom: 18px; }
        .card h2 { margin: 0 0 14px; font-size: 17px; }
        .count { margin-left: 8px; color: #8494a4; font-size: 13px; font-weight: normal; }
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 18px; }
        .stat { background: #fff; border-radius: 12px; padding: 16px 18px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); }
        .stat .label { color: #8494a4; font-size: 13px; }
        .stat .value { margin-top: 6px; font-size: 26px; font-weight: 600; color: #1f2a44; }
        .stat .value small { font-size: 13px; font-weight: normal; color: #8494a4; margin-left: 3px; }
        .stat.blue .value { color: #2f6fb0; }
        .stat.green .value { color: #1f7a3d; }
        .stat.orange .value { color: #b4661a; }
        .add { display: grid; grid-template-columns: 1.2fr 1.6fr 96px 150px auto; gap: 10px; }
        input, select { padding: 9px 11px; border: 1px solid #d3dce6; border-radius: 8px; font-size: 14px; outline: none; width: 100%; background: #fff; }
        input:focus, select:focus { border-color: #2f6fb0; box-shadow: 0 0 0 3px rgba(47, 111, 176, .12); }
        button { border: 0; border-radius: 8px; cursor: pointer; font-size: 13px; }
        .primary { padding: 0 22px; background: #2f6fb0; color: #fff; font-size: 14px; }
        .primary:hover { background: #265b93; }
        .bar { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 12px; flex-wrap: wrap; }
        .tabs { display: flex; gap: 8px; }
        .tab { padding: 7px 14px; border-radius: 8px; background: #eef2f6; color: #40505f; text-decoration: none; font-size: 13px; }
        .tab:hover { background: #e2e9f1; }
        .tab.on { background: #2f6fb0; color: #fff; }
        .filter { display: flex; gap: 8px; align-items: center; }
        .filter select { width: 130px; }
        .filter button { padding: 8px 14px; background: #eef2f6; color: #40505f; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { padding: 8px 10px; text-align: left; color: #8494a4; font-size: 12px; font-weight: normal; border-bottom: 1px solid #e6edf4; }
        td { padding: 10px; border-bottom: 1px solid #f0f4f8; vertical-align: middle; }
        tr.done { background: #fafcfe; }
        tr.done .title-input { color: #9aa8b6; text-decoration: line-through; }
        .edit { display: grid; grid-template-columns: 130px 1.3fr 60px 130px auto; gap: 8px; align-items: center; }
        .mini { padding: 7px 12px; background: #eef2f6; color: #40505f; white-space: nowrap; }
        .mini:hover { background: #e2e9f1; }
        .mini.ok { background: #e6f6ec; color: #1f7a3d; }
        .mini.danger { background: #fdecec; color: #b4322b; }
        .prio { display: inline-block; padding: 3px 9px; border-radius: 999px; font-size: 12px; white-space: nowrap; }
        .prio.p1 { background: #fdecec; color: #b4322b; }
        .prio.p2 { background: #fff3e0; color: #b4661a; }
        .prio.p3 { background: #eef2f6; color: #5b6b7b; }
        .due { color: #5b6b7b; font-size: 12px; white-space: nowrap; }
        .due.late { color: #b4322b; font-weight: 600; }
        .time { color: #8494a4; font-size: 12px; white-space: nowrap; }
        .inline { display: inline; margin: 0; }
        .err { margin-top: 12px; padding: 9px 12px; background: #fdecec; color: #b4322b; border-radius: 6px; font-size: 13px; }
        .empty { margin: 10px 0 4px; color: #8494a4; font-size: 14px; }
        .next { margin-top: 18px; padding: 14px 16px; border-left: 3px solid #2f6fb0; background: #f5f9fd; font-size: 13px; color: #4a5a69; }
    </style>
</head>
<body>

<div class="top">
    <h1>人生管理系统</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}<span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span></span>
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
    <!-- 统计卡片：由 TaskServlet 查询后放入 request -->
    <div class="stats">
        <div class="stat blue">
            <div class="label">全部任务</div>
            <div class="value">${total}<small>条</small></div>
        </div>
        <div class="stat green">
            <div class="label">已完成</div>
            <div class="value">${doneCount}<small>条</small></div>
        </div>
        <div class="stat orange">
            <div class="label">待办</div>
            <div class="value">${todoCount}<small>条</small></div>
        </div>
        <div class="stat">
            <div class="label">完成率</div>
            <div class="value">${rate}<small>%</small></div>
        </div>
    </div>

    <div class="card">
        <h2>新增任务</h2>
        <form class="add" method="post" action="${ctx}/tasks">
            <input type="hidden" name="action" value="add">
            <input name="title" maxlength="100" placeholder="今天要完成什么？" required>
            <input name="content" maxlength="500" placeholder="补充说明（可选）">
            <select name="priority" title="优先级">
                <option value="1">高优先级</option>
                <option value="2" selected>中优先级</option>
                <option value="3">低优先级</option>
            </select>
            <input type="date" name="dueDate" title="截止日期">
            <button class="primary" type="submit">添加</button>
        </form>
        <c:if test="${not empty error}">
            <div class="err">${error}</div>
        </c:if>
    </div>

    <div class="card">
        <div class="bar">
            <h2 style="margin:0">我的任务<span class="count">筛选后 ${tasks.size()} 条</span></h2>
            <div class="tabs">
                <a class="tab ${filter eq 'all' ? 'on' : ''}" href="${ctx}/tasks?filter=all&priority=${priority}">全部</a>
                <a class="tab ${filter eq 'todo' ? 'on' : ''}" href="${ctx}/tasks?filter=todo&priority=${priority}">未完成</a>
                <a class="tab ${filter eq 'done' ? 'on' : ''}" href="${ctx}/tasks?filter=done&priority=${priority}">已完成</a>
            </div>
            <form class="filter" method="get" action="${ctx}/tasks">
                <input type="hidden" name="filter" value="${filter}">
                <select name="priority">
                    <option value="0" ${priority == 0 ? 'selected' : ''}>全部优先级</option>
                    <option value="1" ${priority == 1 ? 'selected' : ''}>高</option>
                    <option value="2" ${priority == 2 ? 'selected' : ''}>中</option>
                    <option value="3" ${priority == 3 ? 'selected' : ''}>低</option>
                </select>
                <button type="submit">筛选</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty tasks}">
                <p class="empty">没有符合条件的任务。</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th style="width:88px">状态</th>
                        <th>任务内容（可直接修改后保存）</th>
                        <th style="width:96px">截止日期</th>
                        <th style="width:126px">创建时间</th>
                        <th style="width:64px">删除</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="t" items="${tasks}">
                        <tr class="${t.doneFlag ? 'done' : ''}">
                            <td>
                                <form class="inline" method="post" action="${ctx}/tasks">
                                    <input type="hidden" name="action" value="toggle">
                                    <input type="hidden" name="id" value="${t.id}">
                                    <input type="hidden" name="done" value="${t.doneFlag ? 0 : 1}">
                                    <button class="mini ${t.doneFlag ? 'ok' : ''}" type="submit">${t.doneFlag ? '已完成' : '未完成'}</button>
                                </form>
                            </td>
                            <td>
                                <form class="edit" method="post" action="${ctx}/tasks">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="${t.id}">
                                    <input class="title-input" name="title" value="${fn:escapeXml(t.title)}" maxlength="100" required>
                                    <input name="content" value="${fn:escapeXml(t.content)}" maxlength="500" placeholder="描述">
                                    <select name="priority" title="优先级">
                                        <option value="1" ${t.priority == 1 ? 'selected' : ''}>高</option>
                                        <option value="2" ${t.priority == 2 ? 'selected' : ''}>中</option>
                                        <option value="3" ${t.priority == 3 ? 'selected' : ''}>低</option>
                                    </select>
                                    <input type="date" name="dueDate" value="${t.dueDate}" title="截止日期">
                                    <button class="mini" type="submit">保存</button>
                                </form>
                            </td>
                            <td class="due ${t.overdue ? 'late' : ''}">
                                <c:choose>
                                    <c:when test="${empty t.dueDate}">—</c:when>
                                    <c:otherwise>${t.dueDate}${t.overdue ? '（逾期）' : ''}</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="time">${t.createTime}</td>
                            <td>
                                <form class="inline" method="post" action="${ctx}/tasks"
                                      onsubmit="return confirm('确定删除这条任务吗？');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${t.id}">
                                    <button class="mini danger" type="submit">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        <div class="next">
            做难事必有所得
        </div>
    </div>
</div>

</body>
</html>
