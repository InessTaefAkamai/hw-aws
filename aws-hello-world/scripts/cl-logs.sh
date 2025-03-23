#!/bin/bash

# -------- Configuration --------
LOG_GROUP_NAME="/ecs/hello-world-cluster"
REGION="us-east-1"

# -------- Get latest log stream --------
LATEST_STREAM=$(aws logs describe-log-streams \
  --log-group-name "$LOG_GROUP_NAME" \
  --order-by LastEventTime \
  --descending \
  --limit 1 \
  --region "$REGION" \
  --query 'logStreams[0].logStreamName' \
  --output text)

if [[ "$LATEST_STREAM" == "None" || -z "$LATEST_STREAM" ]]; then
  echo "No log stream found in $LOG_GROUP_NAME"
  exit 1
fi

echo "Reading logs from stream: $LATEST_STREAM"
echo "-------------------------------------------"

# -------- Fetch logs --------
aws logs get-log-events \
  --log-group-name "$LOG_GROUP_NAME" \
  --log-stream-name "$LATEST_STREAM" \
  --region "$REGION" \
  --limit 50 \
  --query 'events[*].message' \
  --output text

