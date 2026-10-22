package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// WebServlet annotation maps the URL pattern "/restaurant" to this Servlet class
@WebServlet({"/restaurant", "/RestaurantController", "/Restaurant"})
public class RestaurantController extends HttpServlet {

    // doGet method handles HTTP GET requests sent from the browser or home page
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Step 1: Create an object of RestaurantDAOImpl to interact with the database
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();

        // Step 2: Call the getAllRestaurants() method to fetch the complete list of restaurants from the database
        List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();

        // Step 3: Attach the list of restaurants to the request scope under the attribute name "restaurants"
        req.setAttribute("restaurants", allRestaurants);

        // Step 4: Create a RequestDispatcher object targeting the destination view page ("/Restaurant.jsp")
        RequestDispatcher rd = req.getRequestDispatcher("/Restaurant.jsp");

        // Step 5: Forward the request and response objects to "Restaurant.jsp" to render the restaurants on screen
        rd.forward(req, resp);
    }
}