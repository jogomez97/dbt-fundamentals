
WITH payments AS (
    SELECT
        id AS payment_id,
        orderid AS order_id,
        paymentmethod AS payment_method,
        status,
        -- convert cents to usd
        amount / 100 as amount,
        created AS created_date
    
    FROM raw.stripe.payment
)
SELECT * FROM payments