<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/21
  Time: 21:08
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
    <title>记账本 · 人生管理系统</title>
    <style>
            * { box-sizing: border-box; }
            body { margin: 0; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; background: #f2f5f9; color: #22303f; }
            .top { display: flex; align-items: center; justify-content: space-between; padding: 13px 28px; background: #1f2a44; color: #fff; }
            .top h1 { margin: 0; font-size: 17px; font-weight: 600; }
            .top .right { display: flex; align-items: center; gap: 16px; font-size: 13px; }
            .top a { color: #cfe0f5; text-decoration: none; }
            .top a:hover { color: #fff; }
            .top a.on { color: #fff; font-weight: 600; }
            .tag { display: inline-block; margin-left: 8px; padding: 2px 8px; border-radius: 999px; background: rgba(47, 111, 176, .35); color: #dbe9f9; font-size: 12px; }
            .wrap { max-width: 1040px; margin: 24px auto 60px; padding: 0 20px; }
            .card { background: #fff; border-radius: 12px; padding: 20px 24px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); margin-bottom: 18px; }
            .card h2 { margin: 0 0 14px; font-size: 17px; }
            .count { margin-left: 8px; color: #8494a4; font-size: 13px; font-weight: normal; }
            .bar { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 14px; flex-wrap: wrap; }
            .filter { display: flex; gap: 8px; align-items: center; }
            .filter input { width: 170px; }
            .filter select { width: 130px; }
            input, select { padding: 9px 11px; border: 1px solid #d3dce6; border-radius: 8px; font-size: 14px; outline: none; background: #fff; }
            input:focus, select:focus { border-color: #2f6fb0; box-shadow: 0 0 0 3px rgba(47, 111, 176, .12); }
            button { border: 0; border-radius: 8px; cursor: pointer; font-size: 13px; }
            .filter button { padding: 8px 14px; background: #eef2f6; color: #40505f; }
            .filter button:hover { background: #e2e9f1; }
            .btn { display: inline-block; padding: 9px 18px; border-radius: 8px; background: #2f6fb0; color: #fff; text-decoration: none; font-size: 13px; }
            .btn:hover { background: #265b93; }
            .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; margin-bottom: 18px; }
            .stat { background: #fff; border-radius: 12px; padding: 16px 18px; box-shadow: 0 4px 18px rgba(31, 42, 68, .07); }
            .stat .label { color: #8494a4; font-size: 13px; }
            .stat .value { margin-top: 6px; font-size: 25px; font-weight: 600; }
            .stat .value.income { color: #1f7a3d; }
            .stat .value.expense { color: #b4322b; }
            .stat .value.balance { color: #2f6fb0; }
            .cats { display: grid; gap: 12px; }
            .cat .row { display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 5px; color: #40505f; }
            .cat .track { height: 8px; background: #eef2f6; border-radius: 999px; overflow: hidden; }
            .cat .fill { height: 100%; background: linear-gradient(90deg, #2f6fb0, #5b96d0); }
            table { width: 100%; border-collapse: collapse; font-size: 14px; }
            th { padding: 8px 10px; text-align: left; color: #8494a4; font-size: 12px; font-weight: normal; border-bottom: 1px solid #e6edf4; }
            td { padding: 10px; border-bottom: 1px solid #f0f4f8; vertical-align: middle; }
            .date { color: #5b6b7b; font-size: 13px; white-space: nowrap; }
            .type { display: inline-block; padding: 3px 9px; border-radius: 999px; font-size: 12px; white-space: nowrap; }
            .type.in { background: #e6f6ec; color: #1f7a3d; }
            .type.out { background: #fdecec; color: #b4322b; }
            .amount { font-weight: 600; white-space: nowrap; }
            .amount.income { color: #1f7a3d; }
            .amount.expense { color: #b4322b; }
            .remark { color: #5b6b7b; font-size: 13px; }
            .mini { display: inline-block; padding: 7px 12px; background: #eef2f6; color: #40505f; white-space: nowrap; border-radius: 8px; text-decoration: none; font-size: 13px; }
            .mini:hover { background: #e2e9f1; }
            .mini.danger { background: #fdecec; color: #b4322b; }
            .inline { display: inline; margin: 0; }
            .err { margin-bottom: 14px; padding: 9px 12px; background: #fdecec; color: #b4322b; border-radius: 6px; font-size: 13px; }
            .empty { margin: 10px 0 4px; color: #8494a4; font-size: 14px; }
            .next { margin-top: 18px; padding: 14px 16px; border-left: 3px solid #2f6fb0; background: #f5f9fd; font-size: 13px; color: #4a5a69; }
        </style>
</head>
<body>
<div class="top">
    <h1>人生管理系统</h1>
    <div class="right">
        <span>${sessionScope.user.nickname}
            <span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span>
        </span>
        <a href="${ctx}/tasks">我的任务</a>
        <a href="${ctx}/goals">长期目标</a>
        <a class="on" href="${ctx}/bills">记账本</a>
        <c:if test="${sessionScope.user.admin}">
            <a href="${ctx}/admin/users">用户管理</a>
        </c:if>
        <a href="${ctx}/profile">个人中心</a>
        <a href="${ctx}/logout">退出</a>
    </div>
</div>

<div class="wrap">
    <div class="card">
        <div class="bar">
            <h2>记账本 <span class="count">${month}</span></h2>
            <form class="filter" method="get" action="${ctx}/bills">
                <input type="month" name="month" value="${month}">
                <select name="type">
                    <option value="0" ${type == 0 ? 'selected' : ''}>全部类型</option>
                    <option value="1" ${type == 1 ? 'selected' : ''}>收入</option>
                    <option value="2" ${type == 2 ? 'selected' : ''}>支出</option>
                </select>
                <button type="submit">查询</button>
            </form>
            <a class="btn" href="${ctx}/bills?action=new&month=${month}">+ 记一笔</a>
        </div>

        <c:if test="${not empty error}">
            <div class="err">${error}</div>
        </c:if>

        <div class="stats">
            <div class="stat">
                <div class="label">本月收入</div>
                <div class="value income">¥${income}</div>
            </div>
            <div class="stat">
                <div class="label">本月支出</div>
                <div class="value expense">¥${expense}</div>
            </div>
            <div class="stat">
                <div class="label">本月结余</div>
                <div class="value balance">¥${balance}</div>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty bills}">
                <p class="empty">这个月还没有账单，点右上角「记一笔」开始记录。</p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>日期</th>
                        <th>类型</th>
                        <th>分类</th>
                        <th>金额</th>
                        <th>备注</th>
                        <th>操作</th>
                    </tr>

                    <c:forEach var="b" items="${bills}">
                        <tr>
                            <td class="date">${b.billDate}</td>
                            <td>
                                <span class="type ${b.income ? 'in' : 'out'}">${b.typeText}</span>
                            </td>
                            <td>${fn:escapeXml(b.category)}</td>
                            <td class="amount ${b.income ? 'income' : 'expense'}">
                                ${b.income ? '+' : '-'}${b.amount}
                            </td>
                            <td class="remark">
                                ${empty b.remark ? '—' : fn:escapeXml(b.remark)}
                            </td>
                            <td>
                                <a class="mini"
                                   href="${ctx}/bills?action=edit&id=${b.id}&month=${month}">编辑</a>
                                <form class="inline" method="post" action="${ctx}/bills"
                                      onsubmit="return confirm('确定删除这条账单吗？');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${b.id}">
                                    <input type="hidden" name="month" value="${month}">
                                    <button class="mini danger" type="submit">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card">
        <h2>本月支出分类 <span class="count">${month}</span></h2>
        <c:choose>
            <c:when test="${empty categories}">
                <p class="empty">本月还没有支出记录。</p>
            </c:when>
            <c:otherwise>
                <div class="cats">
                    <c:forEach var="c" items="${categories}">
                        <div class="cat">
                            <div class="row">
                                <span>${fn:escapeXml(c.category)}</span>
                                <span>¥${c.amount} · ${c.percent}%</span>
                            </div>
                            <div class="track">
                                <div class="fill" style="width:${c.percent}%"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="next">
        当前为 <strong>v8 记账本</strong>：按月统计收入、支出与结余，支出按分类画占比条；
        账单支持新增、编辑、删除，所有操作都带 <code>user_id</code>，看不到别人的账目。
    </div>
</div>
</body>
</html>

