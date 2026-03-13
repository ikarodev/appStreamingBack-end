#!/bin/bash

# Script para configurar o nginx para proxy reverso do Stripe

set -e

echo "🌐 Configurando nginx para proxy reverso do Stripe..."

# 1. Backup da configuração atual
echo "💾 Fazendo backup da configuração atual do nginx..."
sudo cp /etc/nginx/sites-available/handsplay.com.br /etc/nginx/sites-available/handsplay.com.br.backup.$(date +%Y%m%d_%H%M%S)

# 2. Adicionar configuração do Stripe ao nginx
echo "⚙️ Adicionando configuração do Stripe..."

# Verificar se a configuração já existe
if grep -q "location /stripe" /etc/nginx/sites-available/handsplay.com.br; then
    echo "⚠️ Configuração do Stripe já existe no nginx"
else
    # Adicionar configuração do Stripe
    sudo tee -a /etc/nginx/sites-available/handsplay.com.br > /dev/null <<EOF

# Configuração do Stripe Backend
location /stripe {
    # Proxy para o backend Stripe na porta 4242
    proxy_pass http://localhost:4242;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_cache_bypass \$http_upgrade;
    
    # Timeouts
    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 60s;
    
    # Headers para webhooks do Stripe
    proxy_set_header X-Forwarded-Host \$host;
    proxy_set_header X-Forwarded-Server \$host;
    
    # Buffer settings
    proxy_buffering on;
    proxy_buffer_size 4k;
    proxy_buffers 8 4k;
}
EOF
fi

# 3. Testar configuração do nginx
echo "🧪 Testando configuração do nginx..."
if sudo nginx -t; then
    echo "✅ Configuração do nginx válida"
else
    echo "❌ Erro na configuração do nginx"
    echo "Restaurando backup..."
    sudo cp /etc/nginx/sites-available/handsplay.com.br.backup.* /etc/nginx/sites-available/handsplay.com.br
    exit 1
fi

# 4. Recarregar nginx
echo "🔄 Recarregando nginx..."
sudo systemctl reload nginx

# 5. Verificar status
echo "✅ Verificando status do nginx..."
sudo systemctl status nginx --no-pager

echo "🎉 Nginx configurado com sucesso!"
echo "📍 URL: https://handsplay.com.br/stripe"
echo "🔄 Proxy: localhost:4242"
