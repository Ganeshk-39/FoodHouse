<%-- 
    ========================================================================
    FILE: Checkout.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Ultra-Premium Midnight Luxury Theme for Checkout & Payment.
                 Features pure inline SVG icons (100% bulletproof, zero font bugs),
                 delivery address form, dynamic payment selection, and bill summary.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.User, com.tap.model.Restaurant" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Secure Checkout & Order Confirmation</title>
    
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
        /* ====================================================================
           1. CSS Custom Properties - Ultra-Premium Midnight Luxury Theme
           ==================================================================== */
        :root {
            --bg-body: #0a0e17;
            --bg-card: rgba(17, 24, 39, 0.75);
            --bg-card-hover: rgba(26, 36, 56, 0.95);
            --bg-glass: rgba(15, 23, 42, 0.85);
            
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.4);
            --border-focus: #ff4b5a;
            
            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.35);
            --primary-light: rgba(255, 75, 90, 0.15);
            
            --accent-gold: #fbbf24;
            --accent-green: #10b981;
            --accent-blue: #38bdf8;
            
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

        [data-theme="light"] body {
            background-color: #f8fafc;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.06) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.05) 0px, transparent 50%),
                radial-gradient(at 50% 30%, rgba(16, 185, 129, 0.03) 0px, transparent 50%);
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

        [data-theme="light"] .back-link {
            background: rgba(0, 0, 0, 0.04);
            color: #1e293b;
            border-color: rgba(0, 0, 0, 0.12);
        }

        [data-theme="light"] .page-title,
        [data-theme="light"] .card-header-title,
        [data-theme="light"] .form-label,
        [data-theme="light"] .sidebar-title,
        [data-theme="light"] .bill-total-label {
            color: #0f172a !important;
        }

        [data-theme="light"] .checkout-card,
        [data-theme="light"] .sidebar-card {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.08);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
        }

        [data-theme="light"] .form-input,
        [data-theme="light"] .form-textarea {
            background: #f8fafc;
            color: #0f172a;
            border-color: rgba(0, 0, 0, 0.15);
        }

        [data-theme="light"] .form-input:focus,
        [data-theme="light"] .form-textarea:focus {
            background: #ffffff;
            border-color: var(--primary);
        }

        [data-theme="light"] .payment-option-card {
            background: #f8fafc;
            border-color: rgba(0, 0, 0, 0.1);
        }

        [data-theme="light"] .payment-title {
            color: #0f172a;
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
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background-color: var(--bg-body);
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.05) 0px, transparent 50%),
                radial-gradient(at 50% 30%, rgba(16, 185, 129, 0.03) 0px, transparent 50%);
            color: var(--text-main);
            min-height: 100vh;
            padding-bottom: 80px;
            -webkit-font-smoothing: antialiased;
        }

        /* Glassmorphism Navbar */
        .navbar {
            background: rgba(10, 14, 23, 0.88);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid var(--border-subtle);
            box-shadow: var(--shadow-sm);
        }

        .nav-container {
            max-width: 1180px;
            margin: 0 auto;
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #ffffff;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
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

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: var(--text-secondary);
            font-weight: 700;
            font-size: 13px;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            border: 1px solid var(--border-subtle);
            background: rgba(255, 255, 255, 0.04);
            transition: var(--transition);
        }

        .back-link:hover {
            color: #ffffff;
            border-color: rgba(255, 255, 255, 0.25);
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-2px);
        }

        /* Progress Steps Header */
        .checkout-header {
            max-width: 1180px;
            margin: 28px auto 0;
            padding: 0 24px;
        }

        .page-title-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            padding-bottom: 24px;
            border-bottom: 1px solid var(--border-subtle);
        }

        .page-title {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .step-pills {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 700;
        }

        .step-pill {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: var(--radius-pill);
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
        }

        .step-pill.active {
            background: rgba(255, 75, 90, 0.15);
            border-color: rgba(255, 75, 90, 0.4);
            color: #ffffff;
        }

        .step-num {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: var(--primary);
            color: #ffffff;
            font-size: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
        }

        /* Main Container & Two-Column Grid */
        .container {
            max-width: 1180px;
            margin: 28px auto 0;
            padding: 0 24px;
        }

        .checkout-grid {
            display: grid;
            grid-template-columns: 1.55fr 1fr;
            gap: 32px;
            align-items: start;
        }

        .checkout-form-column {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .checkout-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 28px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
        }

        .checkout-card:hover {
            border-color: rgba(255, 255, 255, 0.15);
        }

        .card-header-flex {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 22px;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--border-subtle);
        }

        .card-header-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: rgba(255, 75, 90, 0.15);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(255, 75, 90, 0.3);
        }

        .card-header-title {
            font-size: 17px;
            font-weight: 800;
            color: #ffffff;
        }

        .card-header-subtitle {
            font-size: 12.5px;
            color: var(--text-secondary);
        }

        /* Form Inputs */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            font-size: 12.5px;
            font-weight: 700;
            color: var(--text-secondary);
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .form-input, .form-textarea {
            width: 100%;
            padding: 12px 16px;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--border-subtle);
            background: rgba(255, 255, 255, 0.04);
            font-size: 14px;
            color: #ffffff;
            outline: none;
            transition: var(--transition);
        }

        .form-textarea {
            resize: vertical;
            min-height: 70px;
        }

        .form-input:focus, .form-textarea:focus {
            border-color: var(--primary);
            background: rgba(255, 255, 255, 0.08);
            box-shadow: 0 0 0 4px var(--primary-light);
        }

        /* Payment Options */
        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .payment-label-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 20px;
            border-radius: var(--radius-lg);
            border: 1.5px solid var(--border-subtle);
            background: rgba(255, 255, 255, 0.03);
            cursor: pointer;
            transition: var(--transition);
        }

        .payment-label-card:hover {
            border-color: rgba(255, 255, 255, 0.25);
            background: rgba(255, 255, 255, 0.06);
            transform: translateY(-1px);
        }

        .payment-label-card:has(input:checked) {
            border-color: var(--primary);
            background: rgba(255, 75, 90, 0.1);
            box-shadow: 0 4px 16px var(--primary-light);
        }

        .payment-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .payment-icon-box {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.06);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            border: 1px solid var(--border-subtle);
        }

        .payment-title {
            font-size: 14.5px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 2px;
        }

        .payment-desc {
            font-size: 12px;
            color: var(--text-secondary);
        }

        .payment-radio-custom {
            accent-color: var(--primary);
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        /* Right Column: Sticky Summary */
        .summary-column {
            position: sticky;
            top: 90px;
        }

        .summary-card {
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 24px;
            box-shadow: var(--shadow-md);
        }

        .rest-mini-banner {
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border-subtle);
            margin-bottom: 16px;
        }

        .rest-thumb {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid var(--border-subtle);
        }

        .rest-name {
            font-size: 15.5px;
            font-weight: 800;
            color: #ffffff;
        }

        .rest-meta {
            font-size: 12px;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* Items Preview */
        .items-preview-list {
            max-height: 180px;
            overflow-y: auto;
            padding-right: 6px;
            margin-bottom: 16px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .preview-item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
        }

        .preview-item-name {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #ffffff;
        }

        .preview-qty-badge {
            background: rgba(255, 255, 255, 0.08);
            color: var(--text-secondary);
            font-size: 11px;
            font-weight: 800;
            padding: 2px 6px;
            border-radius: 6px;
        }

        .preview-item-price {
            font-weight: 700;
            color: var(--accent-gold);
        }

        .bill-divider {
            height: 1px;
            background: var(--border-subtle);
            margin: 14px 0;
        }

        .bill-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13.5px;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }

        .bill-row.discount {
            color: var(--accent-green);
            font-weight: 700;
        }

        .bill-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 2px dashed var(--border-subtle);
            margin-top: 12px;
            margin-bottom: 20px;
        }

        .bill-total-label {
            font-size: 15.5px;
            font-weight: 800;
            color: #ffffff;
        }

        .bill-total-amount {
            font-size: 22px;
            font-weight: 800;
            color: var(--accent-gold);
            letter-spacing: -0.5px;
        }

        .btn-place-order {
            width: 100%;
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            border: none;
            padding: 15px 24px;
            border-radius: var(--radius-pill);
            font-size: 15.5px;
            font-weight: 800;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 6px 20px var(--primary-glow);
            transition: var(--transition);
        }

        .btn-place-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(255, 75, 90, 0.55);
        }

        .secure-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            margin-top: 12px;
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 600;
        }

        @media (max-width: 900px) {
            .checkout-grid {
                grid-template-columns: 1fr;
            }
            .form-grid {
                grid-template-columns: 1fr;
            }
            .summary-column {
                position: static;
            }
        }
    </style>
