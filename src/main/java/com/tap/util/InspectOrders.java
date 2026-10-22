package com.tap.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class InspectOrders {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT orderId, userId, restaurantId, totalAmount, status, paymentMode, orderDate FROM orders ORDER BY orderId DESC")) {
            System.out.println("=== CURRENT ORDERS IN DATABASE ===");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("ID: " + rs.getInt("orderId") 
                        + " | User: " + rs.getInt("userId")
                        + " | Rest: " + rs.getInt("restaurantId")
                        + " | Amount: " + rs.getDouble("totalAmount")
                        + " | Status: '" + rs.getString("status") + "'"
                        + " | Payment: '" + rs.getString("paymentMode") + "'"
                        + " | Date: " + rs.getTimestamp("orderDate"));
            }
            System.out.println("Total orders found: " + count);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
