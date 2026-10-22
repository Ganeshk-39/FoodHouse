package com.tap.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// WebServlet annotation maps the URL pattern "/logout" to this Servlet class
@WebServlet({"/logout", "/LogoutController", "/Logout"})
public class LogoutController extends HttpServlet {

    // doGet method handles logout action
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // Step 1: Get the current session if one exists
        HttpSession session = req.getSession(false);
        
        // Step 2: If session exists, remove attributes and invalidate session
        if (session != null) {
            session.removeAttribute("loggedInUser");
            session.removeAttribute("user");
            session.invalidate();
        }
        
        // Step 3: Redirect to the restaurant page
        resp.sendRedirect("restaurant");
    }

    // doPost method forwards to doGet
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
