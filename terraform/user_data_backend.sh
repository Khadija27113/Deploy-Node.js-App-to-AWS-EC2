#!/bin/bash
set -e

# ── Mise à jour et installation ──
apt update -y
apt install -y git curl mysql-client

# ── Installer Node.js 18 ──
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# ── Cloner le repo ──
cd /home/ubuntu
git clone ${github_repo} app
cd app/backend

# ── Installer les dépendances ──
npm install

# ── Créer le fichier .env ──
cat > /home/ubuntu/app/backend/.env <<EOF
DB_HOST=${db_host}
DB_PORT=3306
DB_USER=${db_username}
DB_PASSWORD=${db_password}
DB_NAME=${db_name}
PORT=${app_port}
NODE_ENV=production
EOF

# ── Attendre que RDS soit disponible ──
echo "Attente de la disponibilité de RDS..."
for i in $(seq 1 30); do
  if mysql -h ${db_host} -u ${db_username} -p${db_password} -e "SELECT 1" > /dev/null 2>&1; then
    echo "RDS disponible ✅"
    break
  fi
  echo "Tentative $i/30 — attente 10s..."
  sleep 10
done

# ── Créer la table tasks ──
mysql -h ${db_host} -u ${db_username} -p${db_password} ${db_name} <<'EOSQL'
CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  is_completed TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOSQL

echo "Table tasks créée ✅"

# ── Installer PM2 et démarrer l'application ──
npm install -g pm2
cd /home/ubuntu/app/backend
pm2 start server.js --name taskmanager
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

echo "Backend démarré sur le port ${app_port} ✅"