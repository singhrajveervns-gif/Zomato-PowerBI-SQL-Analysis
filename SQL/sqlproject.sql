SELECT * FROM customers;
SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM riders;

-- EDA

SELECT COUNT(*) FROM customers
WHERE customer_name IS NULL OR reg_date IS NULL;

SELECT COUNT(*) FROM restaurants
WHERE restaurant_name IS NULL OR city IS NULL OR opening_hours IS NULL ;

SELECT COUNT(*) FROM orders
WHERE
    order_item IS NULL
    OR
    order_date IS NULL
    OR
    order_time IS NULL
    OR
    order_status IS NULL
    OR
    total_amount IS NULL;
    
    -- Analysis and solving real world problems
    
/* ============================================================
Q1. Customer Purchase Behavior Analysis

Business Problem:
Identify the top 5 most frequently ordered dishes by the customer
"Arjun Mehta" over the last 12 months.

Objective:
Understand customer preferences for personalized recommendations
and targeted marketing campaigns.
============================================================ */
SELECT customer_name,dishes,total_orders FROM    
(SELECT c.customer_id, c.customer_name, o.order_item AS dishes,
    COUNT(*) AS total_orders,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS ranks
    FROM orders AS o
	JOIN customers AS c
    ON c.customer_id = o.customer_id
    WHERE 
    C.customer_name = 'Aryan Maharaj'
    GROUP BY
    c.customer_id,
    c.customer_name,
    o.order_item
    ORDER BY
    total_orders DESC) AS t1
    WHERE ranks <= 5;
    
/* ============================================================
Q2. Peak Order Time Analysis

Business Problem:
Determine the 2-hour time slots during which the highest number
of orders are placed.

Objective:
Identify peak ordering hours to optimize restaurant staffing,
rider allocation, and operational efficiency.
============================================================ */
    SELECT
    CASE
        WHEN HOUR(order_time) BETWEEN 0 AND 1 THEN '00:00 - 02:00'
        WHEN HOUR(order_time) BETWEEN 2 AND 3 THEN '02:00 - 04:00'
        WHEN HOUR(order_time) BETWEEN 4 AND 5 THEN '04:00 - 06:00'
        WHEN HOUR(order_time) BETWEEN 6 AND 7 THEN '06:00 - 08:00'
        WHEN HOUR(order_time) BETWEEN 8 AND 9 THEN '08:00 - 10:00'
        WHEN HOUR(order_time) BETWEEN 10 AND 11 THEN '10:00 - 12:00'
        WHEN HOUR(order_time) BETWEEN 12 AND 13 THEN '12:00 - 14:00'
        WHEN HOUR(order_time) BETWEEN 14 AND 15 THEN '14:00 - 16:00'
        WHEN HOUR(order_time) BETWEEN 16 AND 17 THEN '16:00 - 18:00'
        WHEN HOUR(order_time) BETWEEN 18 AND 19 THEN '18:00 - 20:00'
        WHEN HOUR(order_time) BETWEEN 20 AND 21 THEN '20:00 - 22:00'
        WHEN HOUR(order_time) BETWEEN 22 AND 23 THEN '22:00 - 00:00'
    END AS time_slot,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY time_slot
ORDER BY order_count DESC LIMIT 1;

/* ============================================================
Q3. Customer Order Value Analysis

Business Problem:
Calculate the Average Order Value (AOV) for customers who have
placed more than 20 orders.

Objective:
Identify high-frequency customers and evaluate their average
spending behavior to support customer value analysis and
targeted marketing strategies.
============================================================ */

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(o.order_id) > 20
ORDER BY average_order_value DESC;

/* ============================================================
Q4. High-Value Customer Analysis

Business Problem:
Identify customers who have spent more than ₹10,000 on food
orders.

Objective:
Recognize high-value customers based on their cumulative spending
to support customer retention, loyalty programs, and targeted
marketing campaigns.
============================================================ */

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING SUM(o.total_amount) > 10000
ORDER BY total_spent DESC;

/* ============================================================
Q5. Undelivered Orders Analysis

Business Problem:
Identify orders that were placed but not successfully delivered.

Objective:
Analyze undelivered orders across restaurants to identify
operational inefficiencies and improve delivery performance.
============================================================ */
SELECT
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS not_delivered_orders
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
JOIN deliveries d
    ON o.order_id = d.order_id
WHERE d.delivery_status <> 'Delivered'
GROUP BY
    r.restaurant_name,
    r.city
ORDER BY not_delivered_orders DESC;
/* ============================================================
Q6. Restaurant Revenue Ranking

Business Problem:
Rank restaurants based on the total revenue generated during the
latest year available in the dataset and determine their rank
within their respective cities.

Objective:
Identify the top-performing restaurants in each city based on
revenue to support business performance analysis and strategic
decision-making.
============================================================ */

WITH restaurant_revenue AS
(
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        r.city,
        SUM(o.total_amount) AS total_revenue
    FROM restaurants r
    JOIN orders o
        ON r.restaurant_id = o.restaurant_id
    WHERE YEAR(o.order_date) = (
        SELECT MAX(YEAR(order_date))
        FROM orders
    )
    AND o.order_status = 'Completed'
    GROUP BY
        r.restaurant_id,
        r.restaurant_name,
        r.city
)

