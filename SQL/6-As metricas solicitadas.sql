-- As 5 métricas por mês
WITH fs AS (
    SELECT
        DATE_FORMAT(c.`date`, '%Y-%m') AS month,
        SUM(fs.qty * fs.unit_price) AS revenue,
        -- Receita
        SUM(fs.qty * fs.discount) AS total_discount -- Desconto Total
    FROM
        livraria_dw.fact_sales fs
        JOIN livraria_dw.dim_calendar c USING (calendar_key)
    GROUP BY
        1
),
ot AS (
    -- pedidos totais no mês
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        COUNT(DISTINCT order_id) AS orders_total
    FROM
        livraria_stg.orders
    GROUP BY
        1
),
oc AS (
    -- pedidos completed no mês
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        COUNT(DISTINCT order_id) AS orders_completed
    FROM
        livraria_stg.orders
    WHERE
        status = 'completed'
    GROUP BY
        1
),
rc AS (
    -- pedidos completed com devolução no mês
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        COUNT(DISTINCT r.order_id) AS orders_with_return
    FROM
        livraria_stg.orders o
        JOIN livraria_stg.returns r ON r.order_id = o.order_id
    WHERE
        o.status = 'completed'
    GROUP BY
        1
)
SELECT
    ot.month,
    COALESCE(fs.revenue, 0) AS revenue,
    COALESCE(fs.total_discount, 0) AS total_discount,
    ROUND(
        COALESCE(fs.revenue, 0) / NULLIF(oc.orders_completed, 0),
        2
    ) AS avg_ticket,
    ROUND(
        100.0 * COALESCE(rc.orders_with_return, 0) / NULLIF(oc.orders_completed, 0),
        2
    ) AS return_rate_pct,
    ROUND(
        100.0 * COALESCE(oc.orders_completed, 0) / NULLIF(ot.orders_total, 0),
        2
    ) AS pct_completed
FROM
    ot
    LEFT JOIN fs ON fs.month = ot.month
    LEFT JOIN oc ON oc.month = ot.month
    LEFT JOIN rc ON rc.month = ot.month
ORDER BY
    ot.month;