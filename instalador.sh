#!/bin/bash

clear

echo "=========================================="
echo "        HYDRA V2RAY - INSTALADOR"
echo "=========================================="
echo ""

# Verificar root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Debes ejecutar esto como root"
  exit
fi

echo "✔ Usuario root verificado"

# Detectar sistema
echo "🔍 Detectando sistema operativo..."
OS=$(lsb_release -si)

if [ "$OS" != "Ubuntu" ]; then
  echo "❌ Este instalador solo funciona en Ubuntu"
  exit
fi

echo "✔ Ubuntu detectado"

# Actualizar sistema
echo ""
echo "📦 Actualizando sistema..."
apt update -y && apt upgrade -y

# Dependencias base
echo ""
echo "📦 Instalando dependencias..."
apt install -y curl wget unzip sudo git ufw

# Firewall básico
echo ""
echo "🔥 Configurando firewall..."
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable

# Instalar Xray (core VPN)
echo ""
echo "⚙️ Instalando Xray-core..."
bash <(curl -Ls https://github.com/XTLS/Xray-install/raw/main/install-release.sh)

# Crear estructura HYDRA
echo ""
echo "📁 Creando estructura HYDRA..."
mkdir -p /opt/hydra-v2ray
mkdir -p /opt/hydra-v2ray/users
mkdir -p /opt/hydra-v2ray/json
mkdir -p /opt/hydra-v2ray/logs

# Crear servicio base
cat > /etc/systemd/system/hydra.service <<EOF
[Unit]
Description=HYDRA V2RAY SERVICE
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable hydra

# Instalar herramientas web base
echo ""
echo "🌐 Instalando entorno web (base para panel)..."
apt install -y nginx mariadb-server php php-cli php-fpm php-mysql php-mbstring unzip

# Composer
echo ""
echo "🎼 Instalando Composer..."
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Mensaje final
echo ""
echo "=========================================="
echo "        INSTALACIÓN COMPLETADA"
echo "=========================================="
echo ""
echo "✔ Xray instalado"
echo "✔ Base HYDRA creada"
echo "✔ Nginx + PHP + MariaDB listos"
echo ""
echo "📌 PRÓXIMO PASO:"
echo "   Instalar panel HYDRA (Laravel)"
echo ""
echo "🚀 Comando:"
echo "   cd /opt && git clone TU_PANEL_HYDRA"
echo ""
echo "=========================================="
