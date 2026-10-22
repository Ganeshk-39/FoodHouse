package com.tap.util;

import java.sql.Timestamp;
import java.util.List;

import com.tap.DAO.OrderDAO;
import com.tap.model.Order;

/**
 * Manages the order tracking lifecycle for FoodHouse orders.
 * 
 * Realistic Delivery Timeline:
 * 1. CONFIRMED: Immediately after successful order placement (< 2 minutes)
 * 2. ACCEPTED: After 2 minutes
 * 3. FOOD READY: After 5 minutes
 * 4. ON THE WAY: After 10 minutes
 * 5. DELIVERED: After 20–25 minutes from order placement
 * 
 * Supports configurable timings for testing and demonstrations.
 * Enforces forward-only transitions, respects terminal statuses,
 * and ensures DB persistence in MySQL.
 */
public class OrderLifecycleManager {

    // Standard Production Timeline Thresholds (in minutes)
    public static final long DEFAULT_MINUTES_ACCEPTED = 2;
    public static final long DEFAULT_MINUTES_FOOD_READY = 5;
    public static final long DEFAULT_MINUTES_ON_THE_WAY = 10;
    public static final long DEFAULT_MINUTES_DELIVERED = 20;

    // Fast-Demo Timeline Thresholds (in seconds) for rapid testing/evaluations
    public static final long FAST_SECONDS_ACCEPTED = 15;
    public static final long FAST_SECONDS_FOOD_READY = 30;
    public static final long FAST_SECONDS_ON_THE_WAY = 50;
    public static final long FAST_SECONDS_DELIVERED = 75;

    // Status Names
    public static final String STATUS_CONFIRMED = "Confirmed";
    public static final String STATUS_ACCEPTED = "Accepted";
    public static final String STATUS_FOOD_READY = "Food Ready";
    public static final String STATUS_ON_THE_WAY = "On The Way";
    public static final String STATUS_DELIVERED = "Delivered";
    public static final String STATUS_CANCELLED = "Cancelled";
    public static final String STATUS_REFUNDED = "Refunded";

    // Configurable flags
    private static volatile boolean testFastMode = false;
    private static volatile double customTimeMultiplier = 1.0;

    public static boolean isTestFastMode() {
        return testFastMode;
    }

    public static void setTestFastMode(boolean fast) {
        testFastMode = fast;
    }

    public static void setCustomTimeMultiplier(double multiplier) {
        if (multiplier > 0) {
            customTimeMultiplier = multiplier;
        }
    }

    public static double getCustomTimeMultiplier() {
        return customTimeMultiplier;
    }

    /**
     * Maps a status string to its 1-indexed stage number (1 through 5).
     */
    public static int getStageNumber(String status) {
        if (status == null) return 1;
        String s = status.trim().toLowerCase();
        if (s.equals("delivered")) return 5;
        if (s.equals("on the way") || s.equals("out for delivery")) return 4;
        if (s.equals("food ready") || s.equals("ready")) return 3;
        if (s.equals("accepted")) return 2;
        if (s.equals("confirmed") || s.equals("placed")) return 1;
        if (s.equals("cancelled") || s.equals("refunded")) return -1;
        return 1;
    }

    /**
     * Checks if an order status is terminal (cannot transition further).
     */
    public static boolean isTerminalStatus(String status) {
        if (status == null) return false;
        String s = status.trim().toLowerCase();
        return s.equals("delivered") || s.equals("cancelled") || s.equals("refunded");
    }

    /**
     * Checks if an order has a failed or unpaid payment.
     */
    public static boolean isUnpaidOrFailed(String paymentMode) {
        if (paymentMode == null) return false;
        String p = paymentMode.trim().toLowerCase();
        return p.contains("fail") || p.contains("unpaid") || p.contains("declined");
    }

