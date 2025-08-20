use livraria_dw;

-- fonte livraria_stg
-- Dim produto(product_id--> controle)
insert into
    dim_product(
        product_id,
        product_name,
        category,
        subcategory,
        cost,
        list_price
    )
select
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost,
    p.list_price
from
    livraria_stg.products p;

select
    *
from
    dim_product;

-- Dim localidade
insert into
    dim_location(city, state)
select
    distinct c.city,
    c.state
from
    livraria_stg.customers c on duplicate key
update
    city =
values
(city);

select
    *
from
    dim_location;

-- Dim cliente
INSERT INTO
    dim_customer (customer_id, signup_date, segment, location_key)
select
    c.customer_id,
    c.signup_date,
    c.segment,
    dl.location_key
from
    livraria_stg.customers c
    join livraria_dw.dim_location dl on dl.city = c.city
    and dl.state = c.state on duplicate key
update
    signup_date =
values
(signup_date),
    segment =
values
(segment),
    location_key =
values
(location_key);

select
    *
from
    dim_customer;

-- Dim Canal
insert into
    livraria_dw.dim_channel(channel)
select
    o.channel
from
    livraria_stg.orders o;

select
    *
from
    dim_channel;

-- Dim Calendario(Datas presentes nos pedidos)
insert into
    dim_calendar(`date`, ano, mes, yyyymm)
select
    distinct o.order_date,
    YEAR(o.order_date) as `year`,
    MONTH(o.order_date) as `month`,
    YEAR(o.order_date) * 100 + month(o.order_date) as yyyymm
from
    livraria_stg.orders o
where
    o.order_date is not null
order by
    o.order_date;

select
    *
from
    dim_calendar;