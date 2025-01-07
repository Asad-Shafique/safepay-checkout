import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:safepay_payment_gateway/safepay_payment_gateway.dart';
import 'package:safepay_payment_gateway/src/constant/package_constant.dart';
import 'package:safepay_payment_gateway/src/enum/enviroment.dart';
import 'package:safepay_payment_gateway/src/enum/theme.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SafepayCheckout extends StatefulWidget {
  final Widget Function(BuildContext context) checkoutButton;
  final double amount;
  final String clientKey;
  final String secretKey;
  final String currency;
  final SafePayEnvironment environment;
  final String orderId;
  final VoidCallback onPaymentFailed;
  final VoidCallback onPaymentCompleted;
  final VoidCallback onAuthenticationError;
  final String successUrl;
  final String failUrl;

  const SafepayCheckout({
    Key? key,
    required this.amount,
    required this.checkoutButton,
    required this.clientKey,
    required this.secretKey,
    required this.currency,
    required this.environment,
    required this.orderId,
    required this.onPaymentFailed,
    required this.onPaymentCompleted,
    required this.onAuthenticationError,
    required this.successUrl,
    required this.failUrl,
  }) : super(key: key);

  @override
  _SafepayCheckoutState createState() => _SafepayCheckoutState();
}

class _SafepayCheckoutState extends State<SafepayCheckout> {
  //var
  bool isLoading = false;
  String _token = '';
  String _authtoken = '';

  // CHECKOUT URL BASES ON ENVIROMENT
  String get baseURL {
    return widget.environment == SafePayEnvironment.production
        ? productionBaseUrl
        : sandboxBaseUrl;
  }

  String get componentUrl {
    return widget.environment == SafePayEnvironment.production
        ? productionComponentUrl
        : sandboxComponentUrl;
  }

  PlatformType getPlatformType() {
    if (kIsWeb) {
      return PlatformType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      return PlatformType.mobile;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // API TO FETCHTOKEN
  Future<void> fetchToken() async {
    try {
      final response = await http.post(
        Uri.parse('${baseURL}$fetchTokenEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "amount": widget.amount.toInt() * 100,
          "intent": intent,
          "mode": paymentmode,
          "currency": widget.currency.toString(),
          "merchant_api_key": widget.clientKey.toString(),
          "order_id": widget.orderId.toString(),
          "source": getPlatformType().value
        }),
      );
      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        _token = jsonResponse['data']['tracker']['token'];
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
        widget.onAuthenticationError();
      }
    } catch (e) {
      debugPrint('Exception in fetchToken: $e');
      widget.onAuthenticationError();
    }
  }

  // API TO GENERATE AUTH TOKEN
  Future<void> generateAuthToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL$authTokenEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          secretKey: widget.secretKey,
        },
        body: jsonEncode(<String, dynamic>{
          "amount": widget.amount.toInt() * 100,
          "intent": intent,
          "mode": paymentmode,
          "currency": widget.currency.toString(),
          "merchant_api_key": widget.clientKey.toString(),
          "order_id": widget.orderId.toString(),
          "source": getPlatformType().value,
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _authtoken = jsonResponse['data'];
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
        widget.onAuthenticationError();
      }
    } catch (e) {
      debugPrint('Exception in generateAuthToken: $e');
      widget.onAuthenticationError();
    }
  }

  // HANDLING PAYMENT PROCESS AFTER FETCH AND GENERATE
  Future<void> handlePaymentProcess() async {
    setState(() {
      isLoading = true;
    });
    await fetchToken();
    await generateAuthToken();
    if (_token.isNotEmpty && _authtoken.isNotEmpty) {
      final checkoutUrl =
          "${componentUrl}embedded/payment/auth?tracker=$_token&tbt=$_authtoken&order_id=${widget.orderId}&env=${widget.environment.value}&source=mobile&redirect_url=${widget.successUrl}&cancel_url=${widget.failUrl}";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: getPlatformType().value == 'hosted'
                  ? AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: kToolbarHeight,
                    )
                  : AppBar(
                      title: Text("Safepay Checkout"),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
              body: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(checkoutUrl),
                  headers: {secretKey: widget.secretKey},
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                  ),
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  if (url != null &&
                      url.toString().contains(successPaymentUrlContains)) {
                    //for successful payment
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                      widget.onPaymentCompleted();
                    });
                  } else {
                    //for cancelled payment
                    widget.onPaymentFailed();
                  }
                },
              )),
        ),
      );
    } else {
      widget.onAuthenticationError();
    }
    setState(() {
      isLoading = false;
    });
  }

  late InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: handlePaymentProcess, child: widget.checkoutButton(context)),
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
}
