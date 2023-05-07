import 'package:flutter/material.dart';

import '../auth.dart';
// Make sure this import statement points to the correct location of the 'auth.dart' file.

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Auth auth = Auth();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      bool loginSuccessful = await auth.login(_emailController.text, _passwordController.text);

      if (loginSuccessful) {
        // Navigate to the next screen or show a success message
        print('Login successful');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show an error message
        print('Login failed');
        // You can also show a dialog or a snackbar with an error message to provide feedback to the user.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Don\'t have an account? Signup here.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
