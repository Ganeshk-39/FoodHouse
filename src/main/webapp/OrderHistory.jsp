<%-- 
    ========================================================================
    FILE: OrderHistory.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Ultra-Premium Midnight Luxury Theme for Past Orders & Records.
                 Features pure inline SVG icons, rich order cards, status badges,
                 reorder action buttons, and responsive layout.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.tap.model.Order, com.tap.model.OrderItem, com.tap.model.Menu, com.tap.model.Restaurant, com.tap.model.User, com.tap.model.Cart, com.tap.model.CartItem, com.tap.util.OrderLifecycleManager" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | My Orders & Records</title>
    
    <%-- Google Fonts: Plus Jakarta Sans --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <script>
        (function() {
            var theme = localStorage.getItem('foodhouse_theme') || 'dark';
            document.documentElement.setAttribute('data-theme', theme);
        })();
    </script>

    <style>
        :root {
            --bg-body: #0a0e17;
            --bg-card: rgba(17, 24, 39, 0.75);
            --bg-card-hover: rgba(26, 36, 56, 0.95);
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.4);
            
            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.35);
            --primary-light: rgba(255, 75, 90, 0.12);
            
            --accent-gold: #fbbf24;
            --accent-green: #10b981;
            --accent-blue: #38bdf8;
            
            --text-main: #ffffff;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            
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
            
            --border-subtle: rgba(15, 23, 42, 0.08);
            --border-hover: rgba(255, 75, 90, 0.5);
            
            --text-main: #0f172a;
            --text-secondary: #475569;
            --text-muted: #64748b;
            
            --shadow-sm: 0 4px 14px rgba(15, 23, 42, 0.06);
            --shadow-md: 0 10px 25px rgba(15, 23, 42, 0.08);
            --shadow-lg: 0 20px 40px rgba(15, 23, 42, 0.12);
        }

        [data-theme="light"] body {
            background-color: #f8fafc;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.06) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.05) 0px, transparent 50%);
            color: #0f172a;
        }

        [data-theme="light"] .navbar {
            background: rgba(255, 255, 255, 0.92);
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        [data-theme="light"] .brand-logo {
            color: #0f172a;
        }

        [data-theme="light"] .btn-explore {
            background: rgba(0, 0, 0, 0.04);
            color: #1e293b;
            border-color: rgba(0, 0, 0, 0.12);
        }

        [data-theme="light"] .page-title,
        [data-theme="light"] .rest-title {
            color: #0f172a !important;
        }

        [data-theme="light"] .order-card {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.08);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
        }

        [data-theme="light"] .order-date-text {
            color: #64748b;
        }

        [data-theme="light"] .payment-pill {
            background: rgba(0, 0, 0, 0.04);
            border-color: rgba(0, 0, 0, 0.1);
            color: #475569;
        }

        [data-theme="light"] .order-total-amount {
            color: #d97706;
        }

        [data-theme="light"] .theme-icon-light { display: flex; align-items: center; justify-content: center; }
        [data-theme="light"] .theme-icon-dark { display: none; }
        [data-theme="light"] .theme-toggle-btn {
            background: rgba(0, 0, 0, 0.04);
            border-color: rgba(0, 0, 0, 0.12);
            color: #d97706;
        }

        /* Theme Toggle Button */
        .theme-toggle-btn {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.06);
            border: 1.5px solid var(--border-subtle);
            color: var(--accent-gold);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
            padding: 0;
            flex-shrink: 0;
        }

        .theme-toggle-btn:hover {
            background: rgba(251, 191, 36, 0.18);
            border-color: var(--accent-gold);
            transform: rotate(20deg) scale(1.08);
            box-shadow: 0 4px 12px rgba(251, 191, 36, 0.3);
        }

        .theme-icon-light { display: none; }
        .theme-icon-dark { display: flex; align-items: center; justify-content: center; }

        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg-body);
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.05) 0px, transparent 50%);
            color: var(--text-main);
            min-height: 100vh;
            padding-bottom: 80px;
        }

        .navbar {
            background: rgba(10, 14, 23, 0.88);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border-subtle);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #ffffff;
        }

        .brand-logo-icon {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff7675 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 12px var(--primary-glow);
        }

        .brand-logo span {
            color: var(--primary);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 18px;
            border-radius: var(--radius-pill);
            font-size: 13.5px;
            font-weight: 700;
            text-decoration: none;
            transition: var(--transition);
            border: 1.5px solid transparent;
        }

        .btn-explore {
            background: rgba(255, 255, 255, 0.05);
            color: #ffffff;
            border-color: var(--border-subtle);
        }

        .btn-explore:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.25);
        }

        .btn-cart {
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .btn-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(255, 75, 90, 0.55);
        }

        .cart-badge {
            background: #ffffff;
            color: var(--primary);
            font-size: 11px;
            font-weight: 800;
            padding: 2px 7px;
            border-radius: var(--radius-pill);
            margin-left: 2px;
        }

        .user-profile-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: rgba(16, 185, 129, 0.12);
            border: 1.5px solid rgba(16, 185, 129, 0.35);
            padding: 5px 14px 5px 6px;
            border-radius: var(--radius-pill);
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 700;
        }

        .user-avatar-circle {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--accent-green);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 800;
        }

        .btn-logout {
            color: var(--text-muted);
            margin-left: 4px;
            font-size: 12px;
            text-decoration: none;
            padding: 4px 8px;
            border-radius: var(--radius-pill);
            transition: var(--transition);
        }

        .btn-logout:hover {
            background: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
        }

        /* Container */
        .container {
            max-width: 1000px;
            margin: 40px auto 0;
            padding: 0 24px;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .orders-count-badge {
            background: var(--primary-light);
            color: var(--primary);
            font-size: 13px;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            border: 1px solid rgba(255, 75, 90, 0.3);
        }

        /* Order Cards */
        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .order-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 24px;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .order-card:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
        }

        .order-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border-subtle);
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .order-meta-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .order-id-badge {
            background: rgba(255, 255, 255, 0.06);
            color: #ffffff;
            font-size: 13px;
            font-weight: 800;
            padding: 5px 12px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-subtle);
            letter-spacing: 0.5px;
        }

        .order-date-text {
            color: var(--text-secondary);
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .order-status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-confirmed, .status-delivered {
            background: rgba(16, 185, 129, 0.15);
            color: var(--accent-green);
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.15);
            color: var(--accent-gold);
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .order-card-body {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
        }

        .rest-info-group {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .rest-thumb {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            object-fit: cover;
            border: 1px solid var(--border-subtle);
        }

        .rest-title {
            font-size: 17px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 4px;
        }

        .rest-cuisine {
            font-size: 13px;
            color: var(--text-secondary);
        }

        .order-financials {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
        }

        .payment-pill {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            padding: 6px 12px;
            border-radius: var(--radius-pill);
            font-size: 12px;
            color: var(--text-secondary);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .order-total-amount {
            font-size: 20px;
            font-weight: 800;
            color: var(--accent-gold);
            letter-spacing: -0.3px;
        }

        .btn-reorder {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            font-size: 13px;
            font-weight: 800;
            padding: 10px 18px;
            border-radius: var(--radius-pill);
            text-decoration: none;
            box-shadow: 0 4px 12px var(--primary-glow);
            transition: var(--transition);
        }

        .btn-reorder:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 75, 90, 0.55);
        }

        /* Empty State */
        .empty-orders-box {
            text-align: center;
            padding: 60px 24px;
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            border: 1px dashed var(--border-subtle);
        }

        .empty-icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--primary-light);
            color: var(--primary);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 22px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .empty-desc {
            color: var(--text-secondary);
            font-size: 14px;
            max-width: 400px;
            margin: 0 auto 24px;
        }

        /* Live Order Status Pipeline Tracker */
        .live-tracker-box {
            margin: 18px 0 6px;
            padding: 16px 20px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
        }

        .tracker-pipeline {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            margin: 14px 10px 6px;
        }

        .tracker-progress-bar {
            position: absolute;
            top: 14px;
            left: 20px;
            right: 20px;
            height: 3px;
            background: rgba(255, 255, 255, 0.1);
            z-index: 1;
        }

        .tracker-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #10b981, #38bdf8, #fbbf24);
            transition: width 0.4s ease;
        }

        .tracker-step-node {
            position: relative;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            text-align: center;
        }

        .tracker-step-circle {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #111827;
            border: 2px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 800;
            color: var(--text-muted);
            transition: var(--transition);
        }

        .tracker-step-circle.completed {
            background: #10b981;
            border-color: #10b981;
            color: #ffffff;
            box-shadow: 0 0 10px rgba(16, 185, 129, 0.4);
        }

        .tracker-step-circle.active {
            background: #38bdf8;
            border-color: #38bdf8;
            color: #ffffff;
            box-shadow: 0 0 12px rgba(56, 189, 248, 0.6);
            animation: pulseGlow 1.5s infinite;
        }

        .tracker-step-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            max-width: 80px;
            white-space: nowrap;
        }

        .tracker-step-label.active-label {
            color: var(--text-main);
            font-weight: 800;
        }

        @keyframes pulseGlow {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
    </style>
</head>
<body style="background-color: #0a0e17; color: #ffffff;">

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
        Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");
        Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");
        User user = (User) session.getAttribute("user");
        if (user == null) user = (User) session.getAttribute("loggedInUser");

        Cart navCart = (Cart) session.getAttribute("cart");
        int navCartCount = 0;
        if (navCart != null && navCart.getItems() != null) {
            for (CartItem ci : navCart.getItems().values()) {
                navCartCount += ci.getQuantity();
            }
        }

        int totalOrders = (orders != null) ? orders.size() : 0;
    %>

    <!-- Navbar -->
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

            <div class="nav-actions">
                <a href="restaurant" class="nav-btn btn-explore">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon>
                    </svg>
                    <span>Restaurants</span>
                </a>

                <a href="cart" class="nav-btn btn-cart">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="9" cy="21" r="1"></circle>
                        <circle cx="20" cy="21" r="1"></circle>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                    </svg>
                    <span>Cart</span>
                    <span class="cart-badge"><%= navCartCount %></span>
                </a>

                <% if (user != null) { 
                    String initial = (user.getUsername() != null && !user.getUsername().isEmpty()) ? user.getUsername().substring(0, 1).toUpperCase() : "U";
                    String uRole = (user.getRole() != null) ? user.getRole() : "Customer";
                    boolean isUAdmin = "admin".equalsIgnoreCase(uRole) || "restaurantadmin".equalsIgnoreCase(uRole) || "restaurant_admin".equalsIgnoreCase(uRole);
                    boolean isUDelivery = "deliveryagent".equalsIgnoreCase(uRole) || "delivery_agent".equalsIgnoreCase(uRole);
                %>
                    <a href="profile" class="nav-btn btn-explore" title="My Profile Settings">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        <span>Profile</span>
                    </a>

                    <% if (isUAdmin) { %>
                        <a href="restaurant-admin" class="nav-btn" style="background:rgba(251,191,36,0.12); color:var(--accent-gold); border-color:rgba(251,191,36,0.4);" title="Restaurant Admin Portal">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            <span>Admin</span>
                        </a>
                    <% } %>

                    <% if (isUDelivery || isUAdmin) { %>
                        <a href="delivery-admin" class="nav-btn" style="background:rgba(56,189,248,0.12); color:var(--accent-blue); border-color:rgba(56,189,248,0.4);" title="Delivery Partner Portal">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                            <span>Delivery</span>
                        </a>
                    <% } %>

                    <div class="user-profile-pill" style="cursor:pointer;" title="View Profile">
                        <a href="profile" style="text-decoration:none; color:inherit; display:flex; align-items:center; gap:8px;">
                            <div class="user-avatar-circle"><%= initial %></div>
                            <span><%= user.getUsername() %></span>
                        </a>
                        <a href="logout" class="btn-logout" title="Sign Out">Logout</a>
                    </div>
                <% } else { %>
                    <a href="Login.jsp" class="nav-btn btn-explore" title="Sign In or Register">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                            <polyline points="10 17 15 12 10 7"></polyline>
                            <line x1="15" y1="12" x2="3" y2="12"></line>
                        </svg>
                        <span>Sign In</span>
                    </a>
                <% } %>

                <!-- Theme Toggle Button -->
                <button type="button" class="theme-toggle-btn" id="themeToggleBtn" onclick="toggleTheme()" title="Toggle Dark / Light Mode" aria-label="Toggle Theme">
                    <span class="theme-icon-dark">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                        </svg>
                    </span>
                    <span class="theme-icon-light">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="5"></circle>
                            <line x1="12" y1="1" x2="12" y2="3"></line>
                            <line x1="12" y1="21" x2="12" y2="23"></line>
                            <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                            <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                            <line x1="1" y1="12" x2="3" y2="12"></line>
                            <line x1="21" y1="12" x2="23" y2="12"></line>
                            <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                            <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                        </svg>
                    </span>
                </button>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container">

        <% 
            String statusParam = request.getParameter("status");
            String orderIdParam = request.getParameter("orderId");
            if ("success".equalsIgnoreCase(statusParam)) { 
        %>
            <div style="background: rgba(16, 185, 129, 0.12); border: 1.5px solid rgba(16, 185, 129, 0.4); border-radius: var(--radius-lg); padding: 18px 24px; margin-bottom: 28px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 14px; box-shadow: 0 4px 20px rgba(16, 185, 129, 0.2);">
                <div style="display: flex; align-items: center; gap: 14px;">
                    <div style="width: 44px; height: 44px; border-radius: 50%; background: var(--accent-green); color: #ffffff; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 0 16px rgba(16, 185, 129, 0.5);">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                    </div>
                    <div>
                        <div style="font-size: 16px; font-weight: 800; color: #ffffff;">
                            Order Placed Successfully! <%= (orderIdParam != null && !orderIdParam.isEmpty()) ? "(#ORD-" + orderIdParam + ")" : "" %>
                        </div>
                        <div style="font-size: 13px; color: var(--text-secondary); margin-top: 2px;">
                            Your meal is confirmed, being prepared freshly, and will arrive in 30 minutes.
                        </div>
                    </div>
                </div>
                <a href="restaurant" class="btn-reorder" style="padding: 9px 18px; font-size: 13px;">Order More Food</a>
            </div>
        <% } %>

        <div class="page-header">
            <h1 class="page-title">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
                <span>My Order Records</span>
            </h1>
            <span class="orders-count-badge"><%= totalOrders %> Orders Placed</span>
        </div>

        <% if (orders != null && !orders.isEmpty()) { %>
            <div class="orders-list">
                <% for (Order ord : orders) { 
                    Restaurant r = (restaurantMap != null) ? restaurantMap.get(ord.getRestaurantId()) : null;
                    String restName = (r != null && r.getName() != null) ? r.getName() : "Gourmet Restaurant";
                    String restCuisine = (r != null && r.getCuisineType() != null) ? r.getCuisineType() : "Multi-Cuisine";
                    String restImg = (r != null && r.getImagePath() != null) ? r.getImagePath() : "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=300&q=80";
                    String status = (ord.getStatus() != null) ? ord.getStatus() : "Confirmed";
                    String orderDateStr = (ord.getOrderDate() != null) ? ord.getOrderDate().toString().substring(0, 16) : "Recent";
                %>
                    <div class="order-card" id="order-card-<%= ord.getOrderId() %>" data-order-id="<%= ord.getOrderId() %>" data-status="<%= status %>" data-stage="<%= OrderLifecycleManager.getStageNumber(status) %>">
                        <%
                            int stage = OrderLifecycleManager.getStageNumber(status);
                            String statusDesc = OrderLifecycleManager.getStatusDescription(status);
                            int fillPercent = OrderLifecycleManager.getFillPercent(stage);
                        %>
                        <div class="order-card-header">
                            <div class="order-meta-left">
                                <span class="order-id-badge">#ORD-<%= ord.getOrderId() %></span>
                                <span class="order-date-text">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <%= orderDateStr %>
                                </span>
                            </div>
                            <span id="order-status-badge-<%= ord.getOrderId() %>" class="order-status-badge <%= stage == 5 ? "status-delivered" : "status-confirmed" %>">
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <span class="badge-text"><%= status %></span>
                            </span>
                        </div>

                        <!-- 5-Stage Live Order Tracking Pipeline -->
                        <div class="live-tracker-box" id="live-tracker-box-<%= ord.getOrderId() %>">
                            <div style="display:flex; justify-content:space-between; align-items:center; font-size:12px; margin-bottom:6px; flex-wrap:wrap; gap:6px;">
                                <span style="font-weight:700; color:var(--text-secondary); display:flex; align-items:center; gap:6px;">
                                    <span id="live-dot-<%= ord.getOrderId() %>" style="width:8px; height:8px; border-radius:50%; background:<%= stage == 5 ? "#10b981" : "#38bdf8" %>; display:inline-block;"></span>
                                    Live Stage: <strong id="order-stage-text-<%= ord.getOrderId() %>" style="color:var(--text-main);"><%= status %></strong>
                                </span>
                                <span id="order-stage-desc-<%= ord.getOrderId() %>" style="color:var(--text-muted); font-size:11.5px;"><%= statusDesc %></span>
                            </div>
                            <div class="tracker-pipeline">
                                <div class="tracker-progress-bar">
                                    <div id="tracker-fill-<%= ord.getOrderId() %>" class="tracker-progress-fill" style="width: <%= fillPercent %>%;"></div>
                                </div>
                                <div class="tracker-step-node" id="step-node-<%= ord.getOrderId() %>-1">
                                    <div class="tracker-step-circle <%= stage >= 1 ? (stage == 1 ? "active" : "completed") : "" %>">
                                        <%= stage > 1 ? "&#10003;" : "1" %>
                                    </div>
                                    <span class="tracker-step-label <%= stage == 1 ? "active-label" : "" %>">Placed</span>
                                </div>
                                <div class="tracker-step-node" id="step-node-<%= ord.getOrderId() %>-2">
                                    <div class="tracker-step-circle <%= stage >= 2 ? (stage == 2 ? "active" : "completed") : "" %>">
                                        <%= stage > 2 ? "&#10003;" : "2" %>
                                    </div>
                                    <span class="tracker-step-label <%= stage == 2 ? "active-label" : "" %>">Accepted</span>
                                </div>
                                <div class="tracker-step-node" id="step-node-<%= ord.getOrderId() %>-3">
                                    <div class="tracker-step-circle <%= stage >= 3 ? (stage == 3 ? "active" : "completed") : "" %>">
                                        <%= stage > 3 ? "&#10003;" : "3" %>
                                    </div>
                                    <span class="tracker-step-label <%= stage == 3 ? "active-label" : "" %>">Food Ready</span>
                                </div>
                                <div class="tracker-step-node" id="step-node-<%= ord.getOrderId() %>-4">
                                    <div class="tracker-step-circle <%= stage >= 4 ? (stage == 4 ? "active" : "completed") : "" %>">
                                        <%= stage > 4 ? "&#10003;" : "4" %>
                                    </div>
                                    <span class="tracker-step-label <%= stage == 4 ? "active-label" : "" %>">On The Way</span>
                                </div>
                                <div class="tracker-step-node" id="step-node-<%= ord.getOrderId() %>-5">
                                    <div class="tracker-step-circle <%= stage >= 5 ? "completed" : "" %>">
                                        <%= stage >= 5 ? "&#10003;" : "5" %>
                                    </div>
                                    <span class="tracker-step-label <%= stage == 5 ? "active-label" : "" %>">Delivered</span>
                                </div>
                            </div>

                            <!-- Delivery Success Notification Banner for Stage 5 -->
                            <div id="delivered-banner-<%= ord.getOrderId() %>" style="<%= stage == 5 ? "display: flex;" : "display: none;" %> margin-top: 12px; padding: 10px 16px; background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.35); border-radius: var(--radius-md); align-items: center; gap: 10px; color: #10b981; font-size: 12.5px; font-weight: 700;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <span>Your order has been delivered successfully!</span>
                            </div>
                        </div>

                        <div class="order-card-body">
                            <div class="rest-info-group">
                                <img src="<%= restImg %>" alt="<%= restName %>" class="rest-thumb"
                                     onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=300&q=80';">
                                <div>
                                    <div class="rest-title"><%= restName %></div>
                                    <div class="rest-cuisine"><%= restCuisine %></div>
                                </div>
                            </div>

                            <div class="order-financials">
                                <div class="payment-pill">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                                        <line x1="1" y1="10" x2="23" y2="10"></line>
                                    </svg>
                                    <span><%= ord.getPaymentMode() != null ? ord.getPaymentMode() : "COD" %></span>
                                </div>

                                <div class="order-total-amount">
                                    &#8377; <%= String.format("%.0f", ord.getTotalAmount()) %>
                                </div>

                                <a href="menu?restaurantId=<%= ord.getRestaurantId() %>" class="btn-reorder">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <polyline points="23 4 23 10 17 10"></polyline>
                                        <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path>
                                    </svg>
                                    <span>Order Again</span>
                                </a>
                            </div>
                        </div>

                        <%
                            List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(ord.getOrderId()) : null;
                            if (items != null && !items.isEmpty()) {
                        %>
                            <div class="order-items-summary" style="margin-top: 14px; padding-top: 12px; border-top: 1px dashed var(--border-subtle); display: flex; flex-wrap: wrap; align-items: center; gap: 8px; width: 100%;">
                                <span style="font-size: 12px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; margin-right: 4px;">Items:</span>
                                <% for (OrderItem it : items) { 
                                    Menu m = (menuMap != null) ? menuMap.get(it.getMenuId()) : null;
                                    String itemName = (m != null && m.getItemName() != null) ? m.getItemName() : ("Item #" + it.getMenuId());
                                %>
                                    <span style="background: rgba(255, 255, 255, 0.04); border: 1px solid var(--border-subtle); border-radius: var(--radius-pill); padding: 4px 12px; font-size: 12px; color: var(--text-secondary); display: inline-flex; align-items: center; gap: 4px;">
                                        <strong style="color: var(--accent-gold); font-weight: 800;"><%= it.getQuantity() %>x</strong> <%= itemName %>
                                    </span>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-orders-box">
                <div class="empty-icon-circle">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                    </svg>
                </div>
                <h2 class="empty-title">No Orders Yet</h2>
                <p class="empty-desc">You haven't placed any food orders yet. Explore Bangalore's top dining destinations and enjoy delicious meals delivered hot to your doorstep!</p>
                <a href="restaurant" class="btn-reorder" style="padding: 12px 28px; font-size: 15px;">
                    <span>Explore Restaurants</span>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </a>
            </div>
        <% } %>
    </main>

    <% if ("success".equalsIgnoreCase(statusParam)) { %>
        <!-- Canvas for Confetti Celebration Effect -->
        <canvas id="confettiCanvas" style="position:fixed;top:0;left:0;width:100vw;height:100vh;pointer-events:none;z-index:9999;"></canvas>
    <% } %>

    <script>
        // Global Dark / Light Mode Toggle Function
        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            const newTheme = (currentTheme === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('foodhouse_theme', newTheme);
        }

        // Confetti Celebration on Order Success
        <% if ("success".equalsIgnoreCase(statusParam)) { %>
        (function launchConfetti() {
            const canvas = document.getElementById('confettiCanvas');
            if (!canvas) return;
            const ctx = canvas.getContext('2d');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            const particles = [];
            const colors = ['#ff4b5a', '#fbbf24', '#10b981', '#38bdf8', '#a855f7', '#ffffff'];

            for (let i = 0; i < 90; i++) {
                particles.push({
                    x: Math.random() * canvas.width,
                    y: Math.random() * canvas.height - canvas.height,
                    r: Math.random() * 6 + 4,
                    d: Math.random() * 90,
                    color: colors[Math.floor(Math.random() * colors.length)],
                    tilt: Math.floor(Math.random() * 10) - 10,
                    tiltAngleIncremental: (Math.random() * 0.07) + 0.05,
                    tiltAngle: 0
                });
            }

            let animationFrame;
            let elapsed = 0;

            function draw() {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                for (let i = 0; i < particles.length; i++) {
                    const p = particles[i];
                    ctx.beginPath();
                    ctx.lineWidth = p.r / 2;
                    ctx.strokeStyle = p.color;
                    ctx.moveTo(p.x + p.tilt + (p.r / 4), p.y);
                    ctx.lineTo(p.x + p.tilt, p.y + p.tilt + (p.r / 4));
                    ctx.stroke();

                    p.tiltAngle += p.tiltAngleIncremental;
                    p.y += (Math.cos(p.d) + 3 + p.r / 2) / 2;
                    p.tilt = Math.sin(p.tiltAngle - (i / 3)) * 15;

                    if (p.y > canvas.height) {
                        p.y = -20;
                        p.x = Math.random() * canvas.width;
                    }
                }
                elapsed++;
                if (elapsed < 350) {
                    animationFrame = requestAnimationFrame(draw);
                } else {
                    ctx.clearRect(0, 0, canvas.width, canvas.height);
                }
            }
            draw();
        })();
        <% } %>

        // ====================================================================
        // AUTOMATIC PERIODIC POLLING FOR LIVE ORDER TRACKING
        // ====================================================================
        (function initOrderTrackingPolling() {
            const activeCards = document.querySelectorAll('.order-card[data-status]:not([data-status="Delivered"]):not([data-status="Cancelled"]):not([data-status="Refunded"])');
            if (activeCards.length === 0) {
                return;
            }

            let pollTimer = null;
            const pollInterval = 4000; // Check every 4 seconds

            async function fetchOrderUpdates() {
                try {
                    const response = await fetch('order-status', {
                        headers: { 'Accept': 'application/json' }
                    });
                    if (!response.ok) return;

                    const data = await response.json();
                    if (!data.success || !data.orders) return;

                    let remainingActive = 0;

                    data.orders.forEach(ord => {
                        const card = document.getElementById('order-card-' + ord.orderId);
                        if (!card) return;

                        const curStatus = card.getAttribute('data-status');
                        if (curStatus !== ord.status) {
                            applyOrderStatusUI(ord);
                        }

                        if (!ord.isTerminal && !ord.isDelivered) {
                            remainingActive++;
                        }
                    });

                    // If all orders on page are delivered, stop polling gracefully
                    if (remainingActive === 0 && pollTimer) {
                        clearInterval(pollTimer);
                        pollTimer = null;
                    }
                } catch (err) {
                    console.warn('Order polling error:', err);
                }
            }

            function applyOrderStatusUI(ord) {
                const card = document.getElementById('order-card-' + ord.orderId);
                if (!card) return;

                card.setAttribute('data-status', ord.status);
                card.setAttribute('data-stage', ord.stage);

                // 1. Status Badge
                const badge = document.getElementById('order-status-badge-' + ord.orderId);
                if (badge) {
                    badge.className = 'order-status-badge ' + (ord.stage === 5 ? 'status-delivered' : 'status-confirmed');
                    const badgeText = badge.querySelector('.badge-text');
                    if (badgeText) badgeText.textContent = ord.status;
                }

                // 2. Stage header text & description
                const stageText = document.getElementById('order-stage-text-' + ord.orderId);
                if (stageText) stageText.textContent = ord.status;
                const stageDesc = document.getElementById('order-stage-desc-' + ord.orderId);
                if (stageDesc) stageDesc.textContent = ord.statusDesc;
                const liveDot = document.getElementById('live-dot-' + ord.orderId);
                if (liveDot) liveDot.style.background = (ord.stage === 5 ? '#10b981' : '#38bdf8');

                // 3. Progress fill
                const fill = document.getElementById('tracker-fill-' + ord.orderId);
                if (fill) fill.style.width = ord.fillPercent + '%';

                // 4. Update the 5 pipeline step nodes
                for (let i = 1; i <= 5; i++) {
                    const stepNode = document.getElementById('step-node-' + ord.orderId + '-' + i);
                    if (!stepNode) continue;
                    const circle = stepNode.querySelector('.tracker-step-circle');
                    const label = stepNode.querySelector('.tracker-step-label');

                    if (circle) {
                        circle.classList.remove('active', 'completed');
                        if (ord.stage > i || ord.stage === 5) {
                            circle.classList.add('completed');
                            circle.innerHTML = '&#10003;';
                        } else if (ord.stage === i) {
                            circle.classList.add('active');
                            circle.textContent = i.toString();
                        } else {
                            circle.textContent = i.toString();
                        }
                    }
                    if (label) {
                        if (ord.stage === i || (ord.stage === 5 && i === 5)) {
                            label.classList.add('active-label');
                        } else {
                            label.classList.remove('active-label');
                        }
                    }
                }

                // 5. Delivered celebration message banner
                const deliveredBanner = document.getElementById('delivered-banner-' + ord.orderId);
                if (deliveredBanner) {
                    deliveredBanner.style.display = (ord.stage === 5 ? 'flex' : 'none');
                }
            }

            pollTimer = setInterval(fetchOrderUpdates, pollInterval);
            setTimeout(fetchOrderUpdates, 1200);

            // Smooth scroll and focus target order card if orderId is specified
            try {
                var urlParams = new URLSearchParams(window.location.search);
                var targetOrderId = urlParams.get('orderId');
                if (targetOrderId) {
                    var card = document.getElementById('order-card-' + targetOrderId);
                    if (card) {
                        setTimeout(function() {
                            card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            card.style.transition = 'box-shadow 0.4s ease, border-color 0.4s ease';
                            card.style.borderColor = '#10b981';
                            card.style.boxShadow = '0 0 25px rgba(16, 185, 129, 0.45)';
                            setTimeout(function() {
                                card.style.boxShadow = '';
                            }, 3500);
                        }, 400);
                    }
                }
            } catch (err) {}
        })();
    </script>

</body>
</html>
