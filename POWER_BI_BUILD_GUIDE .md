# Power BI Build Guide — Zomato Analytics Dashboard

This documents how `powerbi/Zomato_Analysis.pbix` was built: connecting to MySQL, modeling the data, writing DAX, and laying out the 5 report pages. It does not require changing any existing SQL — Power BI imports the same 5 tables the SQL project already analyzes and recreates the business logic using DAX, so the portfolio shows SQL and DAX skills side by side.

---

## 1. Connect Power BI to MySQL

**Prerequisite:** install the MySQL Connector/NET (or the MySQL ODBC 8.0 driver) — Power BI needs this to talk to MySQL. Download from the official MySQL site, matching your Power BI Desktop's bitness (64-bit in almost all modern installs).

Steps:
1. Open **Power BI Desktop** → **Home → Get Data → More…**
2. Search for **MySQL database** → Connect
3. Enter:
   - **Server:** `localhost:3306` (or your host:port)
   - **Database:** `zomato_db`
4. Choose **Import** mode — with a dataset this size, Import gives faster visuals.
5. Enter your MySQL username/password when prompted (Database credentials).
6. In the Navigator window, select all 5 tables: `customers`, `restaurants`, `orders`, `riders`, `deliveries` → **Transform Data**.

## 2. Power Query (Transform) Checks

Before loading, in Power Query Editor:
- Confirm data types: `order_date`/`reg_date`/`sign_up` as Date, `order_time`/`delivery_time` as Time, `total_amount` as Decimal Number.
- Check for/handle any null `order_status` or `delivery_status` rows.
- Click **Close & Apply**.

The dashboard uses Power BI's **built-in Date Hierarchy** (auto-generated from `orders[order_date]`) rather than a separate custom date table — this is what drives the Month grouping on the Menu & Demand Insights heatmap and the monthly revenue trend on the Executive Dashboard.

## 3. Data Model (Relationships)

In **Model view**, confirm/create these relationships (Power BI usually auto-detects them from the FK names):

- `orders[customer_id]` → `customers[customer_id]` (many-to-one)
- `orders[restaurant_id]` → `restaurants[restaurant_id]` (many-to-one)
- `deliveries[order_id]` → `orders[order_id]` (one-to-one/many-to-one)
- `deliveries[rider_id]` → `riders[rider_id]` (many-to-one)

This gives a clean star-ish schema: `orders` as the fact table, with `customers`, `restaurants`, and `riders` as dimensions, and `deliveries` as a fulfillment-detail table joined to `orders`.

### Calculated column: Time Slot
The Menu & Demand Insights page groups orders into a `Time Slot` calculated column on `orders`, bucketing `order_time` into ranges (e.g. Morning / Afternoon / Evening / Night). Example DAX:

```dax
Time Slot =
SWITCH(
    TRUE(),
    HOUR(orders[order_time]) < 6, "Late Night",
    HOUR(orders[order_time]) < 12, "Morning",
    HOUR(orders[order_time]) < 17, "Afternoon",
    HOUR(orders[order_time]) < 21, "Evening",
    "Night"
)
```
(Adjust the boundaries to match whatever bucketing logic you used — this mirrors the peak-time-slot business question from the SQL analysis.)

## 4. DAX Measures

The dashboard uses the following measures, organized here by the page(s) that use them.

### Core / Executive Dashboard
```dax
Total Revenue = CALCULATE(SUM(orders[total_amount]), orders[order_status] = "Completed")

Total Orders = COUNTROWS(orders)

Average Order Value = DIVIDE([Total Revenue], CALCULATE(COUNTROWS(orders), orders[order_status] = "Completed"))

Completion Rate % = DIVIDE(CALCULATE(COUNTROWS(orders), orders[order_status] = "Completed"), [Total Orders])

Cancellation Rate % = DIVIDE(CALCULATE(COUNTROWS(orders), orders[order_status] = "Cancelled"), [Total Orders])

Cancelled Orders = CALCULATE(COUNTROWS(orders), orders[order_status] = "Cancelled")
```

### Customers Insight
```dax
Customer Revenue = CALCULATE(SUM(orders[total_amount]), orders[order_status] = "Completed")

Out for Delivery Orders = CALCULATE(COUNTROWS(deliveries), deliveries[delivery_status] = "Out for Delivery")

Churned Customers =
CALCULATE(
    DISTINCTCOUNT(customers[customer_id]),
    FILTER(
        customers,
        CALCULATE(COUNTROWS(orders), orders[order_date].[Year] = 2024) > 0
            && CALCULATE(COUNTROWS(orders), orders[order_date].[Year] = MAX(orders[order_date].[Year])) = 0
    )
)
```

