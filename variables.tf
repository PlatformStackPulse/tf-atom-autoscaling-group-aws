variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "subnet_ids must contain at least one subnet."
  }
}

variable "launch_template_id" {
  description = "ID of the launch template"
  type        = string
  validation {
    condition     = length(var.launch_template_id) > 0
    error_message = "launch_template_id must not be empty."
  }
}

variable "launch_template_version" {
  description = "Version of the launch template"
  type        = string
  default     = "$Latest"
}

variable "health_check_type" {
  description = "Health check type (EC2 or ELB)"
  type        = string
  default     = "EC2"
  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "health_check_type must be EC2 or ELB."
  }
}

variable "health_check_grace_period" {
  description = "Grace period before health checks start (seconds)"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "List of target group ARNs to attach"
  type        = list(string)
  default     = []
}

variable "force_delete" {
  description = "Whether to force-delete the ASG"
  type        = bool
  default     = false
}

variable "instance_refresh_enabled" {
  description = "Whether to enable instance refresh on updates"
  type        = bool
  default     = true
}

variable "min_healthy_percentage" {
  description = "Minimum healthy percentage during instance refresh"
  type        = number
  default     = 90
}
