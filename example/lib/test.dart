import 'package:example/checkout.dart';
import 'package:flutter/material.dart';
import 'package:safepay_checkout/safepay_payment_gateway.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        environment: _selectedEnvironment,
                        successUrl: _successUrlController.text,
                        failUrl: _failUrlController.text,
                        tbt:
                            "lwoMYaQ304j5CLdM2ha2JwV69rITMlsxVMuQE7rbnGL455zu7JcWxMTwe3ULB5TkwK-YZWnRvw==",
                        tracker: "track_0bc34443-d969-4fc2-9780-333e1e438c96",
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Proceed with Payment',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
            // Safepay Checkout Widget
          ],
        ),
      ),
    );
  }
}
