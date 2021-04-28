variable "api_name" {
  default = "devops_assignment"  
}

variable "throttling_rate_limit"{
    default = 1000
}

variable "throttling_burst_limit"{
    default = 500
}

variable "logging_level" {
    default = "INFO"
}

variable "table_name" {
  default = "assignment_messages"
}

variable "cloudwatch_role" {}
variable "lambda_invoke_arn" {}
# ---------------------------------------------------------------------------
# Variables: CORS-related
# ---------------------------------------------------------------------------

# var.allow_headers
variable "allow_headers" {
  description = "Allow headers"
  type        = list(string)

  default = [
    "Authorization",
    "Content-Type",
    "X-Amz-Date",
    "X-Amz-Security-Token",
    "X-Api-Key",
  ]
}

# var.allow_methods
variable "allow_methods" {
  description = "Allow methods"
  type        = list(string)

  default = [
    "OPTIONS",
    "POST"
  ]
}

# var.allow_origin
variable "allow_origin" {
  description = "Allow origin"
  type        = string
  default     = "*"
}

# var.allow_max_age
variable "allow_max_age" {
  description = "Allow response caching time"
  type        = string
  default     = "7200"
}

# var.allowed_credentials
variable "allow_credentials" {
  description = "Allow credentials"
  default     = false
}