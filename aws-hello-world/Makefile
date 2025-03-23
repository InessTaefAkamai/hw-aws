# Makefile in project root
REPO_NAME=hello-world
AWS_REGION=us-east-1
REPO_URL=431887213634.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}
DOCKER_CONTEXT=./docker

.PHONY: build push login all

all: build push

build:
	@echo "Building Docker image for platform: linux/amd64"
	docker buildx build --platform linux/amd64 -t ${REPO_URL}:latest ${DOCKER_CONTEXT} --load

login:
	@echo "Logging in to Amazon ECR..."
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPO_URL}

push: login
	@echo "Pushing Docker image to ECR..."
	docker push ${REPO_URL}:latest
	@echo "Done! Image pushed: ${REPO_URL}:latest"

