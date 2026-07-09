# Zomato Data Analytics Project: SQL + Power BI

An end-to-end analytics portfolio project simulating a food-delivery business (Zomato-style), covering the full workflow from raw data to an interactive business dashboard:

**CSV Dataset → MySQL Database → SQL Analysis → Power BI Dashboard → GitHub Portfolio**

---

## 📌 Project Overview

This project analyzes customer ordering behavior, restaurant performance, delivery/rider operations, and revenue trends for a food delivery platform using MySQL for data modeling and querying, and Power BI for interactive visualization.

It was built as a placement-ready portfolio piece to demonstrate:
- Relational database design and SQL querying (joins, CTEs, window functions, subqueries)
- Business problem framing and analytical thinking
- Dashboard design, DAX, and data modeling in Power BI
- End-to-end data workflow documentation

---

## 🗂 Dataset & Schema

The database (`zomato_db`) contains 5 related tables:

| Table | Description | Key Columns |
|---|---|---|
| `customers` | Customer master data | customer_id (PK), customer_name, reg_date |
| `restaurants` | Restaurant master data | restaurant_id (PK), restaurant_name, city, opening_hours |
| `orders` | Order transactions | order_id (PK), customer_id (FK), restaurant_id (FK), order_item, order_date, order_time, order_status, total_amount |
| `riders` | Delivery rider master data | rider_id (PK), rider_name, sign_up |
| `deliveries` | Delivery fulfillment records | delivery_id (PK), order_id (FK), delivery_status, delivery_time, rider_id (FK) |

Entity relationships: `orders` links to `customers` and `restaurants`; `deliveries` links to `orders` and `riders`.

---

## 🧮 SQL Analysis

All SQL work lives in [`/sql`](./sql) and is treated as final/complete. It answers 18 real business questions, including:

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

See [`sql/sqlproject.sql`](./sql/sqlproject.sql) for the full annotated query set and [`sql/Zomato_sql_project_backup_sql.sql`](./sql/Zomato_sql_project_backup_sql.sql) for the schema/data dump.

An additional, clearly-separated file, [`sql/optional_enhancements.sql`](./sql/optional_enhancements.sql), contains a few *optional* supplementary queries that do not modify or replace any original work.

---

## 📊 Power BI Dashboard

The dashboard (`/powerbi/Zomato_Analysis.pbix`) turns the SQL analysis into an interactive, executive-ready tool with 5 pages:

1. **Executive Dashboard** — KPI cards for Total Revenue, Total Orders, Average Order Value, Completion Rate %, and Cancellation Rate %; a monthly revenue trend line; revenue by city; top 10 restaurants by revenue; a restaurant summary table; and an order status breakdown donut.
2. **Customers Insight** — Customer Lifetime Value table; KPI cards for Cancelled Orders, Completion Rate %, Average Order Value, and Out for Delivery Orders; a Churned Customers card; high-value customers (>₹10K); customers with cancelled orders; and a top-10-customers-by-revenue bar chart.
3. **Restaurant Insights** — Top 10 restaurants by revenue; revenue by city; restaurants with the highest cancellation rate; KPI cards for Restaurant Count, Average Revenue per Restaurant, Total Revenue, and Cancellation Rate %; and most popular dishes by city.
4. **Delivery & Rider Ops** — KPI cards for Total Riders, Completed Deliveries, Undelivered Orders, and Delivery Success Rate %; top 10 riders by deliveries; delivery status breakdown; and top 10 restaurants by undelivered orders.
5. **Menu & Demand Insights** — A conditionally-formatted heatmap matrix of order volume by Time Slot (rows) and Month (columns), showing demand patterns across the day and across the year in a single view.

Full build steps, DAX measures, data model, and design notes are documented in [`docs/POWER_BI_BUILD_GUIDE.md`](./docs/POWER_BI_BUILD_GUIDE.md).

### Dashboard Preview
_Add screenshots to `docs/screenshots/` and reference them here, e.g.:_
```
![Executive Dashboard](docs/screenshots/executive_dashboard.png)
```

---

## 🛠 Tools Used

- **MySQL 8.0** — data modeling, business-question SQL
- **Power BI Desktop** — data modeling (DAX), dashboard design, publishing
- **MySQL Connector/NET** — Power BI-to-MySQL connectivity

---

## 📁 Folder Structure

```
zomato-sql-powerbi-project/
├── README.md
├── sql/
│   ├── sqlproject.sql                     # Original business-question queries (unmodified)
│   ├── Zomato_sql_project_backup_sql.sql  # Schema + data dump (unmodified)
│   └── optional_enhancements.sql          # Optional supplementary queries (new, separate)
├── data/
│   └── order.csv                          # Raw order data
├── powerbi/
│   └── Zomato_Analysis.pbix               # Power BI dashboard file
└── docs/
    ├── POWER_BI_BUILD_GUIDE.md            # Step-by-step build guide, DAX, connection setup
    └── screenshots/                       # Dashboard page screenshots for this README
```

---

## 🚀 How to Reproduce

1. Restore the database: `mysql -u root -p < sql/Zomato_sql_project_backup_sql.sql`
2. Run the analysis queries in `sql/sqlproject.sql` to explore the business answers directly in MySQL.
3. Open `powerbi/Zomato_Analysis.pbix` in Power BI Desktop, point the MySQL connector at your local `zomato_db`, and refresh.

---

## 🔭 Possible Future Enhancements

The current dashboard relies on default cross-filtering across visuals. Ideas for a v2, not yet implemented:
- Slicers (date range, city, order status) synced across all pages
- A drill-through "Customer 360" page for per-customer deep dives
- Bookmarks to toggle between "Completed Orders Only" and "All Orders" views
- Tooltip pages for restaurant/customer revenue trends on hover

---

## 👤 Author

Rajveer Singh — IIT (BHU)
Portfolio project for data analytics / business intelligence placements.
