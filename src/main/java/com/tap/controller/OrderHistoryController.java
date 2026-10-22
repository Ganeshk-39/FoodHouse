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

@WebServlet({"/orders", "/order-history", "/OrderHistoryController", "/OrderHistory"})
public class OrderHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        OrderDAOImpl orderDAO = new OrderDAOImpl();
        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());

        if (orders == null || orders.isEmpty()) {
            orders = orderDAO.getAllOrders();
        }

        // Auto-reconcile and persist realistic timeline statuses in MySQL
        com.tap.util.OrderLifecycleManager.reconcileAllOrders(orders, orderDAO);

        RestaurantDAOImpl restDAO = new RestaurantDAOImpl();
        Map<Integer, Restaurant> restaurantMap = new HashMap<>();
        List<Restaurant> allRestaurants = restDAO.getAllRestaurants();
        if (allRestaurants != null) {
            for (Restaurant r : allRestaurants) {
                restaurantMap.put(r.getRestaurantId(), r);
            }
        }

        OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
        MenuDAOImpl menuDAO = new MenuDAOImpl();
        Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
        Map<Integer, Menu> menuMap = new HashMap<>();

        if (orders != null) {
            for (Order ord : orders) {
                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(ord.getOrderId());
                if (items != null) {
                    orderItemsMap.put(ord.getOrderId(), items);
                    for (OrderItem item : items) {
                        if (!menuMap.containsKey(item.getMenuId())) {
                            Menu m = menuDAO.getMenu(item.getMenuId());
                            if (m != null) {
                                menuMap.put(item.getMenuId(), m);
                            }
                        }
                    }
                }
            }
        }

        req.setAttribute("orders", orders);
        req.setAttribute("restaurantMap", restaurantMap);
        req.setAttribute("orderItemsMap", orderItemsMap);
        req.setAttribute("menuMap", menuMap);
        req.setAttribute("user", user);

        RequestDispatcher rd = req.getRequestDispatcher("OrderHistory.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
