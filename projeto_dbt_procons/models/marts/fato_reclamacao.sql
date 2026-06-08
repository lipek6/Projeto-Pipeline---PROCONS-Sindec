{{
    config(
        materialized='table'
    )
}}

WITH stg AS (
    SELECT * FROM {{ ref('stg_reclamacoes_limpo') }}
)

SELECT
    c.id_consumidor_sk,
    f.id_fornecedor_sk,
    a.id_assunto_sk,
    p.id_problema_sk,
    l.id_localidade_sk,
    t.id_tempo_sk,
    stg.atendida,
    stg.ano_origem,
    EXTRACT(EPOCH FROM (stg.dataarquivamento - stg.dataabertura)) / 86400.0 AS dias_abertura_arquivamento
FROM stg
LEFT JOIN {{ ref('dim_consumidor') }} c USING (sexoconsumidor, faixaetariaconsumidor)
LEFT JOIN {{ ref('dim_fornecedor') }} f USING (numerocnpj, radicalcnpj, razaosocialrfb, nomefantasiarfb)
LEFT JOIN {{ ref('dim_assunto') }} a USING (codigoassunto, descricaoassunto)
LEFT JOIN {{ ref('dim_problema') }} p USING (codigoproblema, descricaoproblema)
LEFT JOIN {{ ref('dim_localidade') }} l USING (codigoregiao, regiao, uf, cepconsumidor)
LEFT JOIN {{ ref('dim_tempo') }} t USING (dataabertura)