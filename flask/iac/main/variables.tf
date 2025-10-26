variable "aws_profile" {
  default     = ""
  type        = string
  description = "Usuário da AWS"
}

variable "aws_region" {
  default     = ""
  type        = string
  description = "Região da AWS"
}

variable "api_name" {
  default     = ""
  type        = string
  description = "Nome da APi"
}

variable "api_port" {
  default     = 8080
  type        = number
  description = "Porta da APi"
}