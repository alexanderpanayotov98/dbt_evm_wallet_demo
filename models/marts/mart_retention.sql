with f as (select wallet_id, date(min(event_ts)) as cohort_date
           from {{ ref('stg_events') }}
           where event_type='deposit'
           group by 1),
     a as (select wallet_id, date(event_ts) as d
           from {{ ref('stg_events') }}
           where event_type='wager')
select
  f.cohort_date,
  a.d as activity_date,
  date_diff(a.d, f.cohort_date, day) as day_number,
  count(distinct a.wallet_id) as active_wallets
from f join a using(wallet_id)
where date_diff(a.d, f.cohort_date, day) between 0 and 28
group by 1,2,3
