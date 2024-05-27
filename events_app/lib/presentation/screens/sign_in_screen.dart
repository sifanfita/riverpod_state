import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';
import '../../utils/validation_utils.dart';
import '../../utils/notification_utils.dart';
import 'admin_homepage_screen.dart';
import 'events_screen.dart';
import 'sign_up_screen.dart';

import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Use an existing instance of AuthBloc
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc, // Use the provided AuthBloc
        listener: (context, state) {
          if (state is AuthSuccess) {
            NotificationUtils.showSnackBar(context, 'Sign in successful.',
                isError: false);
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //     builder: (context) =>
            //         state.role == 'admin' ? AdminHomePage() : EventsScreen()));
            navigateBasedOnRole(context, state.role);
          } else if (state is AuthFailure) {
            NotificationUtils.showSnackBar(context, state.error, isError: true);
          }
        },
        child: SingleChildScrollView(
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
                onPressed: () => _onSignInButtonPressed(context, authBloc),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Background color
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => SignUpScreen()),
                  // );
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

  void _onSignInButtonPressed(BuildContext context, AuthBloc authBloc) {
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
    // Dispatch sign-in event
    authBloc.add(SignInRequested(
      email: emailController.text,
      password: passwordController.text,
    ));
  }
}
