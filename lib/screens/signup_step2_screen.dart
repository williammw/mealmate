import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api.dart';
import '../auth.dart';
import 'signup_step3_screen.dart';

class SignupStep2Screen extends StatefulWidget {
  final Map<String, String> userData;

  const SignupStep2Screen({required this.userData});

  @override
  _SignupStep2ScreenState createState() => _SignupStep2ScreenState();
}

class _SignupStep2ScreenState extends State<SignupStep2Screen> {
  String _generateSecurityCode() {
    var random = Random();
    return List.generate(6, (index) => random.nextInt(10).toString()).join('');
  }

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _diningWithController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print('User data passed from SignupScreen: ${widget.userData}');
  }

  @override
  void dispose() {
    _dobController.dispose();
    _diningWithController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2: Additional Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter your date of birth:'),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _dobController.text.isNotEmpty ? DateTime.parse(_dobController.text) : DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null)
                      setState(() {
                        _dobController.text = picked.toIso8601String().substring(0, 10);
                      });
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(hintText: 'YYYY-MM-DD'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Enter the number of people you dine with:'),
                TextFormField(
                  controller: _diningWithController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Generate a security code
                      String securityCode = _generateSecurityCode();

                      // Add additional information to userData
                      widget.userData['dob'] = _dobController.text;
                      widget.userData['dining_with'] = _diningWithController.text;

                      // Initialize the Auth class
                      Auth auth = Auth();

                      // Call the signup method from the Auth class
                      // Logger().i(widget.userData);
                      bool isSignedUp = await auth.signup(
                        widget.userData['email_or_phone'] ?? '',
                        widget.userData['password'] ?? '',
                        widget.userData['username'] ?? '',
                        widget.userData['full_name'] ?? '',
                        DateTime.parse(widget.userData['dob'] ?? '1970-01-01'),
                        int.parse(widget.userData['dining_with'] ?? '0'),
                      );

                      if (isSignedUp) {
                        // Save user data using the API
                        await Api.saveUserData(widget.userData['email_or_phone']!, securityCode);

                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupStep3Screen(
                              userData: widget.userData,
                            ),
                          ),
                        );
                      } else {
                        // Show an error message if the signup fails
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Signup failed. Please try again.'),
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
                    }
                  },
                  child: const Text('Generate and Send Security Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
