with payments as (
    select *
    FROM {{ ref('stg_stripe__payments') }}
)
SELECT order_id,
       SUM(amount) as total_amount
FROM payments
GROUP BY order_id
HAVING total_amount<0