SELECT
    restaurant_name,
    city,
    ROUND(total_revenue,2) AS total_revenue,
    RANK() OVER (
        PARTITION BY city
        ORDER BY total_revenue DESC
    ) AS city_rank
FROM restaurant_revenue
ORDER BY
    city,
    city_rank;

/* ============================================================
Q7. Most Popular Dish by City

Business Problem:
Identify the most popular dish in each city based on the total
number of orders placed.

Objective:
Determine customer food preferences across different cities to
support menu optimization, targeted promotions, and inventory
planning.
============================================================ */

WITH dish_orders AS
(
    SELECT
        r.city,
        o.order_item,
        COUNT(o.order_id) AS total_orders
    FROM orders o
    JOIN restaurants r
        ON o.restaurant_id = r.restaurant_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        r.city,
        o.order_item
)

SELECT
    city,
    order_item,
    total_orders
FROM
(
    SELECT
        city,
        order_item,
        total_orders,
        RANK() OVER(
            PARTITION BY city
            ORDER BY total_orders DESC
        ) AS city_rank
    FROM dish_orders
) AS ranked_dishes
WHERE city_rank = 1
ORDER BY city;    

/* ============================================================
Q8. Customer Churn Analysis

Business Problem:
Identify customers who placed orders in 2024 but did not place
any orders in the latest year available in the dataset.

Objective:
Detect inactive customers (customer churn) to support retention
strategies, personalized marketing campaigns, and customer
re-engagement initiatives.
============================================================ */

SELECT
    c.customer_id,
    c.customer_name
FROM customers c
WHERE c.customer_id IN
(
    SELECT customer_id
    FROM orders
    WHERE YEAR(order_date) = 2024
)
AND c.customer_id NOT IN
(
    SELECT customer_id
    FROM orders
    WHERE YEAR(order_date) = (
        SELECT MAX(YEAR(order_date))
        FROM orders
    )
)
ORDER BY
    c.customer_id;
    
/* ============================================================
Q9. Restaurant Cancellation Rate Comparison

Business Problem:
Compare the order cancellation rate for each restaurant between
the previous year and the latest year available in the dataset.

Objective:
Evaluate changes in cancellation rates to identify restaurants
requiring operational improvements and enhance customer
satisfaction.
============================================================ */

WITH yearly_stats AS
(
    SELECT
        o.restaurant_id,
        YEAR(o.order_date) AS order_year,
        COUNT(o.order_id) AS total_orders,
        SUM(CASE
                WHEN d.delivery_status <> 'Delivered' THEN 1
                ELSE 0
            END) AS cancelled_orders
    FROM orders o
    JOIN deliveries d
        ON o.order_id = d.order_id
    GROUP BY
        o.restaurant_id,
        YEAR(o.order_date)
),

cancellation_rate AS
(
    SELECT
        restaurant_id,
        order_year,
        ROUND((cancelled_orders * 100.0) / total_orders, 2) AS cancellation_rate
    FROM yearly_stats
)

SELECT
    r.restaurant_name,
    r.city,
    MAX(CASE
            WHEN order_year = (
                SELECT MAX(YEAR(order_date)) - 1
                FROM orders
            )
            THEN cancellation_rate
        END) AS previous_year_cancellation_rate,

    MAX(CASE
            WHEN order_year = (
                SELECT MAX(YEAR(order_date))
                FROM orders
            )
            THEN cancellation_rate
        END) AS latest_year_cancellation_rate
FROM cancellation_rate c
JOIN restaurants r
    ON c.restaurant_id = r.restaurant_id
GROUP BY
    r.restaurant_name,
    r.city
ORDER BY
    latest_year_cancellation_rate DESC;
    
/* ============================================================
Q10. Rider Average Delivery Time Analysis

Business Problem:
Determine the average delivery time for each rider.

Objective:
Evaluate rider performance by analyzing the average delivery
time of each rider to identify efficient delivery personnel and
improve operational performance.
============================================================ */

SELECT
    r.rider_id,
    r.rider_name,
    ROUND(AVG(d.delivery_time), 2) AS average_delivery_time
FROM riders r
JOIN deliveries d
    ON r.rider_id = d.rider_id
WHERE d.delivery_status = 'Delivered'
GROUP BY
    r.rider_id,
    r.rider_name
ORDER BY
    average_delivery_time; 
    
/* ============================================================
Q11. Monthly Restaurant Growth Analysis

Business Problem:
Analyze the month-over-month growth in delivered orders for each
restaurant to evaluate business performance over time.

Objective:
Measure monthly growth trends to identify consistently growing
restaurants and support strategic business planning.
============================================================ */

