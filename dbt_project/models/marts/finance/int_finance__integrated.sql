-- Data Integration intermediate step

{{ config(materialized='view') }}

with line_items as (
	select * from {{ ref('stg_finance__line_items') }}
),
invoices as (
	select * from {{ ref('stg_finance__invoices') }}
),

combined as (
	select

        li.customer_id,
        li.invoice_number,
        li.entity_type,
        li.purchase_item,
        li.unit_price,
        li.quantity,
        inv.amount,
        inv.paid_on,
        inv.invoice_date

	from invoices as inv
      left join line_items as li using(invoice_number)
)

select * from combined
