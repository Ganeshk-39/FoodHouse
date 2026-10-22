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

@WebServlet({"/login", "/LoginController", "/Login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("Login.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        UserDAOImpl userDAO = new UserDAOImpl();
        User user = userDAO.getUserByEmail(email);
        
        boolean isValid = false;
        if (user != null && user.getPassword() != null && password != null) {
            String dbPassword = user.getPassword();
            try {
                if (dbPassword.startsWith("$2a$") || dbPassword.startsWith("$2b$") || dbPassword.startsWith("$2y$")) {
                    isValid = BCrypt.checkpw(password, dbPassword);
                } else {
                    isValid = dbPassword.equals(password);
                }
            } catch (Exception e) {
                isValid = dbPassword.equals(password);
            }
        }
        
        if (isValid) {
            
            HttpSession session = req.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("user", user);
            
            String redirect = req.getParameter("redirect");
            if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("Login")) {
                resp.sendRedirect(redirect.trim());
                return;
            }
            
            resp.sendRedirect("restaurant");
            
        } else {
            req.setAttribute("errorMessage", "Invalid email or password");
            
            RequestDispatcher rd = req.getRequestDispatcher("Login.jsp");
            rd.forward(req, resp);
        }
    }
}
