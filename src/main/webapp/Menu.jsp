<%-- 
    ========================================================================
    FILE: Menu.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Ultra-Premium Midnight Luxury Theme for Restaurant Menu.
                 100% Pure JSP, HTML, and CSS (Zero JavaScript).
                 Cart actions (Add, Increment, Decrement) are handled via 
                 standard HTML forms submitting to CartController and 
                 persisted securely in the server HttpSession.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.tap.model.Menu, com.tap.model.Restaurant, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.User" %>

<%!
    // Helper method to guarantee 100% beautiful, crisp, dish-matched photography
    public String getDishImage(Menu item) {
        if (item == null) return "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80";
        String name = (item.getItemName() != null) ? item.getItemName().toLowerCase() : "";
        String existing = item.getImagePath();
        
        // Exact Dish Keyword to High-Res Food Photo Mapping
        if (name.contains("biryani") || name.contains("pulao") || name.contains("rice")) {
            return "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("dosa") || name.contains("masala dosa") || name.contains("benne") || name.contains("ghee roast")) {
            return "https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("idli") || name.contains("vada") || name.contains("sambar") || name.contains("uttapam")) {
            return "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("burger") || name.contains("whopper") || name.contains("patty")) {
            return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("pizza") || name.contains("margherita") || name.contains("pepperoni") || name.contains("garlic bread")) {
            return "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("pasta") || name.contains("lasagna") || name.contains("spaghetti") || name.contains("penne")) {
            return "https://images.unsplash.com/photo-1621996346565-e3d5d6281699?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("tandoori") || name.contains("tikka") || name.contains("kebab") || name.contains("grill") || name.contains("bbq")) {
            return "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("paneer") || name.contains("curry") || name.contains("dal") || name.contains("gravy") || name.contains("butter chicken") || name.contains("korma")) {
            return "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("noodle") || name.contains("chowmein") || name.contains("fried rice") || name.contains("hakka") || name.contains("schezwan")) {
            return "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("momo") || name.contains("dimsum") || name.contains("dumpling") || name.contains("wonton")) {
            return "https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("wrap") || name.contains("roll") || name.contains("kathi") || name.contains("frankie") || name.contains("sub") || name.contains("sandwich")) {
            return "https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("cake") || name.contains("pastry") || name.contains("brownie") || name.contains("cupcake") || name.contains("dessert")) {
            return "https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("ice cream") || name.contains("sundae") || name.contains("dbc") || name.contains("shake") || name.contains("smoothie")) {
            return "https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("coffee") || name.contains("latte") || name.contains("cappuccino") || name.contains("chai") || name.contains("tea")) {
            return "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=600&q=80";
        } else if (name.contains("samosa") || name.contains("chaat") || name.contains("puri") || name.contains("kachori")) {
            return "https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80";
        }
        
        if (existing != null && existing.startsWith("http") && !existing.contains("localhost")) {
            return existing;
        }
        
        return "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Artisanal Restaurant Menu</title>
    
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
            
            --text-main: #ffffff;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            
            --rating-green: #10b981;
            --rating-amber: #f59e0b;
            
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
                radial-gradient(at 50% 20%, rgba(16, 185, 129, 0.03) 0px, transparent 50%);
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

        [data-theme="light"] .hero-banner {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.08);
        }

        [data-theme="light"] .hero-title,
        [data-theme="light"] .section-title,
        [data-theme="light"] .item-name {
            color: #0f172a;
        }

        [data-theme="light"] .menu-item-card {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.08);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
        }

        [data-theme="light"] .menu-item-card:hover {
            background: #f8fafc;
            border-color: rgba(255, 75, 90, 0.35);
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
            padding-bottom: 100px;
            -webkit-font-smoothing: antialiased;
        }

        /* Navbar */
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
            max-width: 1200px;
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
            font-size: 13.5px;
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
            transform: translateY(-1px);
        }

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

        /* Container & Banner */
        .container {
            max-width: 1100px;
            margin: 28px auto 0;
            padding: 0 24px 120px; /* 120px bottom clearance ensures the floating cart bar never covers any menu items or Add buttons */
        }

        .hero-banner {
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 28px 32px;
            box-shadow: var(--shadow-md);
            margin-bottom: 32px;
            position: relative;
            overflow: hidden;
        }

        .hero-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--primary) 0%, #fbbf24 50%, #10b981 100%);
        }

        .hero-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
        }

        .hero-title {
            font-size: 30px;
            font-weight: 800;
            letter-spacing: -0.6px;
            color: #ffffff;
            margin-bottom: 8px;
        }

        .hero-meta {
            display: flex;
            align-items: center;
            gap: 18px;
            font-size: 13.5px;
            color: var(--text-secondary);
            flex-wrap: wrap;
        }

        .hero-meta span {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .rating-badge {
            background: var(--rating-green);
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            padding: 6px 14px;
            border-radius: var(--radius-md);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
        }

        .offer-strip {
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--accent-gold);
            font-size: 13px;
            font-weight: 700;
        }

        /* Menu Items */
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
        }

        .section-title {
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.4px;
            color: #ffffff;
        }

        .items-count {
            font-size: 13px;
            color: var(--text-muted);
            background: rgba(255, 255, 255, 0.05);
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            border: 1px solid var(--border-subtle);
        }

        .menu-list {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .menu-item-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 22px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
        }

        .menu-item-card:hover {
            background: var(--bg-card-hover);
            border-color: rgba(255, 255, 255, 0.16);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .item-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .veg-icon, .nonveg-icon {
            width: 16px;
            height: 16px;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 4px;
        }

        .veg-icon { border: 2px solid var(--accent-green); }
        .veg-icon .dot { width: 7px; height: 7px; border-radius: 50%; background: var(--accent-green); }

        .nonveg-icon { border: 2px solid var(--primary); }
        .nonveg-icon .dot { width: 7px; height: 7px; border-radius: 50%; background: var(--primary); }

        .item-name {
            font-size: 17px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.2px;
        }

        .item-price {
            font-size: 15.5px;
            font-weight: 800;
            color: var(--accent-gold);
        }

        .item-desc {
            font-size: 13.5px;
            color: var(--text-secondary);
            line-height: 1.55;
            max-width: 600px;
        }

        .item-media {
            position: relative;
            width: 140px;
            height: 130px;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .dish-img {
            width: 140px;
            height: 110px;
            border-radius: var(--radius-lg);
            object-fit: cover;
            border: 1px solid var(--border-subtle);
            box-shadow: var(--shadow-sm);
        }

        .btn-container {
            position: absolute;
            bottom: 0px;
            z-index: 10;
        }

        .btn-add {
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 7px 22px;
            border-radius: var(--radius-pill);
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 4px 14px var(--primary-glow);
            transition: var(--transition);
        }

        .btn-add:hover {
            transform: translateY(-2px) scale(1.04);
            box-shadow: 0 6px 20px rgba(255, 75, 90, 0.55);
        }

        .stepper-box {
            display: flex;
            align-items: center;
            background: #1e293b;
            border: 1px solid var(--primary);
            border-radius: var(--radius-pill);
            overflow: hidden;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .btn-step {
            background: transparent;
            color: #ffffff;
            border: none;
            padding: 6px 13px;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-step:hover {
            background: var(--primary);
            color: #ffffff;
        }

        .qty-val {
            font-size: 13.5px;
            font-weight: 800;
            color: #ffffff;
            padding: 0 6px;
            min-width: 22px;
            text-align: center;
        }

        .out-of-stock-badge {
            background: rgba(0, 0, 0, 0.75);
            color: var(--text-muted);
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
            border: 1px solid var(--border-subtle);
            position: absolute;
            bottom: 0px;
        }

        /* Bottom Floating Bar */
        .floating-cart-bar {
            position: fixed;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%) translateY(0);
            width: calc(100% - 48px);
            max-width: 800px;
            background: rgba(17, 24, 39, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 75, 90, 0.4);
            border-radius: var(--radius-pill);
            padding: 14px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.7), 0 0 25px var(--primary-glow);
            z-index: 1000;
            transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.25s ease;
        }

        .cart-bar-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .cart-bar-qty {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-secondary);
        }

        .cart-bar-total {
            font-size: 18px;
            font-weight: 800;
            color: var(--accent-gold);
        }

        .view-cart-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            text-decoration: none;
            padding: 10px 22px;
            border-radius: var(--radius-pill);
            font-weight: 800;
            font-size: 13.5px;
            box-shadow: 0 4px 14px var(--primary-glow);
            transition: var(--transition);
        }

        .view-cart-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 75, 90, 0.55);
            color: #ffffff;
        }

        /* Subtle Toast Notification */
        .cart-toast {
            position: fixed;
            top: 86px;
            right: 28px;
            background: rgba(17, 24, 39, 0.95);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(16, 185, 129, 0.5);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.6), 0 0 20px rgba(16, 185, 129, 0.25);
            border-radius: var(--radius-pill);
            padding: 10px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 700;
            z-index: 2000;
            opacity: 0;
            transform: translateY(-14px) scale(0.96);
            pointer-events: none;
            transition: opacity 0.25s cubic-bezier(0.16, 1, 0.3, 1), transform 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .cart-toast.show {
            opacity: 1;
            transform: translateY(0) scale(1);
            pointer-events: auto;
        }

        .cart-toast.toast-error {
            border-color: rgba(239, 68, 68, 0.6);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.6), 0 0 20px rgba(239, 68, 68, 0.3);
        }

        .cart-toast.toast-error .toast-icon {
            color: #ef4444;
        }

        .cart-toast .toast-icon {
            color: var(--accent-green);
            display: flex;
            align-items: center;
        }

        [data-theme="light"] .cart-toast {
            background: rgba(255, 255, 255, 0.96);
            color: #0f172a;
            border-color: rgba(16, 185, 129, 0.6);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
        }

        @media (max-width: 650px) {
            .menu-item-card {
                flex-direction: column-reverse;
                align-items: flex-start;
            }
            .item-media { width: 100%; height: 160px; }
            .dish-img { width: 100%; height: 140px; }
        }
    </style>
