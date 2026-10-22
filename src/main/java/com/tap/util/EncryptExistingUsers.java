package com.tap.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import org.mindrot.jbcrypt.BCrypt;

public class EncryptExistingUsers {

    public static void main(String[] args) {
        String selectSql = "SELECT userId, username, email, password FROM user";
        String updateSql = "UPDATE user SET password = ? WHERE userId = ?";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(selectSql);
             PreparedStatement ps = con.prepareStatement(updateSql)) {

            int count = 0;
            while (rs.next()) {
                int userId = rs.getInt("userId");
                String pass = rs.getString("password");

                // If password is not already BCrypt hashed (starts with $2a$ or $2b$ or $2y$)
                if (pass != null && !pass.startsWith("$2a$") && !pass.startsWith("$2b$") && !pass.startsWith("$2y$")) {
                    String hashed = BCrypt.hashpw(pass, BCrypt.gensalt());
                    ps.setString(1, hashed);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                    count++;
                    System.out.println("Encrypted password for user ID " + userId + " (" + rs.getString("email") + ")");
                }
            }

            System.out.println("Finished! Successfully encrypted " + count + " users with BCrypt.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
