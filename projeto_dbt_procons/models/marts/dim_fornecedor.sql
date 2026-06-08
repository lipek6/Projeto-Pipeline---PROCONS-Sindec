{{
    config(
        materialized='table'
    )
}}

WITH distinct_fornecedor AS (
    SELECT DISTINCT
        numerocnpj,
        radicalcnpj,
        razaosocialrfb,
        nomefantasiarfb,
        cnaeprincipal,
        desccnaeprincipal
    FROM {{ ref('stg_reclamacoes_limpo') }}
    WHERE numerocnpj IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY numerocnpj, radicalcnpj, razaosocialrfb, nomefantasiarfb) AS id_fornecedor_sk,
    numerocnpj,
    radicalcnpj,
    razaosocialrfb,
    nomefantasiarfb,
    cnaeprincipal,
    desccnaeprincipal
FROM distinct_fornecedor