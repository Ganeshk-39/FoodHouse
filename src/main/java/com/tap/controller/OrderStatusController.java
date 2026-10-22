package com.tap.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.model.Order;
import com.tap.model.User;
import com.tap.util.OrderLifecycleManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller endpoint mapped to "/order-status" and "/api/order-status".
 * Supports periodic polling from OrderHistory.jsp to provide live, dynamic
 * order tracking updates without page reloads.
 * 
 * Automatically updates order statuses in MySQL based on elapsed time.
 * Enforces authenticated customer order ownership and database safety.
 */
@WebServlet({"/order-status", "/api/order-status"})
public class OrderStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\":false,\"error\":\"Unauthorized. Please log in.\"}");
            return;
        }

        // Optional demo/testing configuration
        String demoParam = req.getParameter("demo");
        if ("fast".equalsIgnoreCase(demoParam)) {
            OrderLifecycleManager.setTestFastMode(true);
        } else if ("normal".equalsIgnoreCase(demoParam)) {
            OrderLifecycleManager.setTestFastMode(false);
        }

        String speedParam = req.getParameter("speed");
        if (speedParam != null) {
            try {
                double speed = Double.parseDouble(speedParam.trim());
                if (speed > 0) {
                    OrderLifecycleManager.setCustomTimeMultiplier(speed);
                }
            } catch (NumberFormatException ignored) {}
        }

        OrderDAOImpl orderDAO = new OrderDAOImpl();
        String orderIdStr = req.getParameter("orderId");

        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
            int orderId = 0;
            try {
                orderId = Integer.parseInt(orderIdStr.trim());
            } catch (NumberFormatException e) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\":false,\"error\":\"Invalid orderId format\"}");
                return;
            }

            Order order = orderDAO.getOrder(orderId);
            if (order == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.write("{\"success\":false,\"error\":\"Order not found\"}");
                return;
            }

            // Security check: verify order belongs to authenticated customer (or admin)
            String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "";
            boolean isAdmin = role.contains("admin") || role.contains("delivery");
            if (order.getUserId() != user.getUserId() && !isAdmin) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.write("{\"success\":false,\"error\":\"Access denied to this order\"}");
                return;
            }

            // Reconcile and persist in MySQL
            String status = OrderLifecycleManager.evaluateAndUpdateOrder(order, orderDAO);
            int stage = OrderLifecycleManager.getStageNumber(status);
            String statusDesc = OrderLifecycleManager.getStatusDescription(status);
            int fillPercent = OrderLifecycleManager.getFillPercent(stage);
            boolean isDelivered = "Delivered".equalsIgnoreCase(status);
            boolean isTerminal = OrderLifecycleManager.isTerminalStatus(status);

            long elapsedMillis = 0;
            if (order.getOrderDate() != null) {
                elapsedMillis = System.currentTimeMillis() - order.getOrderDate().getTime();
            }

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\":true,");
            json.append("\"orderId\":").append(order.getOrderId()).append(",");
            json.append("\"status\":\"").append(status).append("\",");
            json.append("\"stage\":").append(stage).append(",");
            json.append("\"statusDesc\":\"").append(statusDesc).append("\",");
            json.append("\"fillPercent\":").append(fillPercent).append(",");
            json.append("\"isDelivered\":").append(isDelivered).append(",");
            json.append("\"isTerminal\":").append(isTerminal).append(",");
            json.append("\"elapsedSeconds\":").append(elapsedMillis / 1000).append(",");
            json.append("\"orderDate\":\"").append(order.getOrderDate() != null ? order.getOrderDate().toString().substring(0, 16) : "").append("\"");
            json.append("}");

            out.write(json.toString());
            return;
        }

        // If no specific orderId requested, return status for all orders of this user
        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());
        if (orders == null || orders.isEmpty()) {
            orders = orderDAO.getAllOrders();
        }

        // Reconcile all orders in MySQL
        OrderLifecycleManager.reconcileAllOrders(orders, orderDAO);

        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"orders\":[");
        if (orders != null) {
            for (int i = 0; i < orders.size(); i++) {
                Order ord = orders.get(i);
                String status = ord.getStatus();
                int stage = OrderLifecycleManager.getStageNumber(status);
                String statusDesc = OrderLifecycleManager.getStatusDescription(status);
                int fillPercent = OrderLifecycleManager.getFillPercent(stage);
                boolean isDelivered = "Delivered".equalsIgnoreCase(status);
                boolean isTerminal = OrderLifecycleManager.isTerminalStatus(status);

                long elapsedMillis = 0;
                if (ord.getOrderDate() != null) {
                    elapsedMillis = System.currentTimeMillis() - ord.getOrderDate().getTime();
                }

                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"orderId\":").append(ord.getOrderId()).append(",");
                json.append("\"status\":\"").append(status).append("\",");
                json.append("\"stage\":").append(stage).append(",");
                json.append("\"statusDesc\":\"").append(statusDesc).append("\",");
                json.append("\"fillPercent\":").append(fillPercent).append(",");
                json.append("\"isDelivered\":").append(isDelivered).append(",");
                json.append("\"isTerminal\":").append(isTerminal).append(",");
                json.append("\"elapsedSeconds\":").append(elapsedMillis / 1000).append(",");
                json.append("\"orderDate\":\"").append(ord.getOrderDate() != null ? ord.getOrderDate().toString().substring(0, 16) : "").append("\"");
                json.append("}");
            }
        }
        json.append("]}");

        out.write(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
