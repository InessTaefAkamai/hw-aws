variable "cluster_name" {}
variable "container_name" {}
variable "container_port" {}
variable "image_url" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "ecs_security_group" {}
