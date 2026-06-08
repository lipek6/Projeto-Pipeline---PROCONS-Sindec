{{
    config(
        materialized='table'
    )
}}

WITH distinct_consumidor AS (
    SELECT DISTINCT
        sexoconsumidor,
        faixaetariaconsumidor
    FROM {{ ref('stg_reclamacoes_limpo') }}
    WHERE sexoconsumidor IS NOT NULL
      AND faixaetariaconsumidor IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY sexoconsumidor, faixaetariaconsumidor) AS id_consumidor_sk,
    sexoconsumidor,
    faixaetariaconsumidor
FROM distinct_consumidor;
