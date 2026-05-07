# ============================================
# SECURITY GROUPS
# Flux autorisés :
#   Internet      → ALB (port 80)
#   ALB           → Backend EC2 (port 5000)
#   Backend EC2   → RDS (port 3306)
#   Internet      → Frontend EC2 (port 80)
#   Votre IP      → Frontend EC2 (port 22 SSH)
# ============================================

# SG 1 : ALB
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-sg-alb"
  description = "ALB : HTTP depuis internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP entrant"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg-alb"
    Project = var.project_name
  }
}

# SG 2 : Backend EC2 (port 5000 depuis ALB uniquement)
resource "aws_security_group" "backend" {
  name        = "${var.project_name}-sg-backend"
  description = "Backend : port 5000 depuis ALB uniquement"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "API depuis ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg-backend"
    Project = var.project_name
  }
}

# SG 3 : RDS (port 3306 depuis backend uniquement)
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-sg-rds"
  description = "RDS MySQL : port 3306 depuis backend uniquement"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL depuis backend"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg-rds"
    Project = var.project_name
  }
}

# SG 4 : Frontend EC2
resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-sg-frontend"
  description = "Frontend : HTTP public + SSH depuis votre IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH depuis mon IP uniquement"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg-frontend"
    Project = var.project_name
  }
}