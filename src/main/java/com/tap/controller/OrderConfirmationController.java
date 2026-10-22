package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.DAOImpl.OrderItemDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller serving the dedicated Order Confirmation view.
 * Mapped to "/order-confirmation", "/OrderConfirmation", "/confirmation".
 * Validates authenticated customer, verifies order ownership, loads order items
 * and restaurant details, and renders OrderConfirmation.jsp.
 */
@WebServlet({"/order-confirmation", "/OrderConfirmation", "/confirmation", "/OrderConfirmationController"})
public class OrderConfirmationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // 1. Validate authenticated customer session
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        // 2. Determine target order ID from request parameter or session fallback
        String orderIdStr = req.getParameter("orderId");
        int orderId = 0;
        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
            try {
                orderId = Integer.parseInt(orderIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (orderId <= 0) {
            Integer sessionOrderId = (Integer) session.getAttribute("lastPlacedOrderId");
            if (sessionOrderId != null && sessionOrderId > 0) {
                orderId = sessionOrderId;
            }
        }

        if (orderId <= 0) {
            resp.sendRedirect("orders");
            return;
        }

        // 3. Fetch order from MySQL database
        OrderDAOImpl orderDAO = new OrderDAOImpl();
        Order order = orderDAO.getOrder(orderId);
        if (order == null) {
            resp.sendRedirect("orders");
            return;
        }

        // 4. Customer authorization security check
        String role = (user.getRole() != null) ? user.getRole().toLowerCase() : "";
        boolean isStaff = role.contains("admin") || role.contains("delivery");
        if (order.getUserId() != user.getUserId() && !isStaff) {
            resp.sendRedirect("orders");
            return;
        }

        // 5. Fetch associated restaurant details
        RestaurantDAOImpl restDAO = new RestaurantDAOImpl();
        Restaurant restaurant = restDAO.getRestaurant(order.getRestaurantId());

        // 6. Fetch order items and menu dish data
        OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
        List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);

        MenuDAOImpl menuDAO = new MenuDAOImpl();
        Map<Integer, Menu> menuMap = new HashMap<>();
        if (orderItems != null) {
            for (OrderItem oi : orderItems) {
                if (!menuMap.containsKey(oi.getMenuId())) {
                    Menu m = menuDAO.getMenu(oi.getMenuId());
                    if (m != null) {
                        menuMap.put(oi.getMenuId(), m);
                    }
                }
            }
        }

        // 7. Attach data to request scope and forward to OrderConfirmation.jsp
        req.setAttribute("order", order);
        req.setAttribute("restaurant", restaurant);
        req.setAttribute("orderItems", orderItems);
        req.setAttribute("menuMap", menuMap);
        req.setAttribute("user", user);

        RequestDispatcher rd = req.getRequestDispatcher("OrderConfirmation.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