### Restaurant Insights
```dax
Restaurant Count = DISTINCTCOUNT(restaurants[restaurant_id])

Average Revenue per Restaurant = DIVIDE([Total Revenue], [Restaurant Count])
```

### Delivery & Rider Ops
```dax
Total Riders = DISTINCTCOUNT(riders[rider_id])

Completed Deliveries = CALCULATE(COUNTROWS(deliveries), deliveries[delivery_status] = "Delivered")

Undelivered Orders = CALCULATE(COUNTROWS(deliveries), deliveries[delivery_status] <> "Delivered")

Delivery Success Rate % = DIVIDE([Completed Deliveries], COUNTROWS(deliveries))

Total Deliveries = COUNTROWS(deliveries)
```

Adjust field/table references to match your exact column names — these mirror the logic in the original SQL business questions (undelivered orders, cancellation rate, churn, CLV, rider performance) expressed in DAX.

---

## 5. Page-by-Page Layout (as built)

### Page 1 — Executive Dashboard
- KPI cards: Total Revenue, Total Orders, Average Order Value, Completion Rate %, Cancellation Rate %
- Line chart: Monthly Revenue Trend
- Column chart: Revenue by City
- Bar chart: Top 10 Restaurants by Revenue
- Table: Restaurants Summary (restaurant_name, Total Revenue, Total Orders, Average Order Value)
- Donut chart: Order Status Distribution

### Page 2 — Customers Insight
- Table: Customer Lifetime Value (customer_name, total spend)
- KPI cards: Cancelled Orders, Completion Rate %, Average Order Value, Out for Delivery Orders
- Table: High Value Customers (> ₹10K)
- Card: Churned Customers
- Table: Customers with Cancelled Orders
- Bar chart: Top 10 Customers by Revenue

### Page 3 — Restaurant Insights
- Bar chart: Top 10 Restaurants by Revenue
- Column chart: Revenue by City
- Bar chart: Restaurants with Highest Cancellation Rate
- KPI cards: Restaurant Count, Average Revenue per Restaurant, Total Revenue, Cancellation Rate %
- Bar chart: Most Popular Dishes by City (order_item, order count, split by city)

### Page 4 — Delivery & Rider Ops
- KPI cards: Total Riders, Completed Deliveries, Undelivered Orders, Delivery Success Rate %
- Bar chart: Top 10 Riders by Deliveries
- Donut chart: Delivery Status Distribution
- Bar chart: Top 10 Restaurants by Undelivered Orders

### Page 5 — Menu & Demand Insights
- Pivot table (matrix): rows = Time Slot, columns = Month, values = order count, with conditional color formatting to create a heatmap effect showing when demand peaks across the day and across the year.

---

## 6. Design Notes

The report uses Power BI's default theme (no custom color palette applied), with conditional formatting used selectively — most notably the color-scaled heatmap on the Menu & Demand Insights matrix. Each page keeps KPI cards along the top with supporting charts and tables below, and there's no slicer panel — all filtering happens through default cross-highlighting when a user clicks a chart element.

If you want to push the visual polish further for placement interviews, consider: a consistent accent color (e.g. Zomato red `#E23744`) applied to titles/highlight bars, and matching card/table styling across pages.

---

## 7. Publish

1. **File → Publish → Publish to Power BI** (choose your workspace).
2. In the Power BI Service, go to the dataset's settings → **Data source credentials** → set up a **Gateway** if MySQL is on-premises/local (required for scheduled refresh against a local MySQL instance).
3. For a portfolio piece, a one-time publish is enough — scheduled refresh requires an on-prem gateway, which is worth mentioning in interviews even if not set up.
4. Grab screenshots of each page (**File → Export → Export to PDF/Image**, or a screen capture) and drop them into `docs/screenshots/` for the README.

---

## 8. Optional Enhancements (do not replace existing SQL)

If you want to extend the analysis further without touching your existing queries, `sql/optional_enhancements.sql` includes a few additive ideas:
- New vs. returning customer counts by month
- Average order value by city
- Rider workload (orders delivered per rider per month)

These are purely additive and can be imported as extra Power BI tables if desired, or skipped entirely.

## 9. Possible Next Steps for the Dashboard

Not currently built, but natural next additions if you want to extend this further:
- Slicers (date range, city, order status) synced across all 5 pages
- A drill-through "Customer 360" page for per-customer deep dives, showing top dishes and order history for whichever customer is selected
- Bookmarks to toggle between "Completed Orders Only" and "All Orders" views
- Tooltip pages for restaurant/customer revenue trends on hover
