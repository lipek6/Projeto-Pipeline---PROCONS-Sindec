# 🚀 Guia de Continuação: Pipeline ELT (Fase Final)

A base estrutural do nosso projeto ELT está validada. Já extraímos os dados brutos de 2009 a 2024 para o PostgreSQL e criamos as primeiras camadas de transformação utilizando o **dbt**.

O nosso modelo intermediário (`int_reclamacoes_preparadas`) já está limpo, com os nulos filtrados e as regras de negócio de padronização (Faixa Etária, Sexo, Região) aplicadas via SQL. Esse é o arquivo que reune todos os dados de 2009 à 2024

Agora, precisamos definir os tipos de dados de cada coluna, finalizar a Modelagem Dimensional (Esquema Estrela) em SQL/dbt e puxarmos os insights (que servem tanto para o ELT e o ETL).

---

## ⚙️ Como rodar o projeto na sua máquina

Antes de começarem a codar as novas tabelas, vocês precisam garantir que o ambiente local de vocês consegue rodar o que já está pronto.

1. **Baixem o repositório** (`git pull`).
2. **Ativem o ambiente virtual** (`source .venv/bin/activate` ou `.venv\\Scripts\\activate`).
3. **Naveguem para a pasta do dbt:**
   ```bash
   cd projeto_dbt_procons

4. Verifiquem a conexão com o banco local:
`dbt debug`
(Tudo deve retornar verde. Se der erro, chequem o arquivo ~/.dbt/profiles.yml de vocês).

5. Rodem os modelos atuais:
`dbt run`
Isso vai criar as views stg_reclamacoes_unificados e int_reclamacoes_preparadas no pgAdmin de vocês.

## 🎯 Missões:
Vamos repetir os mesmos passos que fizemos no ETL, com exceção da missão de setup do postgreSQL e carregamento dos dados no banco, uma vez que isso já é feito diretamente aqui.

## 📊 Missão importante:

Com o Esquema Estrela montado (basta dar um dbt run final para materializar a Fato e as Dimensões no banco), o projeto exige três análises de negócio.

Comecem a pensar em queries SQL que respondam a perguntas do tipo:

    Qual o perfil de consumidor (Idade/Sexo) que mais tem reclamações não atendidas?

    Quais são as empresas (Radical CNPJ) campeãs de reclamações e quais os principais problemas reportados sobre elas?

    Há alguma região (UF) com um tempo médio de arquivamento muito superior ao resto do país?

Qualquer dúvida sobre as regras aplicadas na Staging, chamem aqui.