@JS()
library;

import 'package:flutter/material.dart';
import 'package:handsplay/utils/constant.dart';
import 'package:js/js.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void redirectToCheckout(BuildContext _) async {
  try {
    // Criar sessão de checkout via backend local
    final sessionId = await createCheckoutSession();
    
    if (sessionId != null) {
      final stripe = Stripe(Constant.publishableKey ?? "");
      stripe.redirectToCheckout(CheckoutOptions(
        sessionId: sessionId,
      ));
    } else {
      print('Erro ao criar sessão de checkout');
    }
  } catch (e) {
    print('Erro no redirectToCheckout: $e');
  }
}

Future<String?> createCheckoutSession() async {
  try {
    final response = await http.post(
      Uri.parse('https://app.handsplay.com.br/stripe/create-checkout-session'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'price_id': Constant.packagePriceId ?? '',
        'success_url': Constant.successURL ?? '',
        'cancel_url': Constant.cancelURL ?? '',
        'mode': Constant.paymentMode ?? 'subscription',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['session_id'];
    } else {
      print('Erro na criação da sessão: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return null;
  }
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
