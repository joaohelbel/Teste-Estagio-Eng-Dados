CREATE DATABASE IF NOT EXISTS Livraria_stg
	DEFAULT CHARACTER SET utf8mb4
	DEFAULT COLLATE utf8mb4_general_ci;
USE livraria_stg;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id INT,
  signup_date DATE,
  segment VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(50)
);


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id    INT,
  customer_id INT,
  order_date  DATE,
  channel     VARCHAR(50),
  status      VARCHAR(20),
  city        VARCHAR(100),
  state       VARCHAR(50)
);

DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
  order_id   INT,
  product_id INT,
  qty        INT,
  unit_price DECIMAL(12,2),
  discount   DECIMAL(12,2)
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_id   INT,
  product_name VARCHAR(255),
  category     VARCHAR(100),
  subcategory  VARCHAR(100),
  cost         DECIMAL(12,2),
  list_price   DECIMAL(12,2)
);

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
  order_id       INT,
  payment_method VARCHAR(50),
  amount         DECIMAL(12,2),
  paid_date      DATE
);

-- Return com "_" pois pode conflitar palavras-chaves
-- em clientes.
DROP TABLE IF EXISTS returns_;
CREATE TABLE returns (
  order_id    INT,
  return_date DATE,
  reason      VARCHAR(255)
);

