
with customers as (

    select * from {{ref('stg_customers')}}

),

orders as (

    select * from {{ref('stg_orders')}}

),

payments as (
    select * from {{ref("stg_payment")}}
),

order_payments as (
    select
        orders.*,
        payments.amount as amount
    from orders
    left join payments using(order_id)
    where payments.payment_status='success'
    
),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(distinct order_id) as number_of_orders,
        sum(amount) as total_spent

    from order_payments


    group by 1

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_orders.total_spent,0)

    from customers

    left join customer_orders using (customer_id)

)

select * from final