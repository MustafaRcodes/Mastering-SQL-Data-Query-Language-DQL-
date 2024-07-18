/* below function with 
GROUP BY 
HAVING
DISTINCT
*/
SELECT
website_session_id,
YEAR(created_at) AS year,
WEEK(created_at) AS week,
MIN(DATE(created_at)) AS week_start_date,
MAX(product_page) AS product_made_it,
COUNT(DISTINCT website_session_id) AS sessions,
AVG(DISTINCT order_id) AS avg_orders,
STDDEV(order_id) AS stddev_orders
FROM website_sessions
GROUP BY 
     website_session_id,
     YEAR(created_at),
     WEEK(created_at);