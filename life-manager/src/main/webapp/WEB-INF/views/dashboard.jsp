<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/20
  Time: 23:35
  To change this template use File | Settings | File Templates.
--%>
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
        /* 从参考代码 dashboard.jsp 复制 <style> 整段到这里 */
    </style>
</head>
<body>

<div class="top">
    <h1>人生管理系统</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}
            <span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span>
        </span>
        <c:if test="${sessionScope.user.admin}">
            <a href="${ctx}/admin/users">用户管理</a>
        </c:if>
        <a href="${ctx}/logout">退出</a>
    </div>
</div>

<div class="wrap">
    <!-- 统计卡片：数据来自 TaskServlet 的 request.setAttribute -->
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
            <h2 style="margin:0">我的任务
                <span class="count">筛选后 ${tasks.size()} 条</span>
            </h2>
            <div class="tabs">
                <a class="tab ${filter eq 'all' ? 'on' : ''}"
                   href="${ctx}/tasks?filter=all&priority=${priority}">全部</a>
                <a class="tab ${filter eq 'todo' ? 'on' : ''}"
                   href="${ctx}/tasks?filter=todo&priority=${priority}">未完成</a>
                <a class="tab ${filter eq 'done' ? 'on' : ''}"
                   href="${ctx}/tasks?filter=done&priority=${priority}">已完成</a>
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
                <p class="empty">还没有任务，先在上面的表单添加一条。</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th style="width:88px">状态</th>
                        <th>任务内容（可直接修改后保存）</th>
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
                                    <button class="mini ${t.doneFlag ? 'ok' : ''}" type="submit">
                                        ${t.doneFlag ? '已完成' : '未完成'}
                                    </button>
                                </form>
                            </td>
                            <td>
                                <form class="edit" method="post" action="${ctx}/tasks">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="${t.id}">
                                    <input class="title-input" name="title"
                                           value="${fn:escapeXml(t.title)}" maxlength="100" required>
                                    <input name="content"
                                           value="${fn:escapeXml(t.content)}" maxlength="500" placeholder="描述">
                                    <select name="priority" title="优先级">
                                        <option value="1" ${t.priority == 1 ? 'selected' : ''}>高</option>
                                        <option value="2" ${t.priority == 2 ? 'selected' : ''}>中</option>
                                        <option value="3" ${t.priority == 3 ? 'selected' : ''}>低</option>
                                    </select>
                                    <input type="date" name="dueDate" value="${t.dueDate}" title="截止日期">
                                    <button class="mini" type="submit">保存</button>
                                </form>
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
            当前为 <strong>v3 任务 CRUD</strong>：新增、查询、修改、删除、完成状态都已跑通。
            下一版加入登录拦截与管理员后台。
        </div>
    </div>
</div>

</body>
</html>