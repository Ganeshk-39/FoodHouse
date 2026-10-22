package com.tap.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckUsers {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT userId, username, email, password, role FROM user")) {
            System.out.println("=== USERS IN DATABASE ===");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("userId") + " | Name: " + rs.getString("username") + " | Email: " + rs.getString("email") + " | Role: " + rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
