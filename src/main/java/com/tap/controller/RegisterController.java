package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/register", "/RegisterController", "/Register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("Login.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        UserDAOImpl userDAO = new UserDAOImpl();
        User existingUser = userDAO.getUserByEmail(email);

        if (existingUser != null) {
            req.setAttribute("errorMessage", "An account with this email already exists. Please Sign In.");
            RequestDispatcher rd = req.getRequestDispatcher("Login.jsp");
            rd.forward(req, resp);
            return;
        }

        String encryptedPassword = (password != null && !password.isEmpty()) ? BCrypt.hashpw(password, BCrypt.gensalt()) : "";

        User newUser = new User(0, username, encryptedPassword, email, phone != null ? phone : "", address != null ? address : "", "Customer");
        userDAO.addUser(newUser);

        User savedUser = userDAO.getUserByEmail(email);
        if (savedUser == null) {
            savedUser = newUser;
        }

        HttpSession session = req.getSession();
        session.setAttribute("loggedInUser", savedUser);
        session.setAttribute("user", savedUser);

        String redirect = req.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("Login") && !redirect.contains("register")) {
            resp.sendRedirect(redirect.trim());
            return;
        }

        resp.sendRedirect("restaurant");
    }
}
