variable "region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "nginx-app"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "desired_count" {
  default = 1
}

variable "container_port" {
  default = 80
}

variable "image_url" {
  description = "Docker image URL with tag"
  type        = string
}

