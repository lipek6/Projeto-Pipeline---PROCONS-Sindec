-- PARA RODAR ISSO AQUI: dbt run --select int_reclamacoes_preparadas


-- O nosso primeiro passo será guardar este modelo como uma 'view' ou 'table'
{{
    config(
        materialized='view'
    )
}}

WITH stg_reclamacoes AS (
    -- Importamos o modelo de staging unificado
    SELECT * FROM {{ ref('stg_reclamacoes_unificados') }} 
),

limpeza_e_padronizacao AS (
    SELECT
        -- 1. Descarte do 'anocalendario': 
        -- Em SQL, para eliminar uma coluna, basta não a colocar no SELECT.
        dataarquivamento,
        dataabertura,

        -- 2. Padronização do 'codigoregiao' (0X -> X):
        -- A função LTRIM remove caracteres específicos à esquerda. LTRIM('01', '0') resulta em '1'.
        LTRIM(codigoregiao, '0') AS codigoregiao,
        regiao,
        uf,
        strrazaosocial,
        strnomefantasia,
        tipo,
        numerocnpj,
        radicalcnpj,
        razaosocialrfb,
        nomefantasiarfb,
        cnaeprincipal,
        desccnaeprincipal,
        atendida,
        codigoassunto,
        descricaoassunto,
        codigoproblema,
        descricaoproblema,

        -- 3. Padronização do 'sexoconsumidor' (N ou Nulo -> OUTROS):
        CASE
            WHEN sexoconsumidor IS NULL OR UPPER(sexoconsumidor) = 'N' THEN 'OUTROS'
            ELSE UPPER(sexoconsumidor)
        END AS sexoconsumidor,

        -- 4. Padronização da 'faixaetariaconsumidor' (O dicionário replace do Pandas):
        CASE
            WHEN faixaetariaconsumidor = 'mais de 70 anos' THEN '70+'
            WHEN faixaetariaconsumidor = 'entre 61 a 70 anos' THEN '61 a 70'
            WHEN faixaetariaconsumidor = 'entre 51 a 60 anos' THEN '51 a 60'
            WHEN faixaetariaconsumidor = 'entre 41 a 50 anos' THEN '41 a 50'
            WHEN faixaetariaconsumidor = 'entre 31 a 40 anos' THEN '31 a 40'
            WHEN faixaetariaconsumidor = 'entre 21 a 30 anos' THEN '21 a 30'
            WHEN faixaetariaconsumidor IN ('até 20 anos', 'atÃ© 20 anos') THEN '0 a 20'
            WHEN faixaetariaconsumidor IN ('Nao Informada', 'Nao se aplica') THEN 'NAO INFORMADA'
            ELSE faixaetariaconsumidor
        END AS faixaetariaconsumidor,

        cepconsumidor,
        ano_origem

    FROM stg_reclamacoes

    -- 5. Limpeza Global de Ruídos e Edge Cases (O dropna do Pandas):
    -- No SQL, usamos a cláusula WHERE para filtrar apenas as linhas onde estas colunas não são nulas.
    WHERE
        codigoregiao IS NOT NULL
        AND regiao IS NOT NULL
        AND uf IS NOT NULL
        AND tipo IS NOT NULL
        AND atendida IS NOT NULL
        AND faixaetariaconsumidor IS NOT NULL
        AND dataabertura IS NOT NULL
        AND dataarquivamento IS NOT NULL
        AND codigoassunto IS NOT NULL
        AND descricaoassunto IS NOT NULL
)

SELECT * FROM limpeza_e_padronizacao