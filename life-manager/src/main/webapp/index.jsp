<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2026/10/20
  Time: 20:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    v2 起首页直接进入登录页。
    用 sendRedirect 而不是 jsp:forward，地址栏会变成 /login，刷新不会重复提交。
--%>
<%
    response.sendRedirect(request.getContextPath() + "/login");
%>
