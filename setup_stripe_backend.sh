#!/bin/bash

# Script para configurar o backend Stripe do HandsPlay
# Servidor: 82.112.245.207
# URL: https://handsplay.com.br/stripe

set -e

echo "🚀 Iniciando configuração do backend Stripe..."

# 1. Criar diretório para o backend
echo "📁 Criando diretório stripe-infoprod-checkout..."
sudo mkdir -p /opt/stripe-infoprod-checkout
cd /opt/stripe-infoprod-checkout

# 2. Extrair o arquivo tar.gz (assumindo que está no diretório atual)
echo "📦 Extraindo arquivo stripe-infoprod-checkout.tar.gz..."
if [ -f "stripe-infoprod-checkout.tar.gz" ]; then
    sudo tar -xzf stripe-infoprod-checkout.tar.gz
    sudo chown -R www-data:www-data /opt/stripe-infoprod-checkout
else
    echo "❌ Arquivo stripe-infoprod-checkout.tar.gz não encontrado!"
    echo "Por favor, coloque o arquivo no diretório /opt/stripe-infoprod-checkout/"
    exit 1
fi

# 3. Instalar dependências Ruby (se necessário)
echo "💎 Verificando dependências Ruby..."
if ! command -v ruby &> /dev/null; then
    echo "Instalando Ruby..."
    sudo apt update
    sudo apt install -y ruby ruby-dev build-essential
fi

if ! command -v gem &> /dev/null; then
    echo "Instalando gem..."
    sudo apt install -y rubygems
fi

# 4. Instalar bundler e dependências
echo "📚 Instalando dependências do projeto..."
cd /opt/stripe-infoprod-checkout
sudo gem install bundler
sudo bundle install

# 5. Configurar permissões
echo "🔐 Configurando permissões..."
sudo chmod -R 755 /opt/stripe-infoprod-checkout
sudo chown -R www-data:www-data /opt/stripe-infoprod-checkout

# 6. Configurar variáveis de ambiente do Stripe
echo "🔑 Configurando chaves do Stripe..."
sudo tee /opt/stripe-infoprod-checkout/.env > /dev/null <<EOF
# Stripe Configuration
STRIPE_PUBLISHABLE_KEY=pk_live_51O8YtMJZw4jL9eB4qqydPMqbnx5wToUKoHHmYMaAr8gkobh5jpXrLmgpKwwr1eamHVIRXnNO2y7kvlODG6UAzqT900hG2Y8jCO
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=whsec_CIBwa5m815m5m2H4AX5AsOjQmceVvCES

# Server Configuration
PORT=4242
HOST=0.0.0.0

# Webhook URL
WEBHOOK_URL=https://app.handsplay.com.br/stripe/webhook

# Price IDs
PRICE_DEDINHO=price_1SBOuPJZw4jL9eB4ggij57dR
PRICE_DEDO=price_1SBOu5JZw4jL9eB4wMhPmPqF
PRICE_DEDAO=price_1SBOtfJZw4jL9eB4HceKJ59g
EOF

# 7. Criar arquivo de serviço systemd
echo "⚙️ Criando serviço systemd..."
sudo tee /etc/systemd/system/handsplay-stripe.service > /dev/null <<EOF
[Unit]
Description=HandsPlay Stripe Backend Service
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/stripe-infoprod-checkout
ExecStart=/usr/bin/ruby webhook.rb
Restart=always
RestartSec=10
Environment=PORT=4242
EnvironmentFile=/opt/stripe-infoprod-checkout/.env

[Install]
WantedBy=multi-user.target
EOF

# 7. Recarregar systemd e habilitar serviço
echo "🔄 Configurando serviço systemd..."
sudo systemctl daemon-reload
sudo systemctl enable handsplay-stripe
sudo systemctl start handsplay-stripe

# 8. Verificar status do serviço
echo "✅ Verificando status do serviço..."
sudo systemctl status handsplay-stripe --no-pager

echo "🎉 Backend Stripe configurado com sucesso!"
echo "📍 Serviço rodando na porta 4242"
echo "🌐 URL: https://handsplay.com.br/stripe"
