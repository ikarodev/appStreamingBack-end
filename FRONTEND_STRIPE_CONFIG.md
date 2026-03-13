# Configuração do Frontend Stripe - HandsPlay

## ✅ Correções Aplicadas

### 1. **URL do Domínio Corrigida**
- **Antes**: `https://www.yourappname.com/`
- **Depois**: `https://handsplay.com.br/`

### 2. **Integração com Backend Local**
- Adicionada função `createCheckoutSession()` que chama o backend local
- URL do backend: `https://handsplay.com.br/stripe/create-checkout-session`

### 3. **Fluxo Atualizado**
1. Frontend chama backend local para criar sessão
2. Backend retorna `session_id`
3. Frontend usa `session_id` para redirecionar ao Stripe Checkout

## 🔧 Configurações Necessárias no Admin

### 1. **Chaves do Stripe**
No painel administrativo do app, configure:
- **Publishable Key**: `pk_live_...` (chave pública do Stripe)
- **Secret Key**: `sk_live_...` (chave secreta do Stripe)
- **Price ID**: `price_...` (ID do produto/plano no Stripe)

### 2. **URLs de Retorno**
- **Success URL**: `https://handsplay.com.br/#/success`
- **Cancel URL**: `https://handsplay.com.br/#/cancel`

## 🧪 Teste do Fluxo Completo

### 1. **Frontend → Backend**
```javascript
POST https://handsplay.com.br/stripe/create-checkout-session
{
  "price_id": "price_1234567890",
  "success_url": "https://handsplay.com.br/#/success",
  "cancel_url": "https://handsplay.com.br/#/cancel",
  "mode": "subscription"
}
```

### 2. **Backend → Stripe**
- Backend cria sessão no Stripe
- Retorna `session_id`

### 3. **Frontend → Stripe Checkout**
- Frontend redireciona para Stripe com `session_id`
- Usuário completa pagamento

### 4. **Stripe → Backend (Webhook)**
- Stripe envia webhook para `https://handsplay.com.br/stripe/webhook`
- Backend processa `checkout.session.completed`

## 📋 Checklist de Validação

- [ ] URL do domínio atualizada para `handsplay.com.br`
- [ ] Integração com backend local funcionando
- [ ] Chaves do Stripe configuradas no admin
- [ ] URLs de sucesso/cancelamento corretas
- [ ] Teste de criação de sessão funcionando
- [ ] Teste de webhook funcionando
- [ ] Fluxo completo testado

## 🚨 Possíveis Problemas

### 1. **CORS**
Se houver erro de CORS, adicionar no backend:
```ruby
# No webhook.rb
headers 'Access-Control-Allow-Origin' => '*'
headers 'Access-Control-Allow-Methods' => 'POST, GET, OPTIONS'
headers 'Access-Control-Allow-Headers' => 'Content-Type'
```

### 2. **HTTPS**
Certificar que todas as URLs usam HTTPS em produção.

### 3. **Chaves de Teste vs Produção**
- Usar chaves de teste (`pk_test_`, `sk_test_`) para desenvolvimento
- Usar chaves de produção (`pk_live_`, `sk_live_`) para produção

## 📞 Informações para o Freelancer

- **Backend URL**: `https://handsplay.com.br/stripe`
- **Webhook URL**: `https://handsplay.com.br/stripe/webhook`
- **Frontend atualizado**: ✅ Integração com backend local
- **URLs corretas**: ✅ `handsplay.com.br`
