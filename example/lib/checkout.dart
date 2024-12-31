import 'package:flutter/material.dart';
import 'package:safepay_payment_gateway/safepay_payment_gateway.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SafepayCheckout(
              amount: 100,
              clientKey: 'sec_1a615635-8865-477b-b66c-a3adcb69cba7',
              currency: 'PKR',
              environment: Environment.sandbox,
              orderId: '12345',
              onPaymentCancelled: () {
                print('cancel');
              },
              onPaymentComplete: () {
                print('complete');
              },
              onErrorFetchingTracker: () {
                print('error');
              },
              successUrl: 'https://www.google.com/maps',
              errorUrl: 'https://www.olx.com.pk/',
              buttonTheme: ThemeType.dark,
            ),
          ),
        ],
      ),
    );
  }
}
