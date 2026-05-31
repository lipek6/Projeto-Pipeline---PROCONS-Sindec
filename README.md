# ⚖️ Pipeline de Dados: Reclamações Fundamentadas PROCONS - Sindec

> **Projeto da disciplina de Banco de Dados (2026.1) - CIn/UFPE**

Este projeto implementa e compara duas arquiteturas fundamentais de Engenharia de Dados — **ETL Clássico** e **ELT Moderno** — para processar, higienizar e modelar dados públicos do Cadastro Nacional de Reclamações Fundamentadas. 

O diferencial deste projeto é a construção de um Data Warehouse modelado em **Esquema Estrela (Star Schema)**, transformando registros brutos em uma base otimizada para análises e geração de insights sobre os direitos do consumidor no Brasil.

[Relatório do projeto](https://docs.google.com/document/d/1CEC-qFgPMvfstR0rMVG1PqwhZJ5EF8Lbp4vXveIZ3nE/edit?usp=sharing)

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
| **`NOME_TABELA`** | **TIPO** | DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO. |
| **`NOME_TABELA`** | TIPO | DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO. |
| **`NOME_TABELA`** | TIPO | DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO. |
| **`NOME_TABELA`** | TIPO | DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO. |
| **`NOME_TABELA`** | TIPO | DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO. |
| **`NOME_TABELA`** | TIPO | DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO DESCRIÇÃO. |

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

### Passo 1: 

-----

## 📊 Resultados e Insights


> **Nota sobre a Qualidade dos Dados:**