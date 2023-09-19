with src as (
    select * from {{ ref('Invoices') }}
),

transformed as (
    select
        "Invoice Number" as invoice_number,
        "Invoice Date" AS invoice_date,
        "Amount" AS amount,
        "Paid On" as paid_on
    from src
)

select * from transformed
