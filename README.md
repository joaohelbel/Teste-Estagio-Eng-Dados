# Teste Estágio Engenharia de Dados

Este projeto implementa um **Data Warehouse** baseado em dados de uma livraria online, com pipeline de ingestão, transformação (Python + Pandas), modelagem dimensional em **MySQL** e visualização em **Power BI**.

---

## 📂 Estrutura do Projeto

```
TESTE-ESTAGIO-ENG-DADOS/
│
├── Dashboard/
│   ├── image.png                # Preview do dashboard
│   └── Visualização.pbix        # Arquivo do Power BI
│
├── Data/                        # Dados de origem (CSV)
│   ├── 1Dados.py                 # Script de ingestão
│   ├── customers.csv
│   ├── order_items.csv
│   ├── orders.csv
│   ├── payments.csv
│   ├── products.csv
│   └── returns.csv
│
├── Diagram/
│   └── Star-Schema.png          # Modelo dimensional (Star Schema)
│
├── Questões/                    # Respostas teóricas
│   ├── Interpretação de codigo SQL
│   ├── Python (pandas)
│   └── Questões objetivas
│
├── SQL/                         # Scripts SQL
│   ├── 1-Criando dataset STG.sql
│   ├── 2-Livraria data warehouse.sql
│   ├── 3-Populando as dims.sql
│   ├── 4-Populando a fato.sql
│   ├── 5-Returns_snapshot.sql
│   ├── 6-As metricas solicitadas.sql
│   └── 7-Consultas analíticas.sql
│
├── venv/                        # Ambiente virtual Python
│
├── LICENSE
└── README.md
```

---

## 🚀 Como Rodar o Projeto

### 1. Criar ambiente Python
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate   # Windows
pip install -r requirements.txt
```

### 2. Executar pipeline de ingestão/limpeza
```bash
python Data/1Dados.py
```

### 3. Executar os scripts SQL na ordem:
1. `1-Criando dataset STG.sql`  
2. `2-Livraria data warehouse.sql`  
3. `3-Populando as dims.sql`  
4. `4-Populando a fato.sql`  
5. `5-Returns_snapshot.sql`  
6. `6-As metricas solicitadas.sql`  
7. `7-Consultas analíticas.sql`  

### 4. Abrir dashboard no Power BI
Arquivo: `Dashboard/Visualização.pbix`

---

## 📊 Modelo Dimensional

- **Fato:** `fato_vendas` (grão: item do pedido concluído)
- **Dimensões:**
  - `dim_cliente`
  - `dim_localidade`
  - `dim_produto`
  - `dim_canal`
  - `dim_calendario`

**Métricas principais**
- Receita 
- Descontos 
- Ticket médio 
- Pedidos 
- % Devoluções 

---

## 🛠 Tecnologias Utilizadas
- **Python (pandas, mysql-connector-python)**
- **MySQL 8**
- **Power BI Desktop**
- **VS Code**

---

## 👤 Autor
João Pedro Helbel
