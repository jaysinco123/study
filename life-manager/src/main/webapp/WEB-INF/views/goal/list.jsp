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
    <title>长期目标 · 人生管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; background: #f2f5f9; color: #22303f; }
        .top { display: flex; align-items: center; justify-content: space-between; padding: 13px 28px; background: #1f2a44; color: #fff; }
        .top h1 { margin: 0; font-size: 17px; font-weight: 600; }
        .top .right { display: flex; align-items: center; gap: 16px; font-size: 13px; }
        .top a { color: #cfe0f5; text-decoration: none; }
        .top a:hover, .top a.on { color: #fff; }
        .tag { display: inline-block; margin-left: 8px; padding: 2px 8px; border-radius: 999px; background: rgba(47, 111, 176, .35); color: #dbe9f9; font-size: 12px; }
        .wrap { max-width: 960px; margin: 24px auto 60px; padding: 0 20px; }
        .bar { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
        .bar h2 { margin: 0; font-size: 19px; }
        .bar .count { margin-left: 8px; color: #8494a4; font-size: 13px; font-weight: normal; }
        .filters { display: flex; gap: 8px; }
        select { padding: 9px 11px; border: 1px solid #d3dce6; border-radius: 8px; font-size: 14px; outline: none; background: #fff; }
        .btn { display: inline-block; padding: 10px 20px; border-radius: 8px; background: #2f6fb0; color: #fff; text-decoration: none; font-size: 14px; border: 0; cursor: pointer; }
        .btn:hover { background: #265b93; }
        .err { margin-bottom: 14px; padding: 10px 14px; background: #fdecec; color: #b4322b; border-radius: 8px; font-size: 13px; }
        .goal { background: #fff; border-radius: 12px; padding: 18px 20px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); margin-bottom: 14px; }
        .goal.finished { opacity: .78; }
        .head { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
        .dim { padding: 3px 9px; border-radius: 999px; font-size: 12px; background: #eef2f6; color: #40505f; }
        .dim.d1 { background: #e8f2fd; color: #2f6fb0; }
        .dim.d2 { background: #f3ecfb; color: #6a3fa0; }
        .dim.d3 { background: #fff3e0; color: #b4661a; }
        .dim.d4 { background: #e6f6ec; color: #1f7a3d; }
        .dim.d5 { background: #e9f7f5; color: #157a6e; }
        .lvl, .period { font-size: 12px; color: #8494a4; }
        .state { margin-left: auto; font-size: 12px; color: #b4661a; }
        .goal.finished .state { color: #1f7a3d; }
        .goal h3 { margin: 10px 0 5px; font-size: 16px; }
        .desc { margin: 0 0 12px; color: #5b6b7b; font-size: 13px; line-height: 1.6; }
        .progress { height: 8px; background: #eef2f6; border-radius: 999px; overflow: hidden; }
        .progress .bar { height: 100%; background: #2f6fb0; border-radius: 999px; }
        .goal.finished .progress .bar { background: #1f7a3d; }
        .meta { display: flex; align-items: center; gap: 10px; margin-top: 10px; font-size: 13px; color: #5b6b7b; flex-wrap: wrap; }
        .meta strong { color: #1f2a44; font-size: 14px; }
        .mini { padding: 6px 12px; border: 0; border-radius: 7px; background: #eef2f6; color: #40505f; font-size: 12px; cursor: pointer; text-decoration: none; }
        .mini:hover { background: #e2e9f1; }
        .mini.danger { background: #fdecec; color: #b4322b; }
        .time { margin-left: auto; color: #9aa8b6; font-size: 12px; }
        .inline { display: inline; margin: 0; }
        .empty { padding: 30px; text-align: center; color: #8494a4; background: #fff; border-radius: 12px; }
        .next { margin-top: 18px; padding: 14px 16px; border-left: 3px solid #2f6fb0; background: #f5f9fd; font-size: 13px; color: #4a5a69; }
    </style>
</head>
<body>

<div class="top">
    <h1>人生管理系统</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}<span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span></span>
        <a href="${ctx}/tasks">我的任务</a>
        <a class="on" href="${ctx}/goals">长期目标</a>
        <c:if test="${sessionScope.user.admin}">
            <a href="${ctx}/admin/users">用户管理</a>
        </c:if>
        <a href="${ctx}/profile">个人中心</a>
        <a href="${ctx}/logout">退出</a>
    </div>
</div>

<div class="wrap">
    <div class="bar">
        <h2>长期目标<span class="count">共 ${goals.size()} 个</span></h2>
        <div class="filters">
            <form method="get" action="${ctx}/goals">
                <select name="level" onchange="this.form.submit()">
                    <option value="0" ${level == 0 ? 'selected' : ''}>全部层级</option>
                    <option value="1" ${level == 1 ? 'selected' : ''}>五年规划</option>
                    <option value="2" ${level == 2 ? 'selected' : ''}>年度 OKR</option>
                    <option value="3" ${level == 3 ? 'selected' : ''}>季度里程碑</option>
                </select>
            </form>
            <form method="get" action="${ctx}/goals">
                <input type="hidden" name="level" value="${level}">
                <select name="status" onchange="this.form.submit()">
                    <option value="-1" ${status == -1 ? 'selected' : ''}>全部状态</option>
                    <option value="0" ${status == 0 ? 'selected' : ''}>进行中</option>
                    <option value="1" ${status == 1 ? 'selected' : ''}>已完成</option>
                </select>
            </form>
            <a class="btn" href="${ctx}/goals?action=new">+ 新增目标</a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="err">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty goals}">
            <p class="empty">还没有目标，点右上角「新增目标」开始规划。</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="g" items="${goals}">
                <div class="goal ${g.finished ? 'finished' : ''}">
                    <div class="head">
                        <span class="dim d${g.dimension}">${g.dimensionText}</span>
                        <span class="lvl">${g.levelText}</span>
                        <c:if test="${not empty g.period}">
                            <span class="period">· ${fn:escapeXml(g.period)}</span>
                        </c:if>
                        <span class="state">${g.finished ? '已完成' : '进行中'}</span>
                    </div>
                    <h3>${fn:escapeXml(g.title)}</h3>
                    <p class="desc">${empty g.description ? '（暂无说明）' : fn:escapeXml(g.description)}</p>
                    <div class="progress"><div class="bar" style="width:${g.progress}%"></div></div>
                    <div class="meta">
                        <strong>${g.progress}%</strong>
                        <form class="inline" method="post" action="${ctx}/goals">
                            <input type="hidden" name="action" value="progress">
                            <input type="hidden" name="id" value="${g.id}">
                            <input type="hidden" name="delta" value="10">
                            <button class="mini" type="submit">+10%</button>
                        </form>
                        <form class="inline" method="post" action="${ctx}/goals">
                            <input type="hidden" name="action" value="progress">
                            <input type="hidden" name="id" value="${g.id}">
                            <input type="hidden" name="delta" value="-10">
                            <button class="mini" type="submit">-10%</button>
                        </form>
                        <a class="mini" href="${ctx}/goals?action=edit&id=${g.id}">编辑</a>
                        <form class="inline" method="post" action="${ctx}/goals"
                              onsubmit="return confirm('确定删除这个目标吗？');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${g.id}">
                            <button class="mini danger" type="submit">删除</button>
                        </form>
                        <span class="time">创建于 ${g.createTime}</span>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <div class="next">
        种下一棵树最好的时间是十年前，其次就是现在
    </div>
</div>

</body>
</html>
