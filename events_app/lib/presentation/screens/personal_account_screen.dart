import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../api/user_api.dart';
import '../../models/user_model.dart';
import '../../utils/auth_utils.dart';
import '../../utils/validation_utils.dart';
import '../../models/validation_model.dart';
import 'sign_in_screen.dart';

import 'package:go_router/go_router.dart';

class PersonalAccountScreen extends ConsumerStatefulWidget {
  @override
  _PersonalAccountScreenState createState() => _PersonalAccountScreenState();
}

class _PersonalAccountScreenState extends ConsumerState<PersonalAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userProvider.notifier).loadUser();
      });
      _isFirstBuild = false;
    }

    final userState = ref.watch(userProvider);

    ref.listen<UserState>(userProvider, (previous, next) {
      if (next is UserLoaded) {
        _emailController.text = next.user.email;
        _firstNameController.text = next.user.firstName;
        _lastNameController.text = next.user.lastName;
      }
      if (next is UserUpdateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Details updated successfully!")),
        );
      }
      if (next is UserDeleteSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account deleted successfully!")),
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
        title: Text("Personal Account"),
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
                            'assets/images/sample.png'), // Example image
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
                )
              : Center(child: Text("Unable to load user data.")),
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
      ref.read(userProvider.notifier).updateUserDetails({
        'email': _emailController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
      });
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
    var token = await AuthUtils.getToken();
    if (token != null) {
      var response = await UserApi.getUsers(token);
      if (response['success']) {
        var users =
            List<User>.from(response['data'].map((x) => User.fromJson(x)));
        int adminCount = users.where((user) => user.role == 'admin').length;

        if (adminCount > 1) {
          ref.read(userProvider.notifier).deleteSelf();
        } else {
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
    context.go('/signin');
  }
}
