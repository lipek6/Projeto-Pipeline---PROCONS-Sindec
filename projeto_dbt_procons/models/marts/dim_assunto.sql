{{
    config(
        materialized='table'
    )
}}

WITH distinct_assunto AS (
    SELECT DISTINCT
        codigoassunto,
        descricaoassunto
    FROM {{ ref('stg_reclamacoes_limpo') }}
    WHERE codigoassunto IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY codigoassunto, descricaoassunto) AS id_assunto_sk,
    codigoassunto,
    descricaoassunto
FROM distinct_assunto