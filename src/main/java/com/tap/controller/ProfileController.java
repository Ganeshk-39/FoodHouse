package com.tap.controller;

import java.io.IOException;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.Order;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/profile", "/ProfileController", "/Profile"})
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("loggedInUser");
        if (sessionUser == null) {
            sessionUser = (User) session.getAttribute("user");
        }

        if (sessionUser == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        UserDAOImpl userDAO = new UserDAOImpl();
        User currentUser = userDAO.getUser(sessionUser.getUserId());
        if (currentUser == null) {
            currentUser = sessionUser;
        }

        // Calculate user order history statistics
        OrderDAOImpl orderDAO = new OrderDAOImpl();
        List<Order> userOrders = orderDAO.getOrdersByUserId(currentUser.getUserId());

        int totalOrders = (userOrders != null) ? userOrders.size() : 0;
        double totalSpent = 0.0;
        if (userOrders != null) {
            for (Order o : userOrders) {
                totalSpent += o.getTotalAmount();
            }
        }

        req.setAttribute("user", currentUser);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalSpent", totalSpent);
        req.setAttribute("userOrders", userOrders);

        RequestDispatcher rd = req.getRequestDispatcher("Profile.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("loggedInUser");
        if (sessionUser == null) {
            sessionUser = (User) session.getAttribute("user");
        }

        if (sessionUser == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }

        String action = req.getParameter("action");
        UserDAOImpl userDAO = new UserDAOImpl();
        User currentUser = userDAO.getUser(sessionUser.getUserId());

        if (currentUser == null) {
            currentUser = sessionUser;
        }

        if ("updateProfile".equalsIgnoreCase(action)) {
            String username = req.getParameter("username");
            String phone = req.getParameter("phone");
            String address = req.getParameter("address");

            if (username != null && !username.trim().isEmpty()) {
                currentUser.setUsername(username.trim());
            }
            if (phone != null) {
                currentUser.setPhone(phone.trim());
            }
            if (address != null) {
                currentUser.setAddress(address.trim());
            }

            userDAO.updateUser(currentUser);

            // Synchronize updated user to session
            session.setAttribute("loggedInUser", currentUser);
            session.setAttribute("user", currentUser);

            session.setAttribute("profileSuccess", "Profile updated successfully!");

        } else if ("changePassword".equalsIgnoreCase(action)) {
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            boolean passwordVerified = false;
            if (currentUser.getPassword() != null && currentPassword != null) {
                String dbPass = currentUser.getPassword();
                if (dbPass.startsWith("$2a$") || dbPass.startsWith("$2b$") || dbPass.startsWith("$2y$")) {
                    passwordVerified = BCrypt.checkpw(currentPassword, dbPass);
                } else {
                    passwordVerified = dbPass.equals(currentPassword);
                }
            }

            if (!passwordVerified) {
                session.setAttribute("profileError", "Current password does not match our records.");
            } else if (newPassword == null || newPassword.trim().length() < 6) {
                session.setAttribute("profileError", "New password must be at least 6 characters long.");
            } else if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("profileError", "New password and confirmation do not match.");
            } else {
                String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(10));
                currentUser.setPassword(hashedNewPassword);
                userDAO.updateUser(currentUser);

                session.setAttribute("loggedInUser", currentUser);
                session.setAttribute("user", currentUser);
                session.setAttribute("profileSuccess", "Password changed successfully!");
            }
        }

        resp.sendRedirect("profile");
    }
}
