<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/21
  Time: 21:09
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
    <title>${empty bill ? '记一笔' : '编辑账单'} · 人生管理系统</title>
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
        <span>${sessionScope.user.nickname}
            <span class="tag">${sessionScope.user.admin ? '管理员' : '普通用户'}</span>
        </span>
        <a href="${ctx}/tasks">我的任务</a>
        <a href="${ctx}/goals">长期目标</a>
        <a href="${ctx}/bills">记账本</a>
        <a href="${ctx}/profile">个人中心</a>
        <a href="${ctx}/logout">退出</a>
    </div>
</div>

<div class="wrap">
    <div class="card">
        <h2>${empty bill ? '记一笔' : '编辑账单'}</h2>
        <p class="hint">类型、金额、分类、日期为必填；金额最多两位小数。</p>

        <form method="post" action="${ctx}/bills">
            <input type="hidden" name="action" value="${empty bill ? 'add' : 'save'}">
            <c:if test="${not empty bill}">
                <input type="hidden" name="id" value="${bill.id}">
            </c:if>
            <input type="hidden" name="month" value="${param.month}">

            <div class="row">
                <label for="type">类型</label>
                <select id="type" name="type">
                    <option value="1" ${(empty bill ? 2 : bill.type) == 1 ? 'selected' : ''}>收入</option>
                    <option value="2" ${(empty bill ? 2 : bill.type) == 2 ? 'selected' : ''}>支出</option>
                </select>
            </div>

            <div class="row">
                <label for="amount">金额</label>
                <input id="amount" type="number" name="amount" step="0.01"
                       min="0.01" max="9999999.99" placeholder="例如 35.50"
                       value="${empty bill ? '' : bill.amount}" required>
            </div>

            <div class="row">
                <label for="category">分类</label>
                <input id="category" type="text" name="category" maxlength="30"
                       list="categoryOptions" placeholder="例如 餐饮 / 工资"
                       value="${empty bill ? '' : fn:escapeXml(bill.category)}" required>
                <datalist id="categoryOptions">
                    <option value="餐饮"></option>
                    <option value="交通"></option>
                    <option value="房租"></option>
                    <option value="购物"></option>
                    <option value="学习"></option>
                    <option value="工资"></option>
                    <option value="理财"></option>
                    <option value="其他"></option>
                </datalist>
            </div>

            <div class="row">
                <label for="billDate">日期</label>
                <input id="billDate" type="date" name="billDate"
                       value="${empty bill ? today : bill.billDate}" required>
            </div>

            <div class="row">
                <label for="remark">备注</label>
                <input id="remark" type="text" name="remark" maxlength="200"
                       placeholder="可选" value="${empty bill ? '' : fn:escapeXml(bill.remark)}">
            </div>

            <div class="actions">
                <button type="submit">保存</button>
                <a class="btn" href="${ctx}/bills?month=${param.month}">返回列表</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

