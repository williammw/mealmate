import 'package:flutter/material.dart';
import '../api.dart';
import 'login_screen.dart';

class SignupStep3Screen extends StatefulWidget {
  final Map<String, String> userData;

  const SignupStep3Screen({required this.userData});

  @override
  _SignupStep3ScreenState createState() => _SignupStep3ScreenState();
}

class _SignupStep3ScreenState extends State<SignupStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _confirmationCodeController;

  @override
  void initState() {
    super.initState();
    _confirmationCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3: Confirmation Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter the confirmation code sent to your email:'),
                TextFormField(
                  controller: _confirmationCodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the confirmation code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      print('Form validation passed');

                      try {
                        // Call the API to verify the security code
                        final result = await Api.verifySecurityCode(
                          widget.userData['email_or_phone']!,
                          _confirmationCodeController.text,
                          widget.userData['auth_token']!,
                        );

                        if (result) {
                          print('Security code verification successful');
                          // Navigate to the login screen after successful verification
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          print('Security code verification failed');
                          // Show an error message if verification fails
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Invalid confirmation code.'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } catch (e) {
                        print('Error while verifying security code: $e');
                      }
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
