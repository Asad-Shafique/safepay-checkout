import 'package:flutter/material.dart';
import 'package:safepay_payment_gateway/src/enum/enviroment.dart';
import 'package:safepay_payment_gateway/src/enum/theme.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:http/http.dart' as http;

class SafepayCheckout extends StatefulWidget {
  final double amount;
  final String clientKey;
  final String currency;
  final bool? webhooks;
  final Environment environment;
  final String orderId;
  final TextStyle? buttonStyle;
  final ThemeType buttonTheme;
  final VoidCallback onPaymentCancelled;
  final VoidCallback onPaymentComplete;
  final VoidCallback onErrorFetchingTracker;
  final String successUrl;
  final String errorUrl;

  const SafepayCheckout({
    Key? key,
    required this.amount,
    required this.clientKey,
    required this.currency,
    this.webhooks,
    required this.environment,
    required this.orderId,
    this.buttonStyle,
    required this.buttonTheme,
    required this.onPaymentCancelled,
    required this.onPaymentComplete,
    required this.onErrorFetchingTracker,
    required this.successUrl,
    required this.errorUrl,
  }) : super(key: key);

  @override
  _SafepayCheckoutState createState() => _SafepayCheckoutState();
}

class _SafepayCheckoutState extends State<SafepayCheckout> {
  bool isLoading = false; // To handle the loader state
  String token = '';
  String authtoken = '';
  String X_SPY_TOKEN =
      "ff22ed1a2214242e47b2e0fcaf496587b088cd2b3a97c1909ea1ec8db59632f0";

  String get baseURL {
    return widget.environment == Environment.production
        ? 'https://api.getsafepay.com/'
        : 'https://sandbox.api.getsafepay.com/';
  }

  String get componentUrl {
    return widget.environment == Environment.production
        ? 'https://getsafepay.com/'
        : 'https://sandbox.api.getsafepay.com/';
  }

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createCheckoutUrl() async {
  final String secretKey = 'SAFEPAY_SECRET_KEY';
  final String host = 'https://sandbox.api.getsafepay.com';

  final Uri url = Uri.parse('$host/v1/checkouts/payment');
  
  final Map<String, dynamic> body = {
    "tracker": token,
    "tbt": authtoken,
    "environment": widget.environment.value,
    "source": "mywebsite.com",
    "redirect_url": "https://mywebsite.com/order/success",
    "cancel_url": "https://mywebsite.com/order/cancel"
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'X-SFPY-MERCHANT-SECRET': X_SPY_TOKEN,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final checkoutUrl = data['checkout_url'];
      print('Checkout URL: $checkoutUrl');
    } else {
      print('Failed to create checkout URL: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

  Future<void> fetchToken() async {
    try {
      final response = await http.post(
        Uri.parse('${baseURL}order/payments/v3/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "amount": widget.amount.toInt(),
          "intent": "CYBERSOURCE",
          "mode": "payment",
          "currency": widget.currency.toString(),
          "merchant_api_key": widget.clientKey.toString(),
          "order_id": widget.orderId.toString(),
          "source": "mobile",
        }),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        token = jsonResponse['data']['tracker']['token'];
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
        widget.onErrorFetchingTracker();
      }
    } catch (e) {
      debugPrint('Exception in fetchToken: $e');
      widget.onErrorFetchingTracker();
    }
  }

  Future<void> generateAuthToken() async {
    try {
      final response = await http.post(
        Uri.parse('${baseURL}client/passport/v1/token'),
        headers: {
          'Content-Type': 'application/json',
          'X-SFPY-MERCHANT-SECRET': X_SPY_TOKEN,
        },
        body: jsonEncode(<String, dynamic>{
          "amount": widget.amount.toInt(),
          "intent": "CYBERSOURCE",
          "mode": "payment",
          "currency": widget.currency.toString(),
          "merchant_api_key": widget.clientKey.toString(),
          "order_id": widget.orderId.toString(),
          "source": "mobile",
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        authtoken = jsonResponse['data'];
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
        widget.onErrorFetchingTracker();
      }
    } catch (e) {
      debugPrint('Exception in generateAuthToken: $e');
      widget.onErrorFetchingTracker();
    }
  }

  Future<void> handlePaymentProcess() async {
    setState(() {
      isLoading = true;
    });

    await fetchToken();
    await generateAuthToken();

    if (token.isNotEmpty && authtoken.isNotEmpty) {
      final params = {
        'tracker': token,
        'tbt': authtoken,
        'environment': widget.environment.value,
        'source': 'mobile',
        'redirect_url': widget.successUrl,
        'cancel_url': widget.errorUrl,
      };

      final checkoutUrl =
          '${componentUrl}checkout/pay?${Uri(queryParameters: params).query}';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text("Safepay Checkout")),
            body: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {
                      final uri = Uri.parse(url);
                      final action = uri.queryParameters['action'];
                      if (action == 'cancelled') {
                        widget.onPaymentCancelled();
                      } else if (action == 'complete') {
                        widget.onPaymentComplete();
                      }
                    },
                  ),
                )
                ..loadRequest(Uri.parse(checkoutUrl)),
            ),
          ),
        ),
      );
    } else {
      widget.onErrorFetchingTracker();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: handlePaymentProcess,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0E0E0E),
              border: Border.all(
                color: const Color(0xFF0E0E0E),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: renderLogo(widget.buttonTheme),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Widget renderLogo(ThemeType theme) {
    AssetImage logo;
    switch (theme) {
      case ThemeType.dark:
        logo = const AssetImage(
            'packages/safepay_payment_gateway/assets/safepay-logo-white.png');
        break;
      case ThemeType.light:
        logo = const AssetImage(
            'packages/safepay_payment_gateway/assets/safepay-logo-dark.png');
        break;
      default:
        logo = const AssetImage(
            'packages/safepay_payment_gateway/assets/safepay-logo-blue.png');
        break;
    }

    return Image(
      image: logo,
      width: 100,
      fit: BoxFit.contain,
    );
  }
}
