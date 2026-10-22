package com.tap.controller;

import java.io.IOException;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/cart", "/CartController", "/Cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action != null && !action.trim().isEmpty()) {
            doPost(req, resp);
        } else {
            // Forward to Cart.jsp to render the current session cart
            RequestDispatcher dispatcher = req.getRequestDispatcher("Cart.jsp");
            dispatcher.forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // Step 1: Get the current HttpSession
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        // Step 2: If cart does not exist in session, create a new Cart object
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        // Step 3: Read request parameters (action, menuId/itemId, quantity, source, restaurantId)
        String action = req.getParameter("action");
        String menuIdStr = req.getParameter("menuId");
        if (menuIdStr == null || menuIdStr.trim().isEmpty()) {
            menuIdStr = req.getParameter("itemId");
        }
        
        String restaurantIdStr = req.getParameter("restaurantId");
        String quantityStr = req.getParameter("quantity");
        String source = req.getParameter("source"); // "menu" or "cart"
        String redirectTarget = req.getParameter("redirect");

        int menuId = 0;
        try {
            if (menuIdStr != null && !menuIdStr.trim().isEmpty()) {
                menuId = Integer.parseInt(menuIdStr.trim());
            }
        } catch (NumberFormatException e) {
            menuId = 0;
        }

        int quantity = 1;
        try {
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                quantity = Integer.parseInt(quantityStr.trim());
            }
        } catch (NumberFormatException e) {
            quantity = 1;
        }

        // Step 4: Perform cart operations based on action ("add", "update", "remove"/"delete", "clear")
        boolean opSuccess = true;
        String message = "Cart updated";
        if ("add".equalsIgnoreCase(action) && menuId > 0) {
            MenuDAOImpl menuDAO = new MenuDAOImpl();
            Menu menu = menuDAO.getMenu(menuId);

            if (menu != null && menu.isAvailable()) {
                opSuccess = cart.addItem(menu, quantity);
                if (opSuccess) {
                    message = "Added to cart";
                } else {
                    message = "Your cart contains dishes from another restaurant. Please clear cart first.";
                }
            } else {
                opSuccess = false;
                message = "This dish is currently unavailable";
            }
        } else if ("update".equalsIgnoreCase(action) && menuId > 0) {
            cart.updateQuantity(menuId, quantity);
            message = quantity > 0 ? "Quantity updated" : "Item removed";
        } else if (("delete".equalsIgnoreCase(action) || "remove".equalsIgnoreCase(action)) && menuId > 0) {
            cart.removeItem(menuId);
            message = "Item removed";
        } else if ("clear".equalsIgnoreCase(action)) {
            cart.clear();
            message = "Cart cleared";
        }

        // Save updated cart object back into session
        session.setAttribute("cart", cart);

        // Step 5: Check if request is AJAX / Fetch (to avoid unwanted page jump/reloads)
        String requestedWith = req.getHeader("X-Requested-With");
        String acceptHeader = req.getHeader("Accept");
        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                      || (acceptHeader != null && acceptHeader.contains("application/json"))
                      || "true".equalsIgnoreCase(req.getParameter("ajax"));

        if (isAjax) {
            resp.setContentType("application/json;charset=UTF-8");

            int totalCartQty = 0;
            double totalCartAmount = 0.0;
            int currentItemQty = 0;
            StringBuilder itemsJson = new StringBuilder("[");

            if (cart.getItems() != null) {
                boolean first = true;
                for (CartItem ci : cart.getItems().values()) {
                    totalCartQty += ci.getQuantity();
                    totalCartAmount += ci.getSubtotal();

                    if (!first) itemsJson.append(",");
                    first = false;

                    String iName = (ci.getMenu() != null) ? ci.getMenu().getItemName() : ci.getName();
                    String iImg = (ci.getMenu() != null) ? ci.getMenu().getImagePath() : "";
                    if (iImg == null || iImg.trim().isEmpty()) {
                        iImg = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=300&q=80";
                    }
                    double iPrice = (ci.getMenu() != null) ? ci.getMenu().getPrice() : ci.getPrice();

                    itemsJson.append("{")
                             .append("\"menuId\":").append(ci.getItemId()).append(",")
                             .append("\"name\":\"").append(escapeJson(iName)).append("\",")
                             .append("\"imagePath\":\"").append(escapeJson(iImg)).append("\",")
                             .append("\"price\":").append(String.format(java.util.Locale.US, "%.2f", iPrice)).append(",")
                             .append("\"quantity\":").append(ci.getQuantity()).append(",")
                             .append("\"subtotal\":").append(String.format(java.util.Locale.US, "%.2f", ci.getSubtotal()))
                             .append("}");
                }
                CartItem targetItem = cart.getItems().get(menuId);
                if (targetItem != null) {
                    currentItemQty = targetItem.getQuantity();
                }
            }
            itemsJson.append("]");

            double subtotal = totalCartAmount;
            double deliveryFee = (subtotal >= 500.0 || totalCartQty == 0) ? 0.0 : 40.0;
            double tax = subtotal * 0.05;
            double freeDeliveryGap = Math.max(0.0, 500.0 - subtotal);
            int freeDeliveryPct = (int) Math.min(100, Math.round((subtotal / 500.0) * 100));

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\":").append(opSuccess).append(",");
            json.append("\"action\":\"").append(action != null ? escapeJson(action) : "").append("\",");
            json.append("\"menuId\":").append(menuId).append(",");
            json.append("\"itemQty\":").append(currentItemQty).append(",");
            json.append("\"totalCartQty\":").append(totalCartQty).append(",");
            json.append("\"subtotal\":").append(String.format(java.util.Locale.US, "%.2f", subtotal)).append(",");
            json.append("\"totalCartAmount\":").append(String.format(java.util.Locale.US, "%.2f", totalCartAmount)).append(",");
            json.append("\"formattedTotal\":").append(String.format(java.util.Locale.US, "%.0f", totalCartAmount)).append(",");
            json.append("\"deliveryFee\":").append(String.format(java.util.Locale.US, "%.2f", deliveryFee)).append(",");
            json.append("\"tax\":").append(String.format(java.util.Locale.US, "%.2f", tax)).append(",");
            json.append("\"freeDeliveryGap\":").append(String.format(java.util.Locale.US, "%.2f", freeDeliveryGap)).append(",");
            json.append("\"freeDeliveryPct\":").append(freeDeliveryPct).append(",");
            json.append("\"restaurantId\":").append(cart.getRestaurantId()).append(",");
            json.append("\"message\":\"").append(escapeJson(message)).append("\",");
            json.append("\"items\":").append(itemsJson.toString());
            json.append("}");

            resp.getWriter().write(json.toString());
            resp.getWriter().flush();
            return;
        }

        // Step 6: Non-AJAX fallback redirection logic based on source ("menu" vs "cart")
        if ("menu".equalsIgnoreCase(source)) {
            // Source is Menu page -> stay on Menu page for the specific restaurant
            if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
                resp.sendRedirect("menu?restaurantId=" + restaurantIdStr.trim());
            } else if (cart.getRestaurantId() > 0) {
                resp.sendRedirect("menu?restaurantId=" + cart.getRestaurantId());
            } else {
                resp.sendRedirect("cart");
            }
        } else if ("cart".equalsIgnoreCase(source) || "cart".equalsIgnoreCase(redirectTarget)) {
            // Source is Cart page -> stay on Cart page
            resp.sendRedirect("cart");
        } else if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
            resp.sendRedirect("menu?restaurantId=" + restaurantIdStr.trim());
        } else {
            resp.sendRedirect("cart");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}

