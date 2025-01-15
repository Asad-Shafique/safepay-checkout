
# Safepay Checkout

A Flutter package to seamlessly integrate the Safepay Payment Gateway for secure and efficient payment processing. This package simplifies the checkout integration by providing a pre-built widget that handles all payment operations for you.

## Installation

### Step 1: Add Dependency
To get started, add the following dependency to your **`pubspec.yaml`** file:

```yaml
dependencies:
  safepay_checkout: ^1.0.5
```

### Step 2: Import the Package
Import the package in the Dart file where you want to use it:

```dart
import 'package:safepay_checkout/safepay_payment_gateway.dart';
```

### Step 3: Add the Checkout Widget
Add the `SafepayCheckout` widget to your screen. This widget handles the entire payment process.

```dart
SafepayCheckout(
  tracker: 'your trcker token',
  tbt: 'your authentication token',
  environment: SafePayEnvironment.sandbox,
  successUrl: 'yourdomain.com',
  failUrl: 'yourfaildomain.com',
  onPaymentFailed: () {
    // Payment failed
    print('Payment cancelled');
  },
  onPaymentCompleted: () {
    // Payment successful
    print('Payment successful');
  },
 
);
```

This code will add the Safepay payment gateway to your screen, enabling payment processing.

## Parameters

| Parameter             | Data Type                 | Description                                                                 |
|-----------------------|---------------------------|-----------------------------------------------------------------------------|
| `tracker`             | `String`                  | Your tracker token.                                                     |
| `tbt`                 | `String`                  | Your authentication token.                                                     |
| `environment`         | `SafePayEnvironment`      | The environment setting for the payment (e.g., `production`, `sandbox`).              |
| `successUrl`          | `String`                  | URL to redirect to on successful payment.                                    |
| `failUrl`             | `String`                  | URL to redirect to in case of payment failure.                               |
| `onPaymentFailed`     | `VoidCallback`            | Callback triggered in case of a payment failure.                             |
| `onPaymentCompleted`  | `VoidCallback`            | Callback triggered when the payment has been successfully completed.         |

## Full Screen Example

If you'd like a complete screen to handle payments, take a look at the example below.

### `Checkout.dart`

Create a new file named `Checkout.dart` and navigate to this screen in your app. This will handle the payment logic and trigger success, failure, or authentication error events.

```dart
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
      tracker: 'your trcker token',
      tbt: 'your authentication token',
      environment: SafePayEnvironment.sandbox,
      successUrl: 'yourdomain.com',
      failUrl: 'yourfaildomain.com',
      onPaymentFailed: () {
          // Payment failed
        print('Payment cancelled');
      },
      onPaymentCompleted: () {
         // Payment successful
        print('Payment successful');
      },
    );
  }
}
```

### Additional Example

For a more detailed example, you can refer to the `example` folder in the repository for a complete integration.
