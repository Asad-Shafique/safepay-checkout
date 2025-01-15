import 'package:flutter/material.dart';
import 'package:safepay_checkout/safepay_payment_gateway.dart';

class CheckoutScreen extends StatefulWidget {
  final SafePayEnvironment environment;
  final String successUrl;
  final String failUrl;
  final String trackerToken;
  final String authToken;

  const CheckoutScreen({
    super.key,
    required this.environment,
    required this.successUrl,
    required this.failUrl,
    required this.trackerToken,
    required this.authToken,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafepayCheckout(
      environment: widget.environment,
      authToken: widget.authToken,
      trackerToken: widget.trackerToken,
      onPaymentFailed: () {
        //  payment failed
        print('cancel');
      },
      onPaymentCompleted: () {
        // payment completed
        print('Payment successful');
      },
      successUrl: widget.successUrl,
      failUrl: widget.failUrl,
    );
  }
}
