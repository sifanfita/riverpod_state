import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_event.dart';
import '../../bloc/user_bloc/user_state.dart';
import '../../api/user_api.dart';
import '../../models/user_model.dart';
import '../../utils/auth_utils.dart';
import '../../utils/validation_utils.dart';
import '../../models/validation_model.dart';
import 'sign_in_screen.dart';

import 'package:go_router/go_router.dart';

class PersonalAccountScreen extends StatefulWidget {
  @override
  _PersonalAccountScreenState createState() => _PersonalAccountScreenState();
}

class _PersonalAccountScreenState extends State<PersonalAccountScreen> {
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
        if (state is UserUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Details updated successfully!")),
          );
        }
        if (state is UserDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account deleted successfully!")),
          );
          _logout(context);
        }
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
                  backgroundImage:
                      AssetImage('assets/images/sample.png'), // Example image
                ),
                SizedBox(height: 20),
                _buildTextField(_emailController, "Email"),
                SizedBox(height: 10),
                _buildTextField(_firstNameController, "First Name"),
                SizedBox(height: 10),
                _buildTextField(_lastNameController, "Last Name"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateDetails,
                  child: Text("Update Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                ElevatedButton(
                  onPressed: _attemptDeleteAccount,
                  child: Text("Delete Account"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text("Unable to load user data."));
        }
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
      ),
    );
  }

  void _updateDetails() {
    if (_validateInput()) {
      context.read<UserBloc>().add(UpdateUserDetails({
            'email': _emailController.text,
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
          }));
    }
  }

  bool _validateInput() {
    ValidationResult emailValidation =
        ValidationUtils.validateEmail(_emailController.text);
    if (!emailValidation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailValidation.error)),
      );
      return false;
    }

    ValidationResult nameValidation =
        ValidationUtils.validateName(_firstNameController.text);
    if (!nameValidation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(nameValidation.error)),
      );
      return false;
    }

    return true;
  }

  void _attemptDeleteAccount() async {
    // Check if there are other admins
    var token = await AuthUtils.getToken();
    if (token != null) {
      var response = await UserApi.getUsers(token);
      if (response['success']) {
        var users =
            List<User>.from(response['data'].map((x) => User.fromJson(x)));
        // Count admins
        int adminCount = users.where((user) => user.role == 'admin').length;

        // Check if current user is the only admin
        if (adminCount > 1) {
          // If there are other admins, proceed with deletion
          context.read<UserBloc>().add(DeleteSelf());
        } else {
          // Prevent deletion if this is the only admin
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "You cannot delete the only admin account. Please promote another user first.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to retrieve users: ${response['error']}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication token is missing.")),
      );
    }
  }

  void _logout(BuildContext context) async {
    await AuthUtils.setToken(null); // Clear token
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => SignInScreen()));
    context.go('/signin');
  }
}
