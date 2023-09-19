
-- Data Deduplication
{{ config(materialized='view') }}

with src as (
	select * from {{ ref('int_finance__integrated') }}
),

interested_in_items as (
    select * from src
    where purchase_item in ('CHN-VAL', 'CHN-VAL-1YR')
),

not_interested_in_items as (
    select * from src
    where purchase_item not in ('CHN-VAL', 'CHN-VAL-1YR')
),

ranked as (
    select
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id, purchase_item, DATE_TRUNC('month', invoice_date) ORDER BY paid_on DESC) as rn
    from interested_in_items
),

deduped as (
    select
        rkd.customer_id,
        rkd.invoice_number,
        rkd.entity_type,
        rkd.purchase_item,
        rkd.unit_price,
        rkd.quantity,
        rkd.amount,
        rkd.paid_on,
        rkd.invoice_date
    from ranked as rkd
    where 
      (purchase_item = 'CHN-VAL' and rn = 1)
      or (purchase_item != 'CHN-VAL')
)

select * from deduped
union all (select * from not_interested_in_items)
