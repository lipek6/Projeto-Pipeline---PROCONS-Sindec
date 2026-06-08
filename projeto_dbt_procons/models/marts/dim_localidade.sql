{{
    config(
        materialized='table'
    )
}}

WITH distinct_localidade AS (
    SELECT DISTINCT
        codigoregiao,
        regiao,
        uf,
        cepconsumidor
    FROM {{ ref('stg_reclamacoes_limpo') }}
    WHERE codigoregiao IS NOT NULL
      AND regiao IS NOT NULL
      AND uf IS NOT NULL
      AND cepconsumidor IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY codigoregiao, regiao, uf, cepconsumidor) AS id_localidade_sk,
    codigoregiao,
    regiao,
    uf,
    cepconsumidor
FROM distinct_localidade;
