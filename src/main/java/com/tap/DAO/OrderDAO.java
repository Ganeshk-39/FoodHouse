package com.tap.DAO;

import java.util.List;

import com.tap.model.Order;

public interface OrderDAO {

    int addOrder(Order order);

    int createOrderWithItems(Order order, List<com.tap.model.OrderItem> items);

    Order getOrder(int orderId);

    Order getOrderByPaymentReference(String paymentRef);

    void updateOrder(Order order);

    void deleteOrder(int orderId);

    List<Order> getAllOrders();

    List<Order> getOrdersByUserId(int userId);

    List<Order> getOrdersByRestaurantId(int restaurantId);

    void updateOrderStatus(int orderId, String status);

    List<Order> getOrdersByStatus(String status);
}