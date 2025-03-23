#!/bin/bash
set -e

# Determine project root directory (parent of this script's directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DOCKER_CONTEXT_DIR="$PROJECT_ROOT/docker"

AWS_REGION="us-east-1"
REPO_NAME="hello-world"
REPO_URL="431887213634.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"

echo "Building Docker image for platform: linux/amd64"
docker buildx build --platform linux/amd64 -t "${REPO_URL}:latest" "${DOCKER_CONTEXT_DIR}" --load

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${REPO_URL}"

echo "Pushing image to ECR..."
docker push "${REPO_URL}:latest"

echo "Done! Image pushed successfully: ${REPO_URL}:latest"
