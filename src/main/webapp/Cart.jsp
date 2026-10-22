<%-- 
    ========================================================================
    FILE: Cart.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Ultra-Premium Midnight Luxury Theme for Shopping Cart.
                 Displays all items stored in HttpSession Cart, calculates 
                 taxes & discounts, and provides HTML forms for updating 
                 quantities, deleting items, or clearing the cart.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List, java.util.ArrayList, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.User, com.tap.model.Menu, com.tap.DAOImpl.MenuDAOImpl" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Your Shopping Cart</title>
    
    <%-- Fonts --%>
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
            --bg-glass: rgba(15, 23, 42, 0.85);
            
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.4);
            
            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.35);
            --primary-light: rgba(255, 75, 90, 0.15);
            
            --accent-gold: #fbbf24;
            --accent-green: #10b981;
            
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

        [data-theme="light"] .back-link,
        [data-theme="light"] .btn-signin {
            background: rgba(0, 0, 0, 0.04);
            color: #1e293b;
            border-color: rgba(0, 0, 0, 0.12);
        }

        [data-theme="light"] .cart-header-title,
        [data-theme="light"] .item-name,
        [data-theme="light"] .bill-card-title {
            color: #0f172a;
        }

        [data-theme="light"] .cart-items-card,
        [data-theme="light"] .bill-card {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.08);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
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
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand-logo-icon {
            background: linear-gradient(135deg, var(--primary) 0%, #ff7675 100%);
            color: #ffffff;
            width: 42px;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .brand-logo div {
            color: #ffffff;
        }

        .brand-logo span {
            color: var(--primary);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 10px;
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

        .btn-signin {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.06);
            color: #ffffff;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-weight: 700;
            font-size: 13px;
            border: 1px solid var(--border-subtle);
            transition: var(--transition);
        }

        .btn-signin:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(255, 255, 255, 0.3);
            color: #ffffff;
            transform: translateY(-2px);
        }

        .btn-signup {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 75, 90, 0.15);
            color: #ffffff;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-weight: 700;
            font-size: 13px;
            border: 1px solid rgba(255, 75, 90, 0.4);
            box-shadow: 0 2px 8px rgba(255, 75, 90, 0.2);
            transition: var(--transition);
        }

        .btn-signup:hover {
            background: var(--primary);
            border-color: var(--primary);
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px var(--primary-glow);
        }

        .btn-orders {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(251, 191, 36, 0.12);
            color: var(--accent-gold);
            text-decoration: none;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-weight: 700;
            font-size: 13px;
            border: 1px solid rgba(251, 191, 36, 0.35);
            transition: var(--transition);
        }

        .btn-orders:hover {
            background: rgba(251, 191, 36, 0.22);
            border-color: var(--accent-gold);
            color: #ffffff;
            transform: translateY(-2px);
        }

        .user-profile-pill {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            background: rgba(16, 185, 129, 0.12);
            border: 1.5px solid rgba(16, 185, 129, 0.35);
            padding: 4px 12px 4px 5px;
            border-radius: var(--radius-pill);
            color: #ffffff;
            font-size: 13px;
            font-weight: 700;
        }

        .user-avatar-circle {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: var(--accent-green);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12.5px;
            font-weight: 800;
        }

        .btn-logout {
            color: var(--text-muted);
            margin-left: 4px;
            font-size: 11.5px;
            text-decoration: none;
            padding: 3px 7px;
            border-radius: var(--radius-pill);
            transition: var(--transition);
        }

        .btn-logout:hover {
            background: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
        }

        /* Container & Layout */
        .container {
            max-width: 1180px;
            margin: 32px auto 40px;
            padding: 0 24px 140px; /* 140px bottom clearance ensures fixed controls or summaries never cover the last add-on card */
        }

        .cart-header-title {
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.6px;
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #ffffff;
        }

        .cart-layout {
            display: grid;
            grid-template-columns: 1.55fr 1fr;
            gap: 32px;
            align-items: start;
        }

        /* Left Column: Items Card */
        .cart-items-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .cart-item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 0;
            border-bottom: 1px solid var(--border-subtle);
            gap: 16px;
            flex-wrap: wrap;
        }

        .cart-item-row:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .item-details {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
            min-width: 200px;
        }

        .item-thumb {
            width: 60px;
            height: 60px;
            border-radius: var(--radius-md);
            object-fit: cover;
            border: 1px solid var(--border-subtle);
            flex-shrink: 0;
        }

        .item-name {
            font-size: 15.5px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 4px;
        }

        .item-unit-price {
            font-size: 13px;
            color: var(--text-secondary);
        }

        .stepper-group {
            display: flex;
            align-items: center;
            background: #1e293b;
            border: 1px solid var(--primary);
            border-radius: var(--radius-pill);
            overflow: hidden;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .stepper-btn {
            background: transparent;
            color: #ffffff;
            border: none;
            padding: 6px 12px;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            transition: var(--transition);
        }

        .stepper-btn:hover {
            background: var(--primary);
            color: #ffffff;
        }

        .stepper-num {
            font-size: 13.5px;
            font-weight: 800;
            color: #ffffff;
            padding: 0 6px;
            min-width: 20px;
            text-align: center;
        }

        .item-total-col {
            font-size: 16px;
            font-weight: 800;
            color: var(--accent-gold);
            min-width: 75px;
            text-align: right;
        }

        .btn-delete {
            background: rgba(255, 75, 90, 0.12);
            color: var(--primary);
            border: 1px solid rgba(255, 75, 90, 0.25);
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-delete:hover {
            background: var(--primary);
            color: #ffffff;
            transform: scale(1.08);
        }

        /* Right Column: Bill Summary Card */
        .bill-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 26px;
            box-shadow: var(--shadow-md);
            position: sticky;
            top: 90px;
        }

        .bill-card-title {
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.3px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--border-subtle);
        }

        .bill-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 12px;
            font-weight: 500;
        }

        .bill-row.discount {
            color: var(--accent-green);
            font-weight: 700;
        }

        .bill-divider {
            height: 1px;
            background: var(--border-subtle);
            margin: 16px 0;
        }

        .bill-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 18px;
            font-weight: 800;
            color: #ffffff;
            padding-top: 14px;
            border-top: 2px dashed var(--border-subtle);
            margin-bottom: 24px;
        }

        .btn-checkout {
            width: 100%;
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            border: none;
            padding: 16px 24px;
            border-radius: var(--radius-lg);
            font-size: 15.5px;
            font-weight: 800;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 6px 20px var(--primary-glow);
            transition: var(--transition);
            margin-bottom: 12px;
        }

        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(255, 75, 90, 0.55);
            color: #ffffff;
        }

        .btn-clear {
            width: 100%;
            background: rgba(255, 255, 255, 0.04);
            color: var(--text-secondary);
            border: 1px solid var(--border-subtle);
            padding: 11px 20px;
            border-radius: var(--radius-md);
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: var(--transition);
        }

        .btn-clear:hover {
            background: rgba(255, 75, 90, 0.1);
            color: var(--primary);
            border-color: rgba(255, 75, 90, 0.3);
        }

        /* Empty Cart Box */
        .empty-cart-box {
            text-align: center;
            padding: 70px 24px;
            background: var(--bg-card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border-subtle);
            max-width: 540px;
            margin: 40px auto;
            box-shadow: var(--shadow-md);
        }

        .btn-explore {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            text-decoration: none;
            padding: 14px 32px;
            border-radius: var(--radius-pill);
            font-weight: 800;
            font-size: 14.5px;
            margin-top: 24px;
            box-shadow: 0 6px 20px var(--primary-glow);
            transition: var(--transition);
        }

        .btn-explore:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(255, 75, 90, 0.55);
            color: #ffffff;
        }

        /* ====================================================================
           FoodHouse Smart Cart & Gamification Features
           ==================================================================== */
        
        /* Free Delivery Progress Banner */
        .free-delivery-meter {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            border-radius: var(--radius-lg);
            padding: 14px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            backdrop-filter: blur(12px);
        }

        .meter-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .meter-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(16, 185, 129, 0.2);
            color: var(--accent-green);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .meter-text {
            font-size: 13.5px;
            font-weight: 600;
            color: #ffffff;
        }

        .meter-text span {
            color: var(--accent-green);
            font-weight: 800;
        }

        .meter-progress-bar-bg {
            flex: 1;
            max-width: 220px;
            height: 8px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: var(--radius-pill);
            overflow: hidden;
            position: relative;
        }

        .meter-progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #10b981, #34d399);
            border-radius: var(--radius-pill);
            transition: width 0.5s ease-in-out;
        }

        /* Popular Add-Ons Section */
        .addons-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 24px;
            margin-top: 24px;
            box-shadow: var(--shadow-md);
        }

        .addons-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border-subtle);
        }

        .addons-title {
            font-size: 17px;
            font-weight: 800;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .addons-badge {
            background: rgba(255, 75, 90, 0.15);
            color: var(--primary);
            font-size: 11px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .addons-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
        }

        .addon-item-box {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            transition: var(--transition);
        }

        .addon-item-box:hover {
            border-color: rgba(255, 75, 90, 0.35);
            background: rgba(255, 255, 255, 0.05);
            transform: translateY(-2px);
        }

        .addon-left {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
            min-width: 0;
        }

        .addon-thumb {
            width: 58px;
            height: 58px;
            border-radius: 12px;
            object-fit: cover;
            flex-shrink: 0;
            border: 1px solid var(--border-subtle);
        }

        .addon-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
            min-width: 0;
        }

        .addon-name {
            font-size: 13.5px;
            font-weight: 700;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .addon-price {
            font-size: 13px;
            font-weight: 800;
            color: var(--accent-gold);
        }

        .btn-addon-add {
            background: rgba(255, 75, 90, 0.15);
            color: var(--primary);
            border: 1.5px solid var(--primary);
            padding: 7px 16px;
            border-radius: var(--radius-pill);
            font-size: 12.5px;
            font-weight: 800;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: var(--transition);
            white-space: nowrap;
        }

        .btn-addon-add:hover {
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-glow);
            transform: scale(1.05);
        }

        .addon-stepper {
            display: flex;
            align-items: center;
            background: #1e293b;
            border: 1.5px solid var(--primary);
            border-radius: var(--radius-pill);
            overflow: hidden;
            box-shadow: 0 3px 10px var(--primary-glow);
        }

        .addon-step-btn {
            background: transparent;
            color: #ffffff;
            border: none;
            padding: 5px 9px;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
            transition: var(--transition);
        }

        .addon-step-btn:hover {
            background: var(--primary);
        }

        .addon-step-qty {
            font-size: 12.5px;
            font-weight: 800;
            color: #ffffff;
            min-width: 16px;
            text-align: center;
        }

        /* Cooking & Delivery Instructions */
        .instructions-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 22px;
            margin-top: 24px;
            box-shadow: var(--shadow-md);
        }

        .inst-title {
            font-size: 16px;
            font-weight: 800;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 14px;
        }

        .chips-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 14px;
        }

        .instruction-chip {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-pill);
            padding: 8px 14px;
            font-size: 12.5px;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
            user-select: none;
        }

        .instruction-chip:hover {
            border-color: rgba(255, 255, 255, 0.25);
            color: #ffffff;
        }

        .instruction-chip.active {
            background: rgba(255, 75, 90, 0.15);
            border-color: var(--primary);
            color: var(--primary);
            font-weight: 700;
            box-shadow: 0 0 12px var(--primary-light);
        }

        .inst-textarea {
            width: 100%;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 10px 14px;
            font-size: 13px;
            color: #ffffff;
            font-family: inherit;
            resize: vertical;
            outline: none;
            transition: var(--transition);
            box-sizing: border-box;
        }

        .inst-textarea:focus {
            border-color: var(--primary);
            background: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        /* Promo Coupon & Delivery Tip Widgets */
        .coupon-widget {
            background: rgba(255, 255, 255, 0.03);
            border: 1px dashed var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 14px;
            margin-bottom: 18px;
        }

        .coupon-title {
            font-size: 13px;
            font-weight: 800;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 10px;
        }

        .coupon-chips-row {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 10px;
        }

        .coupon-badge-chip {
            background: rgba(16, 185, 129, 0.12);
            color: var(--accent-green);
            border: 1px dashed rgba(16, 185, 129, 0.4);
            padding: 4px 10px;
            border-radius: var(--radius-pill);
            font-size: 11px;
            font-weight: 800;
            cursor: pointer;
            transition: var(--transition);
        }

        .coupon-badge-chip:hover, .coupon-badge-chip.selected {
            background: var(--accent-green);
            color: #ffffff;
            border-style: solid;
        }

        .coupon-input-group {
            display: flex;
            gap: 6px;
        }

        .coupon-input {
            flex: 1;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 8px 12px;
            font-size: 12.5px;
            color: #ffffff;
            text-transform: uppercase;
            font-weight: 700;
            outline: none;
        }

        .coupon-input:focus {
            border-color: var(--accent-green);
        }

        .btn-apply-coupon {
            background: rgba(16, 185, 129, 0.2);
            border: 1px solid var(--accent-green);
            color: var(--accent-green);
            padding: 8px 14px;
            border-radius: var(--radius-md);
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-apply-coupon:hover {
            background: var(--accent-green);
            color: #ffffff;
        }

        /* Delivery Tip Widget */
        .tip-widget {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 14px;
            margin-bottom: 18px;
        }

        .tip-title {
            font-size: 13px;
            font-weight: 800;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 4px;
        }

        .tip-subtitle {
            font-size: 11px;
            color: var(--text-muted);
            margin-bottom: 10px;
        }

        .tip-chips-row {
            display: flex;
            gap: 8px;
        }

        .tip-chip {
            flex: 1;
            text-align: center;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-pill);
            padding: 6px 0;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-secondary);
            cursor: pointer;
            transition: var(--transition);
        }

        .tip-chip:hover {
            border-color: rgba(255, 255, 255, 0.3);
            color: #ffffff;
        }

        .tip-chip.active {
            background: rgba(251, 191, 36, 0.15);
            border-color: var(--accent-gold);
            color: var(--accent-gold);
            font-weight: 800;
            box-shadow: 0 0 10px rgba(251, 191, 36, 0.3);
        }

        /* Cart Header Button & Badge */
        .cart-header-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: var(--radius-pill);
            font-weight: 700;
            font-size: 13.5px;
            box-shadow: 0 4px 14px var(--primary-glow);
            transition: var(--transition);
        }

        .cart-header-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(255, 75, 90, 0.55);
            color: #ffffff;
        }

        .cart-badge {
            background: #ffffff;
            color: var(--primary);
            font-size: 11px;
            font-weight: 800;
            padding: 2px 7px;
            border-radius: var(--radius-pill);
        }

        /* Success & Error Glassmorphism Toast */
        .cart-toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: rgba(17, 24, 39, 0.95);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(16, 185, 129, 0.4);
            border-radius: var(--radius-pill);
            padding: 12px 22px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
            font-size: 14px;
            font-weight: 700;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5), 0 0 20px rgba(16, 185, 129, 0.3);
            z-index: 9999;
            transform: translateY(100px);
            opacity: 0;
            pointer-events: none;
            transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .cart-toast.show {
            transform: translateY(0);
            opacity: 1;
        }

        .cart-toast.toast-error {
            border-color: rgba(239, 68, 68, 0.4);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5), 0 0 20px rgba(239, 68, 68, 0.3);
        }

        .cart-toast.toast-error .toast-icon {
            background: rgba(239, 68, 68, 0.2);
            color: #ef4444;
        }

        .cart-toast .toast-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: rgba(16, 185, 129, 0.2);
            color: var(--accent-green);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        [data-theme="light"] .cart-toast {
            background: rgba(255, 255, 255, 0.96);
            color: #0f172a;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15), 0 0 15px rgba(16, 185, 129, 0.2);
        }

        /* Subtle Button Loading Spinner & Debounce State */
        .btn-addon-add.btn-loading, 
        .addon-step-btn.btn-loading, 
        .stepper-btn.btn-loading, 
        .btn-delete.btn-loading {
            opacity: 0.65 !important;
            pointer-events: none !important;
            cursor: wait !important;
        }

        .addon-spinner {
            display: inline-block;
            width: 12px;
            height: 12px;
            border: 2px solid rgba(255, 75, 90, 0.3);
            border-radius: 50%;
            border-top-color: var(--primary);
            animation: spin 0.6s linear infinite;
            vertical-align: middle;
            margin-right: 4px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body style="background-color: #0a0e17; color: #ffffff;">

    <%
        Cart cart = (Cart) session.getAttribute("cart");
        Map<Integer, CartItem> items = null;
        int totalQty = 0;
        double subtotal = 0.0;

        if (cart != null && cart.getItems() != null) {
            items = cart.getItems();
            for (CartItem ci : items.values()) {
                totalQty += ci.getQuantity();
                subtotal += ci.getSubtotal();
            }
        }

        double deliveryFee = (subtotal >= 500.0 || totalQty == 0) ? 0.0 : 40.0;
        double tax = subtotal * 0.05;
        double discount = (subtotal >= 299.0) ? (subtotal * 0.20) : 0.0;
        double grandTotal = subtotal + deliveryFee + tax - discount;
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) {
            loggedUser = (User) session.getAttribute("loggedInUser");
        }

        // Add-ons list retrieval from MenuDAOImpl
        int cartRestId = (cart != null) ? cart.getRestaurantId() : 0;
        List<Menu> addonsList = new ArrayList<>();
        if (cartRestId > 0) {
            MenuDAOImpl menuDAO = new MenuDAOImpl();
            List<Menu> allRestMenus = menuDAO.getMenusByRestaurant(cartRestId);
            if (allRestMenus != null) {
                for (Menu m : allRestMenus) {
                    if (m.isAvailable()) {
                        addonsList.add(m);
                    }
                }
            }
        }

        // Free delivery calculation
        double freeDeliveryThreshold = 500.0;
        double freeDeliveryGap = Math.max(0.0, freeDeliveryThreshold - subtotal);
        int freeDeliveryPct = (int) Math.min(100, Math.round((subtotal / freeDeliveryThreshold) * 100));
    %>

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
                <a href="restaurant" class="back-link">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    <span>Restaurants</span>
                </a>

                <a href="cart" class="cart-header-btn" title="Your Shopping Cart">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                    <span>Cart</span>
                    <span class="cart-badge" id="navCartBadge"><%= totalQty %></span>
                </a>

                <% if (loggedUser != null) { 
                    String initial = (loggedUser.getUsername() != null && !loggedUser.getUsername().isEmpty()) ? loggedUser.getUsername().substring(0, 1).toUpperCase() : "U";
                    String displayName = (loggedUser.getUsername() != null) ? loggedUser.getUsername() : "Member";
                    String uRole = (loggedUser.getRole() != null) ? loggedUser.getRole() : "Customer";
                    boolean isUAdmin = "admin".equalsIgnoreCase(uRole) || "restaurantadmin".equalsIgnoreCase(uRole) || "restaurant_admin".equalsIgnoreCase(uRole);
                    boolean isUDelivery = "deliveryagent".equalsIgnoreCase(uRole) || "delivery_agent".equalsIgnoreCase(uRole);
                %>
                    <a href="orders" class="btn-orders" title="View My Order Records">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                        </svg>
                        <span>My Orders</span>
                    </a>

                    <% if (isUAdmin) { %>
                        <a href="restaurant-admin" class="btn-orders" style="background:rgba(251,191,36,0.15); color:var(--accent-gold); border-color:rgba(251,191,36,0.4);" title="Restaurant Admin Portal">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            <span>Admin</span>
                        </a>
                    <% } %>

                    <% if (isUDelivery || isUAdmin) { %>
                        <a href="delivery-admin" class="btn-orders" style="background:rgba(56,189,248,0.15); color:var(--accent-blue); border-color:rgba(56,189,248,0.4);" title="Delivery Partner Portal">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                            <span>Delivery</span>
                        </a>
                    <% } %>

                    <div class="user-profile-pill" style="cursor:pointer;" title="View Profile">
                        <a href="profile" style="text-decoration:none; color:inherit; display:flex; align-items:center; gap:8px;">
                            <div class="user-avatar-circle"><%= initial %></div>
                            <span><%= displayName %></span>
                        </a>
                        <a href="logout" class="btn-logout" title="Sign Out">Logout</a>
                    </div>
                <% } else { %>
                    <a href="Login.jsp" class="btn-signin" title="Sign In or Register">
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

    <main class="container">
        <h1 class="cart-header-title">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="color: var(--primary);">
                <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <path d="M16 10a4 4 0 0 1-8 0"></path>
            </svg>
            <span>Your Shopping Cart (<span id="cartHeaderQty"><%= totalQty %></span> <span id="cartHeaderQtyLabel"><%= (totalQty == 1 ? "Item" : "Items") %></span>)</span>
        </h1>

        <% if (cart != null && items != null && !items.isEmpty()) { %>
            <!-- Free Delivery Milestone Progress Meter (FoodHouse Express gamification) -->
            <div class="free-delivery-meter" id="freeDeliveryMeter" style="<%= (totalQty > 0 ? "display:flex;" : "display:none;") %>">
                <div class="meter-info">
                    <div class="meter-icon" id="meterIcon">
                        <% if (freeDeliveryGap <= 0) { %>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <% } else { %>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                        <% } %>
                    </div>
                    <div class="meter-text" id="meterText">
                        <% if (freeDeliveryGap <= 0) { %>
                            <span>Congratulations!</span> You've unlocked <span>FREE Express Delivery</span> on this order!
                        <% } else { %>
                            Add <span>&#8377; <%= String.format("%.0f", freeDeliveryGap) %></span> more to unlock <span>FREE Doorstep Delivery</span>!
                        <% } %>
                    </div>
                </div>
                <div class="meter-progress-bar-bg" id="meterBarBg" title="<%= freeDeliveryPct %>% to Free Delivery">
                    <div class="meter-progress-bar-fill" id="meterBarFill" style="width: <%= freeDeliveryPct %>%;"></div>
                </div>
            </div>

            <div class="cart-layout">
                <!-- Left: Items List + Complete Meal Add-ons + Cooking Notes -->
                <div class="cart-left-col" style="display:flex; flex-direction:column; gap:0;">
                    
                    <!-- 1. Cart Items List -->
                    <div class="cart-items-card" id="cartItemsContainer">
                        <% for (CartItem item : items.values()) { 
                            String itemImg = (item.getMenu() != null) ? item.getMenu().getImagePath() : null;
                            if (itemImg == null || itemImg.trim().isEmpty()) {
                                itemImg = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=300&q=80";
                            }
                            String itemName = (item.getMenu() != null) ? item.getMenu().getItemName() : item.getName();
                            if (itemName == null || itemName.isEmpty()) itemName = "Gourmet Dish";
                            double itemPrice = (item.getMenu() != null) ? item.getMenu().getPrice() : item.getPrice();
                            int menuId = item.getItemId();
                        %>
                            <div class="cart-item-row" id="cart-item-row-<%= menuId %>" data-menu-id="<%= menuId %>" data-price="<%= itemPrice %>">
                                <div class="item-details">
                                    <img src="<%= itemImg %>" alt="<%= itemName %>" class="item-thumb"
                                         onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=300&q=80';">
                                    <div>
                                        <div class="item-name"><%= itemName %></div>
                                        <div class="item-unit-price">&#8377; <%= String.format("%.0f", itemPrice) %> each</div>
                                    </div>
                                </div>

                                <!-- Stepper Form -->
                                <div class="stepper-group" id="stepper-group-<%= menuId %>">
                                    <form action="cart" method="post" class="cart-ajax-form" style="display:inline;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="menuId" value="<%= menuId %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                        <input type="hidden" name="source" value="cart">
                                        <input type="hidden" name="redirect" value="cart">
                                        <button type="submit" class="stepper-btn" title="Decrease">-</button>
                                    </form>

                                    <span class="stepper-num" id="stepper-num-<%= menuId %>"><%= item.getQuantity() %></span>

                                    <form action="cart" method="post" class="cart-ajax-form" style="display:inline;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="menuId" value="<%= menuId %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                        <input type="hidden" name="source" value="cart">
                                        <input type="hidden" name="redirect" value="cart">
                                        <button type="submit" class="stepper-btn" title="Increase">+</button>
                                    </form>
                                </div>

                                <div class="item-total-col" id="item-total-<%= menuId %>">
                                    &#8377; <%= String.format("%.0f", item.getSubtotal()) %>
                                </div>

                                <!-- Remove Item Form -->
                                <form action="cart" method="post" class="cart-ajax-form" style="display:inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="menuId" value="<%= menuId %>">
                                    <input type="hidden" name="source" value="cart">
                                    <input type="hidden" name="redirect" value="cart">
                                    <button type="submit" class="btn-delete" title="Remove Dish">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                    </button>
                                </form>
                            </div>
                        <% } %>
                    </div>

                    <!-- 2. "Complete Your Meal | Popular Add-Ons" (FoodHouse Quick Adds) -->
                    <% if (addonsList != null && !addonsList.isEmpty()) { %>
                        <div class="addons-card" id="addonsCard">
                            <div class="addons-header">
                                <div class="addons-title">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="color:var(--primary);">
                                        <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                                    </svg>
                                    <span>Complete Your Meal with Popular Add-Ons</span>
                                </div>
                                <span class="addons-badge">Frequently Added</span>
                            </div>

                            <div class="addons-grid" id="addonsGrid">
                                <% for (Menu addM : addonsList) { 
                                    int aId = addM.getMenuId();
                                    boolean isAlreadyInCart = (items != null && items.containsKey(aId));
                                    int aQty = isAlreadyInCart ? items.get(aId).getQuantity() : 0;
                                    String aImg = addM.getImagePath();
                                    if (aImg == null || aImg.trim().isEmpty()) {
                                        aImg = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=300&q=80";
                                    }
                                %>
                                    <div class="addon-item-box" id="addon-box-<%= aId %>" data-menu-id="<%= aId %>" data-name="<%= addM.getItemName().replace("\"", "&quot;") %>" data-price="<%= addM.getPrice() %>" data-img="<%= aImg %>">
                                        <div class="addon-left">
                                            <img src="<%= aImg %>" alt="<%= addM.getItemName() %>" class="addon-thumb"
                                                 onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=300&q=80';">
                                            <div class="addon-info">
                                                <div class="addon-name" title="<%= addM.getItemName() %>"><%= addM.getItemName() %></div>
                                                <div class="addon-price">&#8377; <%= String.format("%.0f", addM.getPrice()) %></div>
                                            </div>
                                        </div>

                                        <div class="addon-control-wrapper" id="addon-control-<%= aId %>">
                                            <% if (isAlreadyInCart) { %>
                                                <!-- Mini Stepper for Already Added Items -->
                                                <div class="addon-stepper" id="addon-stepper-<%= aId %>">
                                                    <form action="cart" method="post" class="cart-ajax-form" style="display:inline; margin:0;">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="menuId" value="<%= aId %>">
                                                        <input type="hidden" name="quantity" value="<%= aQty - 1 %>">
                                                        <input type="hidden" name="source" value="cart">
                                                        <input type="hidden" name="redirect" value="cart">
                                                        <button type="submit" class="addon-step-btn" title="Decrease">-</button>
                                                    </form>
                                                    <span class="addon-step-qty" id="addon-qty-<%= aId %>"><%= aQty %></span>
                                                    <form action="cart" method="post" class="cart-ajax-form" style="display:inline; margin:0;">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="menuId" value="<%= aId %>">
                                                        <input type="hidden" name="quantity" value="<%= aQty + 1 %>">
                                                        <input type="hidden" name="source" value="cart">
                                                        <input type="hidden" name="redirect" value="cart">
                                                        <button type="submit" class="addon-step-btn" title="Increase">+</button>
                                                    </form>
                                                </div>
                                            <% } else { %>
                                                <!-- 1-Click + ADD Button directly into Cart -->
                                                <form action="cart" method="post" class="cart-ajax-form" style="display:inline; margin:0;">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="menuId" value="<%= aId %>">
                                                    <input type="hidden" name="source" value="cart">
                                                    <input type="hidden" name="redirect" value="cart">
                                                    <button type="submit" class="btn-addon-add" title="Add <%= addM.getItemName() %> to Cart">
                                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                                        <span>ADD</span>
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>

                    <!-- 3. Cooking & Delivery Instructions (FoodHouse feature) -->
                    <div class="instructions-card">
                        <div class="inst-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="color:var(--accent-gold);">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                <polyline points="14 2 14 8 20 8"></polyline>
                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                <line x1="16" y1="17" x2="8" y2="17"></line>
                            </svg>
                            <span>Delivery & Cooking Instructions</span>
                        </div>
                        <div class="chips-grid" id="instChips">
                            <div class="instruction-chip" onclick="toggleInstChip(this, 'Leave at door')">
                                <span>🚪 Leave at the door</span>
                            </div>
                            <div class="instruction-chip" onclick="toggleInstChip(this, 'Avoid ringing bell')">
                                <span>🔕 Avoid ringing bell</span>
                            </div>
                            <div class="instruction-chip" onclick="toggleInstChip(this, 'Avoid calling')">
                                <span>📞 Avoid calling</span>
                            </div>
                            <div class="instruction-chip" onclick="toggleInstChip(this, 'Extra spicy')">
                                <span>🌶️ Make it extra spicy</span>
                            </div>
                            <div class="instruction-chip" onclick="toggleInstChip(this, 'Extra onions & lemon')">
                                <span>🧅 Extra sliced onions & lemon</span>
                            </div>
                            <div class="instruction-chip" onclick="toggleInstChip(this, 'No plastic cutlery')">
                                <span>🍴 No plastic cutlery (Eco-friendly)</span>
                            </div>
                        </div>
                        <textarea class="inst-textarea" id="customCookingNotes" rows="2" 
                                  placeholder="Any specific cooking or delivery notes? (e.g. less oil, keep gravy separate, gate code)..."
                                  oninput="saveCustomNotes(this.value)"></textarea>
                    </div>

                </div>

                <!-- Right: Bill Summary + Promo Offers + Delivery Partner Tip -->
                <div class="bill-card">
                    <!-- Apply Coupon Code Widget -->
                    <div class="coupon-widget">
                        <div class="coupon-title">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="color:var(--accent-green);">
                                <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                                <line x1="7" y1="7" x2="7.01" y2="7"></line>
                            </svg>
                            <span>Apply Coupon Code</span>
                        </div>
                        <div class="coupon-chips-row">
                            <span class="coupon-badge-chip selected" id="chipFOODHOUSE20" onclick="applyPromoChip('FOODHOUSE20', 0.20)">FOODHOUSE20 (20% OFF)</span>
                            <span class="coupon-badge-chip" id="chipWELCOME50" onclick="applyPromoChip('WELCOME50', 0.50)">WELCOME50 (50% OFF)</span>
                            <span class="coupon-badge-chip" id="chipFEAST100" onclick="applyPromoChip('FEAST100', 100)">FEAST100 (&#8377;100 OFF)</span>
                        </div>
                        <div class="coupon-input-group">
                            <input type="text" id="promoInput" class="coupon-input" placeholder="ENTER CODE" value="FOODHOUSE20">
                            <button type="button" class="btn-apply-coupon" onclick="handleManualPromo()">APPLY</button>
                        </div>
                    </div>

                    <!-- Delivery Partner Tip Widget -->
                    <div class="tip-widget">
                        <div class="tip-title">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="color:var(--accent-gold);">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                            </svg>
                            <span>Tip Your Delivery Partner</span>
                        </div>
                        <div class="tip-subtitle">100% of this tip goes to your delivery partner.</div>
                        <div class="tip-chips-row">
                            <div class="tip-chip" onclick="selectTip(20, this)">&#8377;20</div>
                            <div class="tip-chip active" onclick="selectTip(30, this)">&#8377;30 ⭐</div>
                            <div class="tip-chip" onclick="selectTip(50, this)">&#8377;50</div>
                            <div class="tip-chip" onclick="selectTip(0, this)">No Tip</div>
                        </div>
                    </div>

                    <div class="bill-card-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="color: var(--primary);">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                        </svg>
                        <span>Bill Summary</span>
                    </div>

                    <div class="bill-row">
                        <span>Item Subtotal</span>
                        <span id="billSubtotal">&#8377; <%= String.format("%.0f", subtotal) %></span>
                    </div>

                    <div class="bill-row">
                        <span>Delivery Fee</span>
                        <span id="billDeliveryFee"><%= (deliveryFee == 0.0) ? "<strong style='color:var(--accent-green);'>FREE</strong>" : "&#8377; " + String.format("%.0f", deliveryFee) %></span>
                    </div>

                    <div class="bill-row">
                        <span>Taxes & Packaging (5% GST)</span>
                        <span id="billTax">&#8377; <%= String.format("%.0f", tax) %></span>
                    </div>

                    <div class="bill-row discount" id="billDiscountRow" style="<%= (discount > 0) ? "" : "display:none;" %>">
                        <span id="billDiscountLabel">Promo Discount (FOODHOUSE20)</span>
                        <span id="billDiscountAmount">- &#8377; <%= String.format("%.0f", discount) %></span>
                    </div>

                    <div class="bill-row" id="billTipRow" style="color:var(--accent-gold); font-weight:700;">
                        <span>Delivery Partner Tip</span>
                        <span id="billTipAmount">&#8377; 30</span>
                    </div>

                    <div class="bill-divider"></div>

                    <div class="bill-total">
                        <span>Grand Total</span>
                        <span id="billGrandTotal" style="color: var(--accent-gold);">&#8377; <%= String.format("%.0f", (grandTotal + 30)) %></span>
                    </div>

                    <!-- Checkout Controller Trigger -->
                    <form action="checkout" method="get">
                        <button type="submit" class="btn-checkout">
                            <span>Proceed to Checkout</span>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                        </button>
                    </form>

                    <!-- Clear Cart Form -->
                    <form action="cart" method="post" class="cart-ajax-form" id="clearCartForm">
                        <input type="hidden" name="action" value="clear">
                        <input type="hidden" name="source" value="cart">
                        <input type="hidden" name="redirect" value="cart">
                        <button type="submit" class="btn-clear">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                            <span>Clear Entire Cart</span>
                        </button>
                    </form>
                </div>
            </div>
        <% } else { %>
            <div class="empty-cart-box">
                <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="color: var(--text-muted); margin-bottom: 18px;">
                    <circle cx="9" cy="21" r="1"></circle>
                    <circle cx="20" cy="21" r="1"></circle>
                    <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                </svg>
                <h2 style="font-size: 24px; font-weight: 800; margin-bottom: 8px; color: #ffffff;">Your Cart is Empty</h2>
                <p style="color: var(--text-secondary); font-size: 14.5px;">Explore our curated restaurants and add delicious dishes to begin your order.</p>
                <a href="restaurant" class="btn-explore">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                    <span>Explore Restaurants</span>
                </a>
            </div>
        <% } %>
    </main>

    <!-- Glassmorphism Cart Toast Notification (Fixed position, never alters layout) -->
    <div id="cartToast" class="cart-toast" role="status" aria-live="polite">
        <div class="toast-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
        </div>
        <div class="toast-message" id="toastMessage">Item added to cart</div>
    </div>

    <script>
        // State variables for dynamic bill recalculation
        var baseSubtotal = <%= subtotal %>;
        var baseDelivery = <%= deliveryFee %>;
        var baseTax = <%= tax %>;
        var currentDiscount = <%= discount %>;
        var currentTip = 30;
        var selectedCoupon = 'FOODHOUSE20';
        var toastTimer = null;

        // Dual Scroll Preservation: Save position continuously into sessionStorage
        window.addEventListener('scroll', function() {
            try {
                sessionStorage.setItem('foodhouse_cart_scroll', window.scrollY.toString());
            } catch (e) {}
        }, { passive: true });

        // Non-intrusive Toast Notification
        function showCartToast(msg, isError) {
            var toast = document.getElementById('cartToast');
            var msgEl = document.getElementById('toastMessage');
            if (!toast || !msgEl) return;

            msgEl.textContent = msg;
            if (isError) {
                toast.classList.add('toast-error');
            } else {
                toast.classList.remove('toast-error');
            }

            toast.classList.add('show');
            if (toastTimer) clearTimeout(toastTimer);
            toastTimer = setTimeout(function() {
                toast.classList.remove('show');
            }, 2600);
        }

        // Helper: HTML escaper for dynamic DOM injection
        function escapeHtml(str) {
            if (!str) return '';
            return String(str)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;');
        }

        // Recalculates grand total and breakdown based on subtotal, delivery, tax, coupon, and tip
        function updateGrandTotalUI() {
            var grand = baseSubtotal + baseDelivery + baseTax - currentDiscount + currentTip;
            if (grand < 0) grand = 0;

            var grandTotalEl = document.getElementById('billGrandTotal');
            if (grandTotalEl) {
                grandTotalEl.innerHTML = '&#8377; ' + Math.round(grand);
            }

            var subtotalEl = document.getElementById('billSubtotal');
            if (subtotalEl) {
                subtotalEl.innerHTML = '&#8377; ' + Math.round(baseSubtotal);
            }

            var deliveryEl = document.getElementById('billDeliveryFee');
            if (deliveryEl) {
                deliveryEl.innerHTML = (baseDelivery === 0.0) 
                    ? "<strong style='color:var(--accent-green);'>FREE</strong>" 
                    : "&#8377; " + Math.round(baseDelivery);
            }

            var taxEl = document.getElementById('billTax');
            if (taxEl) {
                taxEl.innerHTML = '&#8377; ' + Math.round(baseTax);
            }
            
            var discRow = document.getElementById('billDiscountRow');
            if (discRow) {
                if (currentDiscount > 0) {
                    discRow.style.display = 'flex';
                    var discLabel = document.getElementById('billDiscountLabel');
                    if (discLabel) discLabel.innerText = 'Promo Discount (' + selectedCoupon + ')';
                    var discAmount = document.getElementById('billDiscountAmount');
                    if (discAmount) discAmount.innerHTML = '- &#8377; ' + Math.round(currentDiscount);
                } else {
                    discRow.style.display = 'none';
                }
            }

            var tipRow = document.getElementById('billTipRow');
            if (tipRow) {
                if (currentTip > 0) {
                    tipRow.style.display = 'flex';
                    var tipAmount = document.getElementById('billTipAmount');
                    if (tipAmount) tipAmount.innerHTML = '&#8377; ' + currentTip;
                } else {
                    tipRow.style.display = 'none';
                }
            }
        }

        // Recalculate coupon discount according to business rules
        function recalculateBill() {
            if (selectedCoupon === 'FOODHOUSE20') {
                currentDiscount = (baseSubtotal >= 299.0) ? (baseSubtotal * 0.20) : 0.0;
            } else if (selectedCoupon === 'WELCOME50') {
                currentDiscount = baseSubtotal * 0.50;
            } else if (selectedCoupon === 'FEAST100') {
                currentDiscount = Math.min(100.0, baseSubtotal);
            } else if (selectedCoupon === 'FREEDEL') {
                currentDiscount = baseDelivery;
            } else {
                currentDiscount = 0.0;
            }
            updateGrandTotalUI();
        }

        function selectTip(amount, el) {
            currentTip = amount;
            document.querySelectorAll('.tip-chip').forEach(function(c) { c.classList.remove('active'); });
            if (el) el.classList.add('active');
            try {
                localStorage.setItem('foodhouse_tip', amount);
            } catch (e) {}
            updateGrandTotalUI();
        }

        function applyPromoChip(code, rate) {
            selectedCoupon = code;
            var promoInput = document.getElementById('promoInput');
            if (promoInput) promoInput.value = code;

            document.querySelectorAll('.coupon-badge-chip').forEach(function(c) { c.classList.remove('selected'); });
            var chip = document.getElementById('chip' + code);
            if (chip) chip.classList.add('selected');

            try {
                localStorage.setItem('foodhouse_coupon', code);
            } catch (e) {}

            recalculateBill();
        }

        function handleManualPromo() {
            var promoInput = document.getElementById('promoInput');
            var input = promoInput ? promoInput.value.trim().toUpperCase() : '';
            if (input === 'FOODHOUSE20') {
                applyPromoChip('FOODHOUSE20', 0.20);
            } else if (input === 'WELCOME50') {
                applyPromoChip('WELCOME50', 0.50);
            } else if (input === 'FEAST100') {
                applyPromoChip('FEAST100', 100);
            } else if (input === 'FREEDEL') {
                selectedCoupon = 'FREEDEL';
                try {
                    localStorage.setItem('foodhouse_coupon', 'FREEDEL');
                } catch (e) {}
                recalculateBill();
            } else {
                showCartToast('Invalid coupon code. Try FOODHOUSE20, WELCOME50, or FEAST100', true);
            }
        }

        function toggleInstChip(el, text) {
            el.classList.toggle('active');
            var selectedChips = [];
            document.querySelectorAll('.instruction-chip.active').forEach(function(c) {
                selectedChips.push(c.innerText.trim());
            });
            try {
                localStorage.setItem('foodhouse_instructions', JSON.stringify(selectedChips));
            } catch (e) {}
        }

        function saveCustomNotes(val) {
            try {
                localStorage.setItem('foodhouse_cooking_notes', val);
            } catch (e) {}
        }

        function toggleTheme() {
            var currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            var newTheme = (currentTheme === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            try {
                localStorage.setItem('foodhouse_theme', newTheme);
            } catch (e) {}
        }

        // Helper: Construct a fresh cart-item-row when an add-on item is added
        function buildCartItemRow(item) {
            var row = document.createElement('div');
            row.className = 'cart-item-row';
            row.id = 'cart-item-row-' + item.menuId;
            row.dataset.menuId = item.menuId;
            row.dataset.price = item.price;

            var img = item.imagePath && item.imagePath.trim() !== '' ? item.imagePath : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=300&q=80';
            var name = escapeHtml(item.name || 'Dish');
            var price = Math.round(item.price);
            var subtotal = Math.round(item.subtotal);

            row.innerHTML = 
                '<div class="item-details">' +
                    '<img src="' + img + '" alt="' + name + '" class="item-thumb" ' +
                         'onerror="this.onerror=null; this.src=\'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=300&q=80\';">' +
                    '<div>' +
                        '<div class="item-name">' + name + '</div>' +
                        '<div class="item-unit-price">&#8377; ' + price + ' each</div>' +
                    '</div>' +
                '</div>' +
                '<div class="stepper-group" id="stepper-group-' + item.menuId + '">' +
                    '<form action="cart" method="post" class="cart-ajax-form" style="display:inline;">' +
                        '<input type="hidden" name="action" value="update">' +
                        '<input type="hidden" name="menuId" value="' + item.menuId + '">' +
                        '<input type="hidden" name="quantity" value="' + (item.quantity - 1) + '">' +
                        '<input type="hidden" name="source" value="cart">' +
                        '<input type="hidden" name="redirect" value="cart">' +
                        '<button type="submit" class="stepper-btn" title="Decrease">-</button>' +
                    '</form>' +
                    '<span class="stepper-num" id="stepper-num-' + item.menuId + '">' + item.quantity + '</span>' +
                    '<form action="cart" method="post" class="cart-ajax-form" style="display:inline;">' +
                        '<input type="hidden" name="action" value="update">' +
                        '<input type="hidden" name="menuId" value="' + item.menuId + '">' +
                        '<input type="hidden" name="quantity" value="' + (item.quantity + 1) + '">' +
                        '<input type="hidden" name="source" value="cart">' +
                        '<input type="hidden" name="redirect" value="cart">' +
                        '<button type="submit" class="stepper-btn" title="Increase">+</button>' +
                    '</form>' +
                '</div>' +
                '<div class="item-total-col" id="item-total-' + item.menuId + '">&#8377; ' + subtotal + '</div>' +
                '<form action="cart" method="post" class="cart-ajax-form" style="display:inline;">' +
                    '<input type="hidden" name="action" value="remove">' +
                    '<input type="hidden" name="menuId" value="' + item.menuId + '">' +
                    '<input type="hidden" name="source" value="cart">' +
                    '<input type="hidden" name="redirect" value="cart">' +
                    '<button type="submit" class="btn-delete" title="Remove Dish">' +
                        '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>' +
                    '</button>' +
                '</form>';

            return row;
        }

        // Helper: Render Add-On Card Controls (1-Click ADD or Mini Stepper)
        function renderAddonControl(container, aId, aName, qty) {
            if (!container) return;
            if (qty > 0) {
                container.innerHTML = 
                    '<div class="addon-stepper" id="addon-stepper-' + aId + '">' +
                        '<form action="cart" method="post" class="cart-ajax-form" style="display:inline; margin:0;">' +
                            '<input type="hidden" name="action" value="update">' +
                            '<input type="hidden" name="menuId" value="' + aId + '">' +
                            '<input type="hidden" name="quantity" value="' + (qty - 1) + '">' +
                            '<input type="hidden" name="source" value="cart">' +
                            '<input type="hidden" name="redirect" value="cart">' +
                            '<button type="submit" class="addon-step-btn" title="Decrease">-</button>' +
                        '</form>' +
                        '<span class="addon-step-qty" id="addon-qty-' + aId + '">' + qty + '</span>' +
                        '<form action="cart" method="post" class="cart-ajax-form" style="display:inline; margin:0;">' +
                            '<input type="hidden" name="action" value="update">' +
                            '<input type="hidden" name="menuId" value="' + aId + '">' +
                            '<input type="hidden" name="quantity" value="' + (qty + 1) + '">' +
                            '<input type="hidden" name="source" value="cart">' +
                            '<input type="hidden" name="redirect" value="cart">' +
                            '<button type="submit" class="addon-step-btn" title="Increase">+</button>' +
                        '</form>' +
                    '</div>';
            } else {
                container.innerHTML = 
                    '<form action="cart" method="post" class="cart-ajax-form" style="display:inline; margin:0;">' +
                        '<input type="hidden" name="action" value="add">' +
                        '<input type="hidden" name="menuId" value="' + aId + '">' +
                        '<input type="hidden" name="source" value="cart">' +
                        '<input type="hidden" name="redirect" value="cart">' +
                        '<button type="submit" class="btn-addon-add" title="Add ' + escapeHtml(aName) + ' to Cart">' +
                            '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>' +
                            '<span>ADD</span>' +
                        '</button>' +
                    '</form>';
            }
        }

        // Main reactive update function: Synchronizes all cart UI elements without jumping
        function applyCartUpdate(data, targetMenuId, action) {
            var totalQty = data.totalCartQty || 0;

            // 1. Update Navigation Cart Badge & Header Title Count
            var navBadge = document.getElementById('navCartBadge');
            if (navBadge) navBadge.textContent = totalQty;

            var headerQty = document.getElementById('cartHeaderQty');
            if (headerQty) headerQty.textContent = totalQty;

            var headerQtyLabel = document.getElementById('cartHeaderQtyLabel');
            if (headerQtyLabel) headerQtyLabel.textContent = (totalQty === 1 ? 'Item' : 'Items');

            // 2. If Cart is completely empty, transition layout to empty-cart-box
            if (totalQty === 0) {
                var container = document.querySelector('main.container');
                if (container) {
                    container.innerHTML = 
                        '<h1 class="cart-header-title">' +
                            '<svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="color: var(--primary);">' +
                                '<path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>' +
                                '<line x1="3" y1="6" x2="21" y2="6"></line>' +
                                '<path d="M16 10a4 4 0 0 1-8 0"></path>' +
                            '</svg>' +
                            '<span>Your Shopping Cart (<span id="cartHeaderQty">0</span> Items)</span>' +
                        '</h1>' +
                        '<div class="empty-cart-box">' +
                            '<svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="color: var(--text-muted); margin-bottom: 18px;">' +
                                '<circle cx="9" cy="21" r="1"></circle>' +
                                '<circle cx="20" cy="21" r="1"></circle>' +
                                '<path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>' +
                            '</svg>' +
                            '<h2 style="font-size: 24px; font-weight: 800; margin-bottom: 8px; color: #ffffff;">Your Cart is Empty</h2>' +
                            '<p style="color: var(--text-secondary); font-size: 14.5px;">Explore our curated restaurants and add delicious dishes to begin your order.</p>' +
                            '<a href="restaurant" class="btn-explore">' +
                                '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>' +
                                '<span>Explore Restaurants</span>' +
                            '</a>' +
                        '</div>';
                }
                showCartToast('Cart cleared', false);
                return;
            }

            // 3. Update Free Delivery Milestone Progress Meter
            var meterEl = document.getElementById('freeDeliveryMeter');
            var meterIcon = document.getElementById('meterIcon');
            var meterText = document.getElementById('meterText');
            var meterFill = document.getElementById('meterBarFill');
            var meterBg = document.getElementById('meterBarBg');

            if (meterEl) {
                meterEl.style.display = 'flex';
                var gap = parseFloat(data.freeDeliveryGap || 0);
                var pct = parseInt(data.freeDeliveryPct || 0, 10);
                if (gap <= 0) {
                    if (meterIcon) meterIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>';
                    if (meterText) meterText.innerHTML = '<span>Congratulations!</span> You\'ve unlocked <span>FREE Express Delivery</span> on this order!';
                    if (meterFill) meterFill.style.width = '100%';
                } else {
                    if (meterIcon) meterIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>';
                    if (meterText) meterText.innerHTML = 'Add <span>&#8377; ' + Math.round(gap) + '</span> more to unlock <span>FREE Doorstep Delivery</span>!';
                    if (meterFill) meterFill.style.width = pct + '%';
                }
                if (meterBg) meterBg.setAttribute('title', pct + '% to Free Delivery');
            }

            // 4. Update Main Cart Items List
            var itemsContainer = document.getElementById('cartItemsContainer');
            if (itemsContainer && data.items) {
                var serverItemMap = {};
                data.items.forEach(function(it) {
                    serverItemMap[it.menuId] = it;
                });

                // Update existing item rows or remove deleted ones
                var existingRows = itemsContainer.querySelectorAll('.cart-item-row');
                existingRows.forEach(function(row) {
                    var mId = parseInt(row.dataset.menuId, 10);
                    if (serverItemMap[mId]) {
                        var ci = serverItemMap[mId];
                        // Update stepper quantity
                        var qtySpan = row.querySelector('#stepper-num-' + mId);
                        if (qtySpan) qtySpan.textContent = ci.quantity;

                        // Update stepper form inputs
                        var forms = row.querySelectorAll('.stepper-group form');
                        if (forms.length >= 2) {
                            var decInput = forms[0].querySelector('input[name="quantity"]');
                            if (decInput) decInput.value = ci.quantity - 1;
                            var incInput = forms[1].querySelector('input[name="quantity"]');
                            if (incInput) incInput.value = ci.quantity + 1;
                        }

                        // Update subtotal
                        var totCol = row.querySelector('#item-total-' + mId);
                        if (totCol) totCol.innerHTML = '&#8377; ' + Math.round(ci.subtotal);

                        // Mark as handled
                        delete serverItemMap[mId];
                    } else {
                        // Item was removed from cart -> remove row from DOM
                        row.remove();
                    }
                });

                // Any items remaining in serverItemMap were newly added from Popular Add-Ons!
                Object.values(serverItemMap).forEach(function(newItem) {
                    var newRowEl = buildCartItemRow(newItem);
                    itemsContainer.appendChild(newRowEl);
                });
            }

            // 5. Update Popular Add-Ons Controls
            var addonBoxes = document.querySelectorAll('.addon-item-box');
            if (addonBoxes) {
                addonBoxes.forEach(function(box) {
                    var aId = parseInt(box.dataset.menuId, 10);
                    var aName = box.dataset.name || 'Dish';
                    var aQty = 0;
                    if (data.items) {
                        for (var i = 0; i < data.items.length; i++) {
                            if (data.items[i].menuId === aId) {
                                aQty = data.items[i].quantity;
                                break;
                            }
                        }
                    }
                    var ctrl = document.getElementById('addon-control-' + aId);
                    if (ctrl) {
                        renderAddonControl(ctrl, aId, aName, aQty);
                    }
                });
            }

            // 6. Update Subtotal, Delivery Fee, Taxes, and Grand Total
            baseSubtotal = parseFloat(data.subtotal || data.totalCartAmount || 0);
            baseDelivery = parseFloat(data.deliveryFee || 0);
            baseTax = parseFloat(data.tax || 0);
            recalculateBill();

            // 7. Show Contextual Toast Notification
            var dishName = '';
            if (data.items) {
                for (var j = 0; j < data.items.length; j++) {
                    if (data.items[j].menuId === targetMenuId) {
                        dishName = data.items[j].name;
                        break;
                    }
                }
            }
            if (!dishName) {
                var box = document.getElementById('addon-box-' + targetMenuId);
                if (box) dishName = box.dataset.name;
            }
            if (!dishName) {
                var row = document.getElementById('cart-item-row-' + targetMenuId);
                if (row) {
                    var nameEl = row.querySelector('.item-name');
                    if (nameEl) dishName = nameEl.textContent.trim();
                }
            }
            if (!dishName) dishName = 'Dish';

            if (action === 'add') {
                showCartToast(dishName + ' added to cart', false);
            } else if (action === 'update') {
                if (data.itemQty > 0) {
                    showCartToast(dishName + ' quantity: ' + data.itemQty, false);
                } else {
                    showCartToast(dishName + ' removed from cart', false);
                }
            } else if (action === 'remove' || action === 'delete') {
                showCartToast(dishName + ' removed from cart', false);
            } else if (action === 'clear') {
                showCartToast('Cart cleared', false);
            }
        }

        // Dynamic Cart AJAX Handler (Zero Page Jump, No Reload)
        document.addEventListener('submit', function(e) {
            var form = e.target.closest('.cart-ajax-form');
            if (!form) return;

            e.preventDefault();

            var btn = form.querySelector('button[type="submit"]') || form.querySelector('button');
            if (btn && btn.dataset.submitting === 'true') {
                return; // Prevent duplicate rapid submission
            }

            var origHtml = btn ? btn.innerHTML : '';
            if (btn) {
                btn.dataset.submitting = 'true';
                btn.classList.add('btn-loading');
                if (btn.classList.contains('btn-addon-add')) {
                    btn.innerHTML = '<span class="addon-spinner"></span><span>ADDING...</span>';
                }
            }

            var clickedBox = form.closest('.addon-item-box') || form.closest('.cart-item-row');
            var visualTopBefore = clickedBox ? clickedBox.getBoundingClientRect().top : null;

            // Save scroll position
            try {
                sessionStorage.setItem('foodhouse_cart_scroll', window.scrollY.toString());
            } catch (err) {}

            var formData = new FormData(form);
            formData.set('ajax', 'true');
            var bodyParams = new URLSearchParams(formData);

            var action = form.querySelector('input[name="action"]') ? form.querySelector('input[name="action"]').value : 'update';
            var targetMenuId = parseInt(form.querySelector('input[name="menuId"]') ? form.querySelector('input[name="menuId"]').value : '0', 10);

            fetch('cart', {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                },
                body: bodyParams
            })
            .then(function(res) {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(function(data) {
                if (btn) {
                    btn.dataset.submitting = 'false';
                    btn.classList.remove('btn-loading');
                    btn.innerHTML = origHtml;
                }

                if (!data.success) {
                    showCartToast(data.message || 'Unable to update cart', true);
                    return;
                }

                // Update all Cart UI components dynamically
                applyCartUpdate(data, targetMenuId, action);

                // Preserve exact visual position of the clicked card on the user's screen
                if (clickedBox && visualTopBefore !== null) {
                    var visualTopAfter = clickedBox.getBoundingClientRect().top;
                    var shift = visualTopAfter - visualTopBefore;
                    if (Math.abs(shift) > 0.5) {
                        window.scrollBy(0, shift);
                    }
                }
            })
            .catch(function(err) {
                console.error('AJAX Cart request failed, falling back to standard submit:', err);
                if (btn) {
                    btn.dataset.submitting = 'false';
                    btn.classList.remove('btn-loading');
                    btn.innerHTML = origHtml;
                }
                // Fallback to standard form submit with scroll preserved
                try {
                    sessionStorage.setItem('foodhouse_cart_scroll', window.scrollY.toString());
                } catch (e) {}
                form.submit();
            });
        });

        // Restore persisted preferences & scroll position on page load
        (function() {
            // Restore Tip
            var savedTip = localStorage.getItem('foodhouse_tip');
            if (savedTip !== null) {
                currentTip = parseInt(savedTip, 10) || 0;
                document.querySelectorAll('.tip-chip').forEach(function(c) {
                    c.classList.remove('active');
                    if (currentTip === 0 && c.innerText.includes('No Tip')) {
                        c.classList.add('active');
                    } else if (currentTip > 0 && c.innerText.includes(currentTip.toString())) {
                        c.classList.add('active');
                    }
                });
            }

            // Restore Coupon
            var savedCoupon = localStorage.getItem('foodhouse_coupon');
            if (savedCoupon) {
                selectedCoupon = savedCoupon;
                var promoInput = document.getElementById('promoInput');
                if (promoInput) promoInput.value = savedCoupon;
                document.querySelectorAll('.coupon-badge-chip').forEach(function(c) {
                    c.classList.remove('selected');
                });
                var chip = document.getElementById('chip' + savedCoupon);
                if (chip) chip.classList.add('selected');
            }

            // Restore Instructions & Notes
            var savedNotes = localStorage.getItem('foodhouse_cooking_notes');
            if (savedNotes) {
                var notesField = document.getElementById('customCookingNotes');
                if (notesField) notesField.value = savedNotes;
            }

            recalculateBill();

            // Restore exact scroll position if saved
            try {
                var savedScroll = sessionStorage.getItem('foodhouse_cart_scroll');
                if (savedScroll !== null) {
                    var scrollPos = parseInt(savedScroll, 10);
                    if (!isNaN(scrollPos) && scrollPos > 0) {
                        window.scrollTo({ top: scrollPos, behavior: 'instant' });
                    }
                }
            } catch (ex) {}
        })();
    </script>
</body>
</html>