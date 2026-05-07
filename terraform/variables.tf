# ============================================
# VARIABLES — Paramètres de l'infrastructure
# ============================================

variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Préfixe pour nommer toutes les ressources"
  type        = string
  default     = "taskmanager"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Nom de la paire de clés SSH dans AWS"
  type        = string
  default     = "taskmanager-key"
}

variable "public_key_path" {
  description = "Chemin vers la clé publique SSH"
  type        = string
  default     = "../taskmanager-key.pub"
}

variable "private_key_path" {
  description = "Chemin vers la clé privée SSH"
  type        = string
  default     = "../taskmanager-key"
}

variable "my_ip" {
  description = "Votre IP publique pour le SSH (format : x.x.x.x/32)"
  type        = string
}

variable "app_port" {
  description = "Port du backend Node.js"
  type        = number
  default     = 5000
}

variable "github_repo" {
  description = "URL de votre dépôt GitHub"
  type        = string
}

# ── Variables RDS ──

variable "db_name" {
  description = "Nom de la base de données"
  type        = string
  default     = "myapp"
}

variable "db_username" {
  description = "Nom d'utilisateur RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Mot de passe RDS"
  type        = string
  sensitive   = true
}