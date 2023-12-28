/* Check flow optimization*/

-- view tables
select * from checkout_actions;
select * from checkout_carts;



-- group all 3 queries to make a single table using subqueries
SELECT
    action_date,
    COALESCE(count_total_carts, 0) AS count_total_carts,
    COALESCE(count_total_checkout_attempts, 0) AS count_total_checkout_attempts,
    COALESCE(count_successful_checkout_attempts, 0) AS count_successful_checkout_attempts
FROM
    (
        SELECT action_date, COUNT(action_date) AS count_total_carts
        FROM checkout_carts
        WHERE action_date BETWEEN '2022-07-01' and '2023-01-31'
        GROUP BY action_date
    ) carts
LEFT JOIN
    (
		SELECT ca.action_date, count(ca.action_name) AS count_total_checkout_attempts 
        FROM checkout_carts cc
		LEFT JOIN checkout_actions ca ON ca.user_id = cc.user_id
		WHERE ca.action_name LIKE '%checkout%' 
		GROUP BY ca.action_date
    ) attempts
USING (action_date)
LEFT JOIN
    (
        SELECT cc.action_date, COUNT(ca.action_name) AS count_successful_checkout_attempts
        FROM checkout_carts cc
		LEFT JOIN checkout_actions ca ON ca.user_id = cc.user_id
        WHERE ca.action_name LIKE '%success%'
        GROUP BY cc.action_date
    ) successful_attempts
USING (action_date)
WHERE action_date BETWEEN '2022-07-01' and '2023-01-31'
ORDER BY action_date;

-- checkout_errors
SELECT * FROM checkout_actions
WHERE action_name LIKE '%fail%'
AND action_date BETWEEN '2022-07-01' and '2023-01-31'
ORDER BY action_date;

