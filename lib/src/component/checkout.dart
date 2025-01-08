import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:safepay_checkout/safepay_payment_gateway.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SafepayCheckout extends StatefulWidget {
  final double amount;
  final String publicKey;
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
    super.key,
    required this.amount,
    required this.publicKey,
    required this.secretKey,
    required this.currency,
    required this.environment,
    required this.orderId,
    required this.onPaymentFailed,
    required this.onPaymentCompleted,
    required this.onAuthenticationError,
    required this.successUrl,
    required this.failUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SafepayCheckoutState createState() => _SafepayCheckoutState();
}

class _SafepayCheckoutState extends State<SafepayCheckout> {
  //var
  bool isLoading = false;
  bool showScreen = false;
  String _token = '';
  String _authtoken = '';
  String checkoutUrl = '';

  @override
  void initState() {
    super.initState();
    handlePaymentProcess();
  }

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

  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      javaScriptEnabled: true,
      iframeAllowFullscreen: true);

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
        Uri.parse('$baseURL$fetchTokenEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "amount": widget.amount.toInt() * 100,
          "intent": intent,
          "mode": paymentmode,
          "currency": widget.currency.toString(),
          "merchant_api_key": widget.publicKey.toString(),
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
        return;
      }
    } catch (e) {
      debugPrint('Exception in fetchToken: $e');
      widget.onAuthenticationError();
      return;
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
          "merchant_api_key": widget.publicKey.toString(),
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
        return;
      }
    } catch (e) {
      debugPrint('Exception in generateAuthToken: $e');
      widget.onAuthenticationError();
      return;
    }
  }

  // HANDLING PAYMENT PROCESS AFTER FETCH AND GENERATE
  Future<void> handlePaymentProcess() async {
    setState(() {
      isLoading = true;
    });

    await fetchToken();
    if (_token.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    await generateAuthToken();
    if (_authtoken.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    if (_token.isNotEmpty && _authtoken.isNotEmpty) {
      setState(() {
        checkoutUrl =
            "${componentUrl}embedded/payment/auth?tracker=$_token&tbt=$_authtoken&order_id=${widget.orderId}&env=${widget.environment.value}&source=mobile&redirect_url=${widget.successUrl}&cancel_url=${widget.failUrl}";
        showScreen = true;
        isLoading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      widget.onAuthenticationError();
    }
    setState(() {
      isLoading = false;
    });
  }

  InAppWebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getPlatformType().value == 'hosted'
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: kToolbarHeight,
              )
            : AppBar(
                title: const Text("Safepay Checkout"),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : showScreen
                ? InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(checkoutUrl),
                      headers: {secretKey: widget.secretKey},
                    ),
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialSettings: settings,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      if (url != null &&
                          url.toString().contains(successPaymentUrlContains)) {
                        //For successful payment
                        Future.delayed(const Duration(seconds: 2), () {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          widget.onPaymentCompleted();
                        });
                      } else if (areUrlsEqual(url.toString(), widget.failUrl)) {
                        Navigator.of(context).pop();
                        widget.onPaymentFailed();
                      } else {
                        //For cancelled payment
                        // widget.onPaymentFailed();
                      }
                    },
                  )
                : Container());
  }

  bool areUrlsEqual(String url1, String url2) {
    String normalize(String url) =>
        url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return normalize(url1) == normalize(url2);
  }
}
