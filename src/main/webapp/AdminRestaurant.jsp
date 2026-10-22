<%-- 
    ========================================================================
    FILE: AdminRestaurant.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Executive Restaurant Admin Portal.
                 Features ROW-WISE restaurant display, full CRUD for restaurants,
                 row-wise menu item management, and kitchen order acceptance flow.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.tap.model.Restaurant, com.tap.model.Menu, com.tap.model.Order, com.tap.model.OrderItem, com.tap.model.User" %>

<%
    User adminUser = (User) session.getAttribute("loggedInUser");
    if (adminUser == null) adminUser = (User) session.getAttribute("user");

    @SuppressWarnings("unchecked")
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    Restaurant selectedRestaurant = (Restaurant) request.getAttribute("selectedRestaurant");
    @SuppressWarnings("unchecked")
    List<Menu> restaurantMenus = (List<Menu>) request.getAttribute("restaurantMenus");
    @SuppressWarnings("unchecked")
    List<Order> allOrders = (List<Order>) request.getAttribute("allOrders");
    @SuppressWarnings("unchecked")
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    @SuppressWarnings("unchecked")
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");
    @SuppressWarnings("unchecked")
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");

    String adminSuccess = (String) session.getAttribute("adminSuccess");
    session.removeAttribute("adminSuccess");

    int totalRestaurants = (restaurants != null) ? restaurants.size() : 0;
    int totalMenus = (restaurantMenus != null) ? restaurantMenus.size() : 0;
    int pendingOrders = 0;
    if (allOrders != null) {
        for (Order o : allOrders) {
            String s = (o.getStatus() != null) ? o.getStatus().trim() : "";
            if ("Confirmed".equalsIgnoreCase(s) || "Placed".equalsIgnoreCase(s) || "Accepted".equalsIgnoreCase(s)) {
                pendingOrders++;
            }
        }
    }

    String activeTab = request.getParameter("tab");
    if (activeTab == null || activeTab.trim().isEmpty()) {
        activeTab = "restaurants";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Executive Restaurant & Kitchen Admin</title>
    
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
            --bg-body: #080c14;
            --bg-card: rgba(15, 23, 42, 0.88);
            --bg-table-row: rgba(26, 36, 56, 0.6);
            --bg-table-hover: rgba(37, 51, 79, 0.85);
            
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.45);
            
            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.35);
            
            --accent-gold: #fbbf24;
            --accent-green: #10b981;
            --accent-blue: #38bdf8;
            --accent-purple: #a855f7;
            
            --text-main: #ffffff;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            
            --radius-xl: 18px;
            --radius-lg: 12px;
            --radius-md: 8px;
            --radius-pill: 9999px;
            
            --transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        }

        [data-theme="light"] {
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --bg-table-row: #ffffff;
            --bg-table-hover: #f1f5f9;
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
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            min-height: 100vh;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.06) 0px, transparent 50%);
            background-attachment: fixed;
        }

        /* Navbar */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(8, 12, 20, 0.94);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border-subtle);
            padding: 12px 24px;
        }

        [data-theme="light"] .navbar {
            background: rgba(255, 255, 255, 0.94);
        }

        .nav-container {
            max-width: 1400px;
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
            color: var(--text-main);
            font-size: 20px;
            font-weight: 800;
        }

        .brand-logo-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--accent-gold) 0%, #f59e0b 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #000000;
            font-weight: 900;
        }

        .badge-admin {
            background: rgba(251, 191, 36, 0.18);
            color: var(--accent-gold);
            font-size: 11px;
            font-weight: 800;
            padding: 3px 8px;
            border-radius: var(--radius-pill);
            border: 1px solid rgba(251, 191, 36, 0.35);
            text-transform: uppercase;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-link {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 14px;
            border-radius: var(--radius-pill);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            color: var(--text-secondary);
            border: 1px solid var(--border-subtle);
            transition: var(--transition);
        }

        .nav-link:hover {
            color: var(--primary);
            border-color: var(--border-hover);
        }

        .nav-link.active {
            background: var(--primary-glow);
            color: var(--primary);
            border-color: var(--primary);
        }

        .theme-toggle-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-subtle);
            color: var(--accent-gold);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .theme-icon-light { display: none; }
        .theme-icon-dark { display: flex; }
        [data-theme="light"] .theme-icon-light { display: flex; }
        [data-theme="light"] .theme-icon-dark { display: none; }

        /* Main Container */
        .admin-container {
            max-width: 1400px;
            margin: 28px auto;
            padding: 0 24px;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 800;
        }

        .stat-label {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 600;
        }

        /* Tabs Navigation */
        .tabs-nav {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-subtle);
            padding-bottom: 12px;
            overflow-x: auto;
        }

        .tab-btn {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            padding: 10px 20px;
            border-radius: var(--radius-pill);
            font-size: 14.5px;
            font-weight: 800;
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
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .tab-pane {
            display: none;
        }

        .tab-pane.active {
            display: block;
            animation: fadeIn 0.25s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Top Action Bar in Tabs */
        .tab-header-flex {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .tab-heading {
            font-size: 20px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-add-action {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, var(--accent-green) 0%, #059669 100%);
            color: #ffffff;
            border: none;
            padding: 10px 18px;
            border-radius: var(--radius-pill);
            font-size: 13.5px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.35);
            transition: var(--transition);
        }

        .btn-add-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.5);
        }

        /* Row-wise Table Container */
        .table-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            overflow: hidden;
            box-shadow: 0 12px 36px rgba(0, 0, 0, 0.3);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .data-table th {
            background: rgba(0, 0, 0, 0.25);
            padding: 14px 18px;
            font-size: 12.5px;
            font-weight: 800;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            border-bottom: 1px solid var(--border-subtle);
        }

        .data-table td {
            padding: 14px 18px;
            font-size: 13.5px;
            border-bottom: 1px solid var(--border-subtle);
            vertical-align: middle;
            transition: background 0.15s ease;
        }

        .data-table tr:hover td {
            background: var(--bg-table-hover);
        }

        /* Table elements */
        .table-thumb {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid var(--border-subtle);
            flex-shrink: 0;
        }

        .rest-cell-flex {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .rest-name-text {
            font-weight: 800;
            color: var(--text-main);
        }

        .pill-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
            font-size: 12px;
            font-weight: 700;
        }

        .pill-green { background: rgba(16, 185, 129, 0.15); color: #34d399; }
        .pill-red { background: rgba(239, 68, 68, 0.15); color: #f87171; }
        .pill-gold { background: rgba(251, 191, 36, 0.15); color: #fbbf24; }
        .pill-blue { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
        .pill-purple { background: rgba(168, 85, 247, 0.15); color: #c084fc; }

        /* Action Buttons */
        .actions-flex {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-act {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            border: 1px solid var(--border-subtle);
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: rgba(255, 255, 255, 0.04);
            color: var(--text-main);
            text-decoration: none;
        }

        .btn-act:hover {
            transform: translateY(-1px);
        }

        .btn-act.menu-btn {
            background: rgba(56, 189, 248, 0.15);
            color: var(--accent-blue);
            border-color: rgba(56, 189, 248, 0.35);
        }

        .btn-act.edit-btn {
            background: rgba(251, 191, 36, 0.15);
            color: var(--accent-gold);
            border-color: rgba(251, 191, 36, 0.35);
        }

        .btn-act.del-btn {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border-color: rgba(239, 68, 68, 0.35);
        }

        .btn-act.accept-btn {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff;
            border: none;
            padding: 8px 14px;
            font-weight: 800;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.35);
        }

        .btn-act.ready-btn {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: #ffffff;
            border: none;
            padding: 8px 14px;
            font-weight: 800;
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.35);
        }

        /* Success Alert */
        .alert-box {
            padding: 14px 18px;
            border-radius: var(--radius-md);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 700;
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.35);
            color: #34d399;
        }

        /* Modals */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(8px);
            z-index: 999;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-dialog {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            width: 100%;
            max-width: 580px;
            padding: 28px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.6);
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .modal-title {
            font-size: 19px;
            font-weight: 800;
        }

        .modal-close-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 22px;
            line-height: 1;
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-label {
            font-size: 12.5px;
            font-weight: 700;
            color: var(--text-secondary);
        }

        .form-input, .form-textarea, .form-select {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 10px 14px;
            color: var(--text-main);
            font-size: 14px;
            width: 100%;
        }

        [data-theme="light"] .form-input, 
        [data-theme="light"] .form-textarea,
        [data-theme="light"] .form-select {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.15);
        }

        .form-input:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
        }
    </style>
</head>
<body>

    <!-- ================= NAVBAR ================= -->
    <header class="navbar">
        <div class="nav-container">
            <a href="restaurant" class="brand-logo">
                <div class="brand-logo-icon">FH</div>
                <div>Food<span>House</span></div>
                <span class="badge-admin">Restaurant Admin</span>
            </a>

            <div class="nav-actions">
                <a href="restaurant" class="nav-link" target="_blank" title="View customer-facing storefront">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                    <span>Storefront View</span>
                </a>

                <a href="delivery-admin" class="nav-link" style="color:var(--accent-blue);" title="Switch to Delivery Partner Portal">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                    <span>Delivery Portal</span>
                </a>

                <a href="profile" class="nav-link">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>My Profile</span>
                </a>

                <a href="logout" class="nav-link" style="color:#f87171;">Logout</a>

                <!-- Theme Toggle -->
                <button type="button" class="theme-toggle-btn" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                    <span class="theme-icon-dark"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg></span>
                    <span class="theme-icon-light"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line></svg></span>
                </button>
            </div>
        </div>
    </header>

    <!-- ================= MAIN CONTAINER ================= -->
    <main class="admin-container">

        <% if (adminSuccess != null) { %>
            <div class="alert-box">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                <span><%= adminSuccess %></span>
            </div>
        <% } %>

        <!-- Top Metric Counters -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(251, 191, 36, 0.15); color: var(--accent-gold);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                </div>
                <div>
                    <div class="stat-value"><%= totalRestaurants %></div>
                    <div class="stat-label">Active Partner Restaurants</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(56, 189, 248, 0.15); color: var(--accent-blue);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                </div>
                <div>
                    <div class="stat-value"><%= totalMenus %></div>
                    <div class="stat-label">Dishes for Current Restaurant</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255, 75, 90, 0.15); color: var(--primary);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                </div>
                <div>
                    <div class="stat-value" style="color:var(--primary);"><%= pendingOrders %></div>
                    <div class="stat-label">Kitchen Orders Requiring Action</div>
                </div>
            </div>
        </div>

        <!-- Navigation Tabs -->
        <div class="tabs-nav">
            <button type="button" class="tab-btn <%= "restaurants".equals(activeTab) ? "active" : "" %>" onclick="openTab('restaurantsTab', this)">
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                <span>Restaurants (Row-Wise Table)</span>
            </button>
            <button type="button" class="tab-btn <%= "menu".equals(activeTab) ? "active" : "" %>" onclick="openTab('menuTab', this)">
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>
                <span>Restaurant Menu Management</span>
            </button>
            <button type="button" class="tab-btn <%= "orders".equals(activeTab) ? "active" : "" %>" onclick="openTab('ordersTab', this)">
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                <span>Kitchen Live Orders & Accept</span>
                <% if (pendingOrders > 0) { %>
                    <span style="background:#ffffff; color:var(--primary); font-size:11px; padding:1px 6px; border-radius:10px; font-weight:800;"><%= pendingOrders %></span>
                <% } %>
            </button>
        </div>

        <!-- ================= TAB 1: RESTAURANTS (ROW-WISE TABLE) ================= -->
        <div id="restaurantsTab" class="tab-pane <%= "restaurants".equals(activeTab) ? "active" : "" %>">
            <div class="tab-header-flex">
                <div class="tab-heading">
                    <span>Bangalore Partner Restaurants</span>
                    <span class="pill-badge pill-gold"><%= totalRestaurants %> Total</span>
                </div>
                <button type="button" class="btn-add-action" onclick="openModal('addRestaurantModal')">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    <span>Add New Restaurant</span>
                </button>
            </div>

            <div class="table-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 50px;">ID</th>
                            <th>Restaurant</th>
                            <th>Cuisine</th>
                            <th>Delivery Time</th>
                            <th>Location / Address</th>
                            <th>Rating</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (restaurants != null) { 
                            for (Restaurant r : restaurants) { %>
                            <tr>
                                <td><strong style="color:var(--text-muted);">#<%= r.getRestaurantId() %></strong></td>
                                <td>
                                    <div class="rest-cell-flex">
                                        <img src="<%= r.getImagePath() %>" alt="<%= r.getName() %>" class="table-thumb" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=100&q=80';">
                                        <div>
                                            <div class="rest-name-text"><%= r.getName() %></div>
                                            <div style="font-size: 11.5px; color: var(--text-muted);">Admin ID: <%= r.getAdminUserId() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="pill-badge pill-blue"><%= r.getCuisineType() %></span></td>
                                <td>
                                    <span style="font-weight: 700; color: var(--text-secondary);">
                                        <%= r.getDeliveryTime() %> mins
                                    </span>
                                </td>
                                <td style="max-width: 220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: var(--text-secondary);">
                                    <%= r.getAddress() %>
                                </td>
                                <td>
                                    <span class="pill-badge pill-gold">
                                        &#9733; <%= r.getRating() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (r.isActive()) { %>
                                        <span class="pill-badge pill-green">Active</span>
                                    <% } else { %>
                                        <span class="pill-badge pill-red">Inactive</span>
                                    <% } %>
                                </td>
                                <td style="text-align: right;">
                                    <div class="actions-flex" style="justify-content: flex-end;">
                                        <!-- Manage Menu Button -->
                                        <a href="restaurant-admin?restaurantId=<%= r.getRestaurantId() %>&tab=menu" class="btn-act menu-btn" title="View dishes for this restaurant">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line></svg>
                                            <span>Menu</span>
                                        </a>

                                        <!-- Edit Restaurant Button -->
                                        <button type="button" class="btn-act edit-btn" onclick="openEditRestaurantModal('<%= r.getRestaurantId() %>', '<%= r.getName().replace("'", "\\'") %>', '<%= r.getCuisineType().replace("'", "\\'") %>', '<%= r.getDeliveryTime() %>', '<%= r.getAddress().replace("'", "\\'") %>', '<%= r.getRating() %>', <%= r.isActive() %>, '<%= r.getImagePath().replace("'", "\\'") %>')">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                            <span>Edit</span>
                                        </button>

                                        <!-- Delete Restaurant Button -->
                                        <form action="restaurant-admin" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete <%= r.getName().replace("'", "") %>? All its menus will also be deleted.');">
                                            <input type="hidden" name="action" value="deleteRestaurant">
                                            <input type="hidden" name="restaurantId" value="<%= r.getRestaurantId() %>">
                                            <button type="submit" class="btn-act del-btn">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                <span>Delete</span>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= TAB 2: MENU MANAGEMENT (ROW-WISE TABLE) ================= -->
        <div id="menuTab" class="tab-pane <%= "menu".equals(activeTab) ? "active" : "" %>">
            <div class="tab-header-flex">
                <div class="tab-heading">
                    <span>Menu Items for:</span>
                    <form action="restaurant-admin" method="get" style="display:inline-flex; align-items:center; gap:8px;">
                        <input type="hidden" name="tab" value="menu">
                        <select name="restaurantId" class="form-select" onchange="this.form.submit()" style="font-weight:800; font-size:15px; padding:6px 14px;">
                            <% if (restaurants != null) {
                                for (Restaurant r : restaurants) { %>
                                <option value="<%= r.getRestaurantId() %>" <%= (selectedRestaurant != null && selectedRestaurant.getRestaurantId() == r.getRestaurantId()) ? "selected" : "" %>>
                                    <%= r.getName() %> (<%= r.getCuisineType() %>)
                                </option>
                            <% } } %>
                        </select>
                    </form>
                    <span class="pill-badge pill-blue"><%= totalMenus %> Dishes</span>
                </div>

                <% if (selectedRestaurant != null) { %>
                    <button type="button" class="btn-add-action" onclick="openModal('addMenuModal')">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        <span>Add New Dish</span>
                    </button>
                <% } %>
            </div>

            <div class="table-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 50px;">ID</th>
                            <th>Dish & Name</th>
                            <th>Description</th>
                            <th>Price (INR)</th>
                            <th>Availability</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (restaurantMenus != null && !restaurantMenus.isEmpty()) { 
                            for (Menu m : restaurantMenus) { %>
                            <tr>
                                <td><strong style="color:var(--text-muted);">#<%= m.getMenuId() %></strong></td>
                                <td>
                                    <div class="rest-cell-flex">
                                        <img src="<%= m.getImagePath() %>" alt="<%= m.getItemName() %>" class="table-thumb" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=100&q=80';">
                                        <div>
                                            <div class="rest-name-text"><%= m.getItemName() %></div>
                                            <div style="font-size: 11.5px; color: var(--text-muted);">Restaurant ID: <%= m.getRestaurantId() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td style="max-width: 320px; color: var(--text-secondary); font-size: 13px;">
                                    <%= (m.getDescription() != null) ? m.getDescription() : "Freshly prepared gourmet dish" %>
                                </td>
                                <td>
                                    <strong style="color: var(--accent-gold); font-size: 15px;">
                                        &#8377; <%= String.format("%.0f", m.getPrice()) %>
                                    </strong>
                                </td>
                                <td>
                                    <form action="restaurant-admin" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="toggleMenuAvailability">
                                        <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                        <input type="hidden" name="restaurantId" value="<%= m.getRestaurantId() %>">
                                        <button type="submit" class="pill-badge <%= m.isAvailable() ? "pill-green" : "pill-red" %>" style="border:none; cursor:pointer;" title="Click to toggle availability">
                                            <%= m.isAvailable() ? "&#10003; In Stock" : "&#10005; Out of Stock" %>
                                        </button>
                                    </form>
                                </td>
                                <td style="text-align: right;">
                                    <div class="actions-flex" style="justify-content: flex-end;">
                                        <!-- Edit Dish Button -->
                                        <button type="button" class="btn-act edit-btn" onclick="openEditMenuModal('<%= m.getMenuId() %>', '<%= m.getRestaurantId() %>', '<%= m.getItemName().replace("'", "\\'") %>', '<%= (m.getDescription() != null ? m.getDescription() : "").replace("'", "\\'") %>', '<%= m.getPrice() %>', <%= m.isAvailable() %>, '<%= m.getImagePath().replace("'", "\\'") %>')">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                            <span>Edit</span>
                                        </button>

                                        <!-- Delete Dish Button -->
                                        <form action="restaurant-admin" method="post" style="display:inline;" onsubmit="return confirm('Delete dish: <%= m.getItemName().replace("'", "") %>?');">
                                            <input type="hidden" name="action" value="deleteMenu">
                                            <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                            <input type="hidden" name="restaurantId" value="<%= m.getRestaurantId() %>">
                                            <button type="submit" class="btn-act del-btn">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path></svg>
                                                <span>Delete</span>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                    No menu items added for this restaurant yet. Click "Add New Dish" above to create dishes!
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ================= TAB 3: KITCHEN LIVE ORDERS & ACCEPT ================= -->
        <div id="ordersTab" class="tab-pane <%= "orders".equals(activeTab) ? "active" : "" %>">
            <div class="tab-header-flex">
                <div class="tab-heading">
                    <span>Kitchen Incoming Orders & Prep Status</span>
                    <span class="pill-badge pill-purple">Real-Time Kitchen Queue</span>
                </div>
            </div>

            <div class="table-card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 70px;">Order #</th>
                            <th>Restaurant</th>
                            <th>Items & Quantities</th>
                            <th>Total Bill</th>
                            <th>Payment</th>
                            <th>Kitchen Status</th>
                            <th style="text-align: right;">Kitchen Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (allOrders != null && !allOrders.isEmpty()) { 
                            for (Order ord : allOrders) { 
                                Restaurant ordRest = (restaurantMap != null) ? restaurantMap.get(ord.getRestaurantId()) : null;
                                String restName = (ordRest != null) ? ordRest.getName() : ("Restaurant #" + ord.getRestaurantId());
                                List<OrderItem> ordItems = (orderItemsMap != null) ? orderItemsMap.get(ord.getOrderId()) : null;
                                String st = (ord.getStatus() != null) ? ord.getStatus().trim() : "Confirmed";
                        %>
                            <tr>
                                <td><strong style="color:var(--text-main);">#FH-<%= ord.getOrderId() %></strong></td>
                                <td>
                                    <div style="font-weight: 800;"><%= restName %></div>
                                    <div style="font-size: 12px; color: var(--text-muted);"><%= ord.getOrderDate() != null ? ord.getOrderDate().toString().substring(0, 16) : "" %></div>
                                </td>
                                <td>
                                    <% if (ordItems != null && !ordItems.isEmpty()) { %>
                                        <div style="display: flex; flex-direction: column; gap: 4px;">
                                            <% for (OrderItem itm : ordItems) { 
                                                Menu m = (menuMap != null) ? menuMap.get(itm.getMenuId()) : null;
                                                String itmName = (m != null) ? m.getItemName() : ("Dish #" + itm.getMenuId());
                                            %>
                                                <span style="font-size: 13px;">
                                                    <strong style="color:var(--accent-gold);"><%= itm.getQuantity() %>x</strong> <%= itmName %>
                                                </span>
                                            <% } %>
                                        </div>
                                    <% } else { %>
                                        <span style="color: var(--text-muted);">Standard Order Package</span>
                                    <% } %>
                                </td>
                                <td>
                                    <strong style="color: var(--accent-gold); font-size: 15px;">
                                        &#8377; <%= String.format("%.0f", ord.getTotalAmount()) %>
                                    </strong>
                                </td>
                                <td>
                                    <span class="pill-badge pill-blue"><%= ord.getPaymentMode() %></span>
                                </td>
                                <td>
                                    <% if ("Confirmed".equalsIgnoreCase(st) || "Placed".equalsIgnoreCase(st)) { %>
                                        <span class="pill-badge pill-gold">&#9203; Awaiting Acceptance</span>
                                    <% } else if ("Accepted".equalsIgnoreCase(st)) { %>
                                        <span class="pill-badge pill-blue">&#128293; Cooking / In Kitchen</span>
                                    <% } else if ("Food Ready".equalsIgnoreCase(st)) { %>
                                        <span class="pill-badge pill-purple">&#128230; Food Ready (Packed)</span>
                                    <% } else if ("Out for Delivery".equalsIgnoreCase(st)) { %>
                                        <span class="pill-badge pill-blue">&#128693; Out for Delivery</span>
                                    <% } else if ("Delivered".equalsIgnoreCase(st)) { %>
                                        <span class="pill-badge pill-green">&#10004; Delivered</span>
                                    <% } else { %>
                                        <span class="pill-badge pill-gold"><%= st %></span>
                                    <% } %>
                                </td>
                                <td style="text-align: right;">
                                    <% if ("Confirmed".equalsIgnoreCase(st) || "Placed".equalsIgnoreCase(st)) { %>
                                        <!-- Step 1: Restaurant Accepts Order -->
                                        <form action="restaurant-admin" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="acceptOrder">
                                            <input type="hidden" name="orderId" value="<%= ord.getOrderId() %>">
                                            <button type="submit" class="btn-act accept-btn" title="Accept order into kitchen">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                <span>Accept Order</span>
                                            </button>
                                        </form>
                                    <% } else if ("Accepted".equalsIgnoreCase(st)) { %>
                                        <!-- Step 2: Food is Ready -->
                                        <form action="restaurant-admin" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="foodReady">
                                            <input type="hidden" name="orderId" value="<%= ord.getOrderId() %>">
                                            <button type="submit" class="btn-act ready-btn" title="Mark dishes packed and ready for delivery agent">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                                                <span>Food is Ready</span>
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span style="font-size: 12px; font-weight: 700; color: var(--text-muted);">
                                            Handed to Courier
                                        </span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="7" style="text-align:center; padding: 40px; color: var(--text-secondary);">
                                    No customer orders placed yet. Place an order from the cart to test the kitchen flow!
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <!-- ================= MODAL: ADD RESTAURANT ================= -->
    <div id="addRestaurantModal" class="modal-overlay">
        <div class="modal-dialog">
            <div class="modal-header">
                <div class="modal-title">Add New Partner Restaurant</div>
                <button type="button" class="modal-close-btn" onclick="closeModal('addRestaurantModal')">&times;</button>
            </div>
            <form action="restaurant-admin" method="post">
                <input type="hidden" name="action" value="addRestaurant">
                <div class="form-grid-2">
                    <div class="form-group full">
                        <label class="form-label">Restaurant Name *</label>
                        <input type="text" name="name" class="form-input" placeholder="e.g. Rameshwaram Cafe" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Cuisine Type *</label>
                        <input type="text" name="cuisineType" class="form-input" placeholder="e.g. South Indian & Ghee Dosa" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Delivery Time (Mins) *</label>
                        <input type="number" name="deliveryTime" class="form-input" value="25" min="10" max="90" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rating (1.0 to 5.0) *</label>
                        <input type="number" step="0.1" name="rating" class="form-input" value="4.5" min="1.0" max="5.0" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Active Status</label>
                        <select name="isActive" class="form-select">
                            <option value="true" selected>Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Address / Landmark *</label>
                        <input type="text" name="address" class="form-input" placeholder="e.g. 100ft Road, Indiranagar, Bangalore" required>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Cover Image URL</label>
                        <input type="url" name="imagePath" class="form-input" placeholder="https://images.unsplash.com/...">
                    </div>
                </div>
                <button type="submit" class="btn-add-action" style="width:100%; justify-content:center; padding:12px;">Create Restaurant</button>
            </form>
        </div>
    </div>

    <!-- ================= MODAL: EDIT RESTAURANT ================= -->
    <div id="editRestaurantModal" class="modal-overlay">
        <div class="modal-dialog">
            <div class="modal-header">
                <div class="modal-title">Edit Restaurant Details</div>
                <button type="button" class="modal-close-btn" onclick="closeModal('editRestaurantModal')">&times;</button>
            </div>
            <form action="restaurant-admin" method="post">
                <input type="hidden" name="action" value="editRestaurant">
                <input type="hidden" id="editRestId" name="restaurantId" value="">
                <div class="form-grid-2">
                    <div class="form-group full">
                        <label class="form-label">Restaurant Name *</label>
                        <input type="text" id="editRestName" name="name" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Cuisine Type *</label>
                        <input type="text" id="editRestCuisine" name="cuisineType" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Delivery Time (Mins) *</label>
                        <input type="number" id="editRestTime" name="deliveryTime" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rating *</label>
                        <input type="number" step="0.1" id="editRestRating" name="rating" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Active Status</label>
                        <select id="editRestActive" name="isActive" class="form-select">
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Address *</label>
                        <input type="text" id="editRestAddress" name="address" class="form-input" required>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Cover Image URL</label>
                        <input type="url" id="editRestImage" name="imagePath" class="form-input">
                    </div>
                </div>
                <button type="submit" class="btn-add-action" style="width:100%; justify-content:center; padding:12px;">Save Restaurant Changes</button>
            </form>
        </div>
    </div>

    <!-- ================= MODAL: ADD MENU DISH ================= -->
    <div id="addMenuModal" class="modal-overlay">
        <div class="modal-dialog">
            <div class="modal-header">
                <div class="modal-title">Add Dish to <%= (selectedRestaurant != null) ? selectedRestaurant.getName() : "Restaurant" %></div>
                <button type="button" class="modal-close-btn" onclick="closeModal('addMenuModal')">&times;</button>
            </div>
            <form action="restaurant-admin" method="post">
                <input type="hidden" name="action" value="addMenu">
                <input type="hidden" name="restaurantId" value="<%= (selectedRestaurant != null) ? selectedRestaurant.getRestaurantId() : 1 %>">
                <div class="form-grid-2">
                    <div class="form-group full">
                        <label class="form-label">Dish Name *</label>
                        <input type="text" name="itemName" class="form-input" placeholder="e.g. Special Ghee Podi Idli" required>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-textarea" rows="2" placeholder="Rich ghee tossed idlis served with spicy gunpowder and coconut chutney"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Price (INR) *</label>
                        <input type="number" step="1" name="price" class="form-input" value="150" min="10" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Stock Status</label>
                        <select name="isAvailable" class="form-select">
                            <option value="true" selected>In Stock</option>
                            <option value="false">Out of Stock</option>
                        </select>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Dish Image URL</label>
                        <input type="url" name="imagePath" class="form-input" placeholder="https://images.unsplash.com/...">
                    </div>
                </div>
                <button type="submit" class="btn-add-action" style="width:100%; justify-content:center; padding:12px;">Add Dish to Menu</button>
            </form>
        </div>
    </div>

    <!-- ================= MODAL: EDIT MENU DISH ================= -->
    <div id="editMenuModal" class="modal-overlay">
        <div class="modal-dialog">
            <div class="modal-header">
                <div class="modal-title">Edit Menu Dish</div>
                <button type="button" class="modal-close-btn" onclick="closeModal('editMenuModal')">&times;</button>
            </div>
            <form action="restaurant-admin" method="post">
                <input type="hidden" name="action" value="editMenu">
                <input type="hidden" id="editMenuId" name="menuId" value="">
                <input type="hidden" id="editMenuRestId" name="restaurantId" value="">
                <div class="form-grid-2">
                    <div class="form-group full">
                        <label class="form-label">Dish Name *</label>
                        <input type="text" id="editMenuName" name="itemName" class="form-input" required>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Description</label>
                        <textarea id="editMenuDesc" name="description" class="form-textarea" rows="2"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Price (INR) *</label>
                        <input type="number" step="1" id="editMenuPrice" name="price" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Stock Status</label>
                        <select id="editMenuAvail" name="isAvailable" class="form-select">
                            <option value="true">In Stock</option>
                            <option value="false">Out of Stock</option>
                        </select>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Dish Image URL</label>
                        <input type="url" id="editMenuImage" name="imagePath" class="form-input">
                    </div>
                </div>
                <button type="submit" class="btn-add-action" style="width:100%; justify-content:center; padding:12px;">Save Dish Changes</button>
            </form>
        </div>
    </div>

    <script>
        function openTab(tabId, btn) {
            document.querySelectorAll('.tab-pane').forEach(function(pane) {
                pane.classList.remove('active');
            });
            document.querySelectorAll('.tab-btn').forEach(function(b) {
                b.classList.remove('active');
            });
            document.getElementById(tabId).classList.add('active');
            if (btn) btn.classList.add('active');
        }

        function openModal(id) {
            document.getElementById(id).classList.add('active');
        }

        function closeModal(id) {
            document.getElementById(id).classList.remove('active');
        }

        function openEditRestaurantModal(id, name, cuisine, time, address, rating, active, img) {
            document.getElementById('editRestId').value = id;
            document.getElementById('editRestName').value = name;
            document.getElementById('editRestCuisine').value = cuisine;
            document.getElementById('editRestTime').value = time;
            document.getElementById('editRestAddress').value = address;
            document.getElementById('editRestRating').value = rating;
            document.getElementById('editRestActive').value = active ? 'true' : 'false';
            document.getElementById('editRestImage').value = img;
            openModal('editRestaurantModal');
        }

        function openEditMenuModal(id, restId, name, desc, price, avail, img) {
            document.getElementById('editMenuId').value = id;
            document.getElementById('editMenuRestId').value = restId;
            document.getElementById('editMenuName').value = name;
            document.getElementById('editMenuDesc').value = desc;
            document.getElementById('editMenuPrice').value = price;
            document.getElementById('editMenuAvail').value = avail ? 'true' : 'false';
            document.getElementById('editMenuImage').value = img;
            openModal('editMenuModal');
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
