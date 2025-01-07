
# Safepay Payment Gateway
A Flutter package to integrate Safepay Payment Gateway for seamless and secure payment processing. This package supports both sandbox and production environments, provides options for customization, and handles payment success, failure, and authentication errors.
### Currently available on Android, Ios and Web

## Installation
Add the following dependency in your pubspec.yaml:
    safepay_checkout:
Run:
    flutter pub get

Or simply run:
    flutter pub add safepay_checkout


## Features
Customizable checkout button.
Supports sandbox and production environments.
Handles payment success and failure.
Displays an in-app web view for the checkout process.
Easy API integration with clientKey and secretKey.
Usage
Follow these steps to integrate the package into your Flutter app:

### 1. Import the Package
dart
Copy code
import 'package:safepay_checkout/safepay_payment_gateway.dart';

### 2. Add the Safepay Checkout Widget
Use the SafepayCheckout widget to initiate payments:
 
```dart
SafepayCheckout(
  amount: 15000, // Payment amount
  publicKey: 'your_client_key',
  secretKey: 'your_secret_key',
  currency: 'PKR',
  environment: SafePayEnvironment.sandbox, // or SafePayEnvironment.production
  orderId: '12345', // Unique order ID
  successUrl: 'https://www.yoursuccessurl.com', // On payment success
  failUrl: 'https://www.yourfailureurl.com',   // On payment failure
  checkoutButton: (context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Pay Now',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  },
  onPaymentFailed: () {
    // Handle payment failure
    print('Payment failed.');
  },
  onPaymentCompleted: () {
    // Handle payment success
    print('Payment completed.');
  },
  onAuthenticationError: () {
    // Handle authentication errors
    print('Authentication error.');
  },
)```

### 3. Handle Payment States
Implement callback functions to handle the following states:

onPaymentCompleted: Triggered when payment is successfully completed.
onPaymentFailed: Triggered when the payment process fails.
onAuthenticationError: Triggered when authentication fails.
API Reference
Parameters
Parameter	Type	Description
amount	double	The amount to be charged (in minor units, e.g., 15000 = PKR 150.00).
publicKey	String	The client key provided by Safepay.
secretKey	String	The secret key provided by Safepay.
currency	String	Currency code (e.g., PKR).
environment	SafePayEnvironment	sandbox or production.
orderId	String	Unique identifier for the order.
successUrl	String	URL to redirect to upon payment success.
failUrl	String	URL to redirect to upon payment failure.
checkoutButton	Widget Function(BuildContext)	Custom widget for the checkout button.
onPaymentFailed	VoidCallback	Callback for payment failure.
onPaymentCompleted	VoidCallback	Callback for payment success.
onAuthenticationError	VoidCallback	Callback for authentication error.
Example
Here’s a complete example to get started:


### Example code
```dart
import 'package:flutter/material.dart';
import 'package:safepay_checkout/safepay_payment_gateway.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Safepay Payment Gateway')),
        body: Center(
          child: SafepayCheckout(
            amount: 15000,
            clientKey: 'your_client_key',
            secretKey: 'your_secret_key',
            currency: 'PKR',
            environment: SafePayEnvironment.sandbox,
            orderId: '12345',
            successUrl: 'https://www.yoursuccessurl.com',
            failUrl: 'https://www.yourfailureurl.com',
            checkoutButton: (context) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Proceed to Pay',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            },
            onPaymentFailed: () {
              print('Payment failed.');
            },
            onPaymentCompleted: () {
              print('Payment successful!');
            },
            onAuthenticationError: () {
              print('Authentication error occurred.');
            },
          ),
        ),
      ),
    );
  }
}
```