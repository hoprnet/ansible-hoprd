#!/bin/sh

# Validate required environment variables
if [ -z "${HOPRD_API_TOKEN}" ]; then
  echo "Error: HOPRD_API_TOKEN is not set"
  exit 1
fi

if [ -z "${HOPRD_PROMETHEUS_PUSHGATEWAY_KEY}" ]; then
  echo "Error: HOPRD_PROMETHEUS_PUSHGATEWAY_KEY is not set. Get it from Bitwarden Secret "Prometheus Pushgateway Hoprd Node""
  exit 1
fi

HOPRD_PROMETHEUS_PUSHGATEWAY_URL="${1}"
if [ -z "${HOPRD_PROMETHEUS_PUSHGATEWAY_URL}" ]; then
  echo "Error: HOPRD_PROMETHEUS_PUSHGATEWAY_URL argument is required"
  exit 1
fi

# Install required packages
apt update && apt install -y curl jq 2>&1 > /dev/null

# Run the loop
while true; do
  echo Publishing metrics ...
  # Add timeout and retry with backoff
  if ! metrics=$(curl -s --max-time 10 -H "X-Auth-Token: ${HOPRD_API_TOKEN}" "http://hoprd:3001/api/v3/node/metrics"); then
    echo "Error: Failed to fetch metrics from Hoprd API"
  fi

  if ! account_balance=$(curl -s --max-time 10 -H 'accept: application/json' -H "X-Auth-Token: ${HOPRD_API_TOKEN}" "http://hoprd:3001/api/v3/account/balances"); then
    echo "Error: Failed to fetch Hopr node balances"
  fi
  safe_allowance=$(echo $account_balance | jq -r '.safeHoprAllowance')
  safe_balance=$(echo $account_balance | jq -r '.safeHopr')

  # Append the new metric entry
  metrics+="\nhopr_safe_allowance ${safe_allowance}"
  metrics+="\nhopr_safe_balance ${safe_balance}"

  # Push metrics with timeout
  if ! echo "${metrics}" | curl -s --max-time 10 -u ${HOPRD_PROMETHEUS_PUSHGATEWAY_KEY} --data-binary @- "${HOPRD_PROMETHEUS_PUSHGATEWAY_URL}"; then
    echo "Error: Failed to push metrics to ${HOPRD_PROMETHEUS_PUSHGATEWAY_URL}"
  fi
  sleep 15

done