# 🍽️ Zomato Data Analytics Project — SQL + Power BI

An end-to-end data analytics portfolio project built on a Zomato-style food delivery dataset, covering the complete workflow from raw data to an interactive business intelligence dashboard:

**CSV Datasets → MySQL Database → SQL Analysis → Power BI Dashboard → GitHub Portfolio**

---

## 📌 Project Overview

This project analyzes customer ordering behavior, restaurant performance, delivery and rider operations, and revenue trends for a food delivery platform. MySQL is used for data modeling and business-question SQL, and Power BI is used to turn that analysis into an interactive, presentation-ready dashboard.

Built as a placement-ready portfolio piece to demonstrate:
- Relational database design and SQL querying (joins, CTEs, window functions, aggregations)
- Business problem framing and analytical thinking
- Data modeling, DAX, and dashboard design in Power BI
- Clean, professional project documentation

---

## 🗂 Dataset & Schema

The source data lives in [`Data set`](./Data%20set) as five CSV files, each corresponding to a table in the MySQL database (`zomato_db`):

| File | Table | Description | Key Columns |
|---|---|---|---|
| `customers.csv` | `customers` | Customer master data | customer_id (PK), customer_name, reg_date |
| `restaurant.csv` | `restaurants` | Restaurant master data | restaurant_id (PK), restaurant_name, city, opening_hours |
| `order.csv` | `orders` | Order transactions | order_id (PK), customer_id (FK), restaurant_id (FK), order_item, order_date, order_time, order_status, total_amount |
| `riders.csv` | `riders` | Delivery rider master data | rider_id (PK), rider_name, sign_up |
| `deliveries.csv` | `deliveries` | Delivery fulfillment records | delivery_id (PK), order_id (FK), delivery_status, delivery_time, rider_id (FK) |

**Relationships:** `orders` links to `customers` and `restaurants`; `deliveries` links to `orders` and `riders`.

A full schema + data dump is available in [`BACK up/Zomato_sql_project_backup_sql.sql`](./BACK%20up/Zomato_sql_project_backup_sql.sql) for anyone who wants to restore the database directly instead of loading from CSV.

---

## 🧮 SQL Analysis

All SQL work lives in [`SQL`](./SQL) and is final/complete:

- [`sqlproject.sql`](./SQL/sqlproject.sql) — the core set of business-question queries, covering:
  - Customer purchase behavior & top dishes per customer
  - Peak order time-slot analysis
  - Average Order Value (AOV) for high-frequency customers
  - High-value customer identification (>₹10,000 spend)
  - Undelivered order analysis by restaurant
  - Restaurant revenue ranking within each city
  - Most popular dish per city
  - Customer churn detection (active in 2024, inactive latest year)
  - Restaurant cancellation rate, year-over-year comparison
  - Rider average delivery time & efficiency ranking
  - Month-over-month restaurant order growth
  - Rider monthly earnings (8% commission model)
  - Customer Lifetime Value (CLV)
  - Monthly sales trend with MoM growth %
  - Seasonal order-item popularity
  - City-wise revenue contribution %
  - Repeat customer identification
- [`optional_enhancements.sql`](./SQL/optional_enhancements.sql) — a small set of additive, optional queries (new vs. returning customers by month, AOV by city, rider monthly workload) that extend the analysis without modifying any of the original queries.

---

## 📊 Power BI Dashboard

The dashboard — [`Power BI/Zomato_Analysis.pbix`](./Power%20BI/Zomato_Analysis.pbix) — turns the SQL analysis into an interactive, executive-ready tool with **5 pages**:

### 1. Executive Overview
High-level KPIs and trends for a first-glance view of the business: total revenue, total orders, average order value, completion rate, and cancellation rate, alongside a monthly revenue trend, revenue by city, top restaurants by revenue, and an order status breakdown.

![Executive Overview](./SCREEN%20SHOTS/Executive_Overview.png)

### 2. Customer Insights
Customer Lifetime Value, high-value customers (>₹10K), churned customers, customers with cancelled orders, and the top customers by revenue — built to answer "who are our best and most at-risk customers."

![Customer Insights](./SCREEN%20SHOTS/Customer_Insights.png)

### 3. Restaurant Insights
Restaurant-level performance: revenue ranking, revenue by city, restaurants with the highest cancellation rates, restaurant count and average revenue per restaurant, and the most popular dishes by city.

![Restaurant Insights](./SCREEN%20SHOTS/Restaurant_Insights.png)

### 4. Delivery & Rider Ops
Operational view of fulfillment: total riders, completed deliveries, undelivered orders, delivery success rate, top riders by delivery volume, delivery status breakdown, and restaurants with the most undelivered orders.

![Delivery & Rider Ops](./SCREEN%20SHOTS/Delivery_Rider_Ops.png)

### 5. Menu & Demand Insights
A single heatmap matrix showing order demand by **Month** (columns) and **Time Slot** (rows), with conditional color formatting to make demand peaks immediately visible across both the time of day and the time of year.

