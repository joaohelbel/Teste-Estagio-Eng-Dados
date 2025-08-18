import pandas as pd

#Carregar arquivos

customers = pd.read_csv("customers.csv")
orders = pd.read_csv("orders.csv")
order_items = pd.read_csv("order_items.csv")
products = pd.read_csv("products.csv")
payments = pd.read_csv("payments.csv")
returns = pd.read_csv("returns.csv")

#Teste
print(customers.head())
print(orders.head())
