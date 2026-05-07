#!/bin/bash
set -e

# ── Mise à jour et installation de nginx ──
apt update -y
apt install -y nginx git

# ── Cloner le repo ──
cd /tmp
git clone ${github_repo} frontend-app

# ── Copier le frontend dans nginx ──
cp -r /tmp/frontend-app/frontend/* /var/www/html/

# ── Remplacer l'URL localhost par le DNS de l'ALB ──
# Le frontend appelle l'API via l'ALB, jamais directement une instance backend
find /var/www/html -name "*.html" -o -name "*.js" | xargs sed -i \
  "s|http://localhost:${app_port}|http://${alb_dns_name}|g"

# ── Démarrer nginx ──
systemctl start nginx
systemctl enable nginx

echo "Frontend déployé avec succès sur nginx ✅"