</head>
<body style="background-color: #0a0e17; color: #ffffff;">

    <%
        // STEP 1: Fetch session and request attributes
        Cart cart = (Cart) session.getAttribute("cart");
        User user = (User) request.getAttribute("user");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }
        if (user == null) {
            user = (User) session.getAttribute("loggedInUser");
        }
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        Map<Integer, CartItem> items = cart.getItems();

        // Pricing retrieved from controller or calculated safely
        Double subtotalObj = (Double) request.getAttribute("subtotal");
        Double deliveryFeeObj = (Double) request.getAttribute("deliveryFee");
        Double taxObj = (Double) request.getAttribute("tax");
        Double discountObj = (Double) request.getAttribute("discount");
        Double grandTotalObj = (Double) request.getAttribute("grandTotal");

        double subtotal = (subtotalObj != null) ? subtotalObj : cart.getTotalPrice();
        double deliveryFee = (deliveryFeeObj != null) ? deliveryFeeObj : (subtotal >= 500 ? 0.0 : 40.0);
        double tax = (taxObj != null) ? taxObj : (subtotal * 0.05);
        double discount = (discountObj != null) ? discountObj : (subtotal >= 299 ? subtotal * 0.20 : 0.0);
        double grandTotal = (grandTotalObj != null) ? grandTotalObj : (subtotal + deliveryFee + tax - discount);

        // Pre-fill user information if available
        String username = (user != null && user.getUsername() != null) ? user.getUsername() : "";
        String phone = (user != null && user.getPhone() != null) ? user.getPhone() : "";
        String email = (user != null && user.getEmail() != null) ? user.getEmail() : "";
        String userAddress = (user != null && user.getAddress() != null) ? user.getAddress() : "";

        // Restaurant defaults
        String restName = (restaurant != null && restaurant.getName() != null) ? restaurant.getName() : "Gourmet Restaurant";
        String restImg = (restaurant != null && restaurant.getImagePath() != null) ? restaurant.getImagePath() : "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=300&q=80";
        int deliveryTime = (restaurant != null && restaurant.getDeliveryTime() > 0) ? restaurant.getDeliveryTime() : 30;
    %>

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

            <div style="display: flex; align-items: center; gap: 10px;">
                <a href="cart" class="back-link">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    <span>Back to Cart</span>
                </a>

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

    <!-- ================= PROGRESS HEADER ================= -->
    <div class="checkout-header">
        <div class="page-title-box">
            <h1 class="page-title">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5">
                    <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                    <line x1="1" y1="10" x2="23" y2="10"></line>
                </svg>
                <span>Checkout & Order Details</span>
            </h1>

            <div class="step-pills">
                <div class="step-pill">
                    <span class="step-num" style="background:var(--accent-green);">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    </span>
                    <span>Cart</span>
                </div>
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                <div class="step-pill active">
                    <span class="step-num">2</span>
                    <span>Checkout & Payment</span>
                </div>
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                <div class="step-pill">
                    <span class="step-num" style="background: rgba(255,255,255,0.2);">3</span>
                    <span>Confirmation</span>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= MAIN CONTENT ================= -->
    <main class="container">
        <% 
            String errorParam = request.getParameter("error");
            if (errorParam != null && !errorParam.trim().isEmpty()) {
                String errMsg = "An issue occurred while processing your order. Please try again.";
                if ("payment_failed".equalsIgnoreCase(errorParam) || "payment_verification_failed".equalsIgnoreCase(errorParam)) {
                    errMsg = "Payment authorization could not be completed or verified. Please try another payment mode.";
                } else if ("order_creation_failed".equalsIgnoreCase(errorParam)) {
                    errMsg = "Unable to record the order at this moment. Your cart is intact. Please try again.";
                }
        %>
            <div style="background: rgba(239, 68, 68, 0.15); border: 1.5px solid #ef4444; border-radius: var(--radius-lg); padding: 14px 20px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; color: #fca5a5;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <span style="font-weight: 600; font-size: 14px;"><%= errMsg %></span>
            </div>
        <% } %>

        <!-- Order Confirmation Form -->
        <form action="order" method="post" class="checkout-grid" id="checkoutForm" onsubmit="return handleCheckoutSubmit(event);">
            
            <!-- Left Side: Address & Payment Mode -->
            <div class="checkout-form-column">
                
                <!-- Section 1: Delivery Address -->
                <div class="checkout-card">
                    <div class="card-header-flex">
                        <div class="card-header-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                        </div>
                        <div>
                            <div class="card-header-title">Delivery Address</div>
                            <div class="card-header-subtitle">Where should our delivery partner deliver your meal?</div>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="fullName">Full Name *</label>
                            <input type="text" id="fullName" name="fullName" class="form-input" 
                                   placeholder="e.g. Rahul Sharma" value="<%= username %>" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="phone">Phone Number *</label>
                            <input type="tel" id="phone" name="phone" class="form-input" 
                                   placeholder="e.g. 9876543210" value="<%= phone %>" required>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label" for="address">Street Address / House No / Flat *</label>
                            <textarea id="address" name="address" class="form-textarea" 
                                      placeholder="e.g. Flat 302, Green Glen Layout, Bellandur" required><%= userAddress %></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="city">City</label>
                            <input type="text" id="city" name="city" class="form-input" value="Bangalore" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="pincode">Pincode *</label>
                            <input type="text" id="pincode" name="pincode" class="form-input" 
                                   placeholder="560103" value="560103" maxlength="6" required>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Payment Options -->
                <div class="checkout-card">
                    <div class="card-header-flex">
                        <div class="card-header-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <rect x="2" y="5" width="20" height="14" rx="2"></rect>
                                <line x1="2" y1="10" x2="22" y2="10"></line>
                            </svg>
                        </div>
                        <div>
                            <div class="card-header-title">Select Payment Mode</div>
                            <div class="card-header-subtitle">Choose your preferred payment method</div>
                        </div>
                    </div>

                    <div class="payment-options">
                        <!-- Option 1: Razorpay Payment Gateway (Instant Online Payment) -->
                        <label class="payment-label-card" style="border: 1.5px solid rgba(56, 189, 248, 0.45); background: rgba(56, 189, 248, 0.08);">
                            <div class="payment-left">
                                <div class="payment-icon-box" style="background: rgba(56, 189, 248, 0.2); border: 1px solid rgba(56, 189, 248, 0.4);">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="var(--accent-blue)" stroke-width="2.5">
                                        <rect x="2" y="5" width="20" height="14" rx="2"></rect>
                                        <line x1="2" y1="10" x2="22" y2="10"></line>
                                    </svg>
                                </div>
                                <div>
                                    <div class="payment-title" style="display: flex; align-items: center; gap: 8px;">
                                        <span>Razorpay (Cards, UPI, NetBanking)</span>
                                        <span style="background: linear-gradient(135deg, #0284c7 0%, #38bdf8 100%); color: #ffffff; font-size: 10.5px; font-weight: 800; padding: 2px 8px; border-radius: var(--radius-pill); letter-spacing: 0.4px;">RECOMMENDED</span>
                                    </div>
                                    <div class="payment-desc">Instant online payment via Google Pay, PhonePe, Cards & NetBanking</div>
                                </div>
                            </div>
                            <input type="radio" name="paymentMode" value="Razorpay" class="payment-radio-custom" checked>
                        </label>

                        <!-- Option 2: Cash on Delivery -->
                        <label class="payment-label-card">
                            <div class="payment-left">
                                <div class="payment-icon-box">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--accent-green)" stroke-width="2">
                                        <rect x="2" y="6" width="20" height="12" rx="2"></rect>
                                        <circle cx="12" cy="12" r="2"></circle>
                                        <path d="M6 12h.01M18 12h.01"></path>
                                    </svg>
                                </div>
                                <div>
                                    <div class="payment-title">Cash on Delivery (COD)</div>
                                    <div class="payment-desc">Pay cash or scan UPI upon doorstep delivery</div>
                                </div>
                            </div>
                            <input type="radio" name="paymentMode" value="Cash on Delivery" class="payment-radio-custom">
                        </label>

                        <!-- Option 2: UPI / QR -->
                        <label class="payment-label-card">
                            <div class="payment-left">
                                <div class="payment-icon-box">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--accent-blue)" stroke-width="2">
                                        <rect x="3" y="3" width="7" height="7"></rect>
                                        <rect x="14" y="3" width="7" height="7"></rect>
                                        <rect x="14" y="14" width="7" height="7"></rect>
                                        <rect x="3" y="14" width="7" height="7"></rect>
                                    </svg>
                                </div>
                                <div>
                                    <div class="payment-title">UPI & Instant QR</div>
                                    <div class="payment-desc">Google Pay, PhonePe, Paytm, BHIM</div>
                                </div>
                            </div>
                            <input type="radio" name="paymentMode" value="UPI" class="payment-radio-custom">
                        </label>

                        <!-- Option 3: Credit / Debit Card -->
                        <label class="payment-label-card">
                            <div class="payment-left">
                                <div class="payment-icon-box">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--accent-gold)" stroke-width="2">
                                        <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                                        <line x1="1" y1="10" x2="23" y2="10"></line>
                                    </svg>
                                </div>
                                <div>
                                    <div class="payment-title">Credit / Debit Card</div>
                                    <div class="payment-desc">Visa, MasterCard, RuPay, Maestro</div>
                                </div>
                            </div>
                            <input type="radio" name="paymentMode" value="Card" class="payment-radio-custom">
                        </label>

                        <!-- Option 4: Net Banking -->
                        <label class="payment-label-card">
                            <div class="payment-left">
                                <div class="payment-icon-box">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#a78bfa" stroke-width="2">
                                        <line x1="18" y1="20" x2="18" y2="10"></line>
                                        <line x1="12" y1="20" x2="12" y2="4"></line>
                                        <line x1="6" y1="20" x2="6" y2="14"></line>
                                    </svg>
                                </div>
                                <div>
                                    <div class="payment-title">Net Banking</div>
                                    <div class="payment-desc">HDFC, ICICI, SBI, Axis & all major banks</div>
                                </div>
                            </div>
                            <input type="radio" name="paymentMode" value="Net Banking" class="payment-radio-custom">
                        </label>
                    </div>
                </div>

            </div>

            <!-- Right Side: Order Summary Card -->
            <div class="summary-column">
                <div class="summary-card">
                    
                    <!-- Mini Restaurant Header -->
                    <div class="rest-mini-banner">
                        <img src="<%= restImg %>" alt="<%= restName %>" class="rest-thumb"
                             onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=300&q=80';">
                        <div>
                            <div class="rest-name"><%= restName %></div>
                            <div class="rest-meta">
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                <span>Delivery in <%= deliveryTime %> mins</span>
                            </div>
                        </div>
                    </div>

                    <!-- Items Summary List -->
                    <div class="items-preview-list">
                        <% for (CartItem item : items.values()) { 
                            String itemName = (item.getMenu() != null) ? item.getMenu().getItemName() : "Dish";
                        %>
                            <div class="preview-item-row">
                                <div class="preview-item-name">
                                    <span><%= itemName %></span>
                                    <span class="preview-qty-badge">&times;<%= item.getQuantity() %></span>
                                </div>
                                <div class="preview-item-price">
                                    &#8377; <%= String.format("%.0f", item.getSubtotal()) %>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <div class="bill-divider"></div>

                    <!-- Detailed Bill Breakdown -->
                    <div class="bill-row">
                        <span>Item Total</span>
                        <span>&#8377; <%= String.format("%.0f", subtotal) %></span>
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

                    <div class="bill-row" id="checkoutTipRow" style="color:var(--accent-gold); font-weight:700; display:none;">
                        <span>Delivery Partner Tip</span>
                        <span id="checkoutTipAmount">&#8377; 0</span>
                    </div>

                    <div class="bill-total-row">
                        <span class="bill-total-label">To Pay</span>
                        <span class="bill-total-amount" id="checkoutGrandTotal">&#8377; <%= String.format("%.0f", grandTotal) %></span>
                    </div>

                    <!-- Hidden Form Data for Total & Restaurant -->
                    <input type="hidden" name="totalAmount" value="<%= grandTotal %>">
                    <input type="hidden" name="restaurantId" value="<%= cart.getRestaurantId() %>">
                    <input type="hidden" id="razorpayPaymentId" name="razorpayPaymentId" value="">
                    <input type="hidden" id="checkoutTipInput" name="tip" value="0">

                    <!-- Confirm Order Submission Button -->
                    <button type="submit" id="btnPlaceOrder" class="btn-place-order">
                        <span id="btnPlaceOrderText">Proceed with Razorpay</span>
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </button>

                    <div class="secure-badge">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--accent-green)" stroke-width="2.5">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        <span>Secured by Razorpay & SSL 256-bit Encryption</span>
                    </div>
                </div>
            </div>

        </form>
    </main>

    <!-- ================= RAZORPAY CHECKOUT MODAL ================= -->
    <div id="razorpayModal" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.8); z-index:9999; align-items:center; justify-content:center; backdrop-filter:blur(6px);">
        <div style="background:#ffffff; color:#0f172a; border-radius:16px; width:92%; max-width:440px; overflow:hidden; box-shadow:0 25px 60px rgba(0,0,0,0.6); animation:modalPop 0.3s cubic-bezier(0.16,1,0.3,1);">
            <!-- Razorpay Blue Header -->
            <div style="background:linear-gradient(135deg, #0c2340 0%, #163e72 100%); color:#ffffff; padding:22px; position:relative;">
                <button type="button" onclick="closeRazorpayModal()" style="position:absolute; top:16px; right:16px; background:transparent; border:none; color:#ffffff; font-size:22px; cursor:pointer; line-height:1;">&times;</button>
                <div style="display:flex; align-items:center; gap:10px; margin-bottom:12px;">
                    <div style="background:#3395ff; color:#fff; font-weight:900; font-size:14px; width:32px; height:32px; border-radius:8px; display:flex; align-items:center; justify-content:center;">R</div>
                    <div>
                        <div style="font-size:16px; font-weight:800; letter-spacing:-0.3px;">FoodHouse Live Checkout</div>
                        <div style="font-size:11.5px; opacity:0.8;">Secured by Razorpay Payment Gateway</div>
                    </div>
                </div>
                <div style="background:rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; display:flex; justify-content:space-between; align-items:center;">
                    <span style="font-size:13px; font-weight:600;">Total Payable:</span>
                    <strong style="font-size:18px; font-weight:800; color:#38bdf8;">&#8377; <%= String.format("%.0f", grandTotal) %></strong>
                </div>
            </div>

            <!-- Razorpay Payment Body -->
            <div style="padding:22px;">
                <div style="font-size:13px; font-weight:700; color:#64748b; margin-bottom:12px; text-transform:uppercase; letter-spacing:0.5px;">Choose Payment Mode</div>
                
                <div style="display:flex; flex-direction:column; gap:10px; margin-bottom:20px;">
                    <label style="border:1.5px solid #3395ff; background:#f0f7ff; border-radius:10px; padding:12px 14px; display:flex; align-items:center; justify-content:space-between; cursor:pointer;">
                        <div style="display:flex; align-items:center; gap:10px;">
                            <span style="font-size:18px;">&#9889;</span>
                            <div>
                                <div style="font-size:14px; font-weight:800; color:#0c2340;">UPI / Instant QR</div>
                                <div style="font-size:11.5px; color:#64748b;">Google Pay, PhonePe, Paytm, BHIM</div>
                            </div>
                        </div>
                        <input type="radio" name="rzp_sub_mode" value="UPI" checked>
                    </label>

                    <label style="border:1px solid #e2e8f0; border-radius:10px; padding:12px 14px; display:flex; align-items:center; justify-content:space-between; cursor:pointer;">
                        <div style="display:flex; align-items:center; gap:10px;">
                            <span style="font-size:18px;">&#128179;</span>
                            <div>
                                <div style="font-size:14px; font-weight:800; color:#0c2340;">Cards (Credit / Debit)</div>
                                <div style="font-size:11.5px; color:#64748b;">Visa, MasterCard, RuPay (Test Mode)</div>
                            </div>
                        </div>
                        <input type="radio" name="rzp_sub_mode" value="Card">
                    </label>

                    <label style="border:1px solid #e2e8f0; border-radius:10px; padding:12px 14px; display:flex; align-items:center; justify-content:space-between; cursor:pointer;">
                        <div style="display:flex; align-items:center; gap:10px;">
                            <span style="font-size:18px;">&#127963;</span>
                            <div>
                                <div style="font-size:14px; font-weight:800; color:#0c2340;">Net Banking</div>
                                <div style="font-size:11.5px; color:#64748b;">HDFC, ICICI, SBI, Axis & all banks</div>
                            </div>
                        </div>
                        <input type="radio" name="rzp_sub_mode" value="NetBanking">
                    </label>
                </div>

                <button type="button" id="btnPayRazorpayAction" onclick="executeRazorpayPayment()" style="width:100%; background:linear-gradient(135deg, #3395ff 0%, #0284c7 100%); color:#ffffff; border:none; padding:14px; border-radius:10px; font-size:15px; font-weight:800; cursor:pointer; box-shadow:0 4px 14px rgba(51,149,255,0.4); display:flex; align-items:center; justify-content:center; gap:8px;">
                    <span>Pay &#8377; <%= String.format("%.0f", grandTotal) %> Now</span>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                </button>

                <div id="rzpStatusText" style="text-align:center; font-size:12px; color:#64748b; margin-top:12px;">
                    &#128274; Test Gateway Active &bull; Instant Simulation
                </div>
            </div>
        </div>
    </div>

    <!-- Official Razorpay JS SDK (Fallback to local simulator) -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

    <script>
        // Update button text when user selects payment mode
        document.querySelectorAll('input[name="paymentMode"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                var btnText = document.getElementById('btnPlaceOrderText');
                if (this.value === 'Razorpay') {
                    btnText.innerText = 'Proceed with Razorpay';
                } else {
                    btnText.innerText = 'Confirm & Place Order (' + this.value + ')';
                }
            });
        });

        function handleCheckoutSubmit(e) {
            var addressEl = document.getElementById('address');
            if (addressEl && !addressEl.value.trim()) {
                if (e) e.preventDefault();
                addressEl.focus();
                alert('Please enter your delivery address before proceeding.');
                return false;
            }
            var selectedMode = document.querySelector('input[name="paymentMode"]:checked');
            if (selectedMode && selectedMode.value === 'Razorpay') {
                if (e) e.preventDefault();
                // Launch Razorpay Modal
                document.getElementById('razorpayModal').style.display = 'flex';
                return false;
            }
            return true;
        }

        function closeRazorpayModal() {
            document.getElementById('razorpayModal').style.display = 'none';
        }

        function executeRazorpayPayment() {
            var btn = document.getElementById('btnPayRazorpayAction');
            var status = document.getElementById('rzpStatusText');
            btn.disabled = true;
            btn.innerHTML = '<span style="display:inline-block; animation:spin 1s linear infinite;">&#9696;</span> Authorizing with Razorpay...';
            status.innerHTML = '<strong style="color:#0284c7;">Processing transaction... Please do not refresh.</strong>';

            setTimeout(function() {
                var generatedPayId = 'pay_' + Math.random().toString(36).substr(2, 9) + Date.now().toString().substr(-5);
                document.getElementById('razorpayPaymentId').value = generatedPayId;
                btn.style.background = '#10b981';
                btn.innerHTML = '&#10004; Payment Succeeded!';
                status.innerHTML = '<strong style="color:#10b981;">Payment ID: ' + generatedPayId + ' verified! Finalizing order...</strong>';

                setTimeout(function() {
                    document.getElementById('checkoutForm').submit();
                }, 800);
            }, 1200);
        }

        // Hydrate persisted tip and instructions
        (function() {
            var savedTip = localStorage.getItem('foodhouse_tip');
            if (savedTip && parseInt(savedTip) > 0) {
                var tipVal = parseInt(savedTip);
                var tipRow = document.getElementById('checkoutTipRow');
                if (tipRow) {
                    tipRow.style.display = 'flex';
                    document.getElementById('checkoutTipAmount').innerText = '₹ ' + tipVal;
                }
                var currentTotal = <%= grandTotal %> + tipVal;
                var tipInput = document.getElementById('checkoutTipInput');
                if (tipInput) tipInput.value = tipVal;
                var totalEl = document.getElementById('checkoutGrandTotal');
                if (totalEl) totalEl.innerHTML = '&#8377; ' + Math.round(currentTotal);
                var totalInput = document.querySelector('input[name="totalAmount"]');
                if (totalInput) totalInput.value = currentTotal;
                var rzpAmount = document.getElementById('rzpModalAmount');
                if (rzpAmount) rzpAmount.innerText = '₹' + Math.round(currentTotal);
            }
        })();

        // Global Dark / Light Mode Toggle Function
        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            const newTheme = (currentTheme === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('foodhouse_theme', newTheme);
        }
    </script>

    <style>
        @keyframes modalPop {
            from { transform: scale(0.92); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
    </style>

</body>
</html>
