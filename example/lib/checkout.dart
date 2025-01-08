import 'package:flutter/material.dart';
import 'package:safepay_checkout/safepay_payment_gateway.dart';

class CheckoutScreen extends StatefulWidget {
  final double amount;
  final String publicKey;
  final String secretKey;
  final String currency;
  final SafePayEnvironment environment;
  final String orderId;
  final String successUrl;
  final String failUrl;

  const CheckoutScreen({
    Key? key,
    required this.amount,
    required this.publicKey,
    required this.secretKey,
    required this.currency,
    required this.environment,
    required this.orderId,
    required this.successUrl,
    required this.failUrl,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafepayCheckout(
      amount: widget.amount,
      publicKey: widget.publicKey,
      secretKey: widget.secretKey,
      currency: widget.currency,
      environment: widget.environment,
      orderId: widget.orderId,
      onPaymentFailed: () {
        //payment failed
        print('cancel');
      },
      onPaymentCompleted: () {
        // payment completed
        print('Payment successful');
      },
      onAuthenticationError: () {
        //in case of wrong public or secret key
        print('Authentication error');
      },
      successUrl: widget.successUrl,
      failUrl: widget.failUrl,
    );
  }
}
