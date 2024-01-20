with source as(
    select * from {{source('stripe','payment')}}
),

payments as(
    select 
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        case
            when payment_method in ('stripe','paypal','credit_card','gift_card') then 'credit'
            else 'cash'
        end as payment_type,
        status as payment_status,
        amount as amount_cents,
        amount/100.0 as amount,
        case 
            when payment_status='success' then true
            else false
        end as is_completed_payment,
        date_trunc('day',created) as created_date,
        created::timestamp_ltz as created_at
    from source

)

select * from payments

