import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignUpScreen(),
  ));
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              IntrinsicWidth(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/tate_logo.png',
                      width: 70,
                      height: 70,
                    ),
                    SizedBox(width: 8),
                    Text(
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        'Taatee'),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Align(
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
              SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'First Name')),
              SizedBox(
                height: 8,
              ),
              TextField(
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    labelText: 'Sifan',
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              ),
              SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'Last Name')),
              SizedBox(
                height: 8,
              ),
              TextField(
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    labelText: 'Fita',
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              ),
              SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'Your Email')),
              SizedBox(
                height: 8,
              ),
              TextField(
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    labelText: 'sifanfita@gmail.com',
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              ),
              SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      'Password')),
              SizedBox(
                height: 8,
              ),
              TextField(
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                obscureText: true,
                decoration: InputDecoration(
                    labelText: '........',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    'Sign Up'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: Text(
                    style: TextStyle(color: Colors.grey),
                    'Already have an account? Sign In'),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
