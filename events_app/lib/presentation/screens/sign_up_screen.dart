import 'package:events_app/presentation/screens/events_screen.dart';
import 'package:events_app/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignUpScreen(),
  ));
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              IntrinsicWidth(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        'Taatee'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create A New Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'First Name')),
              const SizedBox(
                height: 8,
              ),
              TextField(
                style: const TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    labelText: 'Sifan',
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12)),
              ),
              const SizedBox(height: 16),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'Last Name')),
              const SizedBox(
                height: 8,
              ),
              TextField(
                style: const TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    labelText: 'Fita',
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12)),
              ),
              const SizedBox(height: 16),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'Your Email')),
              const SizedBox(
                height: 8,
              ),
              TextField(
                style: const TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    labelText: 'sifanfita@gmail.com',
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12)),
              ),
              const SizedBox(height: 16),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'Password')),
              const SizedBox(
                height: 8,
              ),
              TextField(
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
                obscureText: true,
                decoration: InputDecoration(
                    labelText: '........',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12)),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => EventsScreen()));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    'Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SignInScreen()));
                },
                child: const Text(
                    style: TextStyle(color: Colors.grey),
                    'Already have an account? Sign In'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
