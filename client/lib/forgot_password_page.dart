import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  int currentStep = 0;

  void _nextStep() {
    setState(() {
      currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      currentStep--;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentStep == 0) ...[
              const Text(
                'Enter your phone number to reset password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (phoneController.text.isEmpty) {
                    _showSnackBar('Phone number cannot be empty');
                  } else {
                    _showSnackBar('Verification code sent');
                    _nextStep();
                  }
                },
                child: const Text('Next'),
              ),
            ] else if (currentStep == 1) ...[
              const Text(
                'Enter the verification code sent to your phone',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (codeController.text.isEmpty) {
                    _showSnackBar('Verification code cannot be empty');
                  } else {
                    _nextStep();
                  }
                },
                child: const Text('Next'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _previousStep,
                child: const Text('Back'),
              ),
            ] else if (currentStep == 2) ...[
              const Text(
                'Reset Your Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final newPassword = newPasswordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (newPassword.isEmpty || confirmPassword.isEmpty) {
                    _showSnackBar('Password cannot be empty');
                  } else if (newPassword.length <= 6) {
                    _showSnackBar('Password must be more than 6 characters');
                  } else if (newPassword != confirmPassword) {
                    _showSnackBar('Passwords do not match');
                  } else {
                    _showSnackBar('Password reset successfully');
                    Navigator.pop(context);
                  }
                },
                child: const Text('Reset Password'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _previousStep,
                child: const Text('Back'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
