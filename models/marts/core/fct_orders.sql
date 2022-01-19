WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
),
final AS (
    SELECT
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        payments.amount
    FROM orders
    LEFT JOIN payments USING (order_id)
)
SELECT * FROM final