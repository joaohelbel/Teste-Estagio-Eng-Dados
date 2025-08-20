import pandas as pd
from sqlalchemy import create_engine, text

customers = pd.read_csv("customers.csv", encoding="utf-8")
orders = pd.read_csv("orders.csv", encoding="utf-8")
order_items = pd.read_csv("order_items.csv", encoding="utf-8")
products = pd.read_csv("products.csv", encoding="utf-8")
payments = pd.read_csv("payments.csv", encoding="utf-8")
returns = pd.read_csv("returns.csv", encoding="utf-8")

engine = create_engine("mysql+mysqlconnector://root:root@localhost:3306/livraria_stg?charset=utf8mb4")

# Garante que a base está em utf8mb4
with engine.begin() as conn:
    conn.execute(text("SET NAMES utf8mb4"))
    conn.execute(text("ALTER DATABASE livraria_stg CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci"))

# Exporta: escolha "replace" na primeira carga
customers.to_sql("customers", con=engine, if_exists="replace", index=False)
orders.to_sql("orders", con=engine, if_exists="replace", index=False)
order_items.to_sql("order_items", con=engine, if_exists="replace", index=False)
products.to_sql("products", con=engine, if_exists="replace", index=False)
payments.to_sql("payments", con=engine, if_exists="replace", index=False)
returns.to_sql("returns", con=engine, if_exists="replace", index=False)

print("Carga concluída ✅")