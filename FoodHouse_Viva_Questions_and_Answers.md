# 🎓 FOODHOUSE — TAP ACADEMY VIVA PREPARATION GUIDE
## 17 Rigorous Technical Questions & Evidence-Based Answers for Evaluation Panel

* **Candidate**: Ganesh K (`Ganeshk-39`)
* **Project**: FoodHouse
* **Stack**: Core Java 21 LTS • Jakarta Servlets 6.0 • JSP 2.3 • MySQL 8.0 • Apache Tomcat 10.1 • Eclipse IDE

---

### Q1: Why did you choose pure Core Java and Jakarta Servlets instead of Spring Boot?
* **Answer**: *"Choosing pure Core Java and Jakarta Servlets on Apache Tomcat 10.1 demonstrates an authentic, foundational understanding of Java Web architecture. It requires manual handling of the HTTP request-response lifecycle, servlet threading, web.xml routing, request dispatching, session cookies, and connection management. While Spring Boot automates these with annotations, building from fundamentals proves I understand what happens under the hood before adopting high-level abstractions."*

---

### Q2: What is the role of JSP in FoodHouse, and how does it interact with Servlets?
* **Answer**: *"JSP (JavaServer Pages) acts strictly as the View layer in our MVC architecture. Servlets (e.g., `RestaurantController`, `MenuController`) process incoming business logic, fetch data from DAOs, and attach the resulting Model objects as request attributes using `request.setAttribute("restaurantList", list)`. The Servlet then forwards to the JSP using `RequestDispatcher.forward(req, resp)`. The JSP renders the HTML dynamically using Expression Language (EL) and JSTL, ensuring clean separation between business logic and presentation."*

---

### Q3: What is the DAO (Data Access Object) design pattern, and why is it implemented?
* **Answer**: *"The DAO pattern creates an abstraction layer between business logic and the underlying persistence storage. In FoodHouse, interfaces like `UserDAO`, `RestaurantDAO`, `MenuDAO`, and `OrderDAO` declare contract methods (e.g., `getMenuByRestaurantId`, `addOrder`). Their implementations (`UserDAOImpl`, `OrderDAOImpl`) encapsulate all JDBC connections, SQL syntax, and ResultSet parsing. If the database schema or storage engine changes, only the DAOImpl changes, leaving controllers completely unaffected."*

---

### Q4: How does JDBC connectivity work in your DBConnection utility?
* **Answer**: *"Our `DBConnection.java` loads the MySQL 8.0 driver (`com.mysql.cj.jdbc.Driver`) using `Class.forName()`. It retrieves a database connection from `DriverManager.getConnection()` using configurable environment variables (`DB_URL`, `DB_USER`, `DB_PASSWORD`) with fallbacks to local defaults. All DAO implementations invoke `DBConnection.getConnection()` inside `try-with-resources` blocks to guarantee that connections are closed immediately after query execution."*

---

### Q5: What is the difference between Statement and PreparedStatement, and which one did you use?
* **Answer**: *"FoodHouse exclusively uses `PreparedStatement`. A standard Statement compiles SQL on every execution and concatenates raw user strings, making it vulnerable to SQL injection. PreparedStatement pre-compiles the SQL command structure once on the database server and accepts user inputs via parameterized placeholders (`?`). The database engine treats parameters strictly as literal values, completely neutralizing SQL injection risks and improving query caching performance."*

---

### Q6: Explain the Primary Keys and Foreign Keys across your 5 database tables.
* **Answer**: *"FoodHouse has 5 normalized relational tables in MySQL:*
* *`user`: `userId` is the Primary Key (PK, AUTO_INCREMENT).*
* *`restaurant`: `restaurantId` is PK; `adminUserId` is a Foreign Key (FK) referencing `user(userId)`.*
* *`menu`: `menuId` is PK; `restaurantId` is FK referencing `restaurant(restaurantId)` with `ON DELETE CASCADE`.*
* *`orders`: `orderId` is PK; `userId` and `restaurantId` are FKs referencing `user` and `restaurant` respectively with `ON DELETE CASCADE`.*
* *`order_item`: `orderItemId` is PK; `orderId` is FK referencing `orders(orderId)` and `menuId` is FK referencing `menu(menuId)`, both with `ON DELETE CASCADE`.*

---

### Q7: How does restaurant-specific menu retrieval work in MenuController and MenuDAOImpl?
* **Answer**: *"When a customer clicks a restaurant card, the URL passes the query parameter `?restaurantId=1`. `MenuController` reads `req.getParameter("restaurantId")`, validates it, and calls `MenuDAOImpl.getMenuByRestaurantId(int id)`. The DAO executes: `SELECT * FROM menu WHERE restaurantId = ? AND isAvailable = TRUE` using PreparedStatement. It iterates through the ResultSet, instantiates Menu model objects, populates a `List<Menu>`, and forwards it to `Menu.jsp`."*

---

### Q8: How does the Shopping Cart calculation algorithm work in Cart.java?
* **Answer**: *"`Cart.java` maintains a `Map<Integer, CartItem>` where the key is the `menuId`. When an item is added or quantity incremented, it updates the quantity and computes the line item total: `itemTotal = dishPrice * quantity`. The cart's `getSubtotal()` method sums all item totals. On the Cart page, delivery fees, packaging charges, and GST (5%) are computed dynamically, producing the final grand total without floating-point precision loss."*

