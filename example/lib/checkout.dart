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
              checkoutButton: (context) {
                return Container(
                    child: Text(
                  'Pay',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ));
              },
              amount: 15000,
              clientKey: 'sec_a7cc6fc1-088d-4f35-9dac-2bab2cb234a1',
              secretKey:
                  '75f04a7ed46b9bad0bb50fa4fcc27667c6766aa6d9ce57857148a412c5e44267',
              currency: 'PKR',
              environment: SafePayEnvironment.sandbox,
              orderId: '12345',
              onPaymentFailed: () {
                print('cancel');
              },
              onPaymentCompleted: () {
                print('fine working');
              },
              onAuthenticationError: () {
                print('auth error');
              },
              successUrl: 'https://www.google.com/maps',
              failUrl: 'https://www.olx.com.pk/',
            ),
          ),
        ],
      ),
    );
  }
}
