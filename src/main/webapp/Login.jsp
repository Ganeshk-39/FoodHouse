<%-- 
    ========================================================================
    FILE: Login.jsp
    PROJECT: FoodHouse
    DESCRIPTION: Unified 1-Page Authentication Portal (Sign In & Sign Up).
                 Features dual interactive tabs for Sign In and Register on 
                 the same single page, 1-click demo logins, glowing inputs, 
                 inline SVGs, and instant Dark / Light mode switching.
    ========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHouse | Sign In & Register</title>
    
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
           1. CSS Design Tokens - Midnight Luxury & Soft Daylight Modes
           ==================================================================== */
        :root {
            --bg-body: #0a0e17;
            --bg-card: rgba(17, 24, 39, 0.92);
            --bg-glass: rgba(15, 23, 42, 0.85);
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 75, 90, 0.45);
            
            --primary: #ff4b5a;
            --primary-hover: #ff2a3b;
            --primary-glow: rgba(255, 75, 90, 0.38);
            --primary-light: rgba(255, 75, 90, 0.12);
            
            --accent-gold: #fbbf24;
            --accent-green: #10b981;
            --accent-blue: #38bdf8;
            
            --text-main: #ffffff;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            
            --radius-xl: 24px;
            --radius-lg: 16px;
            --radius-md: 10px;
            --radius-pill: 9999px;
            
            --transition: all 0.28s cubic-bezier(0.16, 1, 0.3, 1);
        }

        /* Light Theme Overrides */
        [data-theme="light"] {
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --bg-glass: rgba(255, 255, 255, 0.94);
            --border-subtle: rgba(15, 23, 42, 0.08);
            --border-hover: rgba(255, 75, 90, 0.5);
            
            --text-main: #0f172a;
            --text-secondary: #475569;
            --text-muted: #64748b;
        }

        [data-theme="light"] body {
            background-color: #f8fafc;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.06) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.05) 0px, transparent 50%),
                radial-gradient(at 50% 50%, rgba(16, 185, 129, 0.03) 0px, transparent 60%);
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

        [data-theme="light"] .auth-card {
            background: #ffffff;
            border-color: rgba(0, 0, 0, 0.08);
            box-shadow: 0 25px 60px rgba(15, 23, 42, 0.08);
        }

        [data-theme="light"] .auth-title,
        [data-theme="light"] .form-label {
            color: #0f172a !important;
        }

        [data-theme="light"] .form-input {
            background: #f8fafc;
            color: #0f172a;
            border-color: rgba(0, 0, 0, 0.14);
        }

        [data-theme="light"] .form-input:focus {
            background: #ffffff;
            border-color: var(--primary);
        }

        [data-theme="light"] .auth-tabs {
            background: #f1f5f9;
            border-color: rgba(0, 0, 0, 0.06);
        }

        [data-theme="light"] .auth-tab-btn {
            color: #64748b;
        }

        [data-theme="light"] .auth-tab-btn.active {
            background: #ffffff;
            color: var(--primary);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
        }

        [data-theme="light"] .demo-chip-btn {
            background: rgba(0, 0, 0, 0.04);
            border-color: rgba(0, 0, 0, 0.12);
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
                radial-gradient(at 0% 0%, rgba(255, 75, 90, 0.12) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.08) 0px, transparent 50%),
                radial-gradient(at 50% 50%, rgba(16, 185, 129, 0.04) 0px, transparent 60%);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        /* ================= NAVBAR ================= */
        .navbar {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(10, 14, 23, 0.85);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border-subtle);
            padding: 14px 24px;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: var(--text-main);
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand-logo span {
            color: var(--primary);
        }

        .brand-logo-icon {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), #e11d48);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .nav-right-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            border: 1px solid var(--border-subtle);
            background: rgba(255, 255, 255, 0.03);
            transition: var(--transition);
        }

        .back-link:hover {
            color: var(--text-main);
            border-color: var(--border-hover);
            background: var(--primary-light);
        }

        /* ================= 1-PAGE AUTH CONTAINER ================= */
        .auth-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .auth-card {
            width: 100%;
            max-width: 480px;
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 34px 30px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.35);
            backdrop-filter: blur(12px);
            position: relative;
            overflow: hidden;
            animation: cardAppear 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes cardAppear {
            from { opacity: 0; transform: translateY(16px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .auth-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--accent-gold), var(--accent-green));
        }

        /* Dual Tabs */
        .auth-tabs {
            display: flex;
            background: rgba(0, 0, 0, 0.28);
            padding: 4px;
            border-radius: var(--radius-pill);
            border: 1px solid var(--border-subtle);
            margin-bottom: 24px;
        }

        .auth-tab-btn {
            flex: 1;
            padding: 10px 14px;
            border: none;
            background: transparent;
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 700;
            border-radius: var(--radius-pill);
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .auth-tab-btn.active {
            background: linear-gradient(135deg, var(--primary), #e11d48);
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-glow);
        }

        .auth-header {
            text-align: center;
            margin-bottom: 22px;
        }

        .user-icon-avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: var(--primary-light);
            color: var(--primary);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
            border: 1.5px solid var(--border-hover);
        }

        .auth-title {
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 4px;
            color: var(--text-main);
        }

        .auth-subtitle {
            font-size: 13px;
            color: var(--text-secondary);
            line-height: 1.5;
        }

        /* Error Banner */
        .error-alert {
            display: flex;
            align-items: center;
            gap: 12px;
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #ef4444;
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 20px;
            animation: shake 0.35s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-4px); }
            75% { transform: translateX(4px); }
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 16px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        @media (max-width: 480px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #e2e8f0;
            margin-bottom: 6px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 14px;
            color: var(--text-muted);
            pointer-events: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-input {
            width: 100%;
            background: rgba(255, 255, 255, 0.04);
            border: 1.5px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 11px 14px 11px 42px;
            color: var(--text-main);
            font-size: 14px;
            font-weight: 500;
            outline: none;
            transition: var(--transition);
        }

        .form-input:focus {
            background: rgba(255, 255, 255, 0.07);
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        .toggle-password-btn {
            position: absolute;
            right: 12px;
            background: transparent;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }

        .toggle-password-btn:hover {
            color: var(--text-main);
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, var(--primary), #e11d48);
            border: none;
            border-radius: var(--radius-md);
            color: #ffffff;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.2px;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 4px 16px var(--primary-glow);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 8px;
        }

        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(255, 75, 90, 0.5);
            background: linear-gradient(135deg, var(--primary-hover), #be123c);
        }

        .btn-submit.btn-green {
            background: linear-gradient(135deg, #10b981, #059669);
            box-shadow: 0 4px 16px rgba(16, 185, 129, 0.35);
        }

        .btn-submit.btn-green:hover {
            background: linear-gradient(135deg, #059669, #047857);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.5);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        /* Demo Quick Accounts */
        .demo-box {
            margin-top: 18px;
            padding: 12px;
            background: rgba(251, 191, 36, 0.07);
            border: 1px dashed rgba(251, 191, 36, 0.3);
            border-radius: var(--radius-md);
            text-align: center;
        }

        .demo-title {
            font-size: 11px;
            color: var(--accent-gold);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .demo-chips {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .demo-chip-btn {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-subtle);
            color: var(--accent-gold);
            font-size: 12px;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: var(--radius-pill);
            cursor: pointer;
            transition: var(--transition);
        }

        .demo-chip-btn:hover {
            background: rgba(251, 191, 36, 0.18);
            border-color: rgba(251, 191, 36, 0.4);
            transform: translateY(-1px);
        }

        /* Sections */
        .auth-section {
            display: none;
            animation: fadeIn 0.25s ease-out;
        }

        .auth-section.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
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
                <a href="restaurant" class="back-link">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M19 12H5M12 19l-7-7 7-7"/>
                    </svg>
                    <span>Restaurants</span>
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

    <!-- ================= 1-PAGE UNIFIED AUTH CARD ================= -->
    <main class="auth-wrapper">
        <div class="auth-card">
            
            <!-- Dual Interactive Tabs on Single Page -->
            <div class="auth-tabs">
                <button type="button" class="auth-tab-btn active" id="tabSignInBtn" onclick="switchAuthTab('signin')">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                        <polyline points="10 17 15 12 10 7"></polyline>
                        <line x1="15" y1="12" x2="3" y2="12"></line>
                    </svg>
                    <span>Sign In</span>
                </button>
                <button type="button" class="auth-tab-btn" id="tabRegisterBtn" onclick="switchAuthTab('register')">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="8.5" cy="7" r="4"></circle>
                        <line x1="20" y1="8" x2="20" y2="14"></line>
                        <line x1="23" y1="11" x2="17" y2="11"></line>
                    </svg>
                    <span>Register</span>
                </button>
            </div>

            <!-- Error Banner -->
            <% 
               String errorMsg = (String) request.getAttribute("loginErrorMessage");
               if (errorMsg == null) {
                   errorMsg = (String) request.getAttribute("errorMessage");
               }
               if (errorMsg != null && !errorMsg.trim().isEmpty()) { 
            %>
                <div class="error-alert">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span><%= errorMsg %></span>
                </div>
            <% } %>

            <!-- ================= TAB 1: SIGN IN ================= -->
            <div id="signInSection" class="auth-section active">
                <div class="auth-header">
                    <div class="user-icon-avatar">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </div>
                    <h1 class="auth-title">Welcome Back</h1>
                    <p class="auth-subtitle">Sign in with your email and password</p>
                </div>

                <form action="login" method="post">
                    <input type="hidden" name="redirect" value="<%= (request.getParameter("redirect") != null ? request.getParameter("redirect") : "") %>">
                    <div class="form-group">
                        <label class="form-label" for="loginEmail">Email Address</label>
                        <div class="input-wrapper">
                            <span class="input-icon">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                    <polyline points="22,6 12,13 2,6"></polyline>
                                </svg>
                            </span>
                            <input type="email" id="loginEmail" name="email" class="form-input" 
                                   placeholder="e.g. arjun@gmail.com" required autocomplete="email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="loginPassword">Password</label>
                        <div class="input-wrapper">
                            <span class="input-icon">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                            </span>
                            <input type="password" id="loginPassword" name="password" class="form-input" 
                                   placeholder="••••••••" required autocomplete="current-password">
                            <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility('loginPassword', this)" title="Show / Hide Password">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit" id="btnSignInSubmit">
                        <span>Sign In</span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </button>
                </form>

                <!-- Quick 1-Click Role Accounts -->
                <div class="demo-box">
                    <div class="demo-title">&#9889; Quick 1-Click Role Accounts (For Review & Testing)</div>
                    <div class="demo-chips" style="display:flex; flex-wrap:wrap; gap:8px;">
                        <button type="button" class="demo-chip-btn" onclick="fillDemo('arjun@gmail.com', 'arjun123')">Customer (Arjun)</button>
                        <button type="button" class="demo-chip-btn" onclick="fillDemo('admin@foodhouse.com', 'Admin@123')">Restaurant Admin</button>
                        <a href="restaurant-admin?demo=true" class="demo-chip-btn" style="text-decoration:none; display:inline-flex; align-items:center; background:rgba(251,191,36,0.18); color:var(--accent-gold); border:1px solid rgba(251,191,36,0.45); font-weight:800;">
                            &#127860; Admin Portal
                        </a>
                        <a href="delivery-admin?demo=true" class="demo-chip-btn" style="text-decoration:none; display:inline-flex; align-items:center; background:rgba(56,189,248,0.18); color:var(--accent-blue); border:1px solid rgba(56,189,248,0.45); font-weight:800;">
                            &#128693; Delivery Portal
                        </a>
                    </div>
                </div>
            </div>

            <!-- ================= TAB 2: REGISTER ================= -->
            <div id="registerSection" class="auth-section">
                <div class="auth-header">
                    <div class="user-icon-avatar" style="background: rgba(16, 185, 129, 0.12); color: var(--accent-green); border-color: rgba(16, 185, 129, 0.4);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="8.5" cy="7" r="4"></circle>
                            <line x1="20" y1="8" x2="20" y2="14"></line>
                            <line x1="23" y1="11" x2="17" y2="11"></line>
                        </svg>
                    </div>
                    <h1 class="auth-title">Create Account</h1>
                    <p class="auth-subtitle">Join FoodHouse for instant orders & live delivery tracking</p>
                </div>

                <form action="register" method="post">
                    <input type="hidden" name="redirect" value="<%= (request.getParameter("redirect") != null ? request.getParameter("redirect") : "") %>">
                    <div class="form-group">
                        <label class="form-label" for="regUsername">Full Name</label>
                        <div class="input-wrapper">
                            <span class="input-icon">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                            </span>
                            <input type="text" id="regUsername" name="username" class="form-input" 
                                   placeholder="e.g. Arjun Dev" required autocomplete="name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regEmail">Email Address</label>
                        <div class="input-wrapper">
                            <span class="input-icon">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                    <polyline points="22,6 12,13 2,6"></polyline>
                                </svg>
                            </span>
                            <input type="email" id="regEmail" name="email" class="form-input" 
                                   placeholder="e.g. arjun@gmail.com" required autocomplete="email">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="regPassword">Password</label>
                            <div class="input-wrapper">
                                <span class="input-icon">
                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                </span>
                                <input type="password" id="regPassword" name="password" class="form-input" 
                                       placeholder="••••••••" required autocomplete="new-password">
                                <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility('regPassword', this)" title="Show / Hide Password">
                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="8" r="3"></circle>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="regPhone">Phone</label>
                            <div class="input-wrapper">
                                <span class="input-icon">
                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                    </svg>
                                </span>
                                <input type="tel" id="regPhone" name="phone" class="form-input" 
                                       placeholder="9876543210" autocomplete="tel">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="regAddress">Address</label>
                        <div class="input-wrapper">
                            <span class="input-icon">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                            </span>
                            <input type="text" id="regAddress" name="address" class="form-input" 
                                   placeholder="Indiranagar, Bangalore" autocomplete="street-address">
                        </div>
                    </div>

                    <button type="submit" class="btn-submit btn-green" id="btnRegSubmit">
                        <span>Create Account & Sign In</span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </button>
                </form>
            </div>

        </div>
    </main>

    <script>
        function switchAuthTab(tab) {
            var signInSection = document.getElementById('signInSection');
            var registerSection = document.getElementById('registerSection');
            var tabSignInBtn = document.getElementById('tabSignInBtn');
            var tabRegisterBtn = document.getElementById('tabRegisterBtn');

            if (tab === 'register') {
                signInSection.classList.remove('active');
                registerSection.classList.add('active');
                tabSignInBtn.classList.remove('active');
                tabRegisterBtn.classList.add('active');
            } else {
                registerSection.classList.remove('active');
                signInSection.classList.add('active');
                tabRegisterBtn.classList.remove('active');
                tabSignInBtn.classList.add('active');
            }
        }

        function togglePasswordVisibility(inputId, btn) {
            var input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
                btn.style.color = "var(--primary)";
            } else {
                input.type = "password";
                btn.style.color = "var(--text-muted)";
            }
        }

        function fillDemo(email, pass) {
            document.getElementById('loginEmail').value = email;
            document.getElementById('loginPassword').value = pass;
        }

        function toggleTheme() {
            var currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            var newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('foodhouse_theme', newTheme);
        }

        // Check if URL has tab=register
        (function() {
            var urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('tab') === 'register') {
                switchAuthTab('register');
            }
        })();
    </script>
</body>
</html>
