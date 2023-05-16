import 'package:flutter/material.dart';

class SignupSecurityCodeScreen extends StatefulWidget {
  @override
  _SignupSecurityCodeScreenState createState() => _SignupSecurityCodeScreenState();
}

class _SignupSecurityCodeScreenState extends State<SignupSecurityCodeScreen> {
  final TextEditingController _securityCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup - Security Code'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _securityCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Security Code',
                hintText: 'Enter the security code you received',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Validate the security code and complete the registration process
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
