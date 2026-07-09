/* ============================================================
OPTIONAL ENHANCEMENTS
These queries are ADDITIVE ONLY and do not modify, replace, or
depend on any change to the original sqlproject.sql file.
They exist purely as optional extra analysis to strengthen the
Power BI portfolio extension. Skip freely if not needed.
============================================================ */

/* ------------------------------------------------------------
OPT-1. New vs. Returning Customers by Month
Objective: Track monthly acquisition of new customers vs.
orders from existing (returning) customers, to support growth
vs. retention tracking on the Power BI Executive Overview page.
------------------------------------------------------------ */
WITH first_order AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    SUM(CASE WHEN DATE_FORMAT(f.first_order_date, '%Y-%m') = DATE_FORMAT(o.order_date, '%Y-%m')
             THEN 1 ELSE 0 END) AS new_customer_orders,
    SUM(CASE WHEN DATE_FORMAT(f.first_order_date, '%Y-%m') <> DATE_FORMAT(o.order_date, '%Y-%m')
             THEN 1 ELSE 0 END) AS returning_customer_orders
FROM orders o
JOIN first_order f
    ON o.customer_id = f.customer_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY order_month;

/* ------------------------------------------------------------
OPT-2. Average Order Value by City
Objective: Compare spending behavior across cities to support
city-level marketing and pricing strategy discussions.
------------------------------------------------------------ */
SELECT
    r.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Completed'
GROUP BY r.city
ORDER BY average_order_value DESC;

/* ------------------------------------------------------------
OPT-3. Rider Monthly Workload
Objective: Measure the number of deliveries completed by each
rider per month to support workload balancing and staffing
decisions alongside the earnings analysis (Q13).
------------------------------------------------------------ */
SELECT
    r.rider_id,
    r.rider_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(d.delivery_id) AS deliveries_completed
FROM deliveries d
JOIN orders o
    ON d.order_id = o.order_id
JOIN riders r
    ON d.rider_id = r.rider_id
WHERE d.delivery_status = 'Delivered'
GROUP BY
    r.rider_id,
    r.rider_name,
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY
    r.rider_id,
    month;
