import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safepay_payment_gateway/src/enum/enviroment.dart';

class SafepayCheckoutProps {
  final double amount;
  final String clientKey;
  final String currency;
  final bool? webhooks;
  final Environment environment; // Use your Dart enum for environment
  final String orderId;
  final TextStyle? buttonStyle; // Similar to StyleProp<any>
  final Theme buttonTheme; // Use your Dart enum for theme
  final VoidCallback onPaymentCancelled;
  final VoidCallback onPaymentComplete;
  final VoidCallback onErrorFetchingTracker;

  SafepayCheckoutProps({
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
  });
}