</head>
<body style="background-color: #0a0e17; color: #ffffff;">

    <%
        List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        
        int totalDishes = (menuList != null) ? menuList.size() : 0;
        int restId = (restaurant != null) ? restaurant.getRestaurantId() : 1;
        String restName = (restaurant != null && restaurant.getName() != null) ? restaurant.getName() : "Gourmet Restaurant Menu";
        String cuisine = (restaurant != null && restaurant.getCuisineType() != null) ? restaurant.getCuisineType() : "Multi-Cuisine Delicacies";
        String address = (restaurant != null && restaurant.getAddress() != null) ? restaurant.getAddress() : "Bangalore";
        double rating = (restaurant != null && restaurant.getRating() > 0) ? restaurant.getRating() : 4.6;
        int deliveryTime = (restaurant != null && restaurant.getDeliveryTime() > 0) ? restaurant.getDeliveryTime() : 30;

        Cart cart = (Cart) session.getAttribute("cart");
        int totalCartQty = 0;
        double totalCartAmount = 0.0;
        Map<Integer, CartItem> cartItemsMap = null;

        if (cart != null && cart.getItems() != null) {
            cartItemsMap = cart.getItems();
            for (CartItem ci : cartItemsMap.values()) {
                totalCartQty += ci.getQuantity();
                totalCartAmount += ci.getSubtotal();
            }
        }
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) {
            loggedUser = (User) session.getAttribute("loggedInUser");
        }
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

            <div class="nav-actions">
                <a href="restaurant" class="back-link">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    <span>Restaurants</span>
                </a>

                <a href="cart" class="cart-header-btn">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                    <span>Cart</span>
                    <span class="cart-badge"><%= totalCartQty %></span>
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

                    <div class="user-profile-pill" style="cursor:pointer;" title="View & Edit Profile">
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
        <!-- ================= HERO RESTAURANT BANNER ================= -->
        <section class="hero-banner">
            <div class="hero-top">
                <div>
                    <h1 class="hero-title"><%= restName %></h1>
                    <div class="hero-meta">
                        <span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path></svg>
                            <%= cuisine %>
                        </span>
                        <span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            <%= address %>
                        </span>
                        <span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            <%= deliveryTime %> mins
                        </span>
                        <span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--accent-green);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 10"></polyline></svg>
                            11:00 AM – 11:00 PM
                        </span>
                    </div>
                </div>

                <div class="rating-badge">
                    <span><%= String.format("%.1f", rating) %></span>
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                </div>
            </div>

            <div class="offer-strip">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path></svg>
                <span>Special Offer: FLAT 20% OFF on gourmet orders above &#8377;299</span>
            </div>
        </section>

        <!-- ================= MENU ITEMS LIST ================= -->
        <div class="section-header">
            <h2 class="section-title">Signature Dishes</h2>
            <span class="items-count"><%= totalDishes %> Items Available</span>
        </div>

        <div class="menu-list">
            <%
                if (menuList != null && !menuList.isEmpty()) {
                    for (Menu item : menuList) {
                        
                        String itemImg = getDishImage(item);

                        String nameLower = item.getItemName().toLowerCase();
                        boolean isVeg = !nameLower.contains("chicken") 
                                     && !nameLower.contains("mutton") 
                                     && !nameLower.contains("fish")
                                     && !nameLower.contains("prawn")
                                     && !nameLower.contains("meat")
                                     && !nameLower.contains("egg")
                                     && !nameLower.contains("bacon")
                                     && !nameLower.contains("sausage");

                        String desc = item.getDescription();
                        if (desc == null || desc.trim().isEmpty()) {
                            desc = "Crafted with handpicked premium spices and fresh gourmet ingredients.";
                        }

                        int currentQty = 0;
                        if (cartItemsMap != null && cartItemsMap.containsKey(item.getMenuId())) {
                            currentQty = cartItemsMap.get(item.getMenuId()).getQuantity();
                        }
            %>
                        <!-- Individual Dish Card -->
                        <div class="menu-item-card">
                            <div class="item-info">
                                <div>
                                    <% if (isVeg) { %>
                                        <span class="veg-icon" title="Pure Veg"><span class="dot"></span></span>
                                    <% } else { %>
                                        <span class="nonveg-icon" title="Non-Veg"><span class="dot"></span></span>
                                    <% } %>
                                </div>
                                <h3 class="item-name"><%= item.getItemName() %></h3>
                                <div class="item-price">&#8377; <%= String.format("%.0f", item.getPrice()) %></div>
                                <p class="item-desc"><%= desc %></p>
                            </div>

                            <div class="item-media">
                                <img src="<%= itemImg %>" alt="<%= item.getItemName() %>" class="dish-img" loading="lazy"
                                     onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80';">

                                <% if (item.isAvailable()) { %>
                                    <div class="btn-container" id="btn-container-<%= item.getMenuId() %>" data-menu-id="<%= item.getMenuId() %>" data-rest-id="<%= restId %>" data-name="<%= item.getItemName().replace("\"", "&quot;") %>">
                                        <% if (currentQty == 0) { %>
                                            <form action="cart" method="post" class="add-form cart-ajax-form">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                                <input type="hidden" name="restaurantId" value="<%= restId %>">
                                                <input type="hidden" name="source" value="menu">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn-add" id="btn-add-<%= item.getMenuId() %>" style="background: linear-gradient(135deg, #ff4b5a 0%, #ff2a3b 100%) !important; color: #ffffff !important; border: 1.5px solid rgba(255, 255, 255, 0.25) !important; padding: 8px 22px !important; border-radius: 9999px !important; font-size: 13.5px !important; font-weight: 800 !important; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 14px rgba(255, 75, 90, 0.45) !important;">
                                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                                    <span>ADD</span>
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <div class="stepper-box">
                                                <form action="cart" method="post" class="stepper-form cart-ajax-form">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                                    <input type="hidden" name="restaurantId" value="<%= restId %>">
                                                    <input type="hidden" name="source" value="menu">
                                                    <input type="hidden" name="quantity" value="<%= currentQty - 1 %>">
                                                    <button type="submit" class="btn-step" title="Decrease" aria-label="Decrease quantity">-</button>
                                                </form>

                                                 <span class="qty-val" id="qty-val-<%= item.getMenuId() %>"><%= currentQty %></span>

                                                <form action="cart" method="post" class="stepper-form cart-ajax-form">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                                    <input type="hidden" name="restaurantId" value="<%= restId %>">
                                                    <input type="hidden" name="source" value="menu">
                                                    <input type="hidden" name="quantity" value="<%= currentQty + 1 %>">
                                                    <button type="submit" class="btn-step" title="Increase" aria-label="Increase quantity">+</button>
                                                </form>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <div class="out-of-stock-badge">Sold Out</div>
                                <% } %>
                            </div>
                        </div>
            <%
                    }
                } else {
            %>
                <div class="empty-menu" style="text-align:center; padding: 60px 20px; background: var(--bg-card); border-radius: var(--radius-xl); border: 1px solid var(--border-subtle);">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="color: #475569; margin-bottom: 14px;"><circle cx="12" cy="12" r="10"></circle><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                    <h3>No Dishes Available</h3>
                    <p style="color: var(--text-muted); margin-top: 6px;">No menu items found for this restaurant.</p>
                </div>
            <%
                }
            %>
        </div>
    </main>

    <!-- ================= FLOATING STICKY BOTTOM CART BAR ================= -->
    <div id="floatingCartBar" class="floating-cart-bar" style="<%= totalCartQty > 0 ? "display: flex;" : "display: none;" %>">
        <div class="cart-bar-left">
            <span class="cart-bar-qty" id="cartBarQty"><%= totalCartQty %> <%= (totalCartQty == 1 ? "Item Added" : "Items Added") %></span>
            <span class="cart-bar-total" id="cartBarTotal">&#8377; <%= String.format("%.0f", totalCartAmount) %></span>
        </div>
        <a href="cart" class="view-cart-link" id="viewCartLink">
            <span>View Cart</span>
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </a>
    </div>

    <!-- Subtle Floating Toast Notification -->
    <div id="cartToast" class="cart-toast" role="status" aria-live="polite">
        <div class="toast-icon" id="toastIcon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="20 6 9 17 4 12"></polyline>
            </svg>
        </div>
        <div class="toast-message" id="toastMessage">Added to cart</div>
    </div>

    <script>
        // Global Dark / Light Mode Toggle Function
        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            const newTheme = (currentTheme === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('foodhouse_theme', newTheme);
        }

        // ====================================================================
        // DUAL SCROLL PRESERVATION & AJAX CART HANDLING (Zero Page Jump)
        // ====================================================================

        // 1. Safety-Net Scroll Restoration (if a full reload/redirect ever happens)
        (function restoreMenuScroll() {
            if ('scrollRestoration' in history) {
                history.scrollRestoration = 'manual';
            }
            try {
                const savedScroll = sessionStorage.getItem('foodhouse_menu_scroll');
                if (savedScroll !== null) {
                    sessionStorage.removeItem('foodhouse_menu_scroll');
                    const targetTop = parseInt(savedScroll, 10);
                    if (!isNaN(targetTop) && targetTop > 0) {
                        window.scrollTo(0, targetTop);
                        requestAnimationFrame(() => window.scrollTo(0, targetTop));
                    }
                }
            } catch (e) {}
        })();

        // 2. Subtle Toast Notification Controller
        let toastTimer = null;
        function showCartToast(msg, isError) {
            const toast = document.getElementById('cartToast');
            const toastMsg = document.getElementById('toastMessage');
            const toastIcon = document.getElementById('toastIcon');
            if (!toast || !toastMsg) return;

            toastMsg.textContent = msg;
            if (isError) {
                toast.classList.add('toast-error');
                if (toastIcon) {
                    toastIcon.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';
                }
            } else {
                toast.classList.remove('toast-error');
                if (toastIcon) {
                    toastIcon.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>';
                }
            }

            toast.classList.add('show');
            if (toastTimer) clearTimeout(toastTimer);
            toastTimer = setTimeout(() => {
                toast.classList.remove('show');
            }, 2500);
        }

        // 3. Helper to Re-Render Item Controls without Page Jump
        function renderItemContainer(container, menuId, restId, itemName, qty) {
            if (qty <= 0) {
                container.innerHTML = 
                    '<form action="cart" method="post" class="add-form cart-ajax-form">' +
                        '<input type="hidden" name="action" value="add">' +
                        '<input type="hidden" name="menuId" value="' + menuId + '">' +
                        '<input type="hidden" name="restaurantId" value="' + restId + '">' +
                        '<input type="hidden" name="source" value="menu">' +
                        '<input type="hidden" name="quantity" value="1">' +
                        '<button type="submit" class="btn-add" id="btn-add-' + menuId + '" style="background: linear-gradient(135deg, #ff4b5a 0%, #ff2a3b 100%) !important; color: #ffffff !important; border: 1.5px solid rgba(255, 255, 255, 0.25) !important; padding: 8px 22px !important; border-radius: 9999px !important; font-size: 13.5px !important; font-weight: 800 !important; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 14px rgba(255, 75, 90, 0.45) !important;">' +
                            '<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>' +
                            '<span>ADD</span>' +
                        '</button>' +
                    '</form>';
            } else {
                container.innerHTML = 
                    '<div class="stepper-box">' +
                        '<form action="cart" method="post" class="stepper-form cart-ajax-form">' +
                            '<input type="hidden" name="action" value="update">' +
                            '<input type="hidden" name="menuId" value="' + menuId + '">' +
                            '<input type="hidden" name="restaurantId" value="' + restId + '">' +
                            '<input type="hidden" name="source" value="menu">' +
                            '<input type="hidden" name="quantity" value="' + (qty - 1) + '">' +
                            '<button type="submit" class="btn-step" title="Decrease" aria-label="Decrease quantity">-</button>' +
                        '</form>' +
                        '<span class="qty-val" id="qty-val-' + menuId + '">' + qty + '</span>' +
                        '<form action="cart" method="post" class="stepper-form cart-ajax-form">' +
                            '<input type="hidden" name="action" value="update">' +
                            '<input type="hidden" name="menuId" value="' + menuId + '">' +
                            '<input type="hidden" name="restaurantId" value="' + restId + '">' +
                            '<input type="hidden" name="source" value="menu">' +
                            '<input type="hidden" name="quantity" value="' + (qty + 1) + '">' +
                            '<button type="submit" class="btn-step" title="Increase" aria-label="Increase quantity">+</button>' +
                        '</form>' +
                    '</div>';
            }
        }

        // 4. Update Header Badge and Floating Bottom Summary Bar
        function updateCartSummary(totalQty, totalAmountFormatted) {
            // Header badge
            const headerBadge = document.querySelector('.cart-badge');
            if (headerBadge) {
                headerBadge.innerText = totalQty;
            }

            // Floating bottom bar
            const floatingBar = document.getElementById('floatingCartBar');
            const barQty = document.getElementById('cartBarQty');
            const barTotal = document.getElementById('cartBarTotal');

            if (floatingBar) {
                if (totalQty > 0) {
                    floatingBar.style.display = 'flex';
                    if (barQty) {
                        barQty.innerText = totalQty + (totalQty === 1 ? ' Item Added' : ' Items Added');
                    }
                    if (barTotal) {
                        barTotal.innerHTML = '&#8377; ' + totalAmountFormatted;
                    }
                } else {
                    floatingBar.style.display = 'none';
                }
            }
        }

        // 5. Delegated AJAX Form Interceptor (Prevents Page Jumps and Reloads)
        document.addEventListener('submit', function handleCartSubmit(e) {
            const form = e.target.closest('.cart-ajax-form');
            if (!form) return;

            // Stop standard form submit and browser page jump
            e.preventDefault();

            const container = form.closest('.btn-container');
            if (!container) return;

            // Prevent duplicate clicks while processing
            if (container.dataset.loading === 'true') {
                return;
            }
            container.dataset.loading = 'true';

            const menuId = form.querySelector('input[name="menuId"]')?.value || container.dataset.menuId;
            const restId = form.querySelector('input[name="restaurantId"]')?.value || container.dataset.restId;
            const itemName = container.dataset.name || 'Dish';
            const action = form.querySelector('input[name="action"]')?.value;

            // Visual indicator on submit button
            const btn = form.querySelector('button[type="submit"]');
            if (btn) {
                btn.style.opacity = '0.6';
                btn.style.pointerEvents = 'none';
            }

            // Record scroll position into sessionStorage as dual protection
            try {
                sessionStorage.setItem('foodhouse_menu_scroll', window.scrollY.toString());
            } catch (ex) {}

            const formData = new FormData(form);
            formData.set('ajax', 'true');
            const bodyParams = new URLSearchParams(formData);

            fetch('cart', {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                },
                body: bodyParams
            })
            .then(res => {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(data => {
                container.dataset.loading = 'false';

                if (!data.success) {
                    showCartToast(data.message || 'Unable to update cart', true);
                    if (btn) {
                        btn.style.opacity = '1';
                        btn.style.pointerEvents = 'auto';
                    }
                    return;
                }

                // 1. Update this item's control container (smoothly changes + ADD <-> Stepper)
                renderItemContainer(container, menuId, restId, itemName, data.itemQty);

                // 2. Update Header Badge and Floating Cart Bar
                const formatted = data.formattedTotal || Math.round(data.totalCartAmount);
                updateCartSummary(data.totalCartQty, formatted);

                // 3. Display non-intrusive toast notification
                if (action === 'add') {
                    showCartToast(itemName + ' added to cart', false);
                } else if (action === 'update') {
                    if (data.itemQty > 0) {
                        showCartToast(itemName + ' quantity: ' + data.itemQty, false);
                    } else {
                        showCartToast(itemName + ' removed from cart', false);
                    }
                }
            })
            .catch(err => {
                console.warn('AJAX cart request failed, falling back to form submit:', err);
                container.dataset.loading = 'false';
                if (btn) {
                    btn.style.opacity = '1';
                    btn.style.pointerEvents = 'auto';
                }
                // Fallback to standard submit with scroll preserved in sessionStorage
                try {
                    sessionStorage.setItem('foodhouse_menu_scroll', window.scrollY.toString());
                } catch (ex) {}
                form.submit();
            });
        });
    </script>

</body>
</html>