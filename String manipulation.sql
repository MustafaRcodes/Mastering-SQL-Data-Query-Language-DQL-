SELECT 
    user_id,
    CONCAT(UPPER(first_name), ' ', LOWER(last_name)) AS formatted_name,
    REPLACE(email, '@example.com', '@newdomain.com') AS updated_email,
    REVERSE(first_name) AS reversed_first_name,
    TRIM(first_name) AS trimmed_first_name,
    LENGTH(email) AS email_length,
    STR_TO_DATE('31,12,2024', '%d,%m,%Y') AS formatted_date
FROM users
WHERE email LIKE '%@example.com';
