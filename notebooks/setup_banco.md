# 🐘 Setup do Banco de Dados (Missão 2)

Guia para configurar o PostgreSQL e conectar o notebook ETL ao banco de dados local.

---

## Pré-requisitos

- Python 3.12+
- VS Code com a extensão Jupyter

---

## 1. Instalar o PostgreSQL

### Linux (Ubuntu 22.04+ / 24.04)

```bash
sudo apt install postgresql postgresql-contrib
```

Verifique se o serviço está rodando:

```bash
sudo systemctl status postgresql
```

### Windows

1. Acesse https://www.postgresql.org/download/windows/
2. Baixe o instalador do **PostgreSQL 16**
3. Execute o instalador e siga os passos:
   - Mantenha a porta padrão **5432**
   - Quando pedir senha do superusuário, coloque `postgres`
   - Pode desmarcar o Stack Builder no final

---

## 2. Definir a senha do usuário `postgres`

### Linux

```bash
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
```

### Windows

A senha já foi definida durante a instalação. Se precisar redefinir, abra o **SQL Shell (psql)** que foi instalado junto e rode:

```sql
ALTER USER postgres PASSWORD 'postgres';
```

---

## 3. Instalar o pgAdmin 4 (interface visual)

### Linux

Adicione o repositório oficial e instale:

```bash
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

sudo apt update

sudo apt install pgadmin4
```

### Windows

O pgAdmin 4 já vem incluído no instalador do PostgreSQL. Caso não tenha instalado, baixe em https://www.pgadmin.org/download/pgadmin-4-windows/

---

## 4. Criar o banco de dados pelo pgAdmin

1. Abra o pgAdmin 4
2. Clique com botão direito em **Servers → Register → Server**
3. Preencha:
   - **Aba General → Name:** `PROCON` (ou qualquer nome)
   - **Aba Connection → Host:** `localhost`
   - **Aba Connection → Port:** `5432`
   - **Aba Connection → Username:** `postgres`
   - **Aba Connection → Password:** `postgres`
   - Ative **Save password?**
4. Clique em **Save**
5. Com o servidor conectado, clique com botão direito em **Databases → Create → Database**
6. **Database name:** `procons_sindec`
7. Clique em **Save**

---

## 5. Configurar o ambiente Python

### Linux

Na raiz do projeto, crie e ative o ambiente virtual:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### Windows

```bash
python -m venv .venv
.venv\Scripts\activate
```

### Instalar as dependências (Linux e Windows)

Com o venv ativado:

```bash
pip install ipykernel sqlalchemy psycopg2-binary
python -m ipykernel install --user --name=.venv
```

No VS Code, selecione o kernel `.venv` no canto superior direito do notebook.

---

## 6. Testar a conexão

No notebook `ETL_Pipeline_PROCONS_Sindec.ipynb`, rode a célula abaixo para validar a conexão:

```python
from sqlalchemy import create_engine, text

engine = create_engine(
    "postgresql+psycopg2://postgres:postgres@localhost:5432/procons_sindec"
)

with engine.connect() as conn:
    result = conn.execute(text("SELECT 1"))
    print("Conexão OK!", result.fetchone())
```

Se retornar `Conexão OK! (1,)`, o ambiente está pronto para as próximas missões.

---

## Resumo das credenciais

| Campo    | Valor            |
|----------|------------------|
| Host     | `localhost`      |
| Port     | `5432`           |
| Database | `procons_sindec` |
| Username | `postgres`       |
| Password | `postgres`       |