package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.DAOImpl.OrderItemDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.DAOImpl.UserDAOImpl;
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

@WebServlet({"/delivery-admin", "/DeliveryAdminController", "/delivery", "/Delivery"})
public class DeliveryAdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }

        // For presentation ease, allow demo delivery session
        if (user == null) {
            String demo = req.getParameter("demo");
            if ("true".equalsIgnoreCase(demo)) {
                UserDAOImpl userDAO = new UserDAOImpl();
                user = userDAO.getUserByEmail("admin@foodhouse.com");
                if (user != null) {
                    session.setAttribute("loggedInUser", user);
                    session.setAttribute("user", user);
                }
            } else {
                resp.sendRedirect("Login.jsp?redirect=delivery-admin");
                return;
            }
        }

        OrderDAOImpl orderDAO = new OrderDAOImpl();
        RestaurantDAOImpl restDAO = new RestaurantDAOImpl();
        UserDAOImpl userDAO = new UserDAOImpl();
        OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();

        List<Order> allOrders = orderDAO.getAllOrders();
        List<Order> readyDeliveries = new ArrayList<>();
        List<Order> activeDeliveries = new ArrayList<>();
        List<Order> completedDeliveries = new ArrayList<>();

        Map<Integer, Restaurant> restaurantMap = new HashMap<>();
        List<Restaurant> restaurants = restDAO.getAllRestaurants();
        if (restaurants != null) {
            for (Restaurant r : restaurants) {
                restaurantMap.put(r.getRestaurantId(), r);
            }
        }

        Map<Integer, User> customerMap = new HashMap<>();
        Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();

        if (allOrders != null) {
            for (Order o : allOrders) {
                String st = (o.getStatus() != null) ? o.getStatus().trim() : "";
                if ("Food Ready".equalsIgnoreCase(st) || "Ready".equalsIgnoreCase(st)) {
                    readyDeliveries.add(o);
                } else if ("Out for Delivery".equalsIgnoreCase(st)) {
                    activeDeliveries.add(o);
                } else if ("Delivered".equalsIgnoreCase(st)) {
                    completedDeliveries.add(o);
                }

                if (!customerMap.containsKey(o.getUserId())) {
                    User customer = userDAO.getUser(o.getUserId());
                    if (customer != null) {
                        customerMap.put(o.getUserId(), customer);
                    }
                }

                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(o.getOrderId());
                if (items != null) {
                    orderItemsMap.put(o.getOrderId(), items);
                }
            }
        }

        req.setAttribute("readyDeliveries", readyDeliveries);
        req.setAttribute("activeDeliveries", activeDeliveries);
        req.setAttribute("completedDeliveries", completedDeliveries);
        req.setAttribute("restaurantMap", restaurantMap);
        req.setAttribute("customerMap", customerMap);
        req.setAttribute("orderItemsMap", orderItemsMap);
        req.setAttribute("user", user);

        RequestDispatcher rd = req.getRequestDispatcher("DeliveryDashboard.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        OrderDAOImpl orderDAO = new OrderDAOImpl();

        if ("pickup".equalsIgnoreCase(action)) {
            orderDAO.updateOrderStatus(orderId, "Out for Delivery");
            req.getSession().setAttribute("deliverySuccess", "Order #FH-" + orderId + " picked up from restaurant kitchen! Status updated to 'Out for Delivery'.");
        } else if ("delivered".equalsIgnoreCase(action)) {
            orderDAO.updateOrderStatus(orderId, "Delivered");
            req.getSession().setAttribute("deliverySuccess", "Order #FH-" + orderId + " marked as DELIVERED to customer doorstep successfully!");
        }

        resp.sendRedirect("delivery-admin");
    }
}
