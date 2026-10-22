package com.tap.controller;

import java.io.IOException;

import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Cart;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller servlet mapped to "/checkout".
 * Validates cart contents, checks user session, computes final pricing,
 * and forwards to Checkout.jsp for final address and payment selection.
 */
@WebServlet({"/checkout", "/CheckoutController", "/Checkout"})
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Step 1: Access current HttpSession
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        // Step 2: Validate cart existence and content
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            // Cart is empty, redirect user back to cart view
            resp.sendRedirect("cart");
            return;
        }

        // Step 3: Check user session authentication
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            // User is not authenticated; redirect to login and preserve checkout destination
            resp.sendRedirect("Login.jsp?redirect=checkout");
            return;
        }

        // Step 4: Fetch restaurant info associated with current cart
        Restaurant restaurant = null;
        if (cart.getRestaurantId() > 0) {
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
            restaurant = restaurantDAO.getRestaurant(cart.getRestaurantId());
        }

        // Step 5: Compute precise bill breakdown
        double subtotal = cart.getTotalPrice();
        double deliveryFee = (subtotal >= 500.0) ? 0.0 : 40.0;
        double tax = subtotal * 0.05; // 5% GST
        double discount = (subtotal >= 299.0) ? (subtotal * 0.20) : 0.0; // 20% promotional discount
        double grandTotal = subtotal + deliveryFee + tax - discount;

        // Step 6: Attach calculated data to request scope
        req.setAttribute("user", user);
        req.setAttribute("restaurant", restaurant);
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("deliveryFee", deliveryFee);
        req.setAttribute("tax", tax);
        req.setAttribute("discount", discount);
        req.setAttribute("grandTotal", grandTotal);

        // Step 7: Forward request and response to Checkout.jsp
        RequestDispatcher rd = req.getRequestDispatcher("Checkout.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
