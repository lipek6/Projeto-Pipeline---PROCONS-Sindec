## Inicializando o DBT 

Os comandos utilizados serão executados no **terminal** . Vocês podem executar no próprio terminal do **VS Code** com a pasta do projeto aberta. 

É importante ter o **PostgreSQL** instalado e rodando. 

## Passo a passo: 

## 1. Instalando o DBT 

pip install "dbt-core<1.9" "dbt-postgres<1.9"

## 2. Iniciando o projeto 

dbt init nome_projeto 

Basicamente, após executar esse comando, ele vai perguntar qual database você quer usar. Só selecionar a opção do **PostgreSQL** . Feito isso, ele criará as pastas que mencionei (models, staging, marts, etc) 


## 3. Credenciamento 

Agora, você vai inserir a senha e o endereço do Postgre. Caso você não lembre qual configurou, você pode encontrar em: C:\Users\NomeDoUsuario\.dbt\profiles.yml 

## 4. Testando a conexão 

Nessa etapa, tente navegar até a pasta do projeto, caso não esteja. Depois de entrar nela, rode esse comando: 

dbt debug 

Isso vai checar se o Python ta ok, se as pastas estão ok e tentar acessar o Postgre. Se aparecer algo dizendo que tudo passou em verde, então, ta tudo correto. 

## 5. Começando a brincadeira 

Para rodar o projeto inteiro: 

dbt run 

Para rodar só um modelo especifico: 

dbt run --select nome_modelo 

