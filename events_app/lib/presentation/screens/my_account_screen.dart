import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_state.dart';
import '../../bloc/user_bloc/user_event.dart';
import 'package:events_app/presentation/screens/sign_in_screen.dart';
import 'package:events_app/utils/auth_utils.dart';

import '../../models/validation_model.dart';
import '../../utils/validation_utils.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(LoadUser());

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          _emailController.text = state.user.email;
          _firstNameController.text = state.user.firstName;
          _lastNameController.text = state.user.lastName;
        }
        if (state is UserError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is UserUpdateSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("User Details Updated")));
        }
        if (state is UserDeleteSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("User Account Deleted")));
          _logout(context);
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          return SingleChildScrollView(
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
                _buildTextField(_firstNameController, "First Name", context),
                SizedBox(height: 10),
                _buildTextField(_lastNameController, "Last Name", context),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_validateInput()) {
                      context.read<UserBloc>().add(UpdateUserDetails({
                            'email': _emailController.text,
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                          }));
                    }
                  },
                  child: Text(
                    "Update Details",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(DeleteSelf());
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
          );
        } else {
          return Center(
              child: Text("Unable to Load User Data. Please try again."));
        }
      },
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()));
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
