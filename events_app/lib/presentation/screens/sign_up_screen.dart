import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/notification_utils.dart';
import '../../utils/validation_utils.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        NotificationUtils.showSnackBar(context, 'Sign up successful.',
            isError: false);
        context.go('/events');
      } else if (next is AuthFailure) {
        NotificationUtils.showSnackBar(context, next.error, isError: true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
            buildTextField(
                firstNameController, 'First Name', 'Enter your first name'),
            const SizedBox(height: 10),
            buildTextField(
                lastNameController, 'Last Name', 'Enter your last name'),
            const SizedBox(height: 10),
            buildTextField(emailController, 'Email', 'Enter your email'),
            const SizedBox(height: 10),
            buildTextField(
                passwordController, 'Password', 'Enter your password',
                isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onSignUpButtonPressed(
                  context, ref.read(authProvider.notifier)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                context.go('/signin');
              },
              child: const Text(
                "Already have an account? Sign In",
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

  void _onSignUpButtonPressed(BuildContext context, AuthNotifier authNotifier) {
    final firstNameValid =
        ValidationUtils.validateName(firstNameController.text);
    final lastNameValid = ValidationUtils.validateName(lastNameController.text);
    final emailValid = ValidationUtils.validateEmail(emailController.text);
    final passwordValid =
        ValidationUtils.validatePassword(passwordController.text);

    if (!firstNameValid.isValid ||
        !lastNameValid.isValid ||
        !emailValid.isValid ||
        !passwordValid.isValid) {
      NotificationUtils.showSnackBar(context, 'Please check your inputs.',
          isError: true);
      return;
    }

    authNotifier.signUp(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
