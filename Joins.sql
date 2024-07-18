-- LEFT JOIN (Returns all record from LEFT table and any matched record from the RIGHT table) -- 

SELECT DISTINCT
    -- website_session_id,
    website_pageviews.pageview_url,
    COUNT(DISTINCT website_pageviews.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_pageviews.website_session_id) AS viewed_product_to_order_rate
FROM  website_pageviews
   LEFT JOIN orders
     ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2013-02-01' AND '2013-03-01'
GROUP BY  1;

-- INNER JOIN (Returns records that match in both tables) -- 

SELECT 
    time_period,
    cart_session_id,
    order_id,
    items_purchased,
    price_usd
FROM  sessions_seeing_cart
     INNER JOIN orders
        ON sessions_seeing_cart.cart_session_id = orders.website_session_id;
        
-- MULTIPLE LEFT JOIN --

SELECT 
    sessions_seeing_cart.time_period,
    sessions_seeing_cart.cart_session_id,
    CASE WHEN cart_sessions_seeing_another_page.cart_session_id IS NULL THEN 0 ELSE 1 END AS clicked_to_another_page,
    CASE WHEN pre_post_sessions_orders.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
    pre_post_sessions_orders.items_purchased,
    pre_post_sessions_orders.price_usd
FROM sessions_seeing_cart
	LEFT JOIN cart_sessions_seeing_another_page -- (or inner join)
       ON sessions_seeing_cart.cart_session_id = cart_sessions_seeing_another_page.cart_session_id
	LEFT JOIN pre_post_sessions_orders -- (or inner join)
       ON sessions_seeing_cart.cart_session_id = pre_post_sessions_orders.cart_session_id;
       
-- CONDITIONAL JOIN -- 

SELECT 
   sessions_seeing_cart.time_period,
   sessions_seeing_cart.cart_session_id,
   MIN(website_pageviews.website_pageview_id) AS pv_id_after_cart
FROM sessions_seeing_cart
   LEFT JOIN website_pageviews
     ON website_pageviews.website_session_id = sessions_seeing_cart.cart_session_id
     AND website_pageviews.website_pageview_id > sessions_seeing_cart.cart_pageview_id
GROUP BY 
    sessions_seeing_cart.time_period,
    sessions_seeing_cart.cart_session_id
HAVING 
     MIN(website_pageviews.website_pageview_id) IS NOT NULL;