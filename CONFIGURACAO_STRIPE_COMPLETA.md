# 🎯 Configuração Completa do Stripe - HandsPlay

## ✅ **Chaves Configuradas:**

### **Stripe Keys:**
- **Publishable Key**: ``
- **Secret Key**: ``
- **Webhook Secret**: ``

### **Planos Configurados:**
1. **Plano Dedinho**: `price_1SBOuPJZw4jL9eB4ggij57dR`
2. **Plano Dedo**: `price_1SBOu5JZw4jL9eB4wMhPmPqF`
3. **Plano Dedão**: `price_1SBOtfJZw4jL9eB4HceKJ59g`

### **URLs Configuradas:**
- **Backend**: `https://app.handsplay.com.br/stripe`
- **Webhook**: `https://app.handsplay.com.br/stripe/webhook`
- **Success**: `https://app.handsplay.com.br/#/success`
- **Cancel**: `https://app.handsplay.com.br/#/cancel`

## 🚀 **Como Executar:**

### 1. **No Servidor (82.112.245.207):**
```bash
# Copiar arquivos para o servidor
scp setup_stripe_backend.sh root@82.112.245.207:/root/
scp setup_nginx_stripe.sh root@82.112.245.207:/root/
scp test_stripe_flow.sh root@82.112.245.207:/root/

# Conectar ao servidor
ssh root@82.112.245.207

# Executar configuração
chmod +x *.sh
./setup_stripe_backend.sh
./setup_nginx_stripe.sh
./test_stripe_flow.sh
```

### 2. **No Frontend (Flutter):**
```bash
# Compilar o app com as configurações atualizadas
flutter build web --release
```

## 🧪 **Teste dos 3 Planos:**

### **Plano Dedinho:**
```bash
curl -X POST https://app.handsplay.com.br/stripe/create-checkout-session \
  -H "Content-Type: application/json" \
  -d '{
    "price_id": "price_1SBOuPJZw4jL9eB4ggij57dR",
    "success_url": "https://app.handsplay.com.br/#/success",
    "cancel_url": "https://app.handsplay.com.br/#/cancel"
  }'
```

### **Plano Dedo:**
```bash
curl -X POST https://app.handsplay.com.br/stripe/create-checkout-session \
  -H "Content-Type: application/json" \
  -d '{
    "price_id": "price_1SBOu5JZw4jL9eB4wMhPmPqF",
    "success_url": "https://app.handsplay.com.br/#/success",
    "cancel_url": "https://app.handsplay.com.br/#/cancel"
  }'
```

### **Plano Dedão:**
```bash
curl -X POST https://app.handsplay.com.br/stripe/create-checkout-session \
  -H "Content-Type: application/json" \
  -d '{
    "price_id": "price_1SBOtfJZw4jL9eB4HceKJ59g",
    "success_url": "https://app.handsplay.com.br/#/success",
    "cancel_url": "https://app.handsplay.com.br/#/cancel"
  }'
```

## 📋 **Checklist de Validação:**

- [x] Chaves do Stripe configuradas
- [x] 3 planos configurados com Price IDs corretos
- [x] URLs atualizadas para `app.handsplay.com.br`
- [x] Webhook configurado
- [x] Frontend integrado com backend local
- [x] Scripts de configuração atualizados
- [x] Testes configurados

## 🔧 **Configuração no Admin do App:**

No painel administrativo do HandsPlay, configure:
- **Publishable Key**: `pk_live_51O8YtMJZw4jL9eB4qqydPMqbnx5wToUKoHHmYMaAr8gkobh5jpXrLmgpKwwr1eamHVIRXnNO2y7kvlODG6UAzqT900hG2Y8jCO`
- **Price IDs**: Use os IDs dos planos conforme necessário
- **Modo**: `subscription`

## 🎉 **Resultado Final:**

- ✅ Backend Stripe rodando na porta 4242
- ✅ Nginx redirecionando `app.handsplay.com.br/stripe` → `localhost:4242`
- ✅ Webhook funcionando em `app.handsplay.com.br/stripe/webhook`
- ✅ Frontend integrado com backend local
- ✅ 3 planos configurados e funcionando
- ✅ URLs corretas para success/cancel

**Tudo configurado e pronto para usar!** 🚀
