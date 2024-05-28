import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validation_utils.dart';
import '../../utils/notification_utils.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void navigateBasedOnRole(BuildContext context, String role) {
    if (role == 'admin') {
      context.go('/admin');
    } else {
      context.go('/events');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        NotificationUtils.showSnackBar(context, 'Sign in successful.',
            isError: false);
        navigateBasedOnRole(context, next.role);
      } else if (next is AuthFailure) {
        NotificationUtils.showSnackBar(context, next.error, isError: true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/logo.png', width: 100, height: 100),
            const SizedBox(height: 20),
            buildTextField(emailController, 'Email', 'Enter your email'),
            const SizedBox(height: 10),
            buildTextField(
                passwordController, 'Password', 'Enter your password',
                isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onSignInButtonPressed(
                  context, ref.read(authProvider.notifier)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                context.go('/signup');
              },
              child: const Text(
                "Don't have an account? Sign up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, String hintText,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.grey[850],
        filled: true,
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  void _onSignInButtonPressed(BuildContext context, AuthNotifier authNotifier) {
    // Validate email
    final emailValidation = ValidationUtils.validateEmail(emailController.text);
    if (!emailValidation.isValid) {
      NotificationUtils.showSnackBar(context, emailValidation.error,
          isError: true);
      return;
    }
    // Validate password
    final passwordValidation =
        ValidationUtils.validatePassword(passwordController.text);
    if (!passwordValidation.isValid) {
      NotificationUtils.showSnackBar(context, passwordValidation.error,
          isError: true);
      return;
    }
    // Perform sign-in
    authNotifier.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
