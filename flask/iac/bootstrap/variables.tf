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

variable "oidc_provider" {
  default     = ""
  type        = string
  description = "URL do provedor OIDC"
}

variable "oidc_client" {
  default     = ""
  type        = string
  description = "URL do client OIDC"
}
