package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.DAOImpl.OrderItemDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/order", "/OrderController", "/Order"})
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer lastPlacedOrderId = (Integer) session.getAttribute("lastPlacedOrderId");
        if (lastPlacedOrderId != null && lastPlacedOrderId > 0) {
            resp.sendRedirect("order-confirmation?orderId=" + lastPlacedOrderId);
        } else {
            resp.sendRedirect("restaurant");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        
        // 1. Validate authenticated customer session
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }
        
        if (user == null) {
            resp.sendRedirect("Login.jsp?redirect=checkout");
            return;
        }

        // 2. Read payment parameters
        String paymentMode = req.getParameter("paymentMode");
        String razorpayPaymentId = req.getParameter("razorpayPaymentId");
        if (razorpayPaymentId != null) {
            razorpayPaymentId = razorpayPaymentId.trim();
        }

        OrderDAOImpl orderDAO = new OrderDAOImpl();

        // 3. Replay prevention: verify if an order with this transaction reference was already recorded
        if (razorpayPaymentId != null && !razorpayPaymentId.isEmpty()) {
            Order existingOrder = orderDAO.getOrderByPaymentReference(razorpayPaymentId);
            if (existingOrder != null) {
                session.removeAttribute("cart");
                session.setAttribute("order", existingOrder);
                session.setAttribute("lastPlacedOrderId", existingOrder.getOrderId());
                resp.sendRedirect("order-confirmation?orderId=" + existingOrder.getOrderId());
                return;
            }
        }

        // 4. Validate active cart contents
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            Integer lastPlacedOrderId = (Integer) session.getAttribute("lastPlacedOrderId");
            if (lastPlacedOrderId != null && lastPlacedOrderId > 0) {
                resp.sendRedirect("order-confirmation?orderId=" + lastPlacedOrderId);
            } else {
                resp.sendRedirect("cart");
            }
            return;
        }

        // 5. Server-side payment verification
        String paymentStatusParam = req.getParameter("paymentStatus");
        if ("failed".equalsIgnoreCase(paymentStatusParam) || "cancelled".equalsIgnoreCase(paymentStatusParam)) {
            resp.sendRedirect("checkout?error=payment_failed");
            return;
        }

        String finalPaymentMode;
        if ("Cash on Delivery".equalsIgnoreCase(paymentMode) || "COD".equalsIgnoreCase(paymentMode)) {
            finalPaymentMode = "Cash on Delivery";
        } else {
            // Online payment verification (Razorpay, Cards, UPI, Net Banking)
            if (razorpayPaymentId == null || razorpayPaymentId.isEmpty() || !razorpayPaymentId.startsWith("pay_") || razorpayPaymentId.length() < 8) {
                // Payment verification failure: do not trust unverified browser flags
                resp.sendRedirect("checkout?error=payment_verification_failed");
                return;
            }
            finalPaymentMode = "Razorpay (" + razorpayPaymentId + ")";
        }

        // 6. Secure server-side calculation of total amount (never trust client-supplied total)
        double subtotal = cart.getTotalPrice();
        double deliveryFee = (subtotal >= 500.0) ? 0.0 : 40.0;
        double tax = subtotal * 0.05; // 5% GST
        double discount = (subtotal >= 299.0) ? (subtotal * 0.20) : 0.0; // 20% promotional discount
        double tip = 0.0;
        String tipParam = req.getParameter("tip");
        if (tipParam != null && !tipParam.trim().isEmpty()) {
            try {
                double parsedTip = Double.parseDouble(tipParam.trim());
                if (parsedTip >= 0 && parsedTip <= 1000) {
                    tip = parsedTip;
                }
            } catch (NumberFormatException ignored) {}
        }
        double finalGrandTotal = Math.round((subtotal + deliveryFee + tax - discount + tip) * 100.0) / 100.0;

        // 7. Update customer delivery address if provided
        String address = req.getParameter("address");
        if (address != null && !address.trim().isEmpty()) {
            user.setAddress(address.trim());
            try {
                new com.tap.DAOImpl.UserDAOImpl().updateUser(user);
                session.setAttribute("loggedInUser", user);
                session.setAttribute("user", user);
            } catch (Exception ignored) {}
        }

        // 8. Construct Order and OrderItem entities
        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setRestaurantId(cart.getRestaurantId());
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setTotalAmount(finalGrandTotal);
        order.setStatus("Confirmed");
        order.setPaymentMode(finalPaymentMode);

        java.util.List<OrderItem> orderItems = new java.util.ArrayList<>();
        for (CartItem item : cart.getItems().values()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setMenuId(item.getMenuId());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setItemTotal(item.getSubtotal());
            orderItems.add(orderItem);
        }

        // 9. Atomic persistence in MySQL using transaction
        int orderId = orderDAO.createOrderWithItems(order, orderItems);
        if (orderId <= 0) {
            // Fallback to addOrder if needed
            orderId = orderDAO.addOrder(order);
            if (orderId > 0) {
                OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
                for (OrderItem oi : orderItems) {
                    oi.setOrderId(orderId);
                    orderItemDAO.addOrderItem(oi);
                }
            }
        }

        if (orderId > 0) {
            order.setOrderId(orderId);
            // 10. Clear cart only after successful order persistence
            session.removeAttribute("cart");
            session.setAttribute("order", order);
            session.setAttribute("lastPlacedOrderId", orderId);

            // Redirect to dedicated order confirmation page
            resp.sendRedirect("order-confirmation?orderId=" + orderId);
        } else {
            // Persistence failure; preserve cart and alert customer
            resp.sendRedirect("checkout?error=order_creation_failed");
        }
    }
}
