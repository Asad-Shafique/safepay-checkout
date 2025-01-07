import 'package:flutter/material.dart';
import 'package:safepay_checkout/safepay_payment_gateway.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController =
      TextEditingController(text: "15000");
  final TextEditingController _successUrlController =
      TextEditingController(text: "https://www.google.com/maps");
  final TextEditingController _failUrlController =
      TextEditingController(text: "https://www.olx.com.pk");

  SafePayEnvironment _selectedEnvironment = SafePayEnvironment.sandbox;

  @override
  void dispose() {
    _amountController.dispose();
    _successUrlController.dispose();
    _failUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safepay Checkout"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Amount Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the amount";
                  }
                  return null;
                },
              ),
            ),

            // Success URL Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _successUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Success URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the success URL";
                  }
                  return null;
                },
              ),
            ),

            // Fail URL Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _failUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Fail URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the fail URL";
                  }
                  return null;
                },
              ),
            ),

            // Environment Dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<SafePayEnvironment>(
                value: _selectedEnvironment,
                decoration: const InputDecoration(
                  labelText: "Environment",
                  border: OutlineInputBorder(),
                ),
                items: SafePayEnvironment.values.map((environment) {
                  return DropdownMenuItem(
                    value: environment,
                    child: Text(environment.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEnvironment = value!;
                  });
                },
              ),
            ),

            // Safepay Checkout Widget
            SafepayCheckout(
              checkoutButton: (context) {
                return const Text(
                  "Proceed to Pay",
                  style: TextStyle(fontSize: 24),
                );
              },
              amount: int.tryParse(_amountController.text)!.toDouble(),
              publicKey: 'your_client_key',
              secretKey: 'your_secret_key',
              currency: 'PKR',
              environment: _selectedEnvironment,
              orderId: '12345',
              onPaymentFailed: () {
                print('cancel');
              },
              onPaymentCompleted: () {
                print('Payment successful');
              },
              onAuthenticationError: () {
                print('Authentication error');
              },
              successUrl: _successUrlController.text,
              failUrl: _failUrlController.text,
            ),
          ],
        ),
      ),
    );
  }
}
