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
        -- 1.2 Conversão do tipo das datas em formatos diferentes (mixed) para YYYY-MM-DD 00:00:00
        CASE
            WHEN dataarquivamento ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+$'
                THEN dataarquivamento::timestamp
            WHEN dataarquivamento ~ '^\d{2}/\d{2}/\d{4} \d{2}:\d{2}$'
                THEN to_timestamp(dataarquivamento, 'DD/MM/YYYY HH24:MI')
            ELSE NULL
        END AS dataarquivamento,

        CASE
            WHEN dataabertura ~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+$'
                THEN dataabertura::timestamp
            WHEN dataabertura ~ '^\d{2}/\d{2}/\d{4} \d{2}:\d{2}$'
                THEN to_timestamp(dataabertura, 'DD/MM/YYYY HH24:MI')
            ELSE NULL
        END AS dataabertura,

        -- 2. Padronização do 'codigoregiao' (0X -> X):
        -- A função LTRIM remove caracteres específicos à esquerda.
        CASE
            WHEN LTRIM(codigoregiao, '0') ~ '^-?\d+$'
                THEN LTRIM(codigoregiao, '0')::bigint
            ELSE NULL
        END AS codigoregiao,

        regiao,
        uf,
        strrazaosocial,
        strnomefantasia,

        -- Conversão para inteiro
        CASE
            WHEN tipo ~ '^-?\d+$'
                THEN tipo::bigint
            ELSE NULL
        END AS tipo,

        numerocnpj,
        radicalcnpj,
        razaosocialrfb,
        nomefantasiarfb,
        cnaeprincipal,
        desccnaeprincipal,
        atendida,

        -- Conversão para inteiro
        CASE
            WHEN codigoassunto ~ '^-?\d+$'
                THEN codigoassunto::bigint
            ELSE NULL
        END AS codigoassunto,

        descricaoassunto,

        -- Conversão para inteiro
        CASE
            WHEN codigoproblema ~ '^-?\d+$'
                THEN codigoproblema::bigint
            ELSE NULL
        END AS codigoproblema,

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

        -- Conversão para inteiro
        CASE
            WHEN ano_origem ~ '^-?\d+$'
                THEN ano_origem::bigint
            ELSE NULL
        END AS ano_origem

    FROM stg_reclamacoes

    -- 5. Limpeza Global de Ruídos e Edge Cases
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