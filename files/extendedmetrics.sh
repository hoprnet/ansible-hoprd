#!/bin/bash

# Validate required environment variables
if [ -z "${HOPRD_API_TOKEN}" ]; then
  echo "Error: HOPRD_API_TOKEN is not set"
  exit 1
fi

# Install required packages
apt update && apt install -y curl jq netcat-traditional > /dev/null 2>&1

# Function to fetch data from Hopr API and format Prometheus metrics
fetch_hopr_data() {
  account_balance=$(curl -s --max-time 10 -H 'accept: application/json' -H "X-Auth-Token: ${HOPRD_API_TOKEN}" "http://hoprd:3001/api/v3/account/balances")
  if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch Hopr node balances"
    exit 1
  fi

  # Extract values
  safe_allowance=$(echo $account_balance | jq -r '.safeHoprAllowance')
  safe_balance=$(echo $account_balance | jq -r '.safeHopr')

  # Generate Prometheus formatted metrics
  echo -e "hopr_safe_allowance ${safe_allowance}"
  echo -e "hopr_safe_balance ${safe_balance}"
}

# HTTP server loop (listens on port 8080)
while true; do
  # Listen for incoming requests on port 8080
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n$(fetch_hopr_data)" | nc -l -p 8080 -q 1
done
