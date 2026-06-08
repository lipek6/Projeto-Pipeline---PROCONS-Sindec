{{
    config(
        materialized='table'
    )
}}

WITH distinct_problema AS (
    SELECT DISTINCT
        codigoproblema,
        descricaoproblema
    FROM {{ ref('stg_reclamacoes_limpo') }}
    WHERE codigoproblema IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY codigoproblema, descricaoproblema) AS id_problema_sk,
    codigoproblema,
    descricaoproblema
FROM distinct_problema