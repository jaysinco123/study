package com.life.servlet;

import com.life.bean.User;
import com.life.service.BillService;
import com.life.service.ServiceException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * 记账控制器：月度收支统计、账单列表、新增/编辑表单、删除。
 * GET  /bills                    列表（可按 month/type 筛选，默认当月）
 * GET  /bills?action=new         新增表单
 * GET  /bills?action=edit&id=1   编辑表单
 * POST /bills action=add|save|delete
 */
@WebServlet("/bills")
public class BillServlet extends BaseServlet {

    private static final DateTimeFormatter MONTH_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM");

    private final BillService billService = new BillService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            redirect(request, response, "/login");
            return;
        }

        String action = param(request, "action");
        if ("new".equals(action)) {
            request.setAttribute("today", LocalDate.now().toString());
            forward(request, response, "bill/form.jsp");
            return;
        }
        if ("edit".equals(action)) {
            request.setAttribute("bill", billService.find(user.getId(), intParam(request, "id", 0)));
            forward(request, response, "bill/form.jsp");
            return;
        }

        Object flash = request.getSession().getAttribute("flash");
        if (flash != null) {
            request.setAttribute("error", flash);
            request.getSession().removeAttribute("flash");
        }

        int type = intParam(request, "type", 0);
        String month = monthParam(request);
        request.setAttribute("type", type);
        request.setAttribute("month", month);
        request.setAttribute("bills", billService.list(user.getId(), type, month));
        request.setAttribute("income", billService.income(user.getId(), month));
        request.setAttribute("expense", billService.expense(user.getId(), month));
        request.setAttribute("balance", billService.balance(user.getId(), month));
        request.setAttribute("categories", billService.expenseByCategory(user.getId(), month));
        forward(request, response, "bill/list.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            redirect(request, response, "/login");
            return;
        }

        String month = monthParam(request);
        try {
            switch (param(request, "action")) {
                case "add" -> billService.add(user.getId(), intParam(request, "type", 2),
                        param(request, "amount"), param(request, "category"),
                        param(request, "billDate"), param(request, "remark"));
                case "save" -> billService.update(user.getId(), intParam(request, "id", 0),
                        intParam(request, "type", 2), param(request, "amount"),
                        param(request, "category"), param(request, "billDate"), param(request, "remark"));
                case "delete" -> billService.delete(user.getId(), intParam(request, "id", 0));
                default -> throw new ServiceException("不支持的操作");
            }
        } catch (ServiceException e) {
            request.getSession().setAttribute("flash", e.getMessage());
        } catch (RuntimeException e) {
            request.getSession().setAttribute("flash", "操作失败：" + e.getMessage());
        }
        redirect(request, response, "/bills?month=" + month);
    }

    /** 月份参数只接受 yyyy-MM，非法或缺省时回退到当月 */
    private String monthParam(HttpServletRequest request) {
        String month = param(request, "month");
        if (month != null && month.matches("\\d{4}-(0[1-9]|1[0-2])")) {
            return month;
        }
        return LocalDate.now().format(MONTH_FORMAT);
    }

    /** 取整数参数，缺失或格式错误时返回默认值 */
    private int intParam(HttpServletRequest request, String name, int defaultValue) {
        try {
            return Integer.parseInt(param(request, name));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
