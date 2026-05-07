# ============================================
# OUTPUTS — URLs et infos affichées après apply
# ============================================

output "frontend_url" {
  description = "URL du Task Manager (ouvrez dans votre navigateur)"
  value       = "http://${aws_instance.frontend.public_ip}"
}

output "alb_dns_name" {
  description = "URL de l'API backend (via ALB)"
  value       = "http://${aws_lb.main.dns_name}"
}

output "health_check_url" {
  description = "Vérifier que l'API répond"
  value       = "http://${aws_lb.main.dns_name}/health"
}

output "frontend_public_ip" {
  description = "IP publique du frontend"
  value       = aws_instance.frontend.public_ip
}

output "rds_endpoint" {
  description = "Endpoint de la base de données RDS"
  value       = aws_db_instance.main.address
}

output "ssh_frontend" {
  description = "Commande SSH pour accéder au frontend"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.frontend.public_ip}"
}

output "asg_name" {
  description = "Nom de l'Auto Scaling Group"
  value       = aws_autoscaling_group.backend.name
}