import 'package:flutter/material.dart';

class SignupSecurityCodeScreen extends StatefulWidget {
  @override
  _SignupSecurityCodeScreenState createState() => _SignupSecurityCodeScreenState();
}

class _SignupSecurityCodeScreenState extends State<SignupSecurityCodeScreen> {
  TextEditingController _securityCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup - Security Code'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _securityCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Security Code',
                hintText: 'Enter the security code you received',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Validate the security code and complete the registration process
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
