import 'package:flutter/material.dart';

class SignupBirthdateScreen extends StatefulWidget {
  @override
  _SignupBirthdateScreenState createState() => _SignupBirthdateScreenState();
}

class _SignupBirthdateScreenState extends State<SignupBirthdateScreen> {
  DateTime? _selectedDate;
  int? _numberOfPeople;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup - Birthdate & Guests'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                hintText: 'Select your date of birth',
              ),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of people',
                hintText: 'Enter the number of people you usually dine with',
              ),
              onChanged: (value) {
                setState(() {
                  _numberOfPeople = int.tryParse(value);
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Save user's birthdate and number of people, then navigate to the next screen
                Navigator.pushNamed(context, '/signup_securitycode');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
