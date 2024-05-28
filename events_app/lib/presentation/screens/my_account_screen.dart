import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../utils/auth_utils.dart';
import '../../utils/validation_utils.dart';
import '../../models/validation_model.dart';

import 'package:go_router/go_router.dart';

class MyAccountScreen extends ConsumerStatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends ConsumerState<MyAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    ref.listen<UserState>(userProvider, (previous, next) {
      if (next is UserLoaded) {
        _emailController.text = next.user.email;
        _firstNameController.text = next.user.firstName;
        _lastNameController.text = next.user.lastName;
      }
      if (next is UserUpdateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Details Updated")),
        );
      }
      if (next is UserDeleteSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Account Deleted")),
        );
        _logout(context);
      }
      if (next is UserError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        backgroundColor: Colors.deepPurple,
      ),
      body: userState is UserLoading
          ? Center(child: CircularProgressIndicator())
          : userState is UserLoaded
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/image.png'), // Placeholder for user image
                      ),
                      SizedBox(height: 20),
                      _buildTextField(_emailController, "Email", context),
                      SizedBox(height: 10),
                      _buildTextField(
                          _firstNameController, "First Name", context),
                      SizedBox(height: 10),
                      _buildTextField(
                          _lastNameController, "Last Name", context),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_validateInput()) {
                            ref.read(userProvider.notifier).updateUserDetails({
                              'email': _emailController.text,
                              'firstName': _firstNameController.text,
                              'lastName': _lastNameController.text,
                            });
                          }
                        },
                        child: Text(
                          "Update Details",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(userProvider.notifier).deleteSelf();
                        },
                        child: Text("Delete Account"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _logout(context),
                        child: Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[850],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text("Unable to Load User Data. Please try again.")),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[800], // Adjusted color for better blending
        hintStyle: TextStyle(color: Colors.white30),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await AuthUtils.setToken(null); // Clear token
    context.go('/signin'); // Navigate to the sign-in screen using go_router
  }

  bool _validateInput() {
    // Validate Email
    ValidationResult emailResult =
        ValidationUtils.validateEmail(_emailController.text);
    if (!emailResult.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailResult.error)),
      );
      return false;
    }

    // Validate First Name
    ValidationResult firstNameResult =
        ValidationUtils.validateName(_firstNameController.text);
    if (!firstNameResult.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(firstNameResult.error)),
      );
      return false;
    }

    // Validate Last Name
    ValidationResult lastNameResult =
        ValidationUtils.validateName(_lastNameController.text);
    if (!lastNameResult.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lastNameResult.error)),
      );
      return false;
    }

    // All validations passed
    return true;
  }
}
