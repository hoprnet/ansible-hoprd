#!/bin/bash

# Load environment variables
export $(grep -v '^#' /etc/environment | xargs)

# Function to fetch data from Hopr API and format Prometheus metrics
fetch_hopr_data() {
  account_balance=$(curl -s --fail --show-error --max-time 10 \
    -H 'accept: application/json' \
    -H "X-Auth-Token: ${HOPRD_API_TOKEN}" \
    "http://hoprd:3001/api/v4/account/balances")
  if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch Hopr node balances"
    exit 1
  fi

  # Extract values
  safe_allowance=$(echo $account_balance | jq -r '.safeHoprAllowance' | sed 's/ wxHOPR//')
  safe_balance=$(echo $account_balance | jq -r '.safeHopr' | sed 's/ wxHOPR//')

  # Generate Prometheus formatted metrics
  echo "hopr_safe_allowance ${safe_allowance}"
  echo "hopr_safe_balance ${safe_balance}"
}


# Output the headers
echo "Content-Type: text/plain; charset=utf-8"
echo ""

# Output the metrics
echo "$(fetch_hopr_data)"