    /**
     * Computes the appropriate lifecycle status given the elapsed milliseconds.
     */
    public static String computeStatusForElapsed(long elapsedMillis, String currentStatus) {
        if (isTerminalStatus(currentStatus)) {
            return currentStatus;
        }

        if (testFastMode) {
            long elapsedSeconds = (long) ((elapsedMillis / 1000.0) * customTimeMultiplier);
            if (elapsedSeconds >= FAST_SECONDS_DELIVERED) {
                return STATUS_DELIVERED;
            } else if (elapsedSeconds >= FAST_SECONDS_ON_THE_WAY) {
                return STATUS_ON_THE_WAY;
            } else if (elapsedSeconds >= FAST_SECONDS_FOOD_READY) {
                return STATUS_FOOD_READY;
            } else if (elapsedSeconds >= FAST_SECONDS_ACCEPTED) {
                return STATUS_ACCEPTED;
            } else {
                return STATUS_CONFIRMED;
            }
        }

        long elapsedMinutes = (long) ((elapsedMillis / (60.0 * 1000.0)) * customTimeMultiplier);
        if (elapsedMinutes >= DEFAULT_MINUTES_DELIVERED) {
            return STATUS_DELIVERED;
        } else if (elapsedMinutes >= DEFAULT_MINUTES_ON_THE_WAY) {
            return STATUS_ON_THE_WAY;
        } else if (elapsedMinutes >= DEFAULT_MINUTES_FOOD_READY) {
            return STATUS_FOOD_READY;
        } else if (elapsedMinutes >= DEFAULT_MINUTES_ACCEPTED) {
            return STATUS_ACCEPTED;
        } else {
            return STATUS_CONFIRMED;
        }
    }

    /**
     * Returns a customer-facing description for the given stage.
     */
    public static String getStatusDescription(String status) {
        int stage = getStageNumber(status);
        switch (stage) {
            case 2:
                return "Kitchen accepted order & cooking food";
            case 3:
                return "Dishes packed & ready for delivery partner";
            case 4:
                return "Delivery partner on the way to your address";
            case 5:
                return "Delivered safely to customer doorstep";
            case -1:
                return "Order has been cancelled / refunded";
            case 1:
            default:
                return "Order placed & confirmed";
        }
    }

    /**
     * Returns progress bar fill percentage (10% to 100%).
     */
    public static int getFillPercent(int stage) {
        switch (stage) {
            case 1: return 10;
            case 2: return 32;
            case 3: return 58;
            case 4: return 82;
            case 5: return 100;
            default: return 0;
        }
    }

    /**
     * Evaluates an individual order against the current time.
     * If the order has progressed, safely updates MySQL and the Order model object.
     * Prevents backward transitions and respects terminal statuses.
     */
    public static String evaluateAndUpdateOrder(Order order, OrderDAO orderDAO) {
        if (order == null) return STATUS_CONFIRMED;
        
        String curStatus = order.getStatus();
        if (curStatus == null || curStatus.trim().isEmpty()) {
            curStatus = STATUS_CONFIRMED;
        }

        if (isTerminalStatus(curStatus)) {
            return curStatus;
        }

        if (isUnpaidOrFailed(order.getPaymentMode())) {
            return curStatus;
        }

        Timestamp orderDate = order.getOrderDate();
        if (orderDate == null) {
            return curStatus;
        }

        long elapsedMillis = System.currentTimeMillis() - orderDate.getTime();
        if (elapsedMillis < 0) {
            elapsedMillis = 0;
        }

        String targetStatus = computeStatusForElapsed(elapsedMillis, curStatus);
        int curStage = getStageNumber(curStatus);
        int targetStage = getStageNumber(targetStatus);

        // Forward-only transition
        if (targetStage > curStage) {
            if (orderDAO != null) {
                orderDAO.updateOrderStatus(order.getOrderId(), targetStatus);
            }
            order.setStatus(targetStatus);
            return targetStatus;
        }

        return curStatus;
    }

    /**
     * Batch evaluates a list of orders (e.g. on order history page load).
     * Automatically repairs existing orders that were stuck on Confirmed.
     */
    public static void reconcileAllOrders(List<Order> orders, OrderDAO orderDAO) {
        if (orders == null || orders.isEmpty()) return;
        for (Order order : orders) {
            evaluateAndUpdateOrder(order, orderDAO);
        }
    }
}
