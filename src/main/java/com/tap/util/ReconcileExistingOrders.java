package com.tap.util;

import java.sql.Timestamp;
import java.util.List;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.model.Order;

public class ReconcileExistingOrders {

    public static void main(String[] args) {
        System.out.println("=== RECONCILING EXISTING ORDERS IN MYSQL ===");
        OrderDAOImpl orderDAO = new OrderDAOImpl();
        List<Order> orders = orderDAO.getAllOrders();

        if (orders == null || orders.isEmpty()) {
            System.out.println("No orders found to reconcile.");
            return;
        }

        long now = System.currentTimeMillis();
        int updatedCount = 0;

        for (Order ord : orders) {
            String initialStatus = ord.getStatus();
            Timestamp orderDate = ord.getOrderDate();
            long elapsedMillis = (orderDate != null) ? (now - orderDate.getTime()) : 0;
            double elapsedMins = elapsedMillis / (60.0 * 1000.0);

            String newStatus = OrderLifecycleManager.evaluateAndUpdateOrder(ord, orderDAO);

            if (!newStatus.equalsIgnoreCase(initialStatus)) {
                updatedCount++;
                System.out.printf("Order #%d | Date: %s | Elapsed: %.1f mins | Status: '%s' -> '%s' (UPDATED)%n",
                        ord.getOrderId(), orderDate, elapsedMins, initialStatus, newStatus);
            } else {
                System.out.printf("Order #%d | Date: %s | Elapsed: %.1f mins | Status: '%s' (UNCHANGED)%n",
                        ord.getOrderId(), orderDate, elapsedMins, initialStatus);
            }
        }

        System.out.println("--------------------------------------------------");
        System.out.println("Total orders processed: " + orders.size());
        System.out.println("Total orders updated in MySQL: " + updatedCount);
    }
}
