-- Main Query with various data transformations and conditional logic
SELECT 
    o.order_id,
    o.customer_id,
    c.customer_name,
    p.product_name,
    p.price,
    COALESCE(p.discount_price, p.price) AS final_price,
    CAST(o.order_date AS DATE) AS formatted_order_date,
    CASE 
        WHEN p.price > 100 THEN 'Expensive'
        WHEN p.price > 50 THEN 'Moderate'
        ELSE 'Cheap'
    END AS price_category,
    IFNULL(p.discount_price, 0) AS discount_price_if_null,
    IFF(p.price > 100, 'Expensive', 'Affordable') AS price_label,
    LISTAGG(c.customer_name, ', ') WITHIN GROUP (ORDER BY c.customer_name) OVER (PARTITION BY o.customer_id) AS customer_list,
    CAST(p.price AS double precision) AS price_double
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE o.order_date IS NOT NULL
GROUP BY 
    o.order_id, 
    o.customer_id, 
    c.customer_name, 
    p.product_name, 
    p.price, 
    p.discount_price, 
    o.order_date;

-- EXCEPT: Get products that are in stock but not on sale
SELECT product_id, product_name FROM products_in_stock
EXCEPT
SELECT product_id, product_name FROM products_on_sale;

-- UNION: Combine customers and suppliers (removing duplicates)
SELECT customer_id, customer_name FROM customers
UNION
SELECT supplier_id AS customer_id, supplier_name AS customer_name FROM suppliers;

-- UNION ALL: Combine customers and suppliers (including duplicates)
SELECT customer_id, customer_name FROM customers
UNION ALL
SELECT supplier_id AS customer_id, supplier_name AS customer_name FROM suppliers;

-- INTERSECT: Get customers who have placed orders and are also listed in a special promotion
SELECT customer_id FROM orders
INTERSECT
SELECT customer_id FROM special_promotion;

-- MINUS: Get customers who have made purchases but are not in the VIP list
SELECT customer_id FROM orders
MINUS
SELECT customer_id FROM vip_customers;
