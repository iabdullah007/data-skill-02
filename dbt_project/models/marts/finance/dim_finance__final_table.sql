-- Final table
{{ config(materialized='table') }}

with src as (
	select * from {{ ref('int_finance__purchased_priorization') }}
),

interested_in as (
	select * from src where purchase_item = 'CHN-VAL-1YR'
),

not_interested_in as (
	select *, paid_on as expire_on from src where purchase_item != 'CHN-VAL-1YR'
),

with_expire_on as (
    select
        *,
        generate_series(paid_on, paid_on + INTERVAL '11 months', INTERVAL '1 month') as expire_on
    from interested_in
)

select * from with_expire_on
    union all (select * from not_interested_in)
