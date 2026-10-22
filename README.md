# 🍽️ FoodHouse - Enterprise Food Ordering & Delivery Platform

An end-to-end, full-featured online food ordering and restaurant management web application built with **Java 21**, **Jakarta Servlets & JSP**, **MySQL**, and modern responsive design.

---

## 🌟 Key Highlights & Features

- **🏛️ Architecture**: Clean MVC Architecture (Model - View - Controller) with Data Access Object (DAO) design pattern.
- **🔐 Secure Authentication**: User registration and login protected with **BCrypt** password hashing and session management.
- **🏢 Restaurant & Cuisine Discovery**: Curated list of 30+ top restaurants with dynamic ratings, delivery estimates, and cuisine categories.
- **🍱 Dynamic Interactive Menu**: Detailed menu catalogs per restaurant featuring 360+ audited dishes with add-to-cart controls.
- **🛒 Real-time Cart & Checkout**: Interactive cart with quantity modification, subtotal calculation, tax, and instant checkout.
- **📦 Order Tracking & Lifecycle Management**: Live order history, tracking stages (Confirmed, Preparing, Out for Delivery, Delivered), and delivery updates.
- **📱 Fully Responsive UI**: Tailored glassmorphism and modern styling optimized for mobile, tablet, and desktop viewports.

---

## 🛠️ Technology Stack

- **Backend**: Java 21, Jakarta EE 10 (Servlets & JSP)
- **Application Server**: Apache Tomcat 10.1+
- **Database**: MySQL 8.0+
- **Security**: jBCrypt (Password Hashing)
- **Database Driver**: MySQL Connector/J 9.2.0
- **Frontend**: HTML5, CSS3, Vanilla JavaScript

---

## 🗄️ Database Setup

1. Open MySQL Workbench, MySQL CLI, or your preferred SQL tool.
2. Execute the included dataset script:
   ```bash
   mysql -u root -p < foodhouse_dataset.sql
   ```
3. This creates the database `foodhouse` along with pre-seeded users, restaurants, and menu items.

---

## ⚙️ Configuration & Environment Variables

`FoodHouse` supports both local defaults and cloud environment variable injection:

| Variable | Description | Default Value |
| :--- | :--- | :--- |
| `DB_URL` | Full JDBC MySQL Connection String | `jdbc:mysql://localhost:3306/foodhouse` |
| `DB_HOST` | Database Host & Port | `localhost:3306` |
| `DB_NAME` | Database Name | `foodhouse` |
| `DB_USER` | MySQL Username | `root` |
| `DB_PASSWORD` | MySQL Password | `Classy@0539` |

---

## 🚀 How to Run Locally in Eclipse

1. Open **Eclipse IDE for Enterprise Java and Web Developers**.
2. Go to **File -> Import -> Existing Projects into Workspace**.
3. Select the `FoodHouse` directory.
4. Ensure **Apache Tomcat v10.1** is configured under Server runtime (Window -> Preferences -> Server -> Runtime Environments).
5. Right-click on `FoodHouse` -> **Run As -> Run on Server** -> Select **Tomcat v10.1**.
6. Access the application in your browser at:
   ```
   http://localhost:8080/FoodHouse/
   ```

---

## 📦 Deployment (.WAR Export)

1. Right-click on `FoodHouse` in Eclipse.
2. Select **Export -> WAR file**.
3. Target destination: `ROOT.war` (for root deployment) or `FoodHouse.war`.
4. Deploy to Apache Tomcat 10.1 `webapps/` directory or containerized cloud platforms (Railway, Render, AWS EC2).

---

## 👥 Author

- **Developer**: [Ganeshk-39](https://github.com/Ganeshk-39)
