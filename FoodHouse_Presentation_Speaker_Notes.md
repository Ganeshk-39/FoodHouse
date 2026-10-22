# 🎙️ FOODHOUSE — TAP ACADEMY PROJECT PRESENTATION
## Complete Slide-by-Slide Speaking Script & Evaluation Defense Guide

* **Project**: FoodHouse (Online Food Ordering & Delivery Web Application)
* **Candidate**: Ganesh K (`Ganeshk-39`)
* **Technology Stack**: Java 21 LTS • Jakarta Servlets 6.0 • JSP 2.3 • MySQL 8.0 • Apache Tomcat 10.1 • Eclipse IDE
* **Presentation Mode**: 16:9 Widescreen • 14 Slides
* **Strict Speaking Target**: 4 Minutes 15 Seconds (Safe buffer within the mandatory 5-minute limit)

---

## ⏱️ STRICT TIMING ALLOCATION

| Slide | TAP Section | Topic | Target Time | Cumulative Time |
| :---: | :--- | :--- | :---: | :---: |
| **01** | Section 1 | Project Introduction | 10 sec | 0:10 |
| **02** | Section 2 | Technology Stack | 15 sec | 0:25 |
| **03** | Section 3 | Project Structure (Eclipse Workspace) | 15 sec | 0:40 |
| **04** | Section 4 | ER Diagram (5 Relational Tables) | 15 sec | 0:55 |
| **05** | Section 5 (1/6) | Page 1: Home & Restaurant Discovery | 13 sec | 1:08 |
| **06** | Section 5 (2/6) | Page 2: Unified Auth (Login & Register) | 13 sec | 1:21 |
| **07** | Section 5 (3/6) | Page 3: Restaurant Menu Page | 13 sec | 1:34 |
| **08** | Section 5 (4/6) | Page 4: Shopping Cart & Calculations | 13 sec | 1:47 |
| **09** | Section 5 (5/6) | Page 5: Checkout & Payment Mode | 13 sec | 2:00 |
| **10** | Section 5 (6/6) | Page 6: Order History & Real-Time Tracking | 15 sec | 2:15 |
| **11** | Section 6 | New Features Added (FSM, BCrypt, Theme) | 35 sec | 2:50 |
| **12** | Section 7 | Important Algorithm (OrderLifecycleManager FSM) | 35 sec | 3:25 |
| **13** | Section 8 | Major Challenge Faced (Scroll Jump Fix) | 35 sec | 4:00 |
| **14** | Section 9 | What I'll Add Next (Roadmap) | 15 sec | **4:15** |

---

## 🗣️ SLIDE-BY-SLIDE VERBATIM SPEAKING SCRIPT

### SLIDE 1: SECTION 1 — PROJECT INTRODUCTION (0:00 – 0:10)
> *"Good morning respected evaluators. My project is **FoodHouse**, an enterprise food ordering and delivery web application developed using pure Core Java, Jakarta Servlets, JSP, and MySQL. It enables Bangalore food lovers to discover 30 curated dining spots, explore 360 photo-accurate dishes, manage real-time shopping carts, and track their food orders through dynamic live lifecycle tracking."*

### SLIDE 2: SECTION 2 — TECH STACK (0:10 – 0:25)
> *"For the technology stack, I strictly followed enterprise standards without external frameworks. The backend is built using **Java 21 LTS** and **Jakarta Servlets 6.0** running on **Apache Tomcat 10.1**. The database layer uses **MySQL 8.0** with **JDBC PreparedStatements** and atomic transactions. For security, I integrated **jBCrypt** password hashing. The frontend is powered by dynamic JSP, CSS glassmorphism, and vanilla JavaScript."*

### SLIDE 3: SECTION 3 — PROJECT STRUCTURE (0:25 – 0:40)
> *"This is the authentic Eclipse Dynamic Web Project structure. Following the MVC architecture, `com.tap.controller` contains 14 Servlets orchestrating HTTP requests; `com.tap.model` holds 7 POJO entities; `com.tap.DAO` and `DAOImpl` implement decoupled persistence; and `com.tap.util` houses our database connection and order lifecycle engines. All JSPs, CSS, and `web.xml` are organized cleanly under `src/main/webapp`."*

### SLIDE 4: SECTION 4 — ER DIAGRAM (0:40 – 0:55)
> *"Our database architecture consists of five normalized relational tables in MySQL. The `user` table stores registered customers. The `restaurant` table stores 30 outlets. The `menu` table contains 360 dishes mapped via `restaurantId` foreign keys. Placing an order writes a parent record to `orders`, which branches into multiple `order_item` rows capturing dish quantities and line totals, all protected with cascading delete constraints."*

### SLIDE 5: SECTION 5 — HOME & RESTAURANT DISCOVERY (0:55 – 1:08)
> *"Entering the application, this is `Restaurant.jsp`, our discovery catalog. It showcases Bangalore restaurants like Meghana Foods and Truffles with live ratings, cuisine tags, and delivery times. Users can filter by location, search dishes by keyword, and adjust delivery velocity with real-time ETA recalculations."*

### SLIDE 6: SECTION 5 — UNIFIED AUTHENTICATION PORTAL (1:08 – 1:21)
> *"Next is our unified Authentication portal. Both Login and Registration are combined into a clean, tabbed interface. `LoginController` and `RegisterController` hash and verify user passwords using salted BCrypt. Upon successful authentication, an active `HttpSession` is created to maintain session state throughout checkout."*

### SLIDE 7: SECTION 5 — RESTAURANT MENU PAGE (1:21 – 1:34)
> *"When a user selects a restaurant, `MenuController` loads `Menu.jsp`. Here you see Meghana Foods featuring 12 curated dishes with accurate photography, veg/non-veg indicators, and pricing. Users can add items via asynchronous AJAX steppers without causing page reloads or scroll jumps."*

