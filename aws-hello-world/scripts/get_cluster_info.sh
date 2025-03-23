#!/bin/bash

# ----------- CONFIG ----------- #
CLUSTER_NAME="hello-world-cluster"
SERVICE_NAME="ecs-service"
LOG_GROUP="/ecs/$CLUSTER_NAME"
REGION="us-east-1"
# ------------------------------ #

echo "Checking tasks for ECS service: $SERVICE_NAME on cluster: $CLUSTER_NAME..."

# Get Task ARN
TASK_ARN=$(aws ecs list-tasks \
  --cluster "$CLUSTER_NAME" \
  --service-name "$SERVICE_NAME" \
  --query 'taskArns[0]' \
  --output text)

if [[ -z "$TASK_ARN" || "$TASK_ARN" == "None" ]]; then
  echo "No running tasks found for service $SERVICE_NAME."
  exit 1
fi

echo "Found Task: $TASK_ARN"

# Describe the Task
echo -e "\n Task Description:"
aws ecs describe-tasks \
  --cluster "$CLUSTER_NAME" \
  --tasks "$TASK_ARN" \
  --region "$REGION" \
  --query 'tasks[0].{LastStatus: lastStatus, DesiredStatus: desiredStatus, TaskDefinitionArn: taskDefinitionArn, Containers: containers}'

# Extract Log Stream Name
LOG_STREAM=$(aws ecs describe-tasks \
  --cluster "$CLUSTER_NAME" \
  --tasks "$TASK_ARN" \
  --region "$REGION" \
  --query 'tasks[0].containers[0].logConfiguration.options."awslogs-stream-prefix"' \
  --output text)

if [[ -z "$LOG_STREAM" || "$LOG_STREAM" == "None" ]]; then
  echo "No log stream prefix found. Skipping log fetch."
  exit 1
fi

echo "Looking for log stream with prefix: $LOG_STREAM"

# Get actual stream name
STREAM_NAME=$(aws logs describe-log-streams \
  --log-group-name "$LOG_GROUP" \
  --region "$REGION" \
  --query "logStreams[?starts_with(logStreamName, '$LOG_STREAM')].logStreamName" \
  --output text | head -n 1)

if [[ -z "$STREAM_NAME" ]]; then
  echo "No log stream found in $LOG_GROUP with prefix $LOG_STREAM"
  exit 1
fi

echo "Log Stream: $STREAM_NAME"

# Print logs
echo -e "\n Logs from $LOG_GROUP:"
aws logs get-log-events \
  --log-group-name "$LOG_GROUP" \
  --log-stream-name "$STREAM_NAME" \
  --region "$REGION" \
  --limit 50 \
  --query 'events[*].message' \
  --output text
