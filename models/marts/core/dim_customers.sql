WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),
customer_orders_payments as (
    select 
        customer_id,
        sum(orders.amount) AS lifetime_value
    from orders
    LEFT JOIN customers USING (customer_id)
    group by customer_id  
),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_orders_payments.lifetime_value, 0) as lifetime_value
    from customers

    left join customer_orders using (customer_id)
    left join customer_orders_payments using (customer_id)

)

select * from final