INSERT INTO
  livraria_dw.fact_sales (
    customer_key,
    product_key,
    calendar_key,
    channel_key,
    qty,
    unit_price,
    discount,
    gross_amount,
    discount_amount,
    net_amount
  )
SELECT
  dc.customer_key,
  dp.product_key,
  dcal.calendar_key,
  dch.channel_key,
  oi.qty,
  oi.unit_price,
  oi.discount,
  (oi.qty * oi.unit_price) AS gross_amount,
  (oi.qty * oi.discount) AS discount_amount,
  (oi.qty * oi.unit_price) - (oi.qty * oi.discount) AS net_amount
FROM
  livraria_stg.order_items oi
  JOIN livraria_stg.orders o ON o.order_id = oi.order_id
  JOIN livraria_dw.dim_product dp ON dp.product_id = oi.product_id
  JOIN livraria_dw.dim_customer dc ON dc.customer_id = o.customer_id
  JOIN livraria_dw.dim_calendar dcal ON dcal.`date` = o.order_date
  JOIN livraria_dw.dim_channel dch ON dch.channel = (o.channel)
WHERE
  o.status = 'completed';

select
  *
from
  fact_sales;