---

### Q9: How are orders and itemized dishes stored during Checkout?
* **Answer**: *"When a user places an order on `Checkout.jsp`, `OrderController` receives the user's delivery address, payment mode, and active Cart from the session. Inside `OrderDAOImpl`, an atomic transaction is executed: it inserts the primary order record into the `orders` table and retrieves the generated `orderId` using `Statement.RETURN_GENERATED_KEYS`. It then batch-inserts every item from the cart into `order_item` mapped to that generated `orderId`. If any insert fails, the transaction is rolled back, preventing orphaned records."*

---

### Q10: How is user session management handled across the application?
* **Answer**: *"Session management uses Jakarta's HttpSession API (`request.getSession()`). Upon successful login via `LoginController`, the authenticated User object is stored in the session under `session.setAttribute("loggedInUser", user)`. Protected routes like checkout, order history, and profile check if `session.getAttribute("loggedInUser") != null`; if null, they redirect to `Login.jsp`. Similarly, Cart is stored in the session, allowing items to persist as the user navigates across different restaurant menus."*

---

### Q11: What security measures are genuinely implemented in FoodHouse?
* **Answer**: *"Three verified security measures are implemented:*
1. *BCrypt Password Hashing: Using `jBCrypt-0.4.jar`, passwords are never stored in plain text. Registration uses `BCrypt.hashpw(pass, BCrypt.gensalt(12))`, generating a salted Blowfish hash. Login checks passwords via `BCrypt.checkpw()`.*
2. *SQL Injection Prevention: Universal usage of `PreparedStatement` with parameterized queries across all 5 DAO classes.*
3. *Session Hijacking & Tampering Defense: Session validation on state-modifying actions, preventing unauthorized users from placing orders on behalf of others."*

---

### Q12: How does the OrderLifecycleManager Finite State Machine work?
* **Answer**: *"`OrderLifecycleManager` in `com.tap.util` dynamically simulates real-world food preparation and delivery. It calculates elapsed time from the order's `orderDate` timestamp. Milestones: <2 mins = Confirmed; >=2 mins = Accepted; >=5 mins = Food Ready; >=10 mins = On The Way; >=20 mins = Delivered. It strictly enforces monotonic forward progression (stage 1 through 5), ensuring terminal states (Delivered, Cancelled) cannot be rolled back, and updates the database via `OrderDAOImpl`."*

---

### Q13: What was the biggest development challenge you faced, and how did you resolve it?
* **Answer**: *"The biggest challenge was viewport scroll disorientation on the Menu page. In early development, clicking '+ ADD' submitted a standard JSP POST form, which reloaded the page and jumped the viewport scroll to top (`scrollY = 0`). This ruined the user experience on long menus. I solved it by implementing asynchronous `fetch()` JavaScript dispatch with scroll-anchor retention and instant DOM quantity toggles. I validated the solution using automated Microsoft Edge CDP scripts, confirming scroll deviation was under 20 pixels."*

---

### Q14: What is the difference between RequestDispatcher.forward() and HttpServletResponse.sendRedirect()?
* **Answer**: *"`RequestDispatcher.forward()` is a server-side forward. The URL in the browser does not change, request attributes are preserved, and only one HTTP request/response cycle occurs. In contrast, `response.sendRedirect()` is a client-side redirect. The server sends an HTTP 302 response with a Location header, instructing the browser to initiate a brand-new GET request. Request attributes are lost unless saved in `HttpSession`. FoodHouse uses `forward()` to display JSP views with request data, and `sendRedirect()` after successful POST actions (Post/Redirect/Get pattern) to prevent duplicate form submissions."*

---

### Q15: How do you prevent database connection leaks in Apache Tomcat?
* **Answer**: *"Every database connection, PreparedStatement, and ResultSet in our DAO implementation layer is declared within Java 7+ `try-with-resources` blocks. Because `Connection`, `PreparedStatement`, and `ResultSet` all implement `java.lang.AutoCloseable`, the Java runtime guarantees that `.close()` is called automatically when execution exits the try block—even in the event of SQLExceptions or unexpected runtime errors. This prevents connection starvation in Tomcat's thread pool."*

---

### Q16: Why is BCrypt superior to MD5 or SHA-256 for password hashing?
* **Answer**: *"MD5 and SHA-256 are general-purpose cryptographic hash algorithms designed to be extremely fast. Because they are fast, attackers using modern GPUs can compute billions of guesses per second using rainbow tables and brute force. BCrypt is an adaptive key-derivation function based on the Blowfish cipher. It incorporates a random salt to defeat rainbow tables and has a configurable work factor (cost parameter) that deliberately slows down hash computation, making offline brute-force attacks computationally infeasible."*

---

### Q17: What are the next technical enhancements you plan to add to FoodHouse?
* **Answer**: *"My roadmap includes:*
1. *Live Payment Gateway: Integrating the Razorpay Java SDK for webhook-driven UPI intent and card verification.*
2. *Real-time GPS Tracking: Visualizing live rider coordinates on an interactive Google Maps/Mapbox interface.*
3. *Twilio SMS Alerts: Sending automated delivery dispatch SMS and OTP verification on doorstep handover.*
4. *Administrative Analytics: Providing restaurant managers with revenue graphs, top-selling dish heatmaps, and peak dining hour trends."*
