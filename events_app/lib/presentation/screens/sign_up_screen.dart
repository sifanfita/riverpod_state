import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:events_app/presentation/screens/events_screen.dart';
import 'package:events_app/presentation/screens/sign_in_screen.dart';
import 'package:events_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:events_app/bloc/auth_bloc/auth_event.dart';
import 'package:events_app/bloc/auth_bloc/auth_state.dart';
import '../../utils/notification_utils.dart';
import '../../utils/validation_utils.dart';

class SignUpScreen extends StatelessWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use an existing instance of AuthBloc
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is AuthSuccess) {
            NotificationUtils.showSnackBar(context, 'Sign up successful.',
                isError: false);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => EventsScreen()));
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
                onPressed: () => _onSignUpButtonPressed(context, authBloc),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Background color
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SignInScreen()));
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

  void _onSignUpButtonPressed(BuildContext context, AuthBloc authBloc) {
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

    authBloc.add(SignUpRequested(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
    ));
  }
}
