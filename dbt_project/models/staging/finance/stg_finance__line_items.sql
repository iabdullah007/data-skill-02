with src as (
    select * from {{ ref('LineItems') }}
),

transformed as (
    select
        "Customer Id" as customer_id,
        "Invoice Number" as invoice_number,
        "Entity Type" AS entity_type,
        "Purchase Item" AS purchase_item,
        "Unit Price" as unit_price,
        "Quantity" as quantity
    from src
)

select * from transformed
