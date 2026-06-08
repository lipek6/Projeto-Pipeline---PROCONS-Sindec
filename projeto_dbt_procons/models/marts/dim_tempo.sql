{{
    config(
        materialized='table'
    )
}}

WITH distinct_tempo AS (
    SELECT DISTINCT
        dataabertura
    FROM {{ ref('stg_reclamacoes_limpo') }}
    WHERE dataabertura IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY dataabertura) AS id_tempo_sk,
    dataabertura,
    EXTRACT(DAY FROM dataabertura) AS dia,
    EXTRACT(MONTH FROM dataabertura) AS mes,
    EXTRACT(YEAR FROM dataabertura) AS ano,
    EXTRACT(QUARTER FROM dataabertura) AS trimestre,
    TO_CHAR(dataabertura, 'Day') AS dia_semana
FROM distinct_tempo