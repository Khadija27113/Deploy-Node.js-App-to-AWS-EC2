# ============================================
# FRONTEND — EC2 publique avec nginx
# ============================================

resource "aws_instance" "frontend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  user_data = base64encode(
    templatefile("${path.module}/user_data_frontend.sh", {
      github_repo  = var.github_repo
      alb_dns_name = aws_lb.main.dns_name
      app_port     = var.app_port
    })
  )

  tags = {
    Name    = "${var.project_name}-frontend"
    Project = var.project_name
  }

  depends_on = [aws_lb.main]
}