variable "aws_region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "prod-eks-rabi"
}

variable "kubernetes_version" {
  default = "1.33"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "desired_nodes" {
  default = 2
}

variable "min_nodes" {
  default = 2
}

variable "max_nodes" {
  default = 3
}