### SLIDE 8: SECTION 5 — SHOPPING CART PAGE (1:34 – 1:47)
> *"In `Cart.jsp`, our `Cart.java` model computes item subtotals, packaging charges, delivery fees, and taxes dynamically. Users can increment, decrement, or remove items with instant total updates. Cart items remain stored in the user session so no items are lost during browsing."*

### SLIDE 9: SECTION 5 — CHECKOUT & PAYMENT (1:47 – 2:00)
> *"On the Checkout page, users confirm their delivery address and select from multiple payment modes including Cash on Delivery, UPI, Cards, and NetBanking. Clicking Place Order triggers `OrderController`, which writes to both `orders` and `order_item` tables within an atomic database transaction."*

### SLIDE 10: SECTION 5 — ORDER HISTORY & TRACKING (2:00 – 2:15)
> *"Finally, `OrderHistory.jsp` provides real-time status tracking. Driven by `OrderLifecycleManager`, orders dynamically progress through five stages: Confirmed, Kitchen Accepted, Food Ready, On The Way, and Delivered, giving customers full visibility into their food preparation."*

### SLIDE 11: SECTION 6 — NEW FEATURES ADDED (2:15 – 2:50)
> *"Beyond the standard requirements, I added four key innovations: First, a background **Order Lifecycle Finite State Machine** that simulates real kitchen and delivery timelines. Second, **enterprise BCrypt password hashing** for complete database credential security. Third, **zero-jump asynchronous menu steppers** that preserve the user's exact scroll position. And fourth, a **dual Dark/Light mode theme engine** with glassmorphic styling."*

### SLIDE 12: SECTION 7 — IMPORTANT ALGORITHMS (2:50 – 3:25)
> *"Our core algorithm is the `OrderLifecycleManager` Finite State Machine. It accepts the order timestamp as input, computes elapsed time, and compares it against configurable threshold stages—2 minutes for Kitchen Acceptance, 5 minutes for Food Ready, 10 minutes for Dispatch, and 20 minutes for Delivery. It strictly enforces forward-only progression so terminal states like Delivered cannot regress, and persists updates atomically via PreparedStatement queries."*

### SLIDE 13: SECTION 8 — MAJOR CHALLENGE FACED (3:25 – 4:00)
> *"The most significant engineering challenge I solved was viewport scroll disorientation. On lengthy menus, clicking Add triggered standard form submissions, reloading the page and resetting the scroll to zero. The root cause was default browser unload behavior on POST forms. I solved this by implementing asynchronous fetch dispatch with scroll-anchor retention. I also resolved plain-text database security by building `EncryptExistingUsers.java` to auto-migrate legacy seeds to BCrypt. We validated the fix using automated Microsoft Edge CDP test suites."*

### SLIDE 14: SECTION 9 — WHAT I'LL ADD NEXT (4:00 – 4:15)
> *"Looking forward, I have four realistic enhancements planned: first, integrating live payments via Razorpay; second, real-time GPS map tracking with Google Maps API; third, automated SMS and WhatsApp delivery alerts via Twilio; and fourth, a restaurant management analytics dashboard with revenue charts. Thank you, I am now ready for your questions."*

---

## 🎯 DEFENSE PREPARATION: ANTICIPATED PANEL QUESTIONS & BULLETPROOF ANSWERS

### Q1: Why did you build this with pure Servlets and JDBC instead of Spring Boot and Hibernate?
* **Answer**: *"Building with pure Servlets and JDBC demonstrates complete, low-level mastery of fundamental Java Web architecture. I managed the HTTP servlet lifecycle, request dispatching, session cookies, database connection pooling, and explicit SQL query tuning. Understanding these core mechanics from scratch makes adopting Spring Boot or Hibernate intuitive, whereas relying solely on frameworks masks fundamental concepts."*

### Q2: How did you safeguard FoodHouse against SQL Injection?
* **Answer**: *"Every database query across `UserDAOImpl`, `RestaurantDAOImpl`, `MenuDAOImpl`, and `OrderDAOImpl` strictly utilizes `java.sql.PreparedStatement` with parameterized placeholders (`?`). The database pre-compiles the SQL syntax before parameters are bound, ensuring user input is treated exclusively as literal data and never executed as SQL commands."*

### Q3: How does your Finite State Machine prevent order state regression?
* **Answer**: *"In `OrderLifecycleManager.java`, statuses are mapped to discrete, ordered integers: Confirmed is 1, Accepted is 2, Food Ready is 3, On The Way is 4, and Delivered is 5. State transitions only occur if the newly computed stage number is strictly greater than the current stage number. Furthermore, terminal states like Delivered, Cancelled, or Refunded bypass timer re-evaluation entirely."*

### Q4: How do you prevent database connection leaks in Tomcat?
* **Answer**: *"All database operations employ Java 7+ `try-with-resources` blocks encompassing `Connection`, `PreparedStatement`, and `ResultSet`. Even when a runtime exception or network disconnection occurs, the JVM automatically invokes `.close()` on all opened database resources in reverse creation order, completely preventing unreleased connections in the Tomcat pool."*

### Q5: How did you handle user password security and legacy migration?
* **Answer**: *"I integrated `jBCrypt-0.4.jar` using standard Blowfish cryptographic hashing. During registration, `BCrypt.hashpw(password, BCrypt.gensalt())` generates a unique salt per password. For legacy test accounts, I built `EncryptExistingUsers.java` which queries the database, detects un-hashed passwords (those not starting with `$2a$`), and updates them in-place with salted hashes."*
