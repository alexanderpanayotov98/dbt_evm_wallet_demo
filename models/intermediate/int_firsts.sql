with e as (select * from {{ ref('stg_events') }})
select
  wallet_id,
  min(case when event_type='deposit' then event_ts end) as first_deposit_ts,
  min(case when event_type='wager'   then event_ts end) as first_wager_ts
from e
group by 1
