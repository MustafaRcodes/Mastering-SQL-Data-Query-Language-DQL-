SELECT
-- DAY(created_at),
MONTH(created_at),
YEAR(created_at),
    WEEK(created_at),
    -- DATE(created_at),
    -- QUARTER(created_at),
    -- WEEKDAY(created_at),
  MIN(DATE(created_at)) AS week_start_date,
  SUM(   CASE WHEN device_type = 'mobile' THEN 1 ELSE 0 END) AS mob_sessions,
  SUM(   CASE WHEN device_type = 'desktop'THEN 1 ELSE 0 END) AS dtop_sessions
FROM website_sessions
  WHERE  created_at < '2012-06-09' 
AND created_at > '2012-04-15'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY
    YEAR(created_at),
    WEEK(created_at),
    -- DAY(created_at),
    MONTH(created_at);
    -- DATE(created_at),
    -- QUARTER(created_at),
    -- WEEKDAY(created_at)
    
SELECT 
    order_id,
    order_date,
    HOUR(order_date) AS order_hour,
    QUARTER(order_date) AS quarter_of_year,
    DAYOFWEEK(order_date) AS day_of_week,
    DATE(order_date) AS order_date_only,
    DAY(order_date) AS day_of_month,
    MONTH(order_date) AS month,
    YEAR(order_date) AS year,
    WEEK(order_date) AS week_of_year,
    NOW() AS current_datetime,
    DATE_ADD(order_date, INTERVAL 1 DAY) AS next_day, -- can change interval to any day
    DATEDIFF(NOW(), order_date) AS days_since_order,
    DATE_FORMAT(order_date, '%Y-%m-%d') AS formatted_date,
    DATE_TRUNC(order_date, MONTH) AS start_of_month -- can change it to week or day or year 
FROM orders;
