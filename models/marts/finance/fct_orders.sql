WITH orders as (
    SELECT *
    FROM {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    SELECT *
    FROM {{ ref('stg_stripe__payments') }}
),
order_payments as (
    SELECT order_id,
           SUM(CASE WHEN status='success' THEN amount END) as amount
    FROM payments
    GROUP BY 1
),
final as (
    SELECT o.order_id,
           o.customer_id,
           o.order_date,
           coalesce(p.amount,0) as amount
    FROM orders o 
    LEFT JOIN order_payments p
    using (order_id)
)

SELECT *
FROM final