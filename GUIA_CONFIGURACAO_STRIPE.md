# Guia de Configuração do Backend Stripe - HandsPlay

## 📋 Pré-requisitos
- Servidor: 82.112.245.207
- URL final: https://handsplay.com.br/stripe
- Arquivos necessários do freelancer:
  - `stripe-infoprod-checkout.tar.gz`
  - `webhook.rb`
  - Comando `systemctl enable handsplay-stripe`

## 🚀 Passos de Configuração

### 1. Preparar Arquivos no Servidor
```bash
# Conectar ao servidor
ssh root@82.112.245.207

# Criar diretório e copiar arquivos
mkdir -p /opt/stripe-infoprod-checkout
cd /opt/stripe-infoprod-checkout

# Copiar o arquivo tar.gz para o servidor
# (usar scp, rsync ou upload via interface)
scp stripe-infoprod-checkout.tar.gz root@82.112.245.207:/opt/stripe-infoprod-checkout/
```

### 2. Executar Script de Configuração do Backend
```bash
# Tornar o script executável
chmod +x setup_stripe_backend.sh

# Executar configuração
./setup_stripe_backend.sh
```

### 3. Configurar Nginx
```bash
# Tornar o script executável
chmod +x setup_nginx_stripe.sh

# Executar configuração do nginx
./setup_nginx_stripe.sh
```

### 4. Testar Configuração
```bash
# Tornar o script executável
chmod +x test_stripe_flow.sh

# Executar testes
./test_stripe_flow.sh
```

## 🔧 Configurações Manuais Necessárias

### 1. Configurar Variáveis de Ambiente
No arquivo `/opt/stripe-infoprod-checkout/.env` ou no `webhook.rb`, configure:
```bash
# Chaves do Stripe (fornecidas pelo freelancer)
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Configurações do servidor
PORT=4242
HOST=0.0.0.0
```

### 2. Configurar Webhook no Dashboard do Stripe
- URL do webhook: `https://handsplay.com.br/stripe/webhook`
- Eventos: `checkout.session.completed`
- Usar a chave secreta do webhook fornecida

## 🧪 Testes de Validação

### 1. Teste de Conectividade
```bash
# Testar se o serviço está rodando
curl http://localhost:4242/health

# Testar proxy reverso
curl https://handsplay.com.br/stripe/health
```

### 2. Teste de Criação de Sessão
```bash
curl -X POST https://handsplay.com.br/stripe/create-checkout-session \
  -H "Content-Type: application/json" \
  -d '{
    "price_id": "price_1234567890",
    "success_url": "https://handsplay.com.br/success",
    "cancel_url": "https://handsplay.com.br/cancel"
  }'
```

### 3. Teste de Webhook
```bash
# Simular webhook do Stripe
curl -X POST https://handsplay.com.br/stripe/webhook \
  -H "Content-Type: application/json" \
  -H "Stripe-Signature: t=1234567890,v1=..." \
  -d '{
    "type": "checkout.session.completed",
    "data": {
      "object": {
        "id": "cs_test_1234567890",
        "payment_status": "paid"
      }
    }
  }'
```

## 📊 Monitoramento

### 1. Verificar Status do Serviço
```bash
# Status do serviço
sudo systemctl status handsplay-stripe

# Logs do serviço
sudo journalctl -u handsplay-stripe -f

# Logs do nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### 2. Verificar Portas
```bash
# Verificar se a porta 4242 está aberta
netstat -tlnp | grep 4242

# Verificar se o nginx está rodando
sudo systemctl status nginx
```

## 🔒 Configurações de Segurança

### 1. Firewall
```bash
# Permitir apenas tráfego HTTPS (porta 443)
# A porta 4242 deve estar acessível apenas localmente
sudo ufw allow 443
sudo ufw deny 4242
```

### 2. Permissões
```bash
# Configurar permissões corretas
sudo chmod -R 755 /opt/stripe-infoprod-checkout
sudo chown -R www-data:www-data /opt/stripe-infoprod-checkout
```

## 🚨 Troubleshooting

### 1. Serviço não inicia
```bash
# Verificar logs
sudo journalctl -u handsplay-stripe -n 50

# Verificar dependências
cd /opt/stripe-infoprod-checkout
bundle install
```

### 2. Erro 502 Bad Gateway
```bash
# Verificar se o serviço está rodando
sudo systemctl status handsplay-stripe

# Verificar configuração do nginx
sudo nginx -t

# Verificar logs do nginx
sudo tail -f /var/log/nginx/error.log
```

### 3. Webhook não funciona
```bash
# Verificar URL do webhook no Stripe Dashboard
# Verificar chave secreta do webhook
# Verificar logs do serviço para erros de assinatura
```

## 📞 Informações para o Freelancer

- **IP do Servidor**: 82.112.245.207
- **URL do Backend**: https://handsplay.com.br/stripe
- **URL do Webhook**: https://handsplay.com.br/stripe/webhook
- **Porta Interna**: 4242 (não exposta externamente)

## ✅ Checklist Final

- [ ] Backend Stripe rodando na porta 4242
- [ ] Nginx configurado com proxy reverso
- [ ] Serviço systemd habilitado e rodando
- [ ] Permissões 755 configuradas para www-data
- [ ] Webhook configurado no Stripe Dashboard
- [ ] Teste de criação de sessão funcionando
- [ ] Teste de webhook funcionando
- [ ] Logs sem erros 502