WITH monthly_orders AS
(
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        COUNT(o.order_id) AS total_orders
    FROM restaurants r
    JOIN orders o
        ON r.restaurant_id = o.restaurant_id
    JOIN deliveries d
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
    GROUP BY
        r.restaurant_id,
        r.restaurant_name,
        DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    restaurant_id,
    restaurant_name,
    order_month,
    total_orders,
    LAG(total_orders) OVER(
        PARTITION BY restaurant_id
        ORDER BY order_month
    ) AS previous_month_orders,
    ROUND(
        (
            (total_orders -
            LAG(total_orders) OVER(
                PARTITION BY restaurant_id
                ORDER BY order_month
            ))
            * 100.0
        ) /
        LAG(total_orders) OVER(
            PARTITION BY restaurant_id
            ORDER BY order_month
        ),
        2
    ) AS growth_percentage
FROM monthly_orders
ORDER BY
    restaurant_name,
    order_month;
    
-- Q13. Rider Monthly Earnings
-- Business Problem:
-- Calculate each rider's total monthly earnings, assuming riders earn 8% of the total delivered order amount.

SELECT
    d.rider_id,
    r.rider_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(o.total_amount), 2) AS total_revenue,
    ROUND(SUM(o.total_amount) * 0.08, 2) AS rider_earnings
FROM deliveries d
JOIN orders o
    ON d.order_id = o.order_id
JOIN riders r
    ON d.rider_id = r.rider_id
WHERE d.delivery_status = 'Delivered'
GROUP BY
    d.rider_id,
    r.rider_name,
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY
    d.rider_id,
    month;
    
-- Q16. Customer Lifetime Value (CLV)
-- Objective:
-- Calculate the total revenue generated by each customer over
-- their entire ordering history to identify high-value customers
-- and support customer retention strategies.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS customer_lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY
    customer_lifetime_value DESC;
    
-- Q17. Monthly Sales Trends
-- Objective:
-- Analyze Zomato's monthly sales trends by comparing each month's
-- revenue with the previous month to evaluate business growth,
-- identify seasonal patterns, and support data-driven decision making.

WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        ROUND(SUM(total_amount), 2) AS total_sales
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)

SELECT
    sales_month,
    total_sales,
    LAG(total_sales) OVER (
        ORDER BY sales_month
    ) AS previous_month_sales,
    ROUND(
        total_sales -
        LAG(total_sales) OVER (
            ORDER BY sales_month
        ),
        2
    ) AS sales_difference,
    ROUND(
        (
            (total_sales -
            LAG(total_sales) OVER (
                ORDER BY sales_month
            ))
            * 100.0
        ) /
        LAG(total_sales) OVER (
            ORDER BY sales_month
        ),
        2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY sales_month;

-- Q18. Rider Efficiency Analysis
-- Objective:
-- Evaluate Zomato's delivery operations by analyzing the average
-- delivery time of each rider and identifying the most and least
-- efficient riders based on their delivery performance.

SELECT
    d.rider_id,
    r.rider_name,
    ROUND(AVG(d.delivery_time), 2) AS average_delivery_time,
    RANK() OVER (
        ORDER BY AVG(d.delivery_time) ASC
    ) AS efficiency_rank
FROM deliveries d
JOIN riders r
    ON d.rider_id = r.rider_id
WHERE d.delivery_status = 'Delivered'
GROUP BY
    d.rider_id,
    r.rider_name
ORDER BY
    efficiency_rank;
 
 -- Q19. Order Item Popularity Analysis
-- Objective:
-- Analyze the popularity of different food items over time to
-- identify seasonal demand patterns and support menu planning,
-- inventory management, and promotional strategies for Zomato.

WITH monthly_item_orders AS
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        order_item,
        COUNT(order_id) AS total_orders
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY
        DATE_FORMAT(order_date, '%Y-%m'),
        order_item
)

SELECT
    order_month,
    order_item,
    total_orders,
    RANK() OVER
    (
        PARTITION BY order_month
        ORDER BY total_orders DESC
    ) AS popularity_rank
FROM monthly_item_orders
ORDER BY
    order_month,
    popularity_rank;
    
-- Q21. City-wise Revenue Contribution
-- Objective:
-- Analyze the revenue contribution of each city to identify the
-- most profitable markets for Zomato and determine each city's
-- percentage contribution to the overall revenue.

WITH city_revenue AS
(
    SELECT
        r.city,
        ROUND(SUM(o.total_amount), 2) AS total_revenue
    FROM restaurants r
    JOIN orders o
        ON r.restaurant_id = o.restaurant_id
    WHERE o.order_status = 'Completed'
    GROUP BY r.city
)

SELECT
    city,
    total_revenue,
    ROUND(
        (total_revenue * 100.0) /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_contribution_percentage
FROM city_revenue
ORDER BY total_revenue DESC;

-- Q22. Repeat Customer Analysis
-- Objective:
-- Identify repeat customers based on their ordering frequency and
-- total spending to support customer retention strategies and
-- loyalty program planning for Zomato.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS average_order_value,
    DENSE_RANK() OVER (
        ORDER BY COUNT(o.order_id) DESC,
                 SUM(o.total_amount) DESC
    ) AS customer_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY
    total_orders DESC,
    total_spent DESC;
    
    
    
    
 