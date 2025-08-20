-- Consultas analíticas:
-- Receita mensal e variação vs mês anterior
SELECT
    DATE_FORMAT(c.`date`, '%Y-%m') AS month,
    SUM(fs.qty * fs.unit_price) AS revenue,
    LAG(SUM(fs.qty * fs.unit_price)) OVER (
        ORDER BY
            MIN(c.`date`)
    ) AS prev_revenue,
    ROUND(
        100.0 * (
            SUM(fs.qty * fs.unit_price) - LAG(SUM(fs.qty * fs.unit_price)) OVER (
                ORDER BY
                    MIN(c.`date`)
            )
        ) / NULLIF(
            LAG(SUM(fs.qty * fs.unit_price)) OVER (
                ORDER BY
                    MIN(c.`date`)
            ),
            0
        ),
        2
    ) AS mom_growth_pct
FROM
    livraria_dw.fact_sales fs
    JOIN livraria_dw.dim_calendar c USING (calendar_key)
GROUP BY
    DATE_FORMAT(c.`date`, '%Y-%m')
ORDER BY
    month;

-- Top 10 produtos por Receita no período (filtrável por canal)
SET
    @from = '2024-01-01',
    @to = '2024-12-31',
    @channel := null;

-- <-- adicionar o filtro conforme desejado
SELECT
    dp.product_name,
    SUM(fs.qty * fs.unit_price) AS revenue
FROM
    livraria_dw.fact_sales fs
    JOIN livraria_dw.dim_product dp USING (product_key)
    JOIN livraria_dw.dim_calendar c USING (calendar_key)
    JOIN livraria_dw.dim_channel ch USING (channel_key)
WHERE
    c.`date` BETWEEN @from
    AND @to
    AND (
        @channel IS NULL
        OR ch.channel = @channel
    )
GROUP BY
    dp.product_name
ORDER BY
    revenue DESC
LIMIT
    10;

-- Mapa (tabela) Receita por Estado e % participação
SELECT
    dl.state,
    SUM(fs.qty * fs.unit_price) AS revenue,
    ROUND(
        100.0 * SUM(fs.qty * fs.unit_price) / NULLIF(SUM(SUM(fs.qty * fs.unit_price)) OVER (), 0),
        2
    ) AS pct_share
FROM
    livraria_dw.fact_sales fs
    JOIN livraria_dw.dim_customer dc USING (customer_key)
    JOIN livraria_dw.dim_location dl ON dl.location_key = dc.location_key
GROUP BY
    dl.state
ORDER BY
    revenue DESC;

-- Ticket Médio por Canal e tendência mensal
WITH rev AS (
    -- receita por mês e canal (da fato = completed)
    SELECT
        DATE_FORMAT(c.`date`, '%Y-%m') AS month,
        ch.channel,
        SUM(fs.qty * fs.unit_price) AS revenue
    FROM
        livraria_dw.fact_sales fs
        JOIN livraria_dw.dim_calendar c USING (calendar_key)
        JOIN livraria_dw.dim_channel ch USING (channel_key)
    GROUP BY
        1,
        2
),
orders AS (
    -- pedidos completed por mês e canal
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        UPPER(TRIM(channel)) AS channel,
        COUNT(DISTINCT order_id) AS orders_completed
    FROM
        livraria_stg.orders
    WHERE
        status = 'completed'
    GROUP BY
        1,
        2
)
SELECT
    r.month,
    r.channel,
    ROUND(r.revenue / NULLIF(o.orders_completed, 0), 2) AS avg_ticket
FROM
    rev r
    JOIN orders o ON o.month = r.month
    AND o.channel = r.channel
ORDER BY
    r.month,
    r.channel;

-- Taxa de devolução por Categoria e mês
WITH base AS (
    -- pedidos completed por mês × categoria
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        p.category,
        o.order_id
    FROM
        livraria_stg.orders o
        JOIN livraria_stg.order_items oi ON oi.order_id = o.order_id
        JOIN livraria_stg.products p ON p.product_id = oi.product_id
    WHERE
        o.status = 'completed'
    GROUP BY
        1,
        2,
        3
),
ret AS (
    SELECT
        DISTINCT order_id
    FROM
        livraria_stg.returns
)
SELECT
    b.month,
    b.category,
    ROUND(
        100.0 * COUNT(
            DISTINCT CASE
                WHEN r.order_id IS NOT NULL THEN b.order_id
            END
        ) / NULLIF(COUNT(DISTINCT b.order_id), 0),
        2
    ) AS return_rate_pct
FROM
    base b
    LEFT JOIN ret r ON r.order_id = b.order_id
GROUP BY
    b.month,
    b.category
ORDER BY
    b.month,
    return_rate_pct DESC;

-- algo que poderia ser viavel seria habilitar o MySql event scheduler criando eventos diarios
-- que roda um .sql com cargas.
-- Exemplo via MySQL Event Scheduler (diário às 06:00)
-- CREATE EVENT IF NOT EXISTS ev_daily_quality_checks
-- ON SCHEDULE EVERY 1 DAY STARTS TIMESTAMP(CURRENT_DATE, '06:00:00')
-- DO
-- CALL run_quality_checks();