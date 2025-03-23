#!/bin/bash
set -e

# You must export these in your shell first (or replace below)
: "${AWS_ACCESS_KEY_ID:?Set AWS_ACCESS_KEY_ID first}"
: "${AWS_SECRET_ACCESS_KEY:?Set AWS_SECRET_ACCESS_KEY first}"
: "${AWS_DEFAULT_REGION:=us-east-1}"

docker run --rm -it \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  -v $(pwd):/workspace \
  -w /workspace \
  hashicorp/terraform:1.5.6 "$@"

