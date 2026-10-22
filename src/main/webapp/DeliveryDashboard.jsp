<%-- 
    ========================================================================
    FILE: DeliveryDashboard.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Executive Delivery Agent / Rider Operations Portal.
                 Allows delivery partners to accept food pickup, track in-transit
                 orders, and confirm delivery to customer doorstep.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.tap.model.Order, com.tap.model.Restaurant, com.tap.model.User, com.tap.model.OrderItem" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) user = (User) session.getAttribute("user");

    @SuppressWarnings("unchecked")
    List<Order> readyDeliveries = (List<Order>) request.getAttribute("readyDeliveries");
    @SuppressWarnings("unchecked")
    List<Order> activeDeliveries = (List<Order>) request.getAttribute("activeDeliveries");
    @SuppressWarnings("unchecked")
    List<Order> completedDeliveries = (List<Order>) request.getAttribute("completedDeliveries");

    @SuppressWarnings("unchecked")
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    @SuppressWarnings("unchecked")
    Map<Integer, User> customerMap = (Map<Integer, User>) request.getAttribute("customerMap");
    @SuppressWarnings("unchecked")
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");

    String deliverySuccess = (String) session.getAttribute("deliverySuccess");
    session.removeAttribute("deliverySuccess");

    int readyCount = (readyDeliveries != null) ? readyDeliveries.size() : 0;
    int activeCount = (activeDeliveries != null) ? activeDeliveries.size() : 0;
    int completedCount = (completedDeliveries != null) ? completedDeliveries.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Delivery Partner Operations</title>
    
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
            --border-hover: rgba(56, 189, 248, 0.45);
            
            --primary: #38bdf8;
            --accent-green: #10b981;
            --accent-gold: #fbbf24;
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
            --border-hover: rgba(56, 189, 248, 0.5);
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
                radial-gradient(at 0% 0%, rgba(56, 189, 248, 0.08) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(16, 185, 129, 0.06) 0px, transparent 50%);
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
            background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 900;
        }

        .badge-partner {
            background: rgba(56, 189, 248, 0.15);
            color: var(--primary);
            font-size: 11px;
            font-weight: 800;
            padding: 3px 8px;
            border-radius: var(--radius-pill);
            border: 1px solid rgba(56, 189, 248, 0.35);
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

        /* Container */
        .admin-container {
            max-width: 1300px;
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

        /* Table Card */
        .table-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            overflow: hidden;
            box-shadow: 0 12px 36px rgba(0, 0, 0, 0.3);
            margin-bottom: 28px;
        }

        .table-header-title {
            padding: 18px 22px;
            font-size: 17px;
            font-weight: 800;
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
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
        }

        .data-table tr:hover td {
            background: var(--bg-table-hover);
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
        .pill-gold { background: rgba(251, 191, 36, 0.15); color: #fbbf24; }
        .pill-blue { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
        .pill-purple { background: rgba(168, 85, 247, 0.15); color: #c084fc; }

        .btn-pickup {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, #38bdf8 0%, #0284c7 100%);
            color: #ffffff;
            border: none;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-size: 12.5px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(56, 189, 248, 0.35);
            transition: var(--transition);
        }

        .btn-pickup:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(56, 189, 248, 0.55);
        }

        .btn-deliver {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff;
            border: none;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-size: 12.5px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.35);
            transition: var(--transition);
        }

        .btn-deliver:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(16, 185, 129, 0.55);
        }

        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <!-- ================= NAVBAR ================= -->
    <header class="navbar">
        <div class="nav-container">
            <a href="restaurant" class="brand-logo">
                <div class="brand-logo-icon">&#128693;</div>
                <div>Food<span>House</span></div>
                <span class="badge-partner">Delivery Partner Portal</span>
            </a>

            <div class="nav-actions">
                <a href="restaurant" class="nav-link" target="_blank" title="View customer storefront">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                    <span>Storefront View</span>
                </a>

                <a href="restaurant-admin" class="nav-link" style="color:var(--accent-gold);" title="Switch to Restaurant Admin">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                    <span>Restaurant Admin</span>
                </a>

                <a href="profile" class="nav-link">Profile</a>
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

        <% if (deliverySuccess != null) { %>
            <div class="alert-box">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                <span><%= deliverySuccess %></span>
            </div>
        <% } %>

        <!-- Stats Counters -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(168, 85, 247, 0.15); color: var(--accent-purple);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                </div>
                <div>
                    <div class="stat-value" style="color:var(--accent-purple);"><%= readyCount %></div>
                    <div class="stat-label">Orders Ready for Kitchen Pickup</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(56, 189, 248, 0.15); color: var(--primary);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                </div>
                <div>
                    <div class="stat-value" style="color:var(--primary);"><%= activeCount %></div>
                    <div class="stat-label">Active Orders Out for Delivery</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(16, 185, 129, 0.15); color: var(--accent-green);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                </div>
                <div>
                    <div class="stat-value" style="color:var(--accent-green);"><%= completedCount %></div>
                    <div class="stat-label">Orders Delivered Today</div>
                </div>
            </div>
        </div>

        <!-- Section 1: Orders Ready for Pickup -->
        <div class="table-card">
            <div class="table-header-title">
                <span>&#128230; Orders Ready for Restaurant Pickup</span>
                <span class="pill-badge pill-purple"><%= readyCount %> Available</span>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">Order #</th>
                        <th>Restaurant (Pickup Point)</th>
                        <th>Customer Delivery Address</th>
                        <th>Order Amount</th>
                        <th>Payment Mode</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (readyDeliveries != null && !readyDeliveries.isEmpty()) { 
                        for (Order ord : readyDeliveries) { 
                            Restaurant r = (restaurantMap != null) ? restaurantMap.get(ord.getRestaurantId()) : null;
                            User cust = (customerMap != null) ? customerMap.get(ord.getUserId()) : null;
                    %>
                        <tr>
                            <td><strong style="color:var(--text-main);">#FH-<%= ord.getOrderId() %></strong></td>
                            <td>
                                <div style="font-weight: 800;"><%= (r != null) ? r.getName() : "Restaurant" %></div>
                                <div style="font-size: 12px; color: var(--text-muted);"><%= (r != null) ? r.getAddress() : "Bangalore" %></div>
                            </td>
                            <td>
                                <div style="font-weight: 700;"><%= (cust != null && cust.getUsername() != null) ? cust.getUsername() : "Customer" %> (<%= (cust != null && cust.getPhone() != null) ? cust.getPhone() : "" %>)</div>
                                <div style="font-size: 12px; color: var(--text-secondary);"><%= (cust != null && cust.getAddress() != null) ? cust.getAddress() : "Bangalore" %></div>
                            </td>
                            <td><strong style="color:var(--accent-gold);">&#8377; <%= String.format("%.0f", ord.getTotalAmount()) %></strong></td>
                            <td><span class="pill-badge pill-blue"><%= ord.getPaymentMode() %></span></td>
                            <td style="text-align: right;">
                                <form action="delivery-admin" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="pickup">
                                    <input type="hidden" name="orderId" value="<%= ord.getOrderId() %>">
                                    <button type="submit" class="btn-pickup">
                                        <span>Pick Up & Start Delivery</span>
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr>
                            <td colspan="6" style="text-align:center; padding:30px; color:var(--text-secondary);">
                                No orders currently waiting for pickup. Once restaurant marks "Food Ready", they appear here instantly!
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Section 2: Active Deliveries in Transit -->
        <div class="table-card">
            <div class="table-header-title">
                <span>&#128693; Active Deliveries In-Transit</span>
                <span class="pill-badge pill-blue"><%= activeCount %> On the Road</span>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">Order #</th>
                        <th>Restaurant</th>
                        <th>Customer & Destination</th>
                        <th>Total to Collect</th>
                        <th>Payment Mode</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (activeDeliveries != null && !activeDeliveries.isEmpty()) { 
                        for (Order ord : activeDeliveries) { 
                            Restaurant r = (restaurantMap != null) ? restaurantMap.get(ord.getRestaurantId()) : null;
                            User cust = (customerMap != null) ? customerMap.get(ord.getUserId()) : null;
                    %>
                        <tr>
                            <td><strong style="color:var(--text-main);">#FH-<%= ord.getOrderId() %></strong></td>
                            <td>
                                <div style="font-weight: 800;"><%= (r != null) ? r.getName() : "Restaurant" %></div>
                            </td>
                            <td>
                                <div style="font-weight: 700;"><%= (cust != null && cust.getUsername() != null) ? cust.getUsername() : "Customer" %></div>
                                <div style="font-size: 12px; color: var(--text-secondary);"><%= (cust != null && cust.getAddress() != null) ? cust.getAddress() : "Bangalore" %></div>
                            </td>
                            <td><strong style="color:var(--accent-gold);">&#8377; <%= String.format("%.0f", ord.getTotalAmount()) %></strong></td>
                            <td><span class="pill-badge pill-blue"><%= ord.getPaymentMode() %></span></td>
                            <td style="text-align: right;">
                                <form action="delivery-admin" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delivered">
                                    <input type="hidden" name="orderId" value="<%= ord.getOrderId() %>">
                                    <button type="submit" class="btn-deliver">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Mark as Delivered</span>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr>
                            <td colspan="6" style="text-align:center; padding:30px; color:var(--text-secondary);">
                                No deliveries currently in transit.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </main>

    <script>
        function toggleTheme() {
            var current = document.documentElement.getAttribute('data-theme') || 'dark';
            var next = (current === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('foodhouse_theme', next);
        }
    </script>
</body>
</html>
