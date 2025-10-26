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

variable "ecr_url" {
  default     = ""
  type        = string
  description = "URL do ECR"
}

variable "db_name" {
  default     = ""
  type        = string
  description = "Nome do DB"
}

variable "db_user" {
  default     = ""
  type        = string
  description = "Usuário do DB"
}

variable "db_pass" {
  default     = ""
  type        = string
  description = "Senha do DB"
}

variable "app_image_tag" {
  default     = ""
  type        = string
  description = "Tag da imagem"
}

