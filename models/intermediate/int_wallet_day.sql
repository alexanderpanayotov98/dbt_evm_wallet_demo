{{ config(materialized='incremental', unique_key='wallet_id||event_date') }}
with e as (select * from {{ ref('stg_events') }})
select
  wallet_id,
  event_date,
  sum(case when event_type='deposit' then amount else 0 end) as deposits,
  sum(case when event_type='wager'   then amount else 0 end) as wagers,
  sum(case when event_type='payout'  then amount else 0 end) as payouts,
  sum(case when event_type='bonus'   then amount else 0 end) as bonuses,
  countif(event_type='wager') as bets
from e
{% if is_incremental() %}
where event_date >= date_sub(current_date(), interval 7 day)
{% endif %}
group by 1,2
