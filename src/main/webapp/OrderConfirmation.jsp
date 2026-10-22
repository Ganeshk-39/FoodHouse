<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat, com.tap.model.Order, com.tap.model.OrderItem, com.tap.model.Restaurant, com.tap.model.Menu, com.tap.model.User" %>

<%--
    ========================================================================
    FILE: OrderConfirmation.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Dedicated Ultra-Premium Order Confirmation & Success Page.
                 FoodHouse Midnight Luxury Theme with dynamic dark/light mode,
                 festive celebration accents, itemized order breakdown, live
                 payment verification details, and direct tracking link.
    ========================================================================
--%>

<%
    Order order = (Order) request.getAttribute("order");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");
    User user = (User) request.getAttribute("user");

    if (order == null) {
        response.sendRedirect("orders");
        return;
    }

    String restName = (restaurant != null && restaurant.getName() != null) ? restaurant.getName() : "FoodHouse Partner Kitchen";
    String restCuisine = (restaurant != null && restaurant.getCuisineType() != null) ? restaurant.getCuisineType() : "Gourmet Specialties";
    String restImg = (restaurant != null && restaurant.getImagePath() != null) ? restaurant.getImagePath() : "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=400&q=80";

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String orderTimeFormatted = (order.getOrderDate() != null) ? dateFormat.format(order.getOrderDate()) : "Just Now";

    String paymentModeRaw = (order.getPaymentMode() != null) ? order.getPaymentMode() : "Cash on Delivery";
    boolean isCOD = paymentModeRaw.toLowerCase().contains("cash on delivery") || paymentModeRaw.equalsIgnoreCase("cod");

    String paymentMethodDisplay = isCOD ? "Cash on Delivery" : "Online Gateway (Razorpay)";
    String paymentRefDisplay = "N/A";
    if (paymentModeRaw.contains("(") && paymentModeRaw.contains(")")) {
        int start = paymentModeRaw.indexOf('(');
        int end = paymentModeRaw.indexOf(')');
        if (start < end) {
            paymentRefDisplay = paymentModeRaw.substring(start + 1, end).trim();
            paymentMethodDisplay = paymentModeRaw.substring(0, start).trim();
        }
    } else if (!isCOD) {
        paymentMethodDisplay = paymentModeRaw;
    }

    String paymentStatusBadge = isCOD ? "Payable on Doorstep" : "Paid & Verified";
    String paymentStatusColor = isCOD ? "#fbbf24" : "#10b981";

    double itemsSubtotal = 0.0;
    int totalItemsCount = 0;
    if (orderItems != null) {
        for (OrderItem oi : orderItems) {
            itemsSubtotal += oi.getItemTotal();
            totalItemsCount += oi.getQuantity();
        }
    }

    double finalTotal = order.getTotalAmount();
    double deliveryFee = (itemsSubtotal >= 500.0) ? 0.0 : 40.0;
    double tax = itemsSubtotal * 0.05;
    double discount = (itemsSubtotal >= 299.0) ? (itemsSubtotal * 0.20) : 0.0;
    double tip = Math.max(0.0, finalTotal - (itemsSubtotal + deliveryFee + tax - discount));
    if (tip < 0.5) tip = 0.0;

    String customerAddress = (user != null && user.getAddress() != null && !user.getAddress().trim().isEmpty())
            ? user.getAddress() : "Customer Delivery Address on File";
    String customerPhone = (user != null && user.getPhone() != null && !user.getPhone().trim().isEmpty())
            ? user.getPhone() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Order #ORD-<%= order.getOrderId() %> Confirmed</title>
    
    <%-- Google Fonts: Plus Jakarta Sans --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <script>
        (function() {
            var theme = localStorage.getItem('foodhouse_theme') || 'dark';
            document.documentElement.setAttribute('data-theme', theme);
            // Clean up temporary checkout tip from localStorage
            try {
                localStorage.removeItem('foodhouse_tip');
            } catch (e) {}
        })();
    </script>

    <style>
        /* ====================================================================
           1. CSS CUSTOM PROPERTIES - FOODHOUSE MIDNIGHT LUXURY THEME
           ==================================================================== */
        :root {
            --bg-body: #0a0e17;
            --bg-card: rgba(17, 24, 39, 0.75);
            --bg-card-hover: rgba(26, 36, 56, 0.95);
            --bg-glass: rgba(15, 23, 42, 0.85);

            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.4);

            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.35);
            --primary-light: rgba(255, 75, 90, 0.15);

            --accent-gold: #fbbf24;
            --accent-green: #10b981;
            --accent-blue: #38bdf8;
            --accent-purple: #a855f7;

            --text-main: #ffffff;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;

            --shadow-sm: 0 4px 12px rgba(0, 0, 0, 0.3);
            --shadow-md: 0 12px 30px rgba(0, 0, 0, 0.45);
            --shadow-lg: 0 20px 45px rgba(0, 0, 0, 0.6);
            --shadow-glow: 0 10px 25px var(--primary-glow);

            --radius-xl: 20px;
            --radius-lg: 14px;
            --radius-md: 10px;
            --radius-pill: 9999px;

            --transition: all 0.28s cubic-bezier(0.16, 1, 0.3, 1);
        }

        /* Light Theme Overrides */
        [data-theme="light"] {
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --bg-card-hover: #f1f5f9;
            --bg-glass: rgba(255, 255, 255, 0.94);

            --border-subtle: rgba(15, 23, 42, 0.08);
            --border-hover: rgba(255, 75, 90, 0.5);

            --text-main: #0f172a;
            --text-secondary: #475569;
            --text-muted: #64748b;

            --shadow-sm: 0 4px 14px rgba(15, 23, 42, 0.06);
            --shadow-md: 0 10px 25px rgba(15, 23, 42, 0.08);
            --shadow-lg: 0 20px 40px rgba(15, 23, 42, 0.12);
        }

        /* ================= BASE STYLES ================= */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-image:
                radial-gradient(at 0% 0%, rgba(16, 185, 129, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(255, 75, 90, 0.06) 0px, transparent 50%),
                radial-gradient(at 50% 20%, rgba(56, 189, 248, 0.05) 0px, transparent 40%);
            background-attachment: fixed;
            -webkit-font-smoothing: antialiased;
        }

        /* ================= NAVBAR ================= */
        .navbar {
            background: var(--bg-glass);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--border-subtle);
            position: sticky;
            top: 0;
            z-index: 100;
            padding: 14px 0;
        }

        .nav-container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: var(--text-main);
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand-logo-icon {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff758c 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 15px var(--primary-glow);
        }

        .brand-logo span {
            color: var(--primary);
        }

        .nav-right-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .theme-toggle-btn {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            width: 38px;
            height: 38px;
            border-radius: var(--radius-pill);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-main);
            cursor: pointer;
            transition: var(--transition);
        }

        .theme-toggle-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
            transform: scale(1.05);
        }

        [data-theme="dark"] .theme-icon-light { display: none; }
        [data-theme="light"] .theme-icon-dark { display: none; }

        /* ================= MAIN CONTAINER ================= */
        .container {
            max-width: 900px;
            margin: 32px auto 60px;
            padding: 0 20px;
            width: 100%;
        }

        /* Hero Success Banner Card */
        .success-hero {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.12) 0%, rgba(6, 78, 59, 0.35) 100%);
            border: 1.5px solid rgba(16, 185, 129, 0.4);
            border-radius: var(--radius-xl);
            padding: 36px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(16, 185, 129, 0.15);
            margin-bottom: 28px;
            animation: fadeInDown 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .success-icon-wrap {
            width: 76px;
            height: 76px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 10px 30px rgba(16, 185, 129, 0.5), inset 0 2px 4px rgba(255, 255, 255, 0.3);
            margin-bottom: 18px;
            animation: popScale 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        .hero-title {
            font-size: 28px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.6px;
            margin-bottom: 8px;
        }

        [data-theme="light"] .hero-title {
            color: #064e3b;
        }

        .hero-subtitle {
            font-size: 15px;
            color: var(--text-secondary);
            max-width: 540px;
            margin: 0 auto 18px;
            line-height: 1.5;
        }

        .order-meta-pills {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .order-id-badge {
            background: rgba(0, 0, 0, 0.35);
            border: 1px solid rgba(255, 255, 255, 0.15);
            padding: 6px 16px;
            border-radius: var(--radius-pill);
            font-size: 13.5px;
            font-weight: 700;
            color: var(--accent-gold);
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .eta-pill {
            background: rgba(16, 185, 129, 0.2);
            border: 1px solid rgba(16, 185, 129, 0.4);
            padding: 6px 16px;
            border-radius: var(--radius-pill);
            font-size: 13.5px;
            font-weight: 700;
            color: #10b981;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        /* Order Breakdown Grid */
        .confirmation-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 840px) {
            .confirmation-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Cards */
        .conf-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            backdrop-filter: blur(10px);
            margin-bottom: 24px;
        }

        .card-header-line {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border-subtle);
            margin-bottom: 18px;
        }

        .card-title {
            font-size: 16px;
            font-weight: 800;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-title-icon {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: rgba(255, 75, 90, 0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
        }

        /* Restaurant Mini Banner */
        .rest-info-bar {
            display: flex;
            align-items: center;
            gap: 16px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 14px 16px;
            margin-bottom: 20px;
        }

        .rest-avatar {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            object-fit: cover;
            border: 1px solid var(--border-subtle);
        }

        .rest-name-text {
            font-size: 15.5px;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 2px;
        }

        .rest-cuisine-text {
            font-size: 12.5px;
            color: var(--text-muted);
        }

        /* Itemized Food List */
        .order-items-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 20px;
        }

        .order-item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 14px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            transition: var(--transition);
        }

        .order-item-row:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.15);
        }

        .item-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .item-qty-tag {
            background: rgba(255, 75, 90, 0.15);
            color: var(--primary);
            font-size: 12px;
            font-weight: 800;
            padding: 3px 8px;
            border-radius: 6px;
        }

        .item-name-text {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-main);
        }

        .item-price-text {
            font-size: 14px;
            font-weight: 800;
            color: var(--accent-gold);
        }

        /* Financial Breakdown Rows */
        .bill-calc-section {
            border-top: 1px dashed var(--border-subtle);
            padding-top: 16px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .bill-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13.5px;
            color: var(--text-secondary);
        }

        .bill-row.discount {
            color: var(--accent-green);
            font-weight: 700;
        }

        .bill-total-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 10px;
            padding-top: 14px;
            border-top: 2px solid var(--border-subtle);
        }

        .bill-total-label {
            font-size: 16px;
            font-weight: 800;
            color: var(--text-main);
        }

        .bill-total-val {
            font-size: 22px;
            font-weight: 800;
            color: var(--accent-gold);
            background: linear-gradient(135deg, var(--accent-gold) 0%, #f59e0b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Right Column Side Info */
        .info-block {
            margin-bottom: 18px;
        }

        .info-label {
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        .info-val-highlight {
            font-size: 14.5px;
            font-weight: 700;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
        }

        .status-badge.paid {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.35);
        }

        .status-badge.pending {
            background: rgba(251, 191, 36, 0.15);
            color: #fbbf24;
            border: 1px solid rgba(251, 191, 36, 0.35);
        }

        /* Delivery Partner ETA Card */
        .eta-card {
            background: linear-gradient(135deg, rgba(56, 189, 248, 0.1) 0%, rgba(3, 105, 161, 0.2) 100%);
            border: 1.5px solid rgba(56, 189, 248, 0.35);
            border-radius: var(--radius-xl);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }

        .eta-icon-pulse {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: rgba(56, 189, 248, 0.2);
            color: var(--accent-blue);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
            animation: pulseGlow 2s infinite;
        }

        .eta-title {
            font-size: 15px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 2px;
        }

        [data-theme="light"] .eta-title {
            color: #0369a1;
        }

        .eta-desc {
            font-size: 12.5px;
            color: var(--text-secondary);
        }

        /* Action Buttons */
        .actions-wrap {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 10px;
        }

        .btn-track-order {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 16px 24px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff;
            font-size: 15px;
            font-weight: 800;
            border-radius: var(--radius-pill);
            text-decoration: none;
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.35);
            transition: var(--transition);
        }

        .btn-track-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(16, 185, 129, 0.5);
            color: #ffffff;
        }

        .btn-continue-shopping {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            padding: 14px 24px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-subtle);
            color: var(--text-main);
            font-size: 14.5px;
            font-weight: 700;
            border-radius: var(--radius-pill);
            text-decoration: none;
            transition: var(--transition);
        }

        .btn-continue-shopping:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
        }

        /* Animations */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes popScale {
            0% { transform: scale(0.5); opacity: 0; }
            70% { transform: scale(1.15); }
            100% { transform: scale(1); opacity: 1; }
        }

        @keyframes pulseGlow {
            0%, 100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(56, 189, 248, 0.4); }
            50% { transform: scale(1.05); box-shadow: 0 0 0 10px rgba(56, 189, 248, 0); }
        }
    </style>
