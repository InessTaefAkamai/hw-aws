variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  default = "hello-world-cluster"
}

variable "container_name" {
  default = "hello-world"
}

variable "container_port" {
  default = 80
}

variable "image_url" {
  default = "431887213634.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest"
}
variable "ecr_repo_name" {
  default = "hello-world"
}
