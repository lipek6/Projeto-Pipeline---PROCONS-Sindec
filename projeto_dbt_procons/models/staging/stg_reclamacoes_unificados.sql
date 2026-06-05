-- PARA RODAR ISSO AQUI: dbt run --select stg_reclamacoes_unificados

select
    *,
    '2009' as ano_origem 

from {{ source('dados_brutos_procon', 'raw_procons_2009') }}

union all

select
    *,
    '2010' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2010') }}

union all

select
    *,
    '2011' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2011') }}

union all

select
    *,
    '2012' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2012') }}

union all

select
    *,
    '2013' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2013') }}

union all

select
    *,
    '2014' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2014') }}

union all

select
    *,
    '2015' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2015') }}

union all

select
    *,
    '2016' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2016') }}

union all

select
    *,
    '2017' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2017') }}

union all

select
    *,
    '2018' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2018') }}

union all

select
    *,
    '2019' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2019') }}

union all

select
    *,
    '2020' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2020') }}

union all

select
    *,
    '2021' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2021') }}

union all

select
    *,
    '2022' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2022') }}

union all

select
    *,
    '2023' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2023') }}

union all

select
    *,
    '2024' as ano_origem
from {{ source('dados_brutos_procon', 'raw_procons_2024') }}