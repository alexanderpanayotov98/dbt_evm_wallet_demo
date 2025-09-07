with d as (select * from {{ ref('int_wallet_day') }})
, daily as (
  select
    event_date,
    sum(deposits) as deposits,
    sum(wagers)   as wagers,
    sum(payouts)  as payouts,
    sum(bonuses)  as bonuses,
    sum(wagers) - sum(payouts) as ggr,
    (sum(wagers) - sum(payouts)) - sum(bonuses) as ngr
  from d
  group by 1
)
, active_players as (
  select event_date, count(distinct wallet_id) as dau
  from {{ ref('stg_events') }}
  where event_type in ('wager','deposit')
  group by 1
)
select
  daily.event_date,
  daily.deposits,
  daily.wagers,
  daily.payouts,
  daily.bonuses,
  daily.ggr,
  daily.ngr,
  ap.dau,
  safe_divide(daily.ngr, ap.dau) as arpu
from daily
left join active_players ap using (event_date)
