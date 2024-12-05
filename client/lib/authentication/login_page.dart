import 'package:client/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:client/authentication/register_page.dart';
import 'package:client/mail/home_page.dart';
import 'package:client/account/forgot_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordChecked = false;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }


  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneController.text = prefs.getString('phoneNumber') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
    });
  }

  Future<void> _saveUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneController.text);
    await prefs.setString('password', passwordController.text);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> data = userData['data'];
    prefs.setString('_id', data['_id']);
    prefs.setString('accessToken', data['accessToken']);
    prefs.setString('avatar', data['avatar']);
    prefs.setString('full_name', data['full_name']);
    prefs.setBool('two_step_verification', data['two_step_verification']);
    prefs.setString('phone', data['phone']);
    prefs.setString('email', data['email']);
  }

  @override
  Widget build(BuildContext context) {
    const api_url = "https://email.huynhnhathao.site/api/v1/email/users/sign-in";
    final userService = new UserApiService(api_url);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            TextField(
              controller: passwordController,
              obscureText: !isPasswordChecked,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isPasswordChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isPasswordChecked = value ?? false;
                    });
                  },
                ),
                const Text("Show Password"),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final userData = {
                  'phone': phoneController.text,
                  'password': passwordController.text
                };
                final response = await userService.signInUser(userData);

                if(response?['statusCode'] == 200){
                  _saveUserCredentials();
                  _saveUserData(response!);
                  //Check two step verification

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }else {
                  final String errorMessage = response?['message'] ?? 'An error occurred';

                  // Show the error in a SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
