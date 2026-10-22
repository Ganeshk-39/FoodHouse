<%-- 
    ========================================================================
    FILE: Profile.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Ultra-Premium Midnight Luxury Theme for User Profile & Account Management.
                 Features editable personal details, password security, quick order stats,
                 pure inline SVGs, and responsive tabbed interface.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.User, com.tap.model.Order, com.tap.model.Cart" %>

<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        user = (User) session.getAttribute("loggedInUser");
    }
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    Integer totalOrdersObj = (Integer) request.getAttribute("totalOrders");
    Double totalSpentObj = (Double) request.getAttribute("totalSpent");
    @SuppressWarnings("unchecked")
    List<Order> userOrders = (List<Order>) request.getAttribute("userOrders");

    int totalOrders = (totalOrdersObj != null) ? totalOrdersObj : 0;
    double totalSpent = (totalSpentObj != null) ? totalSpentObj : 0.0;

    String successMsg = (String) session.getAttribute("profileSuccess");
    String errorMsg = (String) session.getAttribute("profileError");
    session.removeAttribute("profileSuccess");
    session.removeAttribute("profileError");

    Cart cart = (Cart) session.getAttribute("cart");
    int cartCount = (cart != null && cart.getItems() != null) ? cart.getItems().size() : 0;

    String initial = (user.getUsername() != null && !user.getUsername().isEmpty()) ? user.getUsername().substring(0, 1).toUpperCase() : "U";
    String displayName = (user.getUsername() != null) ? user.getUsername() : "Valued Member";
    String email = (user.getEmail() != null) ? user.getEmail() : "";
    String phone = (user.getPhone() != null && !user.getPhone().isEmpty()) ? user.getPhone() : "Not provided";
    String address = (user.getAddress() != null && !user.getAddress().isEmpty()) ? user.getAddress() : "No default address saved";
    String role = (user.getRole() != null) ? user.getRole() : "Customer";
    boolean isAdmin = "admin".equalsIgnoreCase(role) || "restaurantadmin".equalsIgnoreCase(role) || "restaurant_admin".equalsIgnoreCase(role);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | My Profile & Account Settings</title>
    
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
            --bg-card: rgba(17, 24, 39, 0.82);
            --bg-card-hover: rgba(26, 36, 56, 0.98);
            --bg-glass: rgba(15, 23, 42, 0.85);
            
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.4);
            
            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.35);
            --primary-light: rgba(255, 75, 90, 0.12);
            
            --accent-gold: #fbbf24;
            --accent-green: #10b981;
            --accent-blue: #38bdf8;
            --accent-purple: #a855f7;
            
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
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            min-height: 100vh;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.06) 0px, transparent 50%),
                radial-gradient(at 50% 30%, rgba(16, 185, 129, 0.04) 0px, transparent 50%);
            background-attachment: fixed;
            overflow-x: hidden;
        }

        /* Navbar */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(10, 14, 23, 0.92);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border-subtle);
            padding: 12px 24px;
            transition: var(--transition);
        }

        [data-theme="light"] .navbar {
            background: rgba(255, 255, 255, 0.94);
            border-bottom-color: rgba(0, 0, 0, 0.08);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #ffffff;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        [data-theme="light"] .brand-logo {
            color: #0f172a;
        }

        .brand-logo-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff8a7a 100%);
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
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-size: 13.5px;
            font-weight: 700;
            text-decoration: none;
            transition: var(--transition);
            border: 1px solid var(--border-subtle);
            color: var(--text-secondary);
            background: rgba(255, 255, 255, 0.04);
        }

        .nav-btn:hover {
            color: var(--primary);
            border-color: var(--border-hover);
            background: var(--primary-light);
            transform: translateY(-1px);
        }

        .nav-btn.active {
            background: var(--primary-light);
            color: var(--primary);
            border-color: rgba(255, 75, 90, 0.35);
        }

        .nav-btn.admin-pill {
            background: rgba(251, 191, 36, 0.12);
            color: var(--accent-gold);
            border-color: rgba(251, 191, 36, 0.35);
        }

        .nav-btn.admin-pill:hover {
            background: rgba(251, 191, 36, 0.22);
        }

        .cart-badge {
            background: var(--primary);
            color: #ffffff;
            font-size: 11px;
            font-weight: 800;
            padding: 2px 7px;
            border-radius: var(--radius-pill);
        }

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
        }

        .theme-icon-light { display: none; }
        .theme-icon-dark { display: flex; align-items: center; justify-content: center; }
        [data-theme="light"] .theme-icon-light { display: flex; }
        [data-theme="light"] .theme-icon-dark { display: none; }

        /* Container & Grid */
        .container {
            max-width: 1100px;
            margin: 32px auto;
            padding: 0 20px;
        }

        /* Hero Profile Card */
        .profile-hero {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 32px;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.4);
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 24px;
        }

        .profile-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--accent-gold), var(--accent-green));
        }

        .hero-left {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .profile-avatar-large {
            width: 84px;
            height: 84px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, #ff8a7a 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            font-weight: 800;
            color: #ffffff;
            box-shadow: 0 8px 24px var(--primary-glow);
            border: 3px solid rgba(255, 255, 255, 0.15);
            flex-shrink: 0;
        }

        .hero-info h1 {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 6px;
        }

        .hero-meta-pills {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .meta-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            font-size: 12.5px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            color: var(--text-secondary);
        }

        .meta-pill.role-badge {
            background: rgba(16, 185, 129, 0.15);
            color: var(--accent-green);
            border-color: rgba(16, 185, 129, 0.3);
            font-weight: 700;
        }

        .meta-pill.role-admin {
            background: rgba(251, 191, 36, 0.15);
            color: var(--accent-gold);
            border-color: rgba(251, 191, 36, 0.4);
            font-weight: 700;
        }

        /* Stats Row */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: var(--transition);
        }

        .stat-card:hover {
            transform: translateY(-2px);
            border-color: var(--border-hover);
        }

        .stat-icon {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .stat-val {
            font-size: 22px;
            font-weight: 800;
            margin-bottom: 2px;
        }

        .stat-lbl {
            font-size: 12.5px;
            color: var(--text-secondary);
            font-weight: 600;
        }

        /* Alerts */
        .alert-box {
            padding: 14px 18px;
            border-radius: var(--radius-md);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 600;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.35);
            color: #34d399;
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #f87171;
        }

        /* Tab Buttons */
        .tabs-nav {
            display: flex;
            gap: 10px;
            border-bottom: 1px solid var(--border-subtle);
            padding-bottom: 12px;
            margin-bottom: 24px;
            overflow-x: auto;
        }

        .tab-btn {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            padding: 10px 18px;
            border-radius: var(--radius-pill);
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .tab-btn:hover {
            color: var(--text-main);
            background: rgba(255, 255, 255, 0.05);
        }

        .tab-btn.active {
            background: var(--primary);
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        /* Tab Content Section */
        .tab-pane {
            display: none;
        }

        .tab-pane.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Form Card */
        .content-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 30px;
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.3);
        }

        .content-card-title {
            font-size: 19px;
            font-weight: 800;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .content-card-sub {
            color: var(--text-secondary);
            font-size: 13.5px;
            margin-bottom: 24px;
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-secondary);
        }

        .form-input, .form-textarea {
            width: 100%;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            color: var(--text-main);
            font-size: 14.5px;
            transition: var(--transition);
        }

        [data-theme="light"] .form-input, [data-theme="light"] .form-textarea {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.12);
        }

        .form-input:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(255, 75, 90, 0.18);
        }

        .form-input[readonly] {
            opacity: 0.65;
            cursor: not-allowed;
            background: rgba(255, 255, 255, 0.02);
        }

        .btn-primary-action {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            border: none;
            padding: 13px 26px;
            border-radius: var(--radius-pill);
            font-size: 14.5px;
            font-weight: 800;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 4px 16px var(--primary-glow);
        }

        .btn-primary-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(255, 75, 90, 0.5);
        }

        /* Order item preview list */
        .order-preview-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 18px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: var(--transition);
        }

        .order-preview-card:hover {
            border-color: var(--border-hover);
            transform: translateX(4px);
        }

        .order-status-pill {
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            font-size: 12px;
            font-weight: 700;
        }

        .status-confirmed { background: rgba(16, 185, 129, 0.15); color: #34d399; }
        .status-accepted { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
        .status-ready { background: rgba(251, 191, 36, 0.15); color: #fbbf24; }
        .status-delivery { background: rgba(168, 85, 247, 0.15); color: #c084fc; }
        .status-delivered { background: rgba(16, 185, 129, 0.2); color: #10b981; }

        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: 1fr; }
            .form-grid-2 { grid-template-columns: 1fr; }
            .profile-hero { flex-direction: column; align-items: flex-start; }
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

            <div class="nav-actions">
                <a href="restaurant" class="nav-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                    <span>Restaurants</span>
                </a>

                <a href="cart" class="nav-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                    <span>Cart</span>
                    <span class="cart-badge"><%= cartCount %></span>
                </a>

                <a href="orders" class="nav-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                    <span>My Orders</span>
                </a>

                <a href="profile" class="nav-btn active">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Profile</span>
                </a>

                <% if (isAdmin) { %>
                    <a href="restaurant-admin" class="nav-btn admin-pill">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                        <span>Admin Panel</span>
                    </a>
                <% } %>

                <a href="logout" class="nav-btn" style="color:#f87171;" title="Sign Out">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                    <span>Logout</span>
                </a>

                <!-- Theme Toggle Button -->
                <button type="button" class="theme-toggle-btn" onclick="toggleTheme()" title="Toggle Theme" aria-label="Toggle Theme">
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

    <!-- ================= MAIN CONTAINER ================= -->
    <main class="container">

        <% if (successMsg != null) { %>
            <div class="alert-box alert-success">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                <span><%= successMsg %></span>
            </div>
        <% } %>

        <% if (errorMsg != null) { %>
            <div class="alert-box alert-error">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                <span><%= errorMsg %></span>
            </div>
        <% } %>

        <!-- Hero Card -->
        <div class="profile-hero">
            <div class="hero-left">
                <div class="profile-avatar-large"><%= initial %></div>
                <div class="hero-info">
                    <h1><%= displayName %></h1>
                    <div class="hero-meta-pills">
                        <span class="meta-pill">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                            <%= email %>
                        </span>
                        <span class="meta-pill <%= isAdmin ? "role-admin" : "role-badge" %>">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="M12 6v6l4 2"></path></svg>
                            Role: <%= role %>
                        </span>
                        <span class="meta-pill">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            Bangalore, India
                        </span>
                    </div>
                </div>
            </div>

            <div>
                <a href="orders" class="btn-primary-action" style="padding: 10px 20px; font-size: 13.5px; text-decoration: none;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
                    <span>View All Orders</span>
                </a>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255, 75, 90, 0.15); color: var(--primary);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                </div>
                <div>
                    <div class="stat-val"><%= totalOrders %></div>
                    <div class="stat-lbl">Total Orders Placed</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(251, 191, 36, 0.15); color: var(--accent-gold);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                </div>
                <div>
                    <div class="stat-val">&#8377; <%= String.format("%.0f", totalSpent) %></div>
                    <div class="stat-lbl">Lifetime Foodhouse Spend</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(16, 185, 129, 0.15); color: var(--accent-green);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                </div>
                <div>
                    <div class="stat-val" style="color:var(--accent-green);">Active</div>
                    <div class="stat-lbl">Account Status Verified</div>
                </div>
            </div>
        </div>

        <!-- Navigation Tabs -->
        <div class="tabs-nav">
            <button type="button" class="tab-btn active" onclick="switchTab('overviewTab', this)">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="9" y1="3" x2="9" y2="21"></line></svg>
                <span>Overview</span>
            </button>
            <button type="button" class="tab-btn" onclick="switchTab('editProfileTab', this)">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                <span>Edit Profile</span>
            </button>
            <button type="button" class="tab-btn" onclick="switchTab('securityTab', this)">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                <span>Password & Security</span>
            </button>
            <button type="button" class="tab-btn" onclick="switchTab('ordersTab', this)">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                <span>Recent Activity</span>
            </button>
        </div>

        <!-- ================= TAB 1: OVERVIEW ================= -->
        <div id="overviewTab" class="tab-pane active">
            <div class="content-card">
                <div class="content-card-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Personal Profile Information</span>
                </div>
                <p class="content-card-sub">Your registered account credentials and default food delivery destination</p>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-input" value="<%= displayName %>" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Registered Email</label>
                        <input type="text" class="form-input" value="<%= email %>" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input type="text" class="form-input" value="<%= phone %>" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Account Role</label>
                        <input type="text" class="form-input" value="<%= role %>" readonly>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Saved Delivery Address</label>
                        <textarea class="form-textarea" rows="2" readonly><%= address %></textarea>
                    </div>
                </div>

                <div style="margin-top: 20px;">
                    <button type="button" class="btn-primary-action" onclick="document.querySelectorAll('.tab-btn')[1].click();">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                        <span>Update Personal Details</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- ================= TAB 2: EDIT PROFILE ================= -->
        <div id="editProfileTab" class="tab-pane">
            <div class="content-card">
                <div class="content-card-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                    <span>Edit Profile Details</span>
                </div>
                <p class="content-card-sub">Keep your contact number and doorstep address updated for fast food dispatch</p>

                <form action="profile" method="post">
                    <input type="hidden" name="action" value="updateProfile">

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label" for="username">Full Name *</label>
                            <input type="text" id="username" name="username" class="form-input" value="<%= displayName %>" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="phone">Phone Number *</label>
                            <input type="tel" id="phone" name="phone" class="form-input" value="<%= (phone.equals("Not provided")) ? "" : phone %>" placeholder="e.g. 9876543210" required>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label" for="address">Default Delivery Address *</label>
                            <textarea id="address" name="address" class="form-textarea" rows="3" placeholder="e.g. Flat 402, Royal Palms, Koramangala, Bangalore" required><%= (address.equals("No default address saved")) ? "" : address %></textarea>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary-action">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span>Save Changes</span>
                    </button>
                </form>
            </div>
        </div>

        <!-- ================= TAB 3: PASSWORD & SECURITY ================= -->
        <div id="securityTab" class="tab-pane">
            <div class="content-card">
                <div class="content-card-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    <span>Change Account Password</span>
                </div>
                <p class="content-card-sub">Ensure your account uses a secure password with at least 6 characters</p>

                <form action="profile" method="post">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="form-grid-2">
                        <div class="form-group full-width">
                            <label class="form-label" for="currentPassword">Current Password *</label>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-input" placeholder="Enter your current password" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="newPassword">New Password *</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-input" placeholder="Min 6 characters" required minlength="6">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="confirmPassword">Confirm New Password *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-type new password" required minlength="6">
                        </div>
                    </div>

                    <button type="submit" class="btn-primary-action">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 2l-2 2m-2-2l2 2M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 20"></path><path d="M21 3v5h-5"></path></svg>
                        <span>Update Password</span>
                    </button>
                </form>
            </div>
        </div>

        <!-- ================= TAB 4: RECENT ORDERS ================= -->
        <div id="ordersTab" class="tab-pane">
            <div class="content-card">
                <div class="content-card-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                    <span>Recent Orders Summary</span>
                </div>
                <p class="content-card-sub">Your recent dining orders from Bangalore's finest restaurants</p>

                <% if (userOrders == null || userOrders.isEmpty()) { %>
                    <div style="text-align: center; padding: 40px 20px;">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                        <h3 style="margin-top: 12px; font-size: 17px;">No orders found yet</h3>
                        <p style="color: var(--text-secondary); font-size: 14px; margin-top: 6px;">Explore top restaurants and order delicious dishes today.</p>
                        <a href="restaurant" class="btn-primary-action" style="margin-top: 18px; text-decoration: none;">Explore Restaurants</a>
                    </div>
                <% } else { %>
                    <div>
                        <% for (Order o : userOrders) { 
                            String st = (o.getStatus() != null) ? o.getStatus() : "Confirmed";
                            String stClass = "status-confirmed";
                            if (st.equalsIgnoreCase("Accepted")) stClass = "status-accepted";
                            else if (st.equalsIgnoreCase("Food Ready") || st.equalsIgnoreCase("Ready")) stClass = "status-ready";
                            else if (st.equalsIgnoreCase("Out for Delivery")) stClass = "status-delivery";
                            else if (st.equalsIgnoreCase("Delivered")) stClass = "status-delivered";
                        %>
                            <div class="order-preview-card">
                                <div>
                                    <div style="font-weight: 800; font-size: 15px; margin-bottom: 4px;">
                                        Order #FH-<%= o.getOrderId() %>
                                    </div>
                                    <div style="color: var(--text-secondary); font-size: 13px;">
                                        <%= (o.getOrderDate() != null) ? o.getOrderDate().toString().substring(0, 16) : "Recent" %> &bull; Mode: <%= o.getPaymentMode() %>
                                    </div>
                                </div>
                                <div style="display: flex; align-items: center; gap: 16px;">
                                    <div style="font-size: 16px; font-weight: 800; color: var(--accent-gold);">
                                        &#8377; <%= String.format("%.0f", o.getTotalAmount()) %>
                                    </div>
                                    <span class="order-status-pill <%= stClass %>"><%= st %></span>
                                </div>
                            </div>
                        <% } %>
                    </div>
                    <div style="margin-top: 20px;">
                        <a href="orders" class="btn-primary-action" style="text-decoration: none;">
                            <span>View Full Order Tracking Details</span>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                        </a>
                    </div>
                <% } %>
            </div>
        </div>

    </main>

    <script>
        function switchTab(tabId, btn) {
            document.querySelectorAll('.tab-pane').forEach(function(pane) {
                pane.classList.remove('active');
            });
            document.querySelectorAll('.tab-btn').forEach(function(b) {
                b.classList.remove('active');
            });
            document.getElementById(tabId).classList.add('active');
            btn.classList.add('active');
        }

        function toggleTheme() {
            var current = document.documentElement.getAttribute('data-theme') || 'dark';
            var next = (current === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('foodhouse_theme', next);
        }
    </script>
</body>
</html>