</head>
<body>

    <!-- ================= NAVBAR ================= -->
    <header class="navbar">
        <div class="nav-container">
            <a href="restaurant" class="brand-logo">
                <div class="brand-logo-icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                        <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                        <line x1="6" y1="1" x2="6" y2="4"></line>
                        <line x1="10" y1="1" x2="10" y2="4"></line>
                        <line x1="14" y1="1" x2="14" y2="4"></line>
                    </svg>
                </div>
                <div>Food<span>House</span></div>
            </a>

            <div class="nav-right-actions">
                <a href="restaurant" class="btn-continue-shopping" style="padding: 8px 18px; font-size: 13px;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                    <span>Browse Menu</span>
                </a>

                <button type="button" class="theme-toggle-btn" onclick="toggleTheme()" title="Toggle Dark / Light Mode" aria-label="Toggle Theme">
                    <span class="theme-icon-dark">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
                    </span>
                    <span class="theme-icon-light">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>
                    </span>
                </button>
            </div>
        </div>
    </header>

    <!-- ================= MAIN CONTENT ================= -->
    <main class="container">

        <!-- 1. HERO SUCCESS BANNER -->
        <section class="success-hero">
            <div class="success-icon-wrap">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>
            <h1 class="hero-title">Order Placed Successfully!</h1>
            <p class="hero-subtitle">
                Thank you! Your payment was verified and the kitchen is preparing your meal with care.
            </p>
            <div class="order-meta-pills">
                <span class="order-id-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                    ORDER ID: #ORD-<%= order.getOrderId() %>
                </span>
                <span class="eta-pill">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    Estimated Delivery: 20–25 minutes
                </span>
            </div>
        </section>

        <!-- 2. TWO-COLUMN DETAILS GRID -->
        <div class="confirmation-grid">

            <!-- LEFT COLUMN: Restaurant, Items & Bill Summary -->
            <div class="left-col">
                <div class="conf-card">
                    <div class="card-header-line">
                        <div class="card-title">
                            <span class="card-title-icon">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path></svg>
                            </span>
                            <span>Kitchen & Ordered Items</span>
                        </div>
                        <span style="font-size:12.5px; color:var(--text-muted); font-weight:700;"><%= totalItemsCount %> <%= totalItemsCount == 1 ? "Item" : "Items" %></span>
                    </div>

                    <!-- Restaurant Mini Card -->
                    <div class="rest-info-bar">
                        <img src="<%= restImg %>" alt="<%= restName %>" class="rest-avatar"
                             onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=400&q=80';">
                        <div>
                            <div class="rest-name-text"><%= restName %></div>
                            <div class="rest-cuisine-text"><%= restCuisine %> &bull; Fast Preparation</div>
                        </div>
                    </div>

                    <!-- Itemized Dishes -->
                    <div class="order-items-list">
                        <% if (orderItems != null && !orderItems.isEmpty()) { 
                            for (OrderItem item : orderItems) {
                                Menu menuItem = (menuMap != null) ? menuMap.get(item.getMenuId()) : null;
                                String itemName = (menuItem != null && menuItem.getItemName() != null) ? menuItem.getItemName() : "Dish #" + item.getMenuId();
                        %>
                            <div class="order-item-row">
                                <div class="item-left">
                                    <span class="item-qty-tag">&times;<%= item.getQuantity() %></span>
                                    <span class="item-name-text"><%= itemName %></span>
                                </div>
                                <span class="item-price-text">&#8377; <%= String.format("%.0f", item.getItemTotal()) %></span>
                            </div>
                        <%  } 
                           } else { %>
                            <div style="font-size:13px; color:var(--text-muted); text-align:center; padding:12px;">Items recorded on file</div>
                        <% } %>
                    </div>

                    <!-- Financial Summary Breakdown -->
                    <div class="bill-calc-section">
                        <div class="bill-row">
                            <span>Dishes Subtotal</span>
                            <span>&#8377; <%= String.format("%.0f", itemsSubtotal) %></span>
                        </div>
                        <div class="bill-row">
                            <span>Delivery Partner Fee</span>
                            <span><%= (deliveryFee == 0.0) ? "<strong style='color:var(--accent-green);'>FREE</strong>" : "&#8377; " + String.format("%.0f", deliveryFee) %></span>
                        </div>
                        <div class="bill-row">
                            <span>Taxes & Restaurant Packaging</span>
                            <span>&#8377; <%= String.format("%.0f", tax) %></span>
                        </div>
                        <% if (discount > 0) { %>
                            <div class="bill-row discount">
                                <span>Promotional Discount (20% OFF)</span>
                                <span>- &#8377; <%= String.format("%.0f", discount) %></span>
                            </div>
                        <% } %>
                        <% if (tip > 0) { %>
                            <div class="bill-row" style="color:var(--accent-gold); font-weight:700;">
                                <span>Delivery Partner Tip</span>
                                <span>+ &#8377; <%= String.format("%.0f", tip) %></span>
                            </div>
                        <% } %>

                        <div class="bill-total-row">
                            <span class="bill-total-label">Final Amount Paid</span>
                            <span class="bill-total-val">&#8377; <%= String.format("%.0f", finalTotal) %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN: Payment, Live ETA & Actions -->
            <div class="right-col">
                
                <!-- 20-25 Mins Live ETA Card -->
                <div class="eta-card">
                    <div class="eta-icon-pulse">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                    </div>
                    <div>
                        <div class="eta-title">Estimated: 20–25 minutes</div>
                        <div class="eta-desc">Delivery partner will be assigned once food is ready</div>
                    </div>
                </div>

                <!-- Payment & Verification Details Card -->
                <div class="conf-card">
                    <div class="card-header-line">
                        <div class="card-title">
                            <span class="card-title-icon" style="background:rgba(56,189,248,0.15); color:var(--accent-blue);">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="2" y="5" width="20" height="14" rx="2"></rect><line x1="2" y1="10" x2="22" y2="10"></line></svg>
                            </span>
                            <span>Payment & Order Meta</span>
                        </div>
                    </div>

                    <div class="info-block">
                        <div class="info-label">Payment Mode</div>
                        <div class="info-val-highlight">
                            <span><%= paymentMethodDisplay %></span>
                        </div>
                    </div>

                    <div class="info-block">
                        <div class="info-label">Payment Status</div>
                        <div>
                            <span class="status-badge <%= isCOD ? "pending" : "paid" %>">
                                <span style="width:6px; height:6px; border-radius:50%; background:<%= paymentStatusColor %>; display:inline-block;"></span>
                                <%= paymentStatusBadge %>
                            </span>
                        </div>
                    </div>

                    <% if (!isCOD && paymentRefDisplay != null && !paymentRefDisplay.equals("N/A")) { %>
                        <div class="info-block">
                            <div class="info-label">Payment Reference</div>
                            <div style="font-size:12.5px; font-family:monospace; color:var(--accent-blue); background:rgba(56,189,248,0.1); padding:4px 8px; border-radius:6px; display:inline-block;">
                                <%= paymentRefDisplay %>
                            </div>
                        </div>
                    <% } %>

                    <div class="info-block">
                        <div class="info-label">Placed At</div>
                        <div class="info-val-highlight" style="font-size:13.5px; color:var(--text-secondary);">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            <span><%= orderTimeFormatted %></span>
                        </div>
                    </div>

                    <div class="info-block" style="margin-bottom:0;">
                        <div class="info-label">Delivery Address</div>
                        <div style="font-size:13.5px; color:var(--text-secondary); line-height:1.45;">
                            <%= customerAddress %>
                            <% if (!customerPhone.isEmpty()) { %>
                                <div style="margin-top:4px; font-size:12px; color:var(--text-muted);">
                                    Contact: <strong><%= customerPhone %></strong>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Action Navigation Buttons -->
                <div class="actions-wrap">
                    <a href="orders?orderId=<%= order.getOrderId() %>#order-card-<%= order.getOrderId() %>" class="btn-track-order" id="btnTrackMyOrder">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                        <span>Track My Order</span>
                    </a>

                    <a href="restaurant" class="btn-continue-shopping" id="btnContinueShopping">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                        <span>Continue Shopping</span>
                    </a>
                </div>

            </div>

        </div>

    </main>

    <script>
        function toggleTheme() {
            var current = document.documentElement.getAttribute('data-theme') || 'dark';
            var target = (current === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', target);
            localStorage.setItem('foodhouse_theme', target);
        }
    </script>

</body>
</html>
