package com.tap.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/foodhouse";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "Classy@0539";

    public static Connection getConnection() {

        Connection connection = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = System.getenv("DB_URL");
            if (url == null || url.trim().isEmpty()) {
                String host = System.getenv("DB_HOST");
                String name = System.getenv("DB_NAME");
                if (host != null && name != null) {
                    url = "jdbc:mysql://" + host + "/" + name;
                } else {
                    url = DEFAULT_URL;
                }
            }

            String user = System.getenv("DB_USER");
            if (user == null || user.trim().isEmpty()) {
                user = DEFAULT_USER;
            }

            String pass = System.getenv("DB_PASSWORD");
            if (pass == null) {
                pass = DEFAULT_PASS;
            }

            connection = DriverManager.getConnection(url, user, pass);

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        return connection;
    }
}