![Menu & Demand Insights](./SCREEN%20SHOTS/Menu_Demand_Insights.png)

Full build steps — MySQL connection setup, data model, DAX measures, and page-by-page design notes — are documented in [`POWER_BI_BUILD_GUIDE.md`](./POWER_BI_BUILD_GUIDE.md).

---

## 🛠 Tools Used

- **MySQL 8.0** — data modeling, business-question SQL
- **Power BI Desktop** — data modeling (DAX), dashboard design
- **MySQL Connector/NET** — Power BI-to-MySQL connectivity

---

## 📁 Repository Structure

```
Zomato-PowerBI-SQL-Analysis
│
├── BACK up
│   └── Zomato_sql_project_backup_sql.sql   # Full schema + data dump
│
├── Data set
│   ├── customers.csv
│   ├── deliveries.csv
│   ├── order.csv
│   ├── restaurant.csv
│   └── riders.csv
│
├── Power BI
│   └── Zomato_Analysis.pbix                # Power BI dashboard (5 pages)
│
├── SCREEN SHOTS
│   ├── Executive_Overview.png
│   ├── Customer_Insights.png
│   ├── Restaurant_Insights.png
│   ├── Delivery_Rider_Ops.png
│   └── Menu_Demand_Insights.png
│
├── SQL
│   ├── sqlproject.sql                      # Core business-question queries
│   └── optional_enhancements.sql           # Optional additive queries
│
├── README.md
├── POWER_BI_BUILD_GUIDE.md
└── LICENSE
```

---

## 🚀 How to Reproduce

1. **Restore the database:**
   ```bash
   mysql -u root -p < "BACK up/Zomato_sql_project_backup_sql.sql"
   ```
   (Alternatively, create the schema yourself and load each CSV in `Data set/` into its corresponding table.)
2. **Run the analysis:** execute the queries in `SQL/sqlproject.sql` against `zomato_db` to explore the business answers directly in MySQL.
3. **Open the dashboard:** launch `Power BI/Zomato_Analysis.pbix` in Power BI Desktop, point the MySQL connector at your local `zomato_db`, and refresh. Full connection steps are in `POWER_BI_BUILD_GUIDE.md`.

---

# 🍽️ Zomato Data Analytics Project — SQL + Power BI

An end-to-end data analytics portfolio project built on a Zomato-style food delivery dataset, covering the complete workflow from raw data to an interactive business intelligence dashboard:

**CSV Datasets → MySQL Database → SQL Analysis → Power BI Dashboard → GitHub Portfolio**

---

## 📌 Project Overview

This project analyzes customer ordering behavior, restaurant performance, delivery and rider operations, and revenue trends for a food delivery platform. MySQL is used for data modeling and business-question SQL, and Power BI is used to turn that analysis into an interactive, presentation-ready dashboard.

Built as a placement-ready portfolio piece to demonstrate:
- Relational database design and SQL querying (joins, CTEs, window functions, aggregations)
- Business problem framing and analytical thinking
- Data modeling, DAX, and dashboard design in Power BI
- Clean, professional project documentation

---

## 🗂 Dataset & Schema

The source data lives in [`Data set`](./Data%20set) as five CSV files, each corresponding to a table in the MySQL database (`zomato_db`):

| File | Table | Description | Key Columns |
|---|---|---|---|
| `customers.csv` | `customers` | Customer master data | customer_id (PK), customer_name, reg_date |
| `restaurant.csv` | `restaurants` | Restaurant master data | restaurant_id (PK), restaurant_name, city, opening_hours |
| `order.csv` | `orders` | Order transactions | order_id (PK), customer_id (FK), restaurant_id (FK), order_item, order_date, order_time, order_status, total_amount |
| `riders.csv` | `riders` | Delivery rider master data | rider_id (PK), rider_name, sign_up |
| `deliveries.csv` | `deliveries` | Delivery fulfillment records | delivery_id (PK), order_id (FK), delivery_status, delivery_time, rider_id (FK) |

**Relationships:** `orders` links to `customers` and `restaurants`; `deliveries` links to `orders` and `riders`.

A full schema + data dump is available in [`BACK up/Zomato_sql_project_backup_sql.sql`](./BACK%20up/Zomato_sql_project_backup_sql.sql) for anyone who wants to restore the database directly instead of loading from CSV.

---

## 🧮 SQL Analysis

All SQL work lives in [`SQL`](./SQL) and is final/complete:

- [`sqlproject.sql`](./SQL/sqlproject.sql) — the core set of business-question queries, covering:
  - Customer purchase behavior & top dishes per customer
  - Peak order time-slot analysis
  - Average Order Value (AOV) for high-frequency customers
  - High-value customer identification (>₹10,000 spend)
  - Undelivered order analysis by restaurant
  - Restaurant revenue ranking within each city
  - Most popular dish per city
  - Customer churn detection (active in 2024, inactive latest year)
  - Restaurant cancellation rate, year-over-year comparison
  - Rider average delivery time & efficiency ranking
  - Month-over-month restaurant order growth
  - Rider monthly earnings (8% commission model)
  - Customer Lifetime Value (CLV)
  - Monthly sales trend with MoM growth %
  - Seasonal order-item popularity
  - City-wise revenue contribution %
  - Repeat customer identification
- [`optional_enhancements.sql`](./SQL/optional_enhancements.sql) — a small set of additive, optional queries (new vs. returning customers by month, AOV by city, rider monthly workload) that extend the analysis without modifying any of the original queries.

---

## 📊 Power BI Dashboard

The dashboard — [`Power BI/Zomato_Analysis.pbix`](./Power%20BI/Zomato_Analysis.pbix) — turns the SQL analysis into an interactive, executive-ready tool with **5 pages**:

### 1. Executive Overview
High-level KPIs and trends for a first-glance view of the business: total revenue, total orders, average order value, completion rate, and cancellation rate, alongside a monthly revenue trend, revenue by city, top restaurants by revenue, and an order status breakdown.

![Executive Overview](./SCREEN%20SHOTS/Executive_Overview.png)

### 2. Customer Insights
Customer Lifetime Value, high-value customers (>₹10K), churned customers, customers with cancelled orders, and the top customers by revenue — built to answer "who are our best and most at-risk customers."

![Customer Insights](./SCREEN%20SHOTS/Customer_Insights.png)

### 3. Restaurant Insights
Restaurant-level performance: revenue ranking, revenue by city, restaurants with the highest cancellation rates, restaurant count and average revenue per restaurant, and the most popular dishes by city.

![Restaurant Insights](./SCREEN%20SHOTS/Restaurant_Insights.png)

### 4. Delivery & Rider Ops
Operational view of fulfillment: total riders, completed deliveries, undelivered orders, delivery success rate, top riders by delivery volume, delivery status breakdown, and restaurants with the most undelivered orders.

![Delivery & Rider Ops](./SCREEN%20SHOTS/Delivery_Rider_Ops.png)

### 5. Menu & Demand Insights
A single heatmap matrix showing order demand by **Month** (columns) and **Time Slot** (rows), with conditional color formatting to make demand peaks immediately visible across both the time of day and the time of year.

![Menu & Demand Insights](./SCREEN%20SHOTS/Menu_Demand_Insights.png)

Full build steps — MySQL connection setup, data model, DAX measures, and page-by-page design notes — are documented in [`POWER_BI_BUILD_GUIDE.md`](./POWER_BI_BUILD_GUIDE.md).

---

## 🛠 Tools Used

- **MySQL 8.0** — data modeling, business-question SQL
- **Power BI Desktop** — data modeling (DAX), dashboard design
- **MySQL Connector/NET** — Power BI-to-MySQL connectivity

---

## 📁 Repository Structure

```
Zomato-PowerBI-SQL-Analysis
│
├── BACK up
│   └── Zomato_sql_project_backup_sql.sql   # Full schema + data dump
│
├── Data set
│   ├── customers.csv
│   ├── deliveries.csv
│   ├── order.csv
│   ├── restaurant.csv
│   └── riders.csv
│
├── Power BI
│   └── Zomato_Analysis.pbix                # Power BI dashboard (5 pages)
│
├── SCREEN SHOTS
│   ├── Executive_Overview.png
│   ├── Customer_Insights.png
│   ├── Restaurant_Insights.png
│   ├── Delivery_Rider_Ops.png
│   └── Menu_Demand_Insights.png
│
├── SQL
│   ├── sqlproject.sql                      # Core business-question queries
│   └── optional_enhancements.sql           # Optional additive queries
│
├── README.md
├── POWER_BI_BUILD_GUIDE.md
└── LICENSE
```

---

## 🚀 How to Reproduce

1. **Restore the database:**
   ```bash
   mysql -u root -p < "BACK up/Zomato_sql_project_backup_sql.sql"
   ```
   (Alternatively, create the schema yourself and load each CSV in `Data set/` into its corresponding table.)
2. **Run the analysis:** execute the queries in `SQL/sqlproject.sql` against `zomato_db` to explore the business answers directly in MySQL.
3. **Open the dashboard:** launch `Power BI/Zomato_Analysis.pbix` in Power BI Desktop, point the MySQL connector at your local `zomato_db`, and refresh. Full connection steps are in `POWER_BI_BUILD_GUIDE.md`.

---

## 👤 Author

**Rajveer Singh**

Aspiring Data Analyst

SQL • Power BI • Python • Excel

---

## 🔮 Future Enhancements

Future improvements that can be added to this project include:

- Interactive slicers for City, Date, and Order Status
- Drill-through pages for detailed customer analysis
- Tooltip pages for richer visual interactions
- Additional DAX measures for advanced KPIs
- Power BI Service deployment for online reporting
