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
    row_number() OVER (ORDER BY dataabertura)::INT AS id_tempo_sk,
    dataabertura::timestamp AS dataabertura,
    EXTRACT(DAY FROM dataabertura)::INT AS dia,
    EXTRACT(MONTH FROM dataabertura)::INT AS mes,
    EXTRACT(YEAR FROM dataabertura)::INT AS ano,
    EXTRACT(QUARTER FROM dataabertura)::INT AS trimestre,
    CASE EXTRACT(DOW FROM dataabertura)::INT
        WHEN 0 THEN 'domingo'
        WHEN 1 THEN 'segunda-feira'
        WHEN 2 THEN 'terça-feira'
        WHEN 3 THEN 'quarta-feira'
        WHEN 4 THEN 'quinta-feira'
        WHEN 5 THEN 'sexta-feira'
        WHEN 6 THEN 'sábado'
    END AS dia_semana
FROM distinct_tempo