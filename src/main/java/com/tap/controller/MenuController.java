package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// WebServlet annotation maps the URL "/menu" to this Servlet class
@WebServlet({"/menu", "/MenuController", "/Menu"})
public class MenuController extends HttpServlet {
    
    // doGet method handles HTTP GET requests sent from the browser/JSP
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // Step 1: Read the "restaurantId" query parameter from the request URL and convert (parse) String to int
        int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
        
        // Step 2: Create objects of MenuDAOImpl and RestaurantDAOImpl to communicate with the database
        MenuDAOImpl menuDAO = new MenuDAOImpl();
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        
        // Step 3: Call DAO methods to fetch restaurant details and its menu items
        Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);
        List<Menu> menuList = menuDAO.getMenusByRestaurant(restaurantId);
        
        // Step 4: Set fetched objects as request attributes so the JSP page can access them
        req.setAttribute("restaurant", restaurant);
        req.setAttribute("menuList", menuList);
        
        // Step 5: Create a RequestDispatcher object targeting the destination JSP page ("Menu.jsp")
        RequestDispatcher rd = req.getRequestDispatcher("Menu.jsp");
        
        // Step 6: Forward the request and response objects to "Menu.jsp" to render the output
        rd.forward(req, resp);
    }
}
