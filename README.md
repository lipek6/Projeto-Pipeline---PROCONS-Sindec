# ⚖️ Pipeline de Dados: Reclamações Fundamentadas PROCONS - Sindec

> **Projeto da disciplina de Banco de Dados (2026.1) - CIn/UFPE**

Este projeto implementa e compara duas arquiteturas fundamentais de Engenharia de Dados — **ETL Clássico** e **ELT Moderno** — para processar, higienizar e modelar dados públicos do Cadastro Nacional de Reclamações Fundamentadas. 

O diferencial deste projeto é a construção de um Data Warehouse modelado em **Esquema Estrela (Star Schema)**, transformando registros brutos em uma base otimizada para análises e geração de insights sobre os direitos do consumidor no Brasil.

[Relatório do projeto](https://docs.google.com/document/d/1CEC-qFgPMvfstR0rMVG1PqwhZJ5EF8Lbp4vXveIZ3nE/edit?usp=sharing)
[Repositório de referência](https://github.com/victorluizz/Projeto-Pipeline-Vacina-o-Recife.git)

---

## 🎯 Objetivo e Fonte de Dados

O principal propósito é integrar bases de dados de anos consecutivos (2009 - 2024) para criar um recurso robusto de comparações temporais.

* **Tema:** Cadastro Nacional de Reclamações Fundamentadas (PROCONS - Sindec)
* **Fonte:** [Dados Abertos - Ministério da Justiça e Segurança Pública](https://dados.mj.gov.br/dataset/cadastro-nacional-de-reclamacoes-fundamentadas-procons-sindec)
* **O que são os dados:** O Sindec é um sistema que integra processos relativos ao atendimento aos consumidores nos Procons, documentando empresas reclamadas, problemas relatados e resoluções.

## 🏗️ Arquitetura da Solução (Em desenvolvimento)

Para atender aos requisitos do projeto, utilizaremos o ambiente **Google Colab** para orquestrar os processos. O projeto será dividido em duas abordagens comparativas:

### 1. Abordagem ETL (Extração, Transformação e Carga)
* **Extração:** Leitura dos arquivos diretamente da fonte.
* **Transformação:** Limpeza, padronização e estruturação das dimensões/fatos feitas em memória utilizando Python (Pandas) no Colab.
* **Carga:** Inserção dos dados já modelados no Banco de Dados final.

### 2. Abordagem ELT (Extração, Carga e Transformação)
* **Extração e Carga (EL):** Carregamento dos dados brutos diretamente para o Banco de Dados.
* **Transformação (T):** Utilização de scripts SQL dentro do banco de dados (orquestrados via Colab) para limpar os dados e montar o Esquema Estrela.

---

## ⭐ Modelagem de Dados Inicial (Esquema Estrela)

O modelo dimensional será estruturado da seguinte forma (sujeito a alterações durante a análise exploratória):

| Tabela | Tipo | Descrição |
| :--- | :--- | :--- |
| **`fato_reclamacao`** | **Fato** | Registro central de cada reclamação fundamentada (Métricas, status de resolução e chaves estrangeiras). |
| **`dim_consumidor`** | Dimensão | Perfil demográfico de quem abriu a reclamação (Faixa etária, Sexo). |
| **`dim_fornecedor`** | Dimensão | Dados da empresa acionada (Nome, Segmento de mercado). |
| **`dim_problema`** | Dimensão | Detalhamento do assunto e o tipo de problema relatado. |
| **`dim_localidade`** | Dimensão | Informações geográficas do Procon onde a reclamação foi registrada (Estado, Região). |
| **`dim_tempo`** | Dimensão | Calendário detalhado da data de abertura/finalização da reclamação. |

---

## 🛠️ Tecnologias Utilizadas

  *  **Python 3.10+**: Scripting e manipulação de dados (Pandas).
  *  **PostgreSQL**: Data Warehouse.
  * **Git/GitHub**: Versionamento de código.

-----


## 📂 Estrutura do Repositório

```text
.
├── dados_brutos/                 # Amostras de dados ou dicionários
├── docs/                         # Dicionário de dados, diagramas Draw.io e Relatório Final
├── notebooks/
│   ├── ETL_Pipeline.ipynb        # Script completo do pipeline ETL em Python (Pandas)
│   └── ELT_Pipeline.ipynb        # Script de extração bruta e transformações em SQL
└── README.md

```

## 🚀 Como Executar

### Pré-requisitos

- Python 3.12+
- PostgreSQL 16 instalado e rodando localmente
- pgAdmin 4 (interface visual do banco)
- VS Code com a extensão Jupyter
- Git

### Passo 1: Clonar o repositório e configurar o ambiente

```bash
git clone <url-do-repositorio>
cd Projeto-Pipeline---PROCONS-Sindec
python3 -m venv .venv
source .venv/bin/activate  # Linux/Mac
# ou
.venv\Scripts\activate     # Windows
pip install ipykernel sqlalchemy psycopg2-binary pandas openpyxl
```

### Passo 2: Configurar o PostgreSQL

Crie o banco de dados `procons_sindec` no pgAdmin ou via terminal:

```bash
# Linux
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres psql -c "CREATE DATABASE procons_sindec;"
```

As credenciais esperadas pelo projeto são:

| Campo    | Valor            |
|----------|------------------|
| Host     | `localhost`      |
| Port     | `5432`           |
| Database | `procons_sindec` |
| Username | `postgres`       |
| Password | `postgres`       |

### Passo 3: Executar o pipeline ETL

Abra o notebook `notebooks/ETL_Pipeline_PROCONS_Sindec.ipynb` no VS Code, selecione o kernel `.venv` e execute todas as células em ordem. O pipeline irá:

1. Extrair e unificar os 16 arquivos CSV/XLSX (2009–2024)
2. Aplicar limpeza, padronização e conversão de tipos
3. Modelar o Esquema Estrela em memória
4. Carregar as tabelas dimensão e fato no PostgreSQL

### Passo 4: Executar o pipeline ELT

Execute o notebook `notebooks/ELT_Pipeline_PROCONS_Sindec.ipynb` para carregar os dados brutos no banco. Em seguida, rode o dbt:

```bash
cd projeto_dbt_procons
dbt debug    # valida conexão — tudo deve retornar verde
dbt run      # materializa stg_reclamacoes_unificados e int_reclamacoes_preparadas
```

> **Nota:** Os dados brutos devem estar na pasta `dados_brutos/` com os nomes `CNRF_2009.csv` ... `CNRF_2024.xlsx` antes de executar qualquer pipeline.

---

## 📊 Resultados e Insights

Com o Data Warehouse carregado no PostgreSQL, foram realizadas três análises de Business Intelligence sobre as tabelas fato e dimensão:

**1. Tempo médio de resolução das reclamações**
Em média, uma reclamação formal leva **226,10 dias** (~7,5 meses) para ser arquivada. Esse número revela um gargalo sistêmico na resolução de conflitos de consumo no Brasil: mesmo após abertura formal de processo administrativo, o consumidor enfrenta uma espera prolongada.

**2. Região com maior volume de reclamações em 2020**
O **Sudeste** liderou com **3.901 reclamações** registradas em 2020. O dado é esperado pela densidade populacional da região, mas levanta uma questão relevante: o número reflete maior ocorrência de conflitos ou maior acesso e cultura de uso dos Procons? Um cruzamento per capita revelaria se outras regiões são proporcionalmente mais afetadas.

**3. Distribuição por faixa etária em 2021**
A faixa de **31 a 40 anos** concentrou o maior volume de reclamações (1.615), seguida de 41 a 50 (1.509). Chama atenção a presença expressiva de consumidores entre 61 e 70 anos (1.500) — superior à faixa de 21 a 30 (1.046) — sugerindo que consumidores mais velhos encontram mais dificuldades na resolução direta com fornecedores ou são mais propensos a formalizar reclamações.
