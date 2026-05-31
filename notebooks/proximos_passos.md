# 🚀 Guia de Continuação: Pipeline ETL (Fase 2)

A primeira fase de **Extração (E)** e **Limpeza Estrutural** dos dados do PROCON (2009-2024) já está pronta no notebook. Conseguimos juntar os 16 arquivos, tratar os vazamentos de colunas, resolver problemas de encoding e padronizar textos (Regiões, Sexo e Faixa Etária). 

Atualmente, temos um *DataFrame* único (`df_final`) com cerca de 1.8 milhão de linhas válidas, mas todas as colunas estão como "texto puro" (`dtype=str`). 

Abaixo estão as próximas metas para finalizarmos o pipeline ETL em direção ao nosso Esquema Estrela.

---

## 🎯 Missão 1: Conversão de Tipos (Data Casting)
Para evitar que o Pandas travasse na extração, tudo foi lido como texto. Agora precisamos converter os dados para os tipos corretos antes de enviá-los ao Banco de Dados:
- **Datas (`datetime`):** Converter `dataarquivamento` e `dataabertura`. Precisamos garantir que o formato fique `YYYY-MM-DD`.
- **Numéricos (`int`):** Converter códigos como `codigoregiao`, `codigoassunto`, `codigoproblema`, `tipo`, etc.
- *Dica:* Usem a função `pd.to_datetime()` e o método `.astype()` do Pandas.

## 🐘 Missão 2: Setup do Banco de Dados (PostgreSQL)
Precisamos de um banco de dados relacional para receber o nosso Data Warehouse.
- **Opção Local:** Instalar o PostgreSQL e o pgAdmin na máquina de quem for rodar o notebook final.
- **Conexão:** Precisaremos instalar a biblioteca `SQLAlchemy` e o driver `psycopg2` no Python/Colab para criar a *engine* de conexão entre o nosso código e o Postgres.

## ⭐ Missão 3: Quebra da Base (Modelagem Dimensional)
O nosso `df_final` é gigante e redundante. Precisamos fatiá-lo para criar o **Esquema Estrela** definido no nosso projeto. Vocês vão usar o Pandas para criar novos DataFrames removendo as duplicatas (`.drop_duplicates()`) e gerando Chaves Primárias (IDs artificiais/Surrogate Keys) para cada dimensão.

As tabelas que ***(eu acho que)*** precisamos extrair são:
1. `dim_consumidor` (sexo, faixa etária)
2. `dim_fornecedor` (usar os dados com sufixo 'rfb' e o 'radicalcnpj', ignorando as 'str')
3. `dim_problema` e `dim_assunto` (códigos e descrições do que houve)
4. `dim_localidade` (região, uf, cep)
5. `dim_tempo` (uma tabela gerada a partir das datas, com colunas para Ano, Mês, Trimestre, Dia da Semana).
6. **`fato_reclamacao`:** A tabela central! Ela deve conter apenas os IDs que conectam com as dimensões acima e os dados do evento (ex: flag de `atendida`, tempo entre abertura e arquivamento).

## 📤 Missão 4: Carga (Load)
Com as Dimensões e a Tabela Fato separadas em DataFrames diferentes, a missão é enviá-las para o PostgreSQL.
- *Dica:* Usem a função `df.to_sql('nome_da_tabela', con=engine, if_exists='replace', index=False)` respeitando a ordem de criação (primeiro carrega as Dimensões, depois a Fato por causa das chaves estrangeiras).

## 💡 Missão 5: Análises e Insights
O documento do projeto exige a **"Apresentação de Três Análises e Insights"**. Com o Data Warehouse pronto no Postgres, já podemos começar a rascunhar queries SQL ou usar ferramentas de BI (PowerBI/Metabase) para descobrir coisas como:
1. *Qual segmento de mercado tem o menor índice de resolução ("atendida = N")?*
2. *Existe alguma correlação entre a faixa etária do consumidor e o tipo de problema reportado?*
3. *Como o volume de reclamações fundamentadas oscilou entre 2009 e 2024?*

## AVISOS: Documentem
- Lembrem de sempre deixar, seja lá o que fizerem, muito, MUITO bem documentado e organizado, porque a gente realmente precisa que todo mundo possa entender tudo do trabalho e a gente ainda vai apresentar esse repositório. A documentação é o próprio notebook `ETL_Pipeline_PROCONS_Sindec.ipynb` e o documento [Relatório do projeto](https://docs.google.com/document/d/1CEC-qFgPMvfstR0rMVG1PqwhZJ5EF8Lbp4vXveIZ3nE/edit?usp=sharing) disponível também no `README.md`.

- Também lembrem de dar umas olhadas no notebook `reference.ipynb` disponibilizado pelo monitor e copiado aqui na pasta `notebooks`. Deve ajudar vocês à produzir as suas partes do trabalho.
 
- Criem uma branch nova para o que cada um for fazer e depois abram PR para a main.


Qualquer dúvida sobre como a limpeza inicial foi feita ou sobre o dicionário de variáveis, é só falar