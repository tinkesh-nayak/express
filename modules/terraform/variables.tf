variable "aws_region" {
  description = "The AWS region to create Resources"
  default     = "ap-south-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "ecsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "ubuntu"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect for Nodejs"
  default     = 3000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}