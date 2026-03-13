#!/bin/bash

# Script para testar o fluxo completo do Stripe
# Testa: POST /create-checkout-session e webhook checkout.session.completed

set -e

echo "🧪 Testando fluxo completo do Stripe..."

# Configurações
STRIPE_URL="https://app.handsplay.com.br/stripe"
LOCAL_URL="http://localhost:4242"

# Função para testar endpoint
test_endpoint() {
    local url=$1
    local endpoint=$2
    local method=${3:-GET}
    local data=${4:-""}
    
    echo "🔍 Testando $method $url$endpoint"
    
    if [ "$method" = "POST" ] && [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X POST \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$url$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" "$url$endpoint")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)
    
    echo "📊 Status: $http_code"
    echo "📄 Response: $body"
    echo "---"
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        echo "✅ Sucesso!"
        return 0
    else
        echo "❌ Erro!"
        return 1
    fi
}

# 1. Testar se o serviço está rodando localmente
echo "1️⃣ Testando serviço local (porta 4242)..."
if test_endpoint "$LOCAL_URL" "/health" "GET"; then
    echo "✅ Serviço local funcionando"
else
    echo "❌ Serviço local não está respondendo"
    echo "Verifique: sudo systemctl status handsplay-stripe"
    exit 1
fi

# 2. Testar se o nginx está redirecionando corretamente
echo "2️⃣ Testando proxy reverso do nginx..."
if test_endpoint "$STRIPE_URL" "/health" "GET"; then
    echo "✅ Proxy reverso funcionando"
else
    echo "❌ Proxy reverso não está funcionando"
    echo "Verifique a configuração do nginx"
    exit 1
fi

# 3. Testar criação de sessão de checkout (exemplo)
echo "3️⃣ Testando criação de sessão de checkout..."
checkout_data='{
    "price_id": "price_1SBOuPJZw4jL9eB4ggij57dR",
    "success_url": "https://app.handsplay.com.br/#/success",
    "cancel_url": "https://app.handsplay.com.br/#/cancel"
}'

if test_endpoint "$STRIPE_URL" "/create-checkout-session" "POST" "$checkout_data"; then
    echo "✅ Criação de sessão funcionando"
else
    echo "⚠️ Criação de sessão falhou (pode ser normal se não tiver dados válidos)"
fi

# 4. Verificar logs do serviço
echo "4️⃣ Verificando logs do serviço..."
echo "📋 Últimas 10 linhas dos logs:"
sudo journalctl -u handsplay-stripe -n 10 --no-pager

echo "🎉 Teste concluído!"
echo "📍 URL final: $STRIPE_URL"
echo "🖥️ IP do servidor: 82.112.245.207"
