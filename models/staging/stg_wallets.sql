select
  wallet_id,
  address,
  acquisition_channel,
  region
from {{ ref('seed_wallets') }}
