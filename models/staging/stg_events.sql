select
  wallet_id,
  timestamp(ts) as event_ts,
  date(ts) as event_date,
  lower(event_type) as event_type,
  upper(token) as token,
  cast(amount as numeric) as amount,
  bonus_id,
  tx_hash
from {{ ref('seed_events') }}
