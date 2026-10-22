package com.tap.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBTableInit {

    public static void main(String[] args) {
        String sqlOrders = "CREATE TABLE IF NOT EXISTS `orders` ("
                + "`orderId` INT AUTO_INCREMENT PRIMARY KEY, "
                + "`userId` INT NOT NULL, "
                + "`restaurantId` INT NOT NULL, "
                + "`totalAmount` DOUBLE NOT NULL, "
                + "`status` VARCHAR(50) DEFAULT 'Confirmed', "
                + "`paymentMode` VARCHAR(50) DEFAULT 'Cash on Delivery', "
                + "`orderDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                + "FOREIGN KEY (`userId`) REFERENCES `user`(`userId`) ON DELETE CASCADE, "
                + "FOREIGN KEY (`restaurantId`) REFERENCES `restaurant`(`restaurantId`) ON DELETE CASCADE"
                + ")";

        String sqlOrderItem = "CREATE TABLE IF NOT EXISTS `order_item` ("
                + "`orderItemId` INT AUTO_INCREMENT PRIMARY KEY, "
                + "`orderId` INT NOT NULL, "
                + "`menuId` INT NOT NULL, "
                + "`quantity` INT NOT NULL, "
                + "`itemTotal` DOUBLE NOT NULL, "
                + "FOREIGN KEY (`orderId`) REFERENCES `orders`(`orderId`) ON DELETE CASCADE, "
                + "FOREIGN KEY (`menuId`) REFERENCES `menu`(`menuId`) ON DELETE CASCADE"
                + ")";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            
            st.executeUpdate(sqlOrders);
            st.executeUpdate(sqlOrderItem);
            System.out.println("Tables `orders` and `order_item` verified/created successfully!");

            ResultSet rs = st.executeQuery("SHOW TABLES");
            System.out.println("Current Database Tables in FoodHouse:");
            while (rs.next()) {
                System.out.println(" - " + rs.getString(1));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
