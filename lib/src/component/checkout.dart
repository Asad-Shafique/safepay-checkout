import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:safepay_checkout/safepay_payment_gateway.dart';

class SafepayCheckout extends StatefulWidget {
  final SafePayEnvironment environment;
  final VoidCallback onPaymentFailed;
  final VoidCallback onPaymentCompleted;
  final String successUrl;
  final String failUrl;
  final String tbt;
  final String tracker;

  const SafepayCheckout(
      {super.key,
      required this.environment,
      required this.onPaymentFailed,
      required this.onPaymentCompleted,
      required this.successUrl,
      required this.failUrl,
      required this.tbt,
      required this.tracker});

  @override
  // ignore: library_private_types_in_public_api
  _SafepayCheckoutState createState() => _SafepayCheckoutState();
}

class _SafepayCheckoutState extends State<SafepayCheckout> {
  //var
  bool isLoading = false;
  bool showScreen = false;
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

  // HANDLING PAYMENT PROCESS AFTER FETCH AND GENERATE
  Future<void> handlePaymentProcess() async {
    setState(() {
      isLoading = true;
    });

    if (widget.tbt.isNotEmpty && widget.tracker.isNotEmpty) {
      setState(() {
        checkoutUrl =
            "${componentUrl}embedded/payment/auth?tracker=${widget.tracker}&tbt=${widget.tbt}&env=${widget.environment.value}&source=mobile&redirect_url=${widget.successUrl}&cancel_url=${widget.failUrl}";
        showScreen = true;
        isLoading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
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
                    ),
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialSettings: settings,
                    onLoadStop: (controller, url) {},
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
                      } else if (url != null &&
                          url.toString().contains(failPaymentUrlContains)) {
                        //For successful payment

                        Future.delayed(const Duration(seconds: 2), () {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          widget.onPaymentFailed();
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
