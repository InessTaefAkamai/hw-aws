#!/bin/bash
set -e

CMD=$1
if [[ -z "$CMD" ]]; then
  echo "Usage: ./run-terraform.sh [init|plan|apply|destroy|output]"
  exit 1
fi

echo "🔧 Running Terraform $CMD..."

cd "$(dirname "$0")/.."

export TF_VAR_image_url="431887213634.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest"

case "$CMD" in
  init)
    terraform init
    ;;
  plan)
    terraform plan
    ;;
  apply)
    terraform apply -auto-approve
    ;;
  destroy)
    terraform destroy -auto-approve
    ;;
  output)
    terraform output
    ;;
  *)
    echo "❌ Unknown command: $CMD"
    exit 1
    ;;
esac
