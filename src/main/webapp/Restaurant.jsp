<%-- 
    ========================================================================
    FILE: Restaurant.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Ultra-Premium Midnight Luxury Theme for Restaurant Explorer.
                 Features curated HD cuisine photography, distinct surrounded 
                 "View Menu & Order" action buttons, pure inline SVGs, 
                 live search, and interactive cuisine filter pills.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Restaurant, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.User, com.tap.DAOImpl.RestaurantDAOImpl" %>

<%!
    // Helper method to guarantee 100% beautiful, crisp, cuisine-matched food photography
    public String getCuratedImage(Restaurant r) {
        if (r == null) return "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1000&q=80";
        String name = (r.getName() != null) ? r.getName().toLowerCase() : "";
        String cuisine = (r.getCuisineType() != null) ? r.getCuisineType().toLowerCase() : "";
        int id = r.getRestaurantId();

        // Exact ID & Name & Cuisine based High Definition Photography Mapping
        if (id == 1 || name.contains("meghana") || name.contains("paradise") || name.contains("behrouz") || cuisine.contains("biryani")) {
            return "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 2 || name.contains("empire") || name.contains("mughlai") || cuisine.contains("mughlai")) {
            return "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 3 || id == 19 || name.contains("truffles") || name.contains("leon") || cuisine.contains("burger")) {
            return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 4 || id == 18 || name.contains("nagarjuna") || name.contains("anjappar") || cuisine.contains("andhra") || cuisine.contains("chettinad")) {
            return "https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 5 || id == 11 || name.contains("vidyarthi") || name.contains("ctr") || cuisine.contains("dosa")) {
            return "https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 12 || name.contains("mtr") || cuisine.contains("south indian") || cuisine.contains("tiffin")) {
            return "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 6 || name.contains("punjab") || cuisine.contains("north indian")) {
            return "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 7 || id == 15 || name.contains("beijing") || name.contains("mainland") || cuisine.contains("chinese") || cuisine.contains("asian")) {
            return "https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 8 || id == 16 || id == 30 || name.contains("toscano") || name.contains("brik") || name.contains("domino") || cuisine.contains("pizza") || cuisine.contains("italian")) {
            return "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 9 || id == 20 || name.contains("glen") || name.contains("third wave") || cuisine.contains("cafe") || cuisine.contains("bakery") || cuisine.contains("dessert")) {
            return "https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 10 || id == 28 || name.contains("corner") || name.contains("keventer") || cuisine.contains("ice cream") || cuisine.contains("shake")) {
            return "https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 13 || id == 27 || name.contains("toit") || name.contains("smoke") || cuisine.contains("continental") || cuisine.contains("bistro")) {
            return "https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 14 || name.contains("barbeque") || cuisine.contains("bbq") || cuisine.contains("tandoor")) {
            return "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 21 || name.contains("chai")) {
            return "https://images.unsplash.com/photo-1576092768241-dec231879fc3?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 22 || name.contains("momo")) {
            return "https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 24 || name.contains("faasos") || cuisine.contains("wrap") || cuisine.contains("roll")) {
            return "https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 25 || id == 26 || name.contains("haldiram") || name.contains("kailash") || cuisine.contains("thali") || cuisine.contains("chaat")) {
            return "https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=1000&q=80";
        } else if (id == 29 || name.contains("subway") || cuisine.contains("sandwich")) {
            return "https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=1000&q=80";
        }
        
        String existing = r.getImagePath();
        if (existing != null && existing.startsWith("http") && !existing.contains("localhost")) {
            return existing;
        }
        
        return "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1000&q=80";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Explore Top Restaurants in Bangalore</title>
    
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
            --bg-card: rgba(17, 24, 39, 0.82);
            --bg-card-hover: rgba(26, 36, 56, 0.98);
            --bg-glass: rgba(15, 23, 42, 0.85);
            
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.45);
            
            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.4);
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

        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            overflow-x: hidden;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-body, #0a0e17);
            color: var(--text-main, #ffffff);
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        button, input, select, textarea {
            font-family: inherit;
        }

        /* ====================================================================
           Light Theme Overrides
           ==================================================================== */
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

        [data-theme="light"] .btn-explore,
        [data-theme="light"] .btn-signin {
            background: rgba(0, 0, 0, 0.04);
            color: #1e293b;
            border-color: rgba(0, 0, 0, 0.12);
        }

        [data-theme="light"] .btn-explore:hover,
        [data-theme="light"] .btn-signin:hover {
            background: rgba(0, 0, 0, 0.08);
            color: #0f172a;
            border-color: rgba(0, 0, 0, 0.25);
        }

        [data-theme="light"] .search-input {
            background: #f1f5f9;
            color: #0f172a;
            border-color: rgba(0, 0, 0, 0.12);
        }

        [data-theme="light"] .search-input:focus {
            background: #ffffff;
            border-color: var(--primary);
        }

        [data-theme="light"] .hero-banner {
            background: radial-gradient(circle at 80% 20%, rgba(255, 120, 80, 0.08) 0%, rgba(248, 250, 252, 0.98) 70%);
            border-bottom-color: rgba(0, 0, 0, 0.06);
        }

        [data-theme="light"] .running-world-dark-overlay {
            background: linear-gradient(90deg, rgba(248, 250, 252, 0.96) 0%, rgba(248, 250, 252, 0.84) 48%, rgba(248, 250, 252, 0.28) 85%, rgba(248, 250, 252, 0.88) 100%);
        }

        [data-theme="light"] .hero-headline,
        [data-theme="light"] .section-title,
        [data-theme="light"] .feature-title,
        [data-theme="light"] .card-title {
            color: #0f172a;
        }

        [data-theme="light"] .hero-search-card {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
        }

        [data-theme="light"] .hero-search-input {
            color: #0f172a;
        }

        [data-theme="light"] .hero-location-pill {
            background: #f1f5f9 !important;
            border-color: rgba(0, 0, 0, 0.12) !important;
            color: #0f172a !important;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06) !important;
        }

        [data-theme="light"] .hero-location-pill svg.icon-caret {
            color: #64748b !important;
        }

        [data-theme="light"] .location-dropdown {
            background: #ffffff !important;
            border-color: rgba(0, 0, 0, 0.12) !important;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.15) !important;
        }

        [data-theme="light"] .location-option {
            color: #334155 !important;
        }

        [data-theme="light"] .location-option:hover,
        [data-theme="light"] .location-option.active {
            background: rgba(255, 75, 90, 0.1) !important;
            color: #ff4b5a !important;
        }

        [data-theme="light"] .popular-chip {
            background: rgba(0, 0, 0, 0.04);
            border-color: rgba(0, 0, 0, 0.08);
            color: #475569;
        }

        [data-theme="light"] .popular-chip:hover {
            background: rgba(255, 75, 90, 0.1);
            color: var(--primary);
            border-color: rgba(255, 75, 90, 0.3);
        }

        [data-theme="light"] .scooter-rig-card {
            background: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
            border-color: rgba(0, 0, 0, 0.08);
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.08);
        }

        [data-theme="light"] .hud-stat-pill {
            background: rgba(255, 255, 255, 0.94);
            color: #0f172a;
            border-color: rgba(0, 0, 0, 0.08);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }

        [data-theme="light"] .cuisine-pill {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.08);
            color: #475569;
        }

        [data-theme="light"] .cuisine-pill:hover {
            color: #0f172a;
            border-color: rgba(0, 0, 0, 0.2);
            background: #f1f5f9;
        }

        [data-theme="light"] .restaurant-card {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.06);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
        }

        [data-theme="light"] .restaurant-card:hover {
            box-shadow: 0 16px 36px rgba(0, 0, 0, 0.08);
        }

        [data-theme="light"] .card-body {
            background: #ffffff;
        }

        [data-theme="light"] .rating-badge {
            background: rgba(16, 185, 129, 0.12);
            color: #059669;
            border-color: rgba(16, 185, 129, 0.3);
        }

        [data-theme="light"] .card-cuisine {
            color: #64748b;
        }

        [data-theme="light"] .card-address {
            color: #64748b;
        }

        [data-theme="light"] .btn-view-menu {
            background: #0f172a;
            color: #ffffff;
        }

        [data-theme="light"] .btn-view-menu:hover {
            background: var(--primary);
        }

        /* ====================================================================
           2. Sticky Glassmorphism Header & Navbar
           ==================================================================== */
        header.navbar,
        .navbar-container {
            position: sticky;
            top: 0;
            z-index: 1000;
            width: 100%;
            background: rgba(10, 14, 23, 0.92);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border-subtle);
            box-shadow: var(--shadow-sm);
        }

        .navbar .nav-container,
        .nav-container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 10px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            box-sizing: border-box;
            width: 100%;
        }

        /* Brand Logo */
        .brand-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #ffffff;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
            flex-shrink: 0;
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
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .brand-logo span {
            color: var(--primary);
        }

        /* Centered Capsule Nav Pills (Ref Match) */
        .nav-center-pills {
            display: flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.04);
            padding: 4px 8px;
            border-radius: var(--radius-pill);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .nav-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: var(--radius-pill);
            color: #cbd5e1;
            font-size: 13px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            text-decoration: none;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .nav-pill:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        .nav-pill.active {
            background: #ff3b30;
            color: #ffffff;
            box-shadow: 0 2px 12px rgba(255, 59, 48, 0.45);
        }

        @media (max-width: 992px) {
            .nav-center-pills {
                display: none !important;
            }
        }

        /* Navbar Action Buttons */
        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-btn,
        .nav-action-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-size: 13px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            text-decoration: none;
            transition: var(--transition);
            white-space: nowrap;
            box-sizing: border-box;
        }

        .btn-cart {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            color: #ffffff;
        }

        .btn-cart:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
        }

        .btn-signin {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #ffffff;
        }

        .btn-signin:hover {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.16), rgba(255, 255, 255, 0.08));
            border-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-1px);
        }

        .btn-orders {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            color: #ffffff;
        }

        .btn-orders:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
        }

        .user-profile-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 4px 12px 4px 4px;
            border-radius: var(--radius-pill);
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            color: #ffffff;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        .user-avatar-circle {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #ff7675);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
        }

        .btn-logout {
            margin-left: 4px;
            padding: 3px 8px;
            border-radius: 12px;
            background: rgba(255, 75, 90, 0.15);
            color: var(--primary);
            font-size: 11px;
            font-weight: 700;
            text-decoration: none;
            transition: var(--transition);
        }

        .btn-logout:hover {
            background: var(--primary);
            color: #ffffff;
        }

        .theme-toggle-btn,
        .btn-theme-toggle {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--border-subtle);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: #fbbf24;
            transition: var(--transition);
            flex-shrink: 0;
            padding: 0;
        }

        .theme-toggle-btn:hover,
        .btn-theme-toggle:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: rotate(15deg);
        }
        
        /* ====================================================================
           3. MASTER PRODUCTION-GRADE HERO BANNER STYLES (FOODHOUSE REFERENCE)
           ==================================================================== */
        .hero-banner {
            --speed-mult: 1;
            --road-dur: 0.35s;
            --bike-drive-dur: 10s;
            
            position: relative;
            overflow: hidden;
            padding: 34px 20px 22px;
            background: 
                radial-gradient(circle at 50% 12%, rgba(255, 69, 58, 0.08) 0%, transparent 55%),
                radial-gradient(circle at 85% 65%, rgba(56, 189, 248, 0.06) 0%, transparent 50%),
                radial-gradient(circle at 15% 65%, rgba(255, 149, 0, 0.06) 0%, transparent 50%),
                linear-gradient(180deg, #050811 0%, #090e1c 55%, #050811 100%);
            min-height: 520px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
        }

        /* Dynamic Speed Modes */
        .hero-banner.speed-turbo {
            --speed-mult: 1.6;
            --road-dur: 0.20s;
            --bike-drive-dur: 6.5s;
        }

        .hero-banner.speed-nitro {
            --speed-mult: 2.6;
            --road-dur: 0.09s;
            --bike-drive-dur: 3.8s;
        }

        /* Ambient Glow & Star Dust */
        .hero-ambient-stars {
            position: absolute;
            inset: 0;
            background-image: 
                radial-gradient(1.5px 1.5px at 15% 25%, rgba(255, 255, 255, 0.7) 100%, transparent),
                radial-gradient(1.5px 1.5px at 35% 15%, rgba(255, 255, 255, 0.5) 100%, transparent),
                radial-gradient(1.5px 1.5px at 65% 22%, rgba(255, 255, 255, 0.6) 100%, transparent),
                radial-gradient(1.5px 1.5px at 85% 35%, rgba(255, 255, 255, 0.5) 100%, transparent),
                radial-gradient(2px 2px at 50% 10%, rgba(255, 215, 0, 0.6) 100%, transparent);
            background-size: 550px 320px;
            pointer-events: none;
            opacity: 0.6;
            z-index: 1;
        }

        /* Centered Floating Dispatch Capsule (Ref Match) */
        .live-dispatch-ticker {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: rgba(13, 19, 33, 0.92);
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.45);
            padding: 7px 20px;
            border-radius: var(--radius-pill);
            margin: 0 auto 14px auto;
            max-width: 92%;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            position: relative;
            z-index: 10;
        }

        .ticker-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #10b981;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.6px;
            white-space: nowrap;
        }

        .ticker-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #10b981;
            box-shadow: 0 0 10px #10b981;
            animation: pulseGreen 1.4s infinite;
        }

        @keyframes pulseGreen {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.35; transform: scale(1.3); }
        }

        .ticker-divider {
            color: rgba(255, 255, 255, 0.2);
            font-weight: 300;
        }

        .ticker-message {
            color: #e2e8f0;
            font-size: 12px;
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transition: opacity 0.35s ease;
        }

        /* Next-Gen Fleet Pill (Ref Match) */
        .hero-badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 14px;
            border-radius: var(--radius-pill);
            background: rgba(255, 69, 58, 0.1);
            border: 1px solid rgba(255, 69, 58, 0.32);
            color: #ff6b7a;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.05em;
            margin: 0 auto 14px auto;
            text-transform: uppercase;
            position: relative;
            z-index: 10;
        }

        /* Main Forefront Container */
        .hero-container {
            position: relative;
            z-index: 10;
            max-width: 960px;
            width: 100%;
            margin: 0 auto;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* Main Heading (Ref Match) */
        .hero-headline {
            max-width: 660px;
            font-size: clamp(30px, 3.8vw, 46px);
            font-weight: 800;
            line-height: 1.16;
            letter-spacing: -0.03em;
            color: #ffffff;
            margin: 0 0 10px 0;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.7);
        }

        .hero-brand-foodhouse {
            color: #ff3b30;
            font-weight: 900;
        }

        .hero-brand-delivers {
            background: linear-gradient(135deg, #ff453a 0%, #ff9500 50%, #ffcc00 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 800;
        }

        /* Subtitle */
        .hero-subtext {
            font-size: 14px;
            line-height: 1.55;
            color: #94a3b8;
            max-width: 600px;
            margin: 0 auto 20px auto;
            font-weight: 400;
        }

        /* ====================================================================
           SYMMETRICAL FLOATING GOURMET FOOD CARDS (LEFT & RIGHT)
           ==================================================================== */
        .floating-food-card {
            position: absolute;
            z-index: 8;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 14px 8px 10px;
            border-radius: 20px;
            background: rgba(13, 19, 33, 0.88);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            user-select: none;
        }

        .floating-food-card:hover {
            transform: translateY(-4px) scale(1.02);
        }

        /* Left Card: Royal Chicken Dum Biryani */
        .card-left {
            top: 22%;
            left: clamp(18px, 3.2vw, 55px);
            border: 1.5px solid rgba(255, 149, 0, 0.75);
            box-shadow: 0 12px 36px rgba(0, 0, 0, 0.55), 0 0 24px rgba(255, 149, 0, 0.2);
            animation: floatCardLeft 5s ease-in-out infinite;
        }

        @keyframes floatCardLeft {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-7px); }
        }

        /* Right Card: Woodfired Truffle Pizza */
        .card-right {
            top: 22%;
            right: clamp(18px, 3.2vw, 55px);
            border: 1.5px solid rgba(56, 189, 248, 0.75);
            box-shadow: 0 12px 36px rgba(0, 0, 0, 0.55), 0 0 24px rgba(56, 189, 248, 0.2);
            animation: floatCardRight 5.5s ease-in-out infinite;
        }

        @keyframes floatCardRight {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(7px); }
        }

        .food-thumb-circle {
            width: 58px;
            height: 58px;
            border-radius: 50%;
            overflow: hidden;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .card-left .food-thumb-circle {
            border: 2px solid #ff9500;
            box-shadow: 0 0 14px rgba(255, 149, 0, 0.45);
        }

        .card-right .food-thumb-circle {
            border: 2px solid #38bdf8;
            box-shadow: 0 0 14px rgba(56, 189, 248, 0.45);
        }

        .food-thumb-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .floating-food-card:hover .food-thumb-img {
            transform: scale(1.1);
        }

        .food-card-details {
            display: flex;
            flex-direction: column;
            gap: 4px;
            text-align: left;
        }

        .food-card-title {
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 700;
            letter-spacing: -0.01em;
            white-space: nowrap;
        }

        .food-card-meta-row {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            font-weight: 700;
        }

        .badge-hot {
            color: #ff8533;
            background: rgba(255, 107, 0, 0.15);
            border: 1px solid rgba(255, 107, 0, 0.35);
            padding: 2px 7px;
            border-radius: var(--radius-pill);
        }

        .badge-courier {
            color: #38bdf8;
            background: rgba(56, 189, 248, 0.15);
            border: 1px solid rgba(56, 189, 248, 0.35);
            padding: 2px 7px;
            border-radius: var(--radius-pill);
        }

        .badge-star {
            color: #fbbf24;
            background: rgba(251, 191, 36, 0.15);
            border: 1px solid rgba(251, 191, 36, 0.35);
            padding: 2px 7px;
            border-radius: var(--radius-pill);
        }

        .badge-time {
            color: #cbd5e1;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.12);
            padding: 2px 7px;
            border-radius: var(--radius-pill);
        }

        .card-arrow-circle {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.16);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            margin-left: 4px;
            flex-shrink: 0;
            transition: all 0.2s ease;
        }

        .floating-food-card:hover .card-arrow-circle {
            background: #ff4b5a;
            border-color: #ff4b5a;
            transform: translateX(2px);
        }

        /* Outer Decorative Plates (Lower Left & Right in Ref) */
        .decor-plate {
            position: absolute;
            pointer-events: none;
            z-index: 5;
            filter: drop-shadow(0 15px 35px rgba(0, 0, 0, 0.7));
            opacity: 0.88;
            transition: transform 0.4s ease;
        }

        .decor-plate-left {
            bottom: 45px;
            left: clamp(24px, 3.5vw, 65px);
            width: 125px;
            height: 125px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid rgba(255, 149, 0, 0.45);
        }

        .decor-plate-right {
            bottom: 45px;
            right: clamp(24px, 3.5vw, 65px);
            width: 125px;
            height: 125px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid rgba(56, 189, 248, 0.45);
        }

        .decor-plate-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* ====================================================================
           PREMIUM SEARCH BAR (Exact Match to Reference Image)
           ==================================================================== */
        .hero-search-card {
            width: 100%;
            max-width: 760px;
            background: rgba(13, 19, 33, 0.94);
            border: 1.5px solid rgba(56, 189, 248, 0.35);
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.6), 0 0 24px rgba(56, 189, 248, 0.16);
            border-radius: var(--radius-pill);
            display: flex;
            align-items: center;
            padding: 6px 8px 6px 8px;
            gap: 10px;
            margin: 0 auto 18px auto;
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            transition: border-color 0.25s, box-shadow 0.25s;
            box-sizing: border-box;
        }

        .hero-search-card:focus-within {
            border-color: #38bdf8;
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.7), 0 0 30px rgba(56, 189, 248, 0.3);
        }

        /* 1. Location Selector - Premium Dark Navy Theme */
        .hero-location-container {
            position: relative;
            flex-shrink: 0;
        }

        .hero-location-pill {
            background: #0d1527 !important;
            border: 1px solid rgba(56, 189, 248, 0.32) !important;
            border-radius: var(--radius-pill) !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 7px !important;
            color: #ffffff !important;
            font-size: 13px !important;
            font-weight: 700 !important;
            font-family: inherit !important;
            white-space: nowrap !important;
            cursor: pointer !important;
            padding: 8px 14px !important;
            transition: all 0.2s ease !important;
            outline: none !important;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45) !important;
            box-sizing: border-box !important;
            user-select: none !important;
            -webkit-appearance: none !important;
            appearance: none !important;
        }

        .hero-location-pill:hover {
            background: #15223c !important;
            border-color: rgba(56, 189, 248, 0.65) !important;
            color: #ffffff !important;
            box-shadow: 0 4px 14px rgba(56, 189, 248, 0.25) !important;
            transform: translateY(-0.5px);
        }

        .hero-location-pill:focus-visible {
            border-color: #38bdf8 !important;
            box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.35) !important;
        }

        .hero-location-pill svg.icon-pin {
            color: #ff3b30 !important;
            flex-shrink: 0;
        }

        .hero-location-pill svg.icon-caret {
            color: #94a3b8 !important;
            flex-shrink: 0;
            transition: transform 0.25s ease !important;
        }

        .hero-location-pill[aria-expanded="true"] svg.icon-caret {
            transform: rotate(180deg) !important;
            color: #38bdf8 !important;
        }

        /* Opened Dropdown Menu */
        .location-dropdown {
            position: absolute;
            top: calc(100% + 10px);
            left: 0;
            min-width: 220px;
            background: #0b1120 !important;
            border: 1px solid rgba(56, 189, 248, 0.38) !important;
            border-radius: 14px !important;
            padding: 6px !important;
            box-shadow: 0 18px 45px rgba(0, 0, 0, 0.85), 0 0 24px rgba(56, 189, 248, 0.2) !important;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            z-index: 100;
            display: none;
            flex-direction: column;
            gap: 3px;
            box-sizing: border-box;
        }

        .location-dropdown.show {
            display: flex;
            animation: dropdownFade 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes dropdownFade {
            from { opacity: 0; transform: translateY(-6px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .location-option {
            background: transparent !important;
            border: none !important;
            outline: none !important;
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            padding: 8px 12px;
            border-radius: 8px;
            color: #cbd5e1 !important;
            font-size: 12.5px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            text-align: left;
            transition: all 0.18s ease;
            box-sizing: border-box;
        }

        .location-option:hover {
            background: rgba(56, 189, 248, 0.14) !important;
            color: #ffffff !important;
        }

        .location-option.active {
            background: rgba(56, 189, 248, 0.22) !important;
            color: #ffffff !important;
            font-weight: 700;
        }

        .location-option .loc-badge {
            font-size: 10.5px;
            font-weight: 700;
            background: rgba(255, 255, 255, 0.08);
            color: #94a3b8;
            padding: 2px 7px;
            border-radius: var(--radius-pill);
        }

        .location-option.active .loc-badge {
            background: rgba(56, 189, 248, 0.3);
            color: #38bdf8;
        }

        /* 2. Search Input Wrap */
        .search-input-wrap {
            display: flex;
            align-items: center;
            gap: 9px;
            flex: 1;
            min-width: 180px;
            padding: 0 4px;
        }

        .search-input-wrap svg.icon-glass {
            color: #ff4b5a;
            flex-shrink: 0;
        }

        .hero-search-input {
            width: 100%;
            background: transparent;
            border: none;
            outline: none;
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 500;
            font-family: inherit;
            padding: 8px 0;
            line-height: 1.4;
        }

        .hero-search-input::placeholder {
            color: rgba(255, 255, 255, 0.52);
            font-weight: 400;
            letter-spacing: 0.01em;
        }

        [data-theme="light"] .hero-search-input::placeholder {
            color: #94a3b8;
        }

        /* 3. Find Food Search Button */
        .hero-search-btn {
            background: linear-gradient(135deg, #ff453a 0%, #ff2d55 100%);
            border: none;
            outline: none;
            color: #ffffff;
            padding: 10px 24px;
            border-radius: var(--radius-pill);
            font-size: 13.5px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 7px;
            white-space: nowrap;
            box-shadow: 0 4px 18px rgba(255, 69, 58, 0.45);
            transition: all 0.2s ease;
        }

        .hero-search-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 24px rgba(255, 69, 58, 0.6);
            background: linear-gradient(135deg, #ff5747 0%, #ff1f4b 100%);
        }

        /* ====================================================================
           SINGLE HORIZONTAL ROW: FLEET VELOCITY & TELEMETRY CONTROLS
           ==================================================================== */
        .hero-controls-stack {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            width: 100%;
            margin-bottom: 6px;
        }

        /* ONE SINGLE HORIZONTAL LINE on desktop (align-items: center, flex-wrap: nowrap) */
        .fleet-velocity-bar {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-wrap: nowrap;
            gap: 5px;
            width: 100%;
            max-width: 960px;
            margin: 0 auto;
            padding: 2px 0;
            box-sizing: border-box;
            white-space: nowrap;
        }

        .velocity-label {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            color: #94a3b8;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            margin-right: 2px;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .speed-chip-btn {
            background: rgba(13, 19, 33, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.14);
            color: #cbd5e1;
            padding: 5px 11px;
            border-radius: var(--radius-pill);
            font-size: 11.5px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            white-space: nowrap;
            flex-shrink: 0;
            line-height: 1.25;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .speed-chip-btn:hover {
            border-color: rgba(255, 255, 255, 0.35);
            color: #ffffff;
            transform: translateY(-1px);
        }

        /* Active Speed Chip (Red/Coral Gradient matching Reference) */
        .speed-chip-btn.active {
            background: linear-gradient(135deg, #ff453a 0%, #ff2d55 100%);
            border-color: #ff453a;
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(255, 69, 58, 0.45);
        }

        .btn-race-across {
            background: rgba(13, 19, 33, 0.85);
            border: 1px solid rgba(56, 189, 248, 0.5);
            color: #38bdf8;
        }

        .btn-race-across:hover {
            background: rgba(56, 189, 248, 0.18);
            box-shadow: 0 0 16px rgba(56, 189, 248, 0.4);
            color: #ffffff;
        }

        /* Telemetry Indicators aligned in same single row */
        .hud-stat-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4.5px 10px;
            border-radius: var(--radius-pill);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.02em;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            white-space: nowrap;
            flex-shrink: 0;
            line-height: 1.25;
        }

        .hud-speed {
            background: rgba(56, 189, 248, 0.12);
            border: 1px solid rgba(56, 189, 248, 0.45);
            color: #38bdf8;
        }

        .hud-speed-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #38bdf8;
            box-shadow: 0 0 8px #38bdf8;
            animation: pulseCyan 1.2s infinite;
            flex-shrink: 0;
        }

        @keyframes pulseCyan {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(1.3); }
        }

        .hud-eta {
            background: rgba(245, 158, 11, 0.12);
            border: 1px solid rgba(245, 158, 11, 0.45);
            color: #fbbf24;
        }

        .hud-fresh {
            background: rgba(16, 185, 129, 0.12);
            border: 1px solid rgba(16, 185, 129, 0.45);
            color: #34d399;
        }

        @media (max-width: 900px) {
            .fleet-velocity-bar {
                justify-content: flex-start;
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                padding-bottom: 6px;
                scrollbar-width: none;
            }
            .fleet-velocity-bar::-webkit-scrollbar {
                display: none;
            }
        }

        /* Popular Search Chips */
        .hero-popular-tags {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            flex-wrap: wrap;
            font-size: 12px;
            margin-top: 4px;
        }

        .popular-label {
            color: #94a3b8;
            font-weight: 600;
            font-size: 12px;
        }

        .popular-chip {
            background: rgba(255, 255, 255, 0.07);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: #e2e8f0;
            padding: 3px 12px;
            border-radius: var(--radius-pill);
            text-decoration: none;
            cursor: pointer;
            font-size: 11.5px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .popular-chip:hover {
            background: rgba(255, 69, 58, 0.2);
            border-color: rgba(255, 69, 58, 0.45);
            color: #ffffff;
            transform: translateY(-1px);
        }

        /* ====================================================================
           SIGNATURE FEATURE: HIGHWAY TRACK WITH MOVING ELECTRIC SUPERBIKES
           ==================================================================== */
        .highway-track-section {
            position: relative;
            width: 100%;
            height: 124px;
            margin-top: 22px;
            overflow: hidden;
            border-radius: 18px;
            border: 1px solid rgba(255, 255, 255, 0.06);
            box-shadow: 0 14px 34px rgba(0, 0, 0, 0.7) inset, 0 4px 18px rgba(0, 0, 0, 0.35);
            mask-image: linear-gradient(180deg, transparent 0%, black 16%, black 86%, transparent 100%);
            -webkit-mask-image: linear-gradient(180deg, transparent 0%, black 16%, black 86%, transparent 100%);
        }

        /* Cinematic Night Highway Background (City Skyline & Bridge) */
        .highway-backdrop {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            background-image: url('assets/images/city-highway-night.jpg');
            background-size: cover;
            background-position: center bottom;
            filter: brightness(0.9) contrast(1.1);
        }

        .highway-overlay-vignette {
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(5, 8, 17, 0.7) 0%, rgba(5, 8, 17, 0.2) 40%, rgba(5, 8, 17, 0.75) 100%);
            pointer-events: none;
        }

        /* Scrolling Dashed Lane Lines */
        .highway-dashed-lines {
            position: absolute;
            bottom: 30px;
            left: 0;
            width: 200%;
            height: 4px;
            background: repeating-linear-gradient(
                90deg,
                rgba(255, 215, 0, 0.85) 0px,
                rgba(255, 215, 0, 0.85) 45px,
                transparent 45px,
                transparent 90px
            );
            animation: highwayDashScroll calc(var(--road-dur) * 1.5) linear infinite;
        }

        @keyframes highwayDashScroll {
            0% { transform: translateX(0); }
            100% { transform: translateX(-90px); }
        }

        /* Wet Asphalt Specular Road Reflections */
        .highway-asphalt-sheen {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 60px;
            background: linear-gradient(180deg, transparent 0%, rgba(255, 180, 50, 0.08) 50%, rgba(5, 8, 17, 0.8) 100%);
            pointer-events: none;
        }

        /* Active Moving Superbikes (Convoy in Action) */
        .highway-bike-rig {
            position: absolute;
            bottom: 15px;
            width: 130px;
            height: 74px;
            will-change: transform;
            z-index: 5;
            pointer-events: none;
            left: 0;
            transform: translate3d(-220px, 0, 0);
        }

        /* Bike 1: Lead Superbike (smooth continuous fluid cruise) */
        .bike-lead {
            bottom: 14px;
            animation: driveFleetLead var(--bike-drive-dur) linear infinite;
        }

        @keyframes driveFleetLead {
            0% { transform: translate3d(-220px, 0, 0); }
            100% { transform: translate3d(calc(100vw + 140px), 0, 0); }
        }

        /* Bike 2: Partner Courier Superbike (cruising slightly behind with natural offset) */
        .bike-second {
            bottom: 24px;
            opacity: 0.92;
            animation: driveFleetSecond calc(var(--bike-drive-dur) * 1.35) linear infinite 4.2s;
        }

        @keyframes driveFleetSecond {
            0% { transform: translate3d(-220px, 0, 0) scale(0.86); }
            100% { transform: translate3d(calc(100vw + 140px), 0, 0) scale(0.86); }
        }

        /* Race Across Super Nitro Mode */
        .highway-bike-rig.race-active {
            animation: raceSprintAcross 1.5s cubic-bezier(0.2, 0.8, 0.2, 1) forwards !important;
            z-index: 20;
        }

        @keyframes raceSprintAcross {
            0% { transform: translate3d(-160px, 0, 0) scale(1.1); }
            100% { transform: translate3d(calc(100vw + 180px), 0, 0) scale(1.1); }
        }

        .superbike-img-wrap {
            position: relative;
            width: 100%;
            height: 100%;
        }

        .superbike-png {
            width: 100%;
            height: 100%;
            object-fit: contain;
            filter: drop-shadow(0 6px 14px rgba(0, 0, 0, 0.85));
            animation: bikeIdleBounce 0.22s ease-in-out infinite alternate;
        }

        @keyframes bikeIdleBounce {
            0% { transform: translateY(0); }
            100% { transform: translateY(-1.5px); }
        }

        /* Refined Headlight Beam */
        .bike-headlight {
            position: absolute;
            right: -92px;
            top: 25px;
            width: 105px;
            height: 36px;
            background: linear-gradient(90deg, rgba(56, 189, 248, 0.75) 0%, rgba(56, 189, 248, 0.22) 45%, transparent 100%);
            clip-path: polygon(0 42%, 100% 0, 100% 100%, 0 58%);
            pointer-events: none;
            filter: blur(1.5px);
        }

        /* Taillight Flare */
        .bike-taillight {
            position: absolute;
            left: 12px;
            top: 32px;
            width: 16px;
            height: 6px;
            background: #ff3b30;
            border-radius: 50%;
            box-shadow: -15px 0 20px #ff3b30, -30px 0 35px rgba(255, 59, 48, 0.5);
            pointer-events: none;
        }

        /* Underglow Neon */
        .bike-underglow {
            position: absolute;
            bottom: 4px;
            left: 20px;
            right: 20px;
            height: 10px;
            background: rgba(56, 189, 248, 0.7);
            border-radius: 50%;
            filter: blur(6px);
            pointer-events: none;
        }

        /* Nitro Flame (Active in Nitro / Sprint) */
        .bike-nitro-fire {
            position: absolute;
            left: -22px;
            top: 33px;
            width: 28px;
            height: 7px;
            background: linear-gradient(90deg, transparent 0%, #38bdf8 30%, #ec4899 70%, #ff4b5a 100%);
            border-radius: var(--radius-pill);
            opacity: 0;
            filter: blur(1px);
            transition: opacity 0.25s;
            pointer-events: none;
        }

        .speed-nitro .bike-nitro-fire,
        .race-active .bike-nitro-fire {
            opacity: 1;
            animation: nitroFlicker 0.08s infinite alternate;
        }

        @keyframes nitroFlicker {
            0% { transform: scaleX(0.85) scaleY(0.9); }
            100% { transform: scaleX(1.3) scaleY(1.2); }
        }

        /* ====================================================================
           BOTTOM SERVICE-BENEFIT CARDS (Exact Match to Reference Image)
           ==================================================================== */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            width: 100%;
            max-width: 1280px;
            margin: 28px auto 36px auto;
            padding: 0 20px;
            position: relative;
            z-index: 10;
            box-sizing: border-box;
        }

        .feature-card {
            background: rgba(13, 19, 33, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 16px 18px;
            display: flex;
            align-items: center;
            gap: 14px;
            height: 100%;
            min-height: 76px;
            box-sizing: border-box;
            transition: all 0.25s ease;
        }

        .feature-card:hover {
            border-color: rgba(255, 255, 255, 0.24);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
        }

        .feature-icon-box {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .feature-icon-box.icon-red {
            background: rgba(255, 69, 58, 0.15);
            color: #ff453a;
            border: 1px solid rgba(255, 69, 58, 0.3);
        }

        .feature-icon-box.icon-green {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .feature-icon-box.icon-gold {
            background: rgba(245, 158, 11, 0.15);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .feature-icon-box.icon-blue {
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.3);
        }

        .feature-title {
            color: #ffffff;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .feature-desc {
            color: #94a3b8;
            font-size: 12px;
            font-weight: 500;
        }

        /* ====================================================================
           RESPONSIVE DESIGN ADAPTATIONS
           ==================================================================== */
        @media (max-width: 1340px) {
            .decor-plate {
                display: none !important;
            }
        }

        @media (max-width: 1340px) {
            .floating-food-card,
            .decor-plate {
                display: none !important;
            }
        }

        @media (max-width: 992px) {
            .features-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 12px;
            }
        }

        @media (max-width: 768px) {
            .hero-banner {
                padding: 18px 14px 16px;
                min-height: auto;
            }
            .hero-headline {
                font-size: 27px;
            }
            .hero-search-card {
                flex-direction: column;
                border-radius: 18px;
                padding: 12px;
                gap: 10px;
            }
            .hero-location-container {
                width: 100%;
            }
            .hero-location-pill {
                width: 100% !important;
                justify-content: center !important;
                border-radius: var(--radius-pill) !important;
                padding: 10px 16px !important;
            }
            .location-dropdown {
                left: 50% !important;
                transform: translateX(-50%) !important;
                width: 100% !important;
            }
            .hero-search-btn {
                width: 100%;
                justify-content: center;
            }
            .features-grid {
                grid-template-columns: 1fr;
                padding: 0 14px;
            }
            .highway-track-section {
                height: 100px;
            }
            .highway-bike-rig {
                width: 105px;
                height: 60px;
            }
        }

    
        /* Accessibility: Prefers-Reduced-Motion */
        @media (prefers-reduced-motion: reduce) {
            .highway-bike-rig,
            .highway-dashed-lines,
            .superbike-png,
            .bike-headlight,
            .bike-taillight,
            .bike-underglow,
            .bike-nitro-fire,
            .floating-food-card,
            .hud-speed-dot,
            .pulse-dot {
                animation: none !important;
                transition: none !important;
            }
            .bike-lead {
                transform: translate3d(20vw, 0, 0) !important;
            }
            .bike-second {
                display: none !important;
            }
        }
/* ====================================================================
           4. Cuisine Filter Pills Section
           ==================================================================== */
        .filters-section {
            padding: 24px;
            max-width: 1280px;
            margin: 0 auto;
        }

        .section-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .section-title {
            font-size: 22px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.3px;
        }

        .restaurant-counter {
            font-size: 13.5px;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .city-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 75, 90, 0.1);
            color: var(--primary);
            border: 1px solid rgba(255, 75, 90, 0.3);
            padding: 5px 12px;
            border-radius: var(--radius-pill);
            font-size: 12.5px;
            font-weight: 700;
        }

        .cuisine-pills-bar {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 8px;
            scrollbar-width: thin;
        }

        .cuisine-pills-bar::-webkit-scrollbar {
            height: 4px;
        }

        .cuisine-pills-bar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 4px;
        }

        .cuisine-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
            cursor: pointer;
            transition: var(--transition);
            user-select: none;
        }

        .cuisine-pill:hover {
            color: #ffffff;
            border-color: rgba(255, 255, 255, 0.25);
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-1px);
        }

        .cuisine-pill.active {
            background: linear-gradient(135deg, var(--primary) 0%, #ff2a3b 100%);
            color: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        /* ====================================================================
           5. Restaurant Cards Grid
           ==================================================================== */
        .restaurants-section {
            padding: 0 24px 60px;
            max-width: 1280px;
            margin: 0 auto;
        }

        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 26px;
        }

        .restaurant-card {
            background: var(--bg-card);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            color: inherit;
            transition: var(--transition);
            position: relative;
            box-shadow: var(--shadow-sm);
        }

        .restaurant-card:hover {
            transform: translateY(-6px);
            border-color: var(--border-hover);
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.6), 0 0 20px rgba(255, 75, 90, 0.2);
            background: var(--bg-card-hover);
        }

        .card-img-box {
            position: relative;
            width: 100%;
            height: 210px;
            overflow: hidden;
            background: #1e293b;
        }

        .card-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .restaurant-card:hover .card-img {
            transform: scale(1.06);
        }

        .promoted-badge {
            position: absolute;
            top: 14px;
            left: 14px;
            background: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(8px);
            color: #ffffff;
            font-size: 10.5px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .offer-ribbon {
            position: absolute;
            bottom: 12px;
            left: 12px;
            background: linear-gradient(135deg, rgba(255, 75, 90, 0.95) 0%, rgba(255, 42, 59, 0.95) 100%);
            backdrop-filter: blur(8px);
            color: #ffffff;
            font-size: 11.5px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        }

        .delivery-time-pill {
            position: absolute;
            bottom: 12px;
            right: 12px;
            background: rgba(10, 14, 23, 0.88);
            backdrop-filter: blur(8px);
            color: #ffffff;
            font-size: 11.5px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
            display: flex;
            align-items: center;
            gap: 5px;
            border: 1px solid rgba(255, 255, 255, 0.12);
        }

        .card-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex: 1;
            gap: 12px;
        }

        .card-row-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .card-title {
            font-size: 18.5px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .rating-badge-card {
            background: var(--rating-green);
            color: #ffffff;
            font-size: 12.5px;
            font-weight: 800;
            padding: 4px 9px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.35);
        }

        .rating-badge-card.amber {
            background: var(--rating-amber);
            box-shadow: 0 2px 8px rgba(245, 158, 11, 0.35);
        }

        .card-row-mid {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13.5px;
        }

        .cuisine-badge {
            color: var(--text-secondary);
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 65%;
        }

        .price-badge {
            color: var(--accent-gold);
            font-weight: 700;
            font-size: 13px;
        }

        .card-location {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12.5px;
            color: var(--text-muted);
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        }

        .card-location span {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .card-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 2px;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 700;
        }

        .status-indicator.open {
            color: var(--accent-green);
        }

        .status-indicator.closed {
            color: var(--text-muted);
        }

        .status-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: currentColor;
            display: inline-block;
        }

        .status-indicator.open .status-dot {
            box-shadow: 0 0 8px var(--accent-green);
            animation: pulse-dot 2s infinite;
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(1.2); }
        }

        /* Distinct, Boxed, Surrounded View Menu Button */
        .card-action-box {
            margin-top: 10px;
            padding-top: 12px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        .btn-view-menu-surrounded {
            width: 100%;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 10px !important;
            background: linear-gradient(135deg, #ff4b5a 0%, #ff2a3b 100%) !important;
            color: #ffffff !important;
            font-size: 14.5px !important;
            font-weight: 800 !important;
            padding: 13px 22px !important;
            border-radius: 9999px !important;
            border: 1.5px solid rgba(255, 255, 255, 0.3) !important;
            box-shadow: 0 6px 20px rgba(255, 75, 90, 0.45) !important;
            text-decoration: none !important;
            letter-spacing: 0.3px !important;
            transition: all 0.28s cubic-bezier(0.16, 1, 0.3, 1) !important;
            cursor: pointer !important;
            box-sizing: border-box !important;
        }

        .btn-view-menu-surrounded:hover {
            transform: translateY(-3px) scale(1.02) !important;
            box-shadow: 0 10px 30px rgba(255, 75, 90, 0.7) !important;
            background: linear-gradient(135deg, #ff2a3b 0%, #ff5252 100%) !important;
            border-color: rgba(255, 255, 255, 0.6) !important;
            color: #ffffff !important;
        }

        /* Footer */
        footer {
            text-align: center;
            padding: 30px 24px;
            font-size: 13px;
            color: var(--text-muted);
            border-top: 1px solid var(--border-subtle);
            background: rgba(10, 14, 23, 0.7);
        }

        @media (max-width: 1024px) {
            .hero-main-grid {
                grid-template-columns: 1fr;
                gap: 32px;
            }
            .hero-content-col {
                text-align: center;
                align-items: center;
            }
            .hero-subtext {
                max-width: 100%;
            }
            .hero-search-card {
                width: 100%;
                max-width: 580px;
            }
            .hero-popular-tags {
                justify-content: center;
            }
            .scooter-showcase-card {
                max-width: 480px;
                margin: 0 auto;
            }
            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .nav-container {
                flex-wrap: wrap;
            }
            .search-wrapper {
                order: 3;
                max-width: 100%;
                width: 100%;
            }
            .hero-banner {
                padding: 28px 16px 20px;
                min-height: auto;
            }
            .hero-headline {
                font-size: 28px;
            }
            .hero-search-card {
                flex-direction: column;
                align-items: stretch;
                padding: 10px;
                gap: 10px;
            }
            .hero-location-container {
                width: 100%;
            }
            .hero-location-pill {
                width: 100% !important;
                justify-content: center !important;
                border-radius: var(--radius-pill) !important;
                padding: 10px 14px !important;
            }
            .hero-search-btn {
                justify-content: center;
                width: 100%;
            }
            .restaurant-grid {
                grid-template-columns: 1fr;
            }
            .features-grid {
                grid-template-columns: 1fr;
            }
        }
    
        /* Accessibility: Prefers-Reduced-Motion */
        @media (prefers-reduced-motion: reduce) {
            .highway-bike-rig,
            .highway-dashed-lines,
            .superbike-png,
            .bike-headlight,
            .bike-taillight,
            .bike-underglow,
            .bike-nitro-fire,
            .floating-food-card,
            .hud-speed-dot,
            .pulse-dot {
                animation: none !important;
                transition: none !important;
            }
            .bike-lead {
                transform: translate3d(20vw, 0, 0) !important;
            }
            .bike-second {
                display: none !important;
            }
        }
</style>
</head>
<body style="background-color: #0a0e17; color: #ffffff;">

    <%
        // Retrieve restaurants from Request Scope or instantiate DAO fallback
        List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
        if (restaurants == null) {
            RestaurantDAOImpl dao = new RestaurantDAOImpl();
            restaurants = dao.getAllRestaurants();
        }

        // Live dynamic cart count from HttpSession
        Cart navCart = (Cart) session.getAttribute("cart");
        int navCartCount = 0;
        if (navCart != null && navCart.getItems() != null) {
            for (CartItem ci : navCart.getItems().values()) {
                navCartCount += ci.getQuantity();
            }
        }

        // Check if user is logged in
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) {
            loggedUser = (User) session.getAttribute("loggedInUser");
        }

        int totalCount = (restaurants != null) ? restaurants.size() : 0;
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

            <!-- Hidden Input maintaining full compatibility with backend filtering -->
            <input type="hidden" id="searchInput" class="search-input" onkeyup="filterRestaurants()">

            <!-- Centered Capsule Nav Pills (Ref Match) -->
            <nav class="nav-center-pills" aria-label="Main Navigation">
                <a href="restaurant" class="nav-pill active">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
                    <span>Home</span>
                </a>
                <a href="#restaurants" onclick="const el=document.querySelector('.filters-section'); if(el) el.scrollIntoView({behavior:'smooth'}); return false;" class="nav-pill">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                    <span>Restaurants</span>
                </a>
                <a href="javascript:void(0)" onclick="quickSearch('Pizza')" class="nav-pill">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                    <span>Offers</span>
                </a>
                <a href="orders" class="nav-pill">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
                    <span>Track Order</span>
                </a>
                <a href="#about" onclick="const el=document.querySelector('.features-grid'); if(el) el.scrollIntoView({behavior:'smooth'}); return false;" class="nav-pill">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                    <span>About</span>
                </a>
            </nav>

            <!-- Navbar Actions -->
            <div class="nav-actions">


                <!-- Cart Button with Dynamic Live Badge -->
                <a href="cart" class="nav-btn btn-cart">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="9" cy="21" r="1"></circle>
                        <circle cx="20" cy="21" r="1"></circle>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                    </svg>
                    <span>Cart (<%= navCartCount %>)</span>
                </a>

                <!-- Dynamic Login / User Profile State -->
                <% if (loggedUser != null) { 
                    String initial = (loggedUser.getUsername() != null && !loggedUser.getUsername().isEmpty()) ? loggedUser.getUsername().substring(0, 1).toUpperCase() : "U";
                    String displayName = (loggedUser.getUsername() != null) ? loggedUser.getUsername() : "Member";
                    String uRole = (loggedUser.getRole() != null) ? loggedUser.getRole() : "Customer";
                    boolean isUAdmin = "admin".equalsIgnoreCase(uRole) || "restaurantadmin".equalsIgnoreCase(uRole) || "restaurant_admin".equalsIgnoreCase(uRole);
                    boolean isUDelivery = "deliveryagent".equalsIgnoreCase(uRole) || "delivery_agent".equalsIgnoreCase(uRole);
                %>
                    <!-- My Orders / Records Button -->
                    <a href="orders" class="nav-btn btn-orders" title="View My Order Records">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                        </svg>
                        <span>My Orders</span>
                    </a>

                    <% if (isUAdmin) { %>
                        <a href="restaurant-admin" class="nav-btn" style="background:rgba(251,191,36,0.12); color:var(--accent-gold); border-color:rgba(251,191,36,0.4);" title="Restaurant Admin Portal">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            <span>Admin</span>
                        </a>
                    <% } %>

                    <% if (isUDelivery || isUAdmin) { %>
                        <a href="delivery-admin" class="nav-btn" style="background:rgba(56,189,248,0.12); color:var(--accent-blue); border-color:rgba(56,189,248,0.4);" title="Delivery Partner Portal">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                            <span>Delivery</span>
                        </a>
                    <% } %>

                    <!-- User Profile Pill linking to Profile Page -->
                    <div class="user-profile-pill" style="cursor: pointer;" title="View & Edit Profile">
                        <a href="profile" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 8px;">
                            <div class="user-avatar-circle"><%= initial %></div>
                            <span><%= displayName %></span>
                        </a>
                        <a href="logout" class="btn-logout" title="Sign Out">Logout</a>
                    </div>
                <% } else { %>
                    <!-- Guest: Single unified Sign In button -->
                    <a href="Login.jsp" class="nav-btn btn-signin" title="Sign In or Register">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
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

            <!-- ================= HERO RUNNING BANNER: FOODHOUSE CINEMATIC ================= -->
    <section class="hero-banner" id="heroBannerSection">
        <!-- Ambient Stars -->
        <div class="hero-ambient-stars" aria-hidden="true"></div>

        <!-- 1. LIVE FLEET DISPATCH TICKER (Ref Match) -->
        <div class="live-dispatch-ticker">
            <span class="ticker-tag">
                <span class="ticker-dot"></span>
                LIVE FLEET DISPATCH
            </span>
            <span class="ticker-divider">|</span>
            <span id="liveTickerText" class="ticker-message">Order #FH-8943 • Royal Chicken Biryani & Paneer Tikka dispatched to Indiranagar • Rider: Suresh K. (⭐ 4.98) • ETA: 12 mins</span>
        </div>

        <!-- 2. FLEET BADGE PILL (Ref Match) -->
        <div class="hero-badge-pill">
            ⚡ NEXT-GEN 100% ELECTRIC HIGH-SPEED DELIVERY FLEET
        </div>

        <!-- 3. SYMMETRICAL FLOATING GOURMET FOOD CARDS (Flanking Desktop View) -->
        <!-- Left: Royal Chicken Dum Biryani -->
        <a href="javascript:void(0)" onclick="quickSearch('Biryani')" class="floating-food-card card-left" aria-label="View Royal Chicken Dum Biryani">
            <div class="food-thumb-circle">
                <img src="${pageContext.request.contextPath}/assets/images/biryani-dish.jpg" alt="Royal Chicken Dum Biryani" class="food-thumb-img">
            </div>
            <div class="food-card-details">
                <div class="food-card-title">Royal Chicken Dum Biryani</div>
                <div class="food-card-meta-row">
                    <span class="badge-hot">🔥 100% Hot</span>
                    <span class="badge-star">⭐ 4.9</span>
                    <span class="badge-time">🕒 20 mins</span>
                </div>
            </div>
            <div class="card-arrow-circle">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
            </div>
        </a>

        <!-- Outer Decorative Biryani Plate (Lower Left) -->
        <div class="decor-plate decor-plate-left" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/assets/images/biryani-dish.jpg" alt="" class="decor-plate-img">
        </div>

        <!-- Right: Woodfired Truffle Pizza -->
        <a href="javascript:void(0)" onclick="quickSearch('Pizza')" class="floating-food-card card-right" aria-label="View Woodfired Truffle Pizza">
            <div class="food-card-details">
                <div class="food-card-title">Woodfired Truffle Pizza</div>
                <div class="food-card-meta-row">
                    <span class="badge-courier">⚡ Express Courier</span>
                    <span class="badge-star">⭐ 4.8</span>
                    <span class="badge-time">🕒 15 mins</span>
                </div>
            </div>
            <div class="card-arrow-circle">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>
            </div>
            <div class="food-thumb-circle">
                <img src="${pageContext.request.contextPath}/assets/images/truffle-pizza.jpg" alt="Woodfired Truffle Pizza" class="food-thumb-img">
            </div>
        </a>

        <!-- Outer Decorative Pizza Plate (Lower Right) -->
        <div class="decor-plate decor-plate-right" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/assets/images/truffle-pizza.jpg" alt="" class="decor-plate-img">
        </div>

        <!-- 4. CENTERED HERO HEADLINE, SEARCH & CONTROLS -->
        <div class="hero-container">
            <h1 class="hero-headline">
                Craving something delicious?<br>
                <span class="hero-brand-foodhouse">FoodHouse</span> <span class="hero-brand-delivers">delivers it fast.</span>
            </h1>

            <p class="hero-subtext">
                Hyper-speed delivery powered by FoodHouse smart electric superbikes. Fresh gourmet flavors, verified hygienic kitchens, delivered piping-hot right to your doorstep.
            </p>

            <!-- Location & Food Search Bar -->
            <div class="hero-search-card">
                <div class="hero-location-container">
                    <button type="button" class="hero-location-pill" id="heroLocationPill" onclick="toggleLocationDropdown(event)" aria-haspopup="listbox" aria-expanded="false" aria-label="Selected Delivery Location: Bangalore">
                        <svg class="icon-pin" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                        </svg>
                        <span id="selectedLocationLabel">All Bangalore</span>
                        <svg class="icon-caret" width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="6 9 12 15 18 9"></polyline>
                        </svg>
                    </button>
                    <div class="location-dropdown" id="locationDropdown" role="listbox" aria-label="Select Delivery Location">
                        <button type="button" class="location-option active" role="option" onclick="selectLocation('All', 'All Bangalore', event)">
                            <span>📍 All Bangalore</span>
                            <span class="loc-badge">30 spots</span>
                        </button>
                        <button type="button" class="location-option" role="option" onclick="selectLocation('Indiranagar', 'Indiranagar', event)">
                            <span>Indiranagar</span>
                            <span class="loc-badge">6 spots</span>
                        </button>
                        <button type="button" class="location-option" role="option" onclick="selectLocation('Koramangala', 'Koramangala', event)">
                            <span>Koramangala</span>
                            <span class="loc-badge">6 spots</span>
                        </button>
                        <button type="button" class="location-option" role="option" onclick="selectLocation('HSR Layout', 'HSR Layout', event)">
                            <span>HSR Layout</span>
                            <span class="loc-badge">3 spots</span>
                        </button>
                        <button type="button" class="location-option" role="option" onclick="selectLocation('Church Street', 'MG Road / Church St', event)">
                            <span>MG Road / Church St</span>
                            <span class="loc-badge">4 spots</span>
                        </button>
                        <button type="button" class="location-option" role="option" onclick="selectLocation('Jayanagar', 'Jayanagar', event)">
                            <span>Jayanagar</span>
                            <span class="loc-badge">2 spots</span>
                        </button>
                        <button type="button" class="location-option" role="option" onclick="selectLocation('Malleshwaram', 'Malleshwaram', event)">
                            <span>Malleshwaram</span>
                            <span class="loc-badge">2 spots</span>
                        </button>
                    </div>
                </div>
                <div class="search-input-wrap">
                    <svg class="icon-glass" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <input type="text" id="heroSearchInput" class="hero-search-input" 
                           placeholder="Search restaurant, dish, or cuisine (Biryani, Dosa, Pizza...)"
                           oninput="syncHeroSearch(this.value)"
                           onkeydown="if(event.key === 'Enter') triggerHeroSearch()"
                           aria-label="Search food, dish, or restaurant">
                </div>
                <button type="button" class="hero-search-btn" onclick="triggerHeroSearch()" aria-label="Find Food">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <span>Find Food</span>
                </button>
            </div>

            <!-- Controls Stack: 1 Single Horizontal Row Fleet Velocity Controls -->
            <div class="hero-controls-stack">
                <div class="fleet-velocity-bar" role="group" aria-label="Fleet Velocity Controls">
                    <span class="velocity-label">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                        Fleet Velocity:
                    </span>
                    <button type="button" class="speed-chip-btn" id="btnCruise" onclick="setBannerSpeed('normal', this)">🌱 Eco 40 km/h</button>
                    <button type="button" class="speed-chip-btn active" id="btnTurbo" onclick="setBannerSpeed('turbo', this)">⚡ Express 65 km/h</button>
                    <button type="button" class="speed-chip-btn" id="btnNitro" onclick="setBannerSpeed('nitro', this)">🚀 Hyper 95 km/h</button>
                    <button type="button" class="speed-chip-btn btn-race-across" onclick="triggerRaceAcross()">🏆 Race Delivery</button>
                    <div class="hud-stat-pill hud-speed" title="Fleet Cruising Speed">
                        <span class="hud-speed-dot"></span>
                        <span id="hudSpeedometer"><strong>SPEED:</strong> 65 KM/H</span>
                    </div>
                    <div class="hud-stat-pill hud-eta" title="Estimated Time of Arrival">
                        <span>🕒</span>
                        <span id="hudEta"><strong>ETA:</strong> 12 MINS</span>
                    </div>
                    <div class="hud-stat-pill hud-fresh" title="Kitchen Quality Standards">
                        <span>🔥</span>
                        <span>100% Hot & Steaming</span>
                    </div>
                </div>

                <!-- Row 3: Popular Searches Chips -->
                <div class="hero-popular-tags">
                    <span class="popular-label">Popular searches:</span>
                    <a href="javascript:void(0)" class="popular-chip" onclick="quickSearch('Biryani')">Biryani</a>
                    <a href="javascript:void(0)" class="popular-chip" onclick="quickSearch('Pizza')">Pizza</a>
                    <a href="javascript:void(0)" class="popular-chip" onclick="quickSearch('Burger')">Burgers</a>
                    <a href="javascript:void(0)" class="popular-chip" onclick="quickSearch('South Indian')">South Indian</a>
                    <a href="javascript:void(0)" class="popular-chip" onclick="quickSearch('Chinese')">Chinese</a>
                </div>
            </div>
        </div>

        <!-- 5. SIGNATURE FEATURE: DEDICATED HIGHWAY TRACK WITH MOVING ELECTRIC SUPERBIKES -->
        <div class="highway-track-section" aria-hidden="true">
            <div class="highway-backdrop" style="background-image: url('${pageContext.request.contextPath}/assets/images/city-highway-night.jpg');"></div>
            <div class="highway-dashed-lines"></div>
            <div class="highway-asphalt-sheen"></div>
            <div class="highway-overlay-vignette"></div>

            <!-- Lead FoodHouse Electric Superbike -->
            <div class="highway-bike-rig bike-lead" id="movingBikeRig">
                <div class="superbike-img-wrap">
                    <div class="bike-headlight"></div>
                    <div class="bike-taillight"></div>
                    <div class="bike-underglow"></div>
                    <div class="bike-nitro-fire"></div>
                    <img src="${pageContext.request.contextPath}/assets/images/foodhouse-future-bike.png" alt="" class="superbike-png">
                </div>
            </div>

            <!-- Second Convoy FoodHouse Electric Superbike -->
            <div class="highway-bike-rig bike-second" id="movingBikeRig2">
                <div class="superbike-img-wrap">
                    <div class="bike-headlight"></div>
                    <div class="bike-taillight"></div>
                    <div class="bike-underglow"></div>
                    <div class="bike-nitro-fire"></div>
                    <img src="${pageContext.request.contextPath}/assets/images/foodhouse-future-bike.png" alt="" class="superbike-png">
                </div>
            </div>
        </div>
    </section>

    <!-- ================= 4 SERVICE-BENEFIT CARDS (Ref Match) ================= -->
    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon-box icon-red">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                </svg>
            </div>
            <div>
                <div class="feature-title">30 Mins Delivery</div>
                <div class="feature-desc">Superfast doorstep delivery</div>
            </div>
        </div>

        <div class="feature-card">
            <div class="feature-icon-box icon-green">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                </svg>
            </div>
            <div>
                <div class="feature-title">100% Hygienic</div>
                <div class="feature-desc">Verified kitchen standards</div>
            </div>
        </div>

        <div class="feature-card">
            <div class="feature-icon-box icon-gold">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                    <line x1="7" y1="7" x2="7.01" y2="7"></line>
                </svg>
            </div>
            <div>
                <div class="feature-title">Up to 40% OFF</div>
                <div class="feature-desc">Exclusive app gourmet deals</div>
            </div>
        </div>

        <div class="feature-card">
            <div class="feature-icon-box icon-blue">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                </svg>
            </div>
            <div>
                <div class="feature-title">4.5+ Top Rated</div>
                <div class="feature-desc">Handpicked dining spots</div>
            </div>
        </div>
    </div>

    <!-- ================= CUISINE FILTERS & SECTION HEADER ================= -->
    <section class="filters-section">
        <div class="section-header-row">
            <div>
                <h2 class="section-title">Explore Restaurants</h2>
                <div class="restaurant-counter" id="restaurantCountText">
                    Showing <%= totalCount %> gourmet dining destinations near you
                </div>
            </div>
            
            <div class="city-badge">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                </svg>
                <span>Trending in Bangalore</span>
            </div>
        </div>

        <!-- Interactive Cuisine Filter Pills -->
        <div class="cuisine-pills-bar">
            <button class="cuisine-pill active" onclick="filterCuisine('All', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <rect x="3" y="3" width="7" height="7"></rect>
                    <rect x="14" y="3" width="7" height="7"></rect>
                    <rect x="14" y="14" width="7" height="7"></rect>
                    <rect x="3" y="14" width="7" height="7"></rect>
                </svg>
                <span>All</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('South Indian', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                    <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                </svg>
                <span>South Indian</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('North Indian', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <path d="M8 12h8"></path>
                </svg>
                <span>North Indian</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('Andhra', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 2c5.52 0 10 4.48 10 10s-4.48 10-10 10S2 17.52 2 12 6.48 2 12 2z"></path>
                </svg>
                <span>Andhra Spices</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('Biryani', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                </svg>
                <span>Biryani & Mughlai</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('Chinese', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                </svg>
                <span>Chinese</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('Pizza', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polygon points="12 2 15 12 12 22 9 12"></polygon>
                </svg>
                <span>Pizza & Italian</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('Continental', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                </svg>
                <span>Continental</span>
            </button>
            <button class="cuisine-pill" onclick="filterCuisine('Cafe', this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                    <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                </svg>
                <span>Cafe</span>
            </button>
        </div>
    </section>

    <!-- ================= RESTAURANTS LISTING GRID ================= -->
    <main class="restaurants-section">
        <div class="restaurant-grid" id="restaurantGrid">
            <% 
                if (restaurants != null && !restaurants.isEmpty()) {
                    for (Restaurant r : restaurants) {
                        String name = (r.getName() != null) ? r.getName() : "Gourmet Spot";
                        String cuisine = (r.getCuisineType() != null) ? r.getCuisineType() : "Multi-Cuisine";
                        String address = (r.getAddress() != null) ? r.getAddress() : "Bangalore";
                        double rating = r.getRating();
                        int deliveryTime = (r.getDeliveryTime() > 0) ? r.getDeliveryTime() : 30;
                        boolean isActive = r.isActive();
                        
                        // Curated HD image matching the exact cuisine
                        String imgUrl = getCuratedImage(r);
            %>
                <div class="restaurant-card"
                     data-name="<%= name.toLowerCase() %>"
                     data-cuisine="<%= cuisine.toLowerCase() %>"
                     data-location="<%= address.toLowerCase() %>">
                    
                    <!-- Card Image with Overlays -->
                    <div class="card-img-box">
                        <img src="<%= imgUrl %>" alt="<%= name %>" class="card-img" loading="lazy"
                             onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80';">
                        
                        <% if (rating >= 4.5) { %>
                            <span class="promoted-badge">Featured</span>
                        <% } %>

                        <div class="offer-ribbon">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
                                <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                            </svg>
                            <span>40% OFF UPTO &#8377;80</span>
                        </div>

                        <div class="delivery-time-pill">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span><%= deliveryTime %> mins</span>
                        </div>
                    </div>

                    <!-- Card Body -->
                    <div class="card-body">
                        <div class="card-row-top">
                            <h3 class="card-title" title="<%= name %>"><%= name %></h3>
                            <div class="rating-badge-card <%= (rating < 4.0) ? "amber" : "" %>">
                                <span><%= (rating > 0) ? String.format("%.1f", rating) : "4.2" %></span>
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                            </div>
                        </div>

                        <div class="card-row-mid">
                            <span class="cuisine-badge" title="<%= cuisine %>"><%= cuisine %></span>
                            <span class="price-badge">&#8377;350 for two</span>
                        </div>

                        <div class="card-location">
                            <span>
                                <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor" style="color: var(--primary);">
                                    <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                                </svg>
                                <%= address %>
                            </span>
                            <span>2.4 km</span>
                        </div>

                        <div class="card-footer">
                            <div class="status-indicator <%= isActive ? "open" : "closed" %>">
                                <span class="status-dot"></span>
                                <span><%= isActive ? "Open Now" : "Closed" %></span>
                                <span style="color: var(--text-muted); font-size: 11.5px; font-weight: 600; margin-left: 6px;">• 11:00 AM – 11:00 PM</span>
                            </div>
                        </div>

                        <!-- Distinct Boxed Surrounded View Menu Button -->
                        <div class="card-action-box" style="margin-top: 10px; padding-top: 12px; border-top: 1px solid rgba(255, 255, 255, 0.08);">
                            <a href="menu?restaurantId=<%= r.getRestaurantId() %>" class="btn-view-menu-surrounded" style="width: 100%; display: flex; align-items: center; justify-content: center; gap: 10px; background: linear-gradient(135deg, #ff4b5a 0%, #ff2a3b 100%); color: #ffffff !important; font-size: 14.5px; font-weight: 800; padding: 13px 22px; border-radius: 9999px; border: 1.5px solid rgba(255, 255, 255, 0.35); box-shadow: 0 6px 20px rgba(255, 75, 90, 0.45); text-decoration: none; letter-spacing: 0.3px; box-sizing: border-box;">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                                    <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                                    <line x1="6" y1="1" x2="6" y2="4"></line>
                                    <line x1="10" y1="1" x2="10" y2="4"></line>
                                    <line x1="14" y1="1" x2="14" y2="4"></line>
                                </svg>
                                <span>View Menu & Order</span>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </a>
                        </div>
                    </div>
                </div>
            <% 
                    }
                } else {
            %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: var(--text-secondary);">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 16px;">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <h3>No Restaurants Found</h3>
                    <p>We are expanding rapidly. Check back soon for exciting dining spots!</p>
                </div>
            <% } %>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <p>&copy; 2026 FoodHouse Technologies Pvt Ltd. Midnight Luxury Gourmet Delivery.</p>
    </footer>

    <!-- Client-Side Real-Time Filter & Search JavaScript -->
    <script>
        let currentCuisineFilter = 'All';

        function filterCuisine(cuisine, buttonElement) {
            currentCuisineFilter = cuisine;
            
            // Update active pill styling
            document.querySelectorAll('.cuisine-pill').forEach(btn => btn.classList.remove('active'));
            if (buttonElement) {
                buttonElement.classList.add('active');
            }

            executeFiltering();
        }

        function filterRestaurants() {
            const query = (document.getElementById('searchInput').value || '').trim();
            const heroInput = document.getElementById('heroSearchInput');
            if (heroInput && heroInput.value !== query) {
                heroInput.value = query;
            }
            executeFiltering();
        }

        function syncHeroSearch(query) {
            const mainInput = document.getElementById('searchInput');
            if (mainInput) {
                mainInput.value = query;
            }
            executeFiltering();
        }

        function triggerHeroSearch() {
            const heroInput = document.getElementById('heroSearchInput');
            if (heroInput) {
                syncHeroSearch(heroInput.value);
            }
            const target = document.querySelector('.filters-section');
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        }

        function quickSearch(cuisineName) {
            const heroInput = document.getElementById('heroSearchInput');
            const mainInput = document.getElementById('searchInput');
            if (heroInput) heroInput.value = cuisineName;
            if (mainInput) mainInput.value = cuisineName;
            executeFiltering();
            const target = document.querySelector('.filters-section');
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        }

        let currentLocationFilter = 'All';

        function toggleLocationDropdown(event) {
            if (event) event.stopPropagation();
            const dropdown = document.getElementById('locationDropdown');
            const pill = document.getElementById('heroLocationPill');
            if (!dropdown) return;
            const isOpen = dropdown.classList.toggle('show');
            if (pill) pill.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
        }

        function selectLocation(locKey, locLabel, event) {
            if (event) event.stopPropagation();
            currentLocationFilter = locKey;
            const labelEl = document.getElementById('selectedLocationLabel');
            if (labelEl) labelEl.innerText = locLabel;

            document.querySelectorAll('.location-option').forEach(opt => {
                opt.classList.remove('active');
                if (opt.textContent.includes(locLabel) || (locKey === 'All' && opt.textContent.includes('All Bangalore'))) {
                    opt.classList.add('active');
                }
            });

            const dropdown = document.getElementById('locationDropdown');
            if (dropdown) dropdown.classList.remove('show');
            const pill = document.getElementById('heroLocationPill');
            if (pill) pill.setAttribute('aria-expanded', 'false');

            executeFiltering();

            const target = document.querySelector('.filters-section');
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        }

        document.addEventListener('click', (e) => {
            const dropdown = document.getElementById('locationDropdown');
            const pill = document.getElementById('heroLocationPill');
            if (dropdown && dropdown.classList.contains('show')) {
                if (!dropdown.contains(e.target) && !pill.contains(e.target)) {
                    dropdown.classList.remove('show');
                    if (pill) pill.setAttribute('aria-expanded', 'false');
                }
            }
        });

        function executeFiltering() {
            const query = (document.getElementById('searchInput').value || '').trim().toLowerCase();
            const cards = document.querySelectorAll('.restaurant-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const name = card.getAttribute('data-name') || '';
                const cuisine = card.getAttribute('data-cuisine') || '';
                const location = card.getAttribute('data-location') || '';

                const matchesSearch = !query || name.includes(query) || cuisine.includes(query) || location.includes(query);
                const matchesCuisine = (currentCuisineFilter === 'All') || cuisine.includes(currentCuisineFilter.toLowerCase());
                const matchesLocation = (currentLocationFilter === 'All') || location.includes(currentLocationFilter.toLowerCase());

                if (matchesSearch && matchesCuisine && matchesLocation) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Update counter
            const counterText = document.getElementById('restaurantCountText');
            if (counterText) {
                const locSuffix = (currentLocationFilter === 'All') ? 'near you' : 'in ' + currentLocationFilter;
                counterText.innerText = 'Showing ' + visibleCount + ' gourmet dining destinations ' + locSuffix;
            }
        }

        // Global Dark / Light Mode Toggle Function
        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            const newTheme = (currentTheme === 'dark') ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('foodhouse_theme', newTheme);
        }

        // ====================================================================
        // Interview Features: Interactive Speed Controller & Live Dispatch Feed
        // ====================================================================
        function setBannerSpeed(mode, btnElement) {
            const banner = document.getElementById('heroBannerSection');
            const speedHud = document.getElementById('hudSpeedometer');
            const etaHud = document.getElementById('hudEta');
            
            // Remove previous active button state
            document.querySelectorAll('.speed-chip-btn').forEach(btn => btn.classList.remove('active'));
            if (btnElement) btnElement.classList.add('active');

            if (!banner) return;
            banner.classList.remove('speed-turbo', 'speed-nitro');

            if (mode === 'turbo') {
                banner.classList.add('speed-turbo');
                if (speedHud) speedHud.innerHTML = '<strong>SPEED:</strong> 65 KM/H';
                if (etaHud) etaHud.innerHTML = '<strong>ETA:</strong> 8 MINS ⚡';
            } else if (mode === 'nitro') {
                banner.classList.add('speed-nitro');
                if (speedHud) speedHud.innerHTML = '<strong>SPEED:</strong> 95 KM/H 🔥';
                if (etaHud) etaHud.innerHTML = '<strong>ETA:</strong> 4 MINS 🚀';
            } else {
                if (speedHud) speedHud.innerHTML = '<strong>SPEED:</strong> 40 KM/H';
                if (etaHud) etaHud.innerHTML = '<strong>ETA:</strong> 12 MINS';
            }
        }

        // Cinematic Feature: Bike Races Across the Entire Screen
        function triggerRaceAcross() {
            const rig = document.getElementById('movingBikeRig');
            const banner = document.getElementById('heroBannerSection');
            const speedHud = document.getElementById('hudSpeedometer');
            const etaHud = document.getElementById('hudEta');
            if (!rig) return;

            // Activate nitro flame during race across
            if (banner) banner.classList.add('speed-nitro');
            if (speedHud) speedHud.innerHTML = '<strong>SPEED:</strong> 140 KM/H 🚀';
            if (etaHud) etaHud.innerHTML = '<strong>ETA:</strong> 1 MIN 💨';

            rig.classList.remove('race-active', 'bike-race-across');
            void rig.offsetWidth; // Force CSS reflow
            rig.classList.add('race-active');

            setTimeout(() => {
                rig.classList.remove('race-active', 'bike-race-across');
                const activeBtn = document.querySelector('.speed-chip-btn.active');
                if (activeBtn && activeBtn.id === 'btnNitro') {
                    if (banner) banner.classList.add('speed-nitro');
                    if (speedHud) speedHud.innerHTML = '<strong>SPEED:</strong> 95 KM/H 🔥';
                    if (etaHud) etaHud.innerHTML = '<strong>ETA:</strong> 4 MINS 🚀';
                } else if (activeBtn && activeBtn.id === 'btnTurbo') {
                    if (banner) banner.classList.add('speed-turbo');
                    if (speedHud) speedHud.innerHTML = '<strong>SPEED:</strong> 65 KM/H';
                    if (etaHud) etaHud.innerHTML = '<strong>ETA:</strong> 8 MINS ⚡';
                } else {
                    if (banner) banner.classList.remove('speed-nitro', 'speed-turbo');
                    if (speedHud) speedHud.innerHTML = '<strong>SPEED:</strong> 40 KM/H';
                    if (etaHud) etaHud.innerHTML = '<strong>ETA:</strong> 12 MINS';
                }
            }, 2000);
        }

        // Real-Time Dispatch Ticker Simulated Live Order Stream
        const simulatedOrders = [
            "Order #FH-8942 • Royal Chicken Biryani & Paneer Tikka dispatched to Indiranagar • Rider: Suresh K. (⭐ 4.98) • ETA: 12 mins",
            "Order #FH-8943 • Truffles All-American Burger & Seasoned Fries en route to Koramangala • Rider: Rajesh M. (⭐ 4.96) • ETA: 14 mins",
            "Order #FH-8944 • Woodfired Pepperoni Pizza & Garlic Bread heading to HSR Layout • Rider: Arun V. (⭐ 4.99) • ETA: 16 mins",
            "Order #FH-8945 • Vidyarthi Bhavan Crispy Masala Dosa & Filter Coffee to Jayanagar • Rider: Chetan P. (⭐ 4.97) • ETA: 11 mins",
            "Order #FH-8946 • Dragon Hakka Noodles & Dim Sums dispatched to Whitefield • Rider: Deepa R. (⭐ 4.98) • ETA: 15 mins"
        ];
        let currentTickerIndex = 0;

        setInterval(() => {
            const tickerEl = document.getElementById('liveTickerText');
            if (tickerEl) {
                tickerEl.style.opacity = '0';
                setTimeout(() => {
                    currentTickerIndex = (currentTickerIndex + 1) % simulatedOrders.length;
                    tickerEl.innerText = simulatedOrders[currentTickerIndex];
                    tickerEl.style.opacity = '1';
                }, 350);
            }
        }, 4500);
    </script>

</body>
</html>