-- models/marts/mart_wallet_funnel.sql
{{ config(materialized='table') }}

with f as (select * from {{ ref('int_firsts') }}),
     w as (select * from {{ ref('stg_wallets') }})
select
  w.wallet_id,
  w.acquisition_channel,
  w.region,
  f.first_deposit_ts,
  f.first_wager_ts,
  case when f.first_deposit_ts is not null then 1 else 0 end as deposited,
  case when f.first_wager_ts  is not null then 1 else 0 end as wagered,
  case when f.first_wager_ts is not null and f.first_wager_ts >= f.first_deposit_ts then 1 else 0 end as converted
from w
left join f using (wallet_id)
