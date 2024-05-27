import 'package:events_app/bloc/user_bloc/user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_state.dart';

import 'package:go_router/go_router.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserUpdateSuccess) {
            BlocProvider.of<UserBloc>(context).add(LoadAllUsers());
            return Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(user.email),
                    subtitle: Text("Role: ${user.role}"),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_upward, color: Colors.green),
                          tooltip: 'Promote to Admin',
                          onPressed: user.role != 'admin'
                              ? () => context.read<UserBloc>().add(
                                    PromoteUser(user.id),
                                  )
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_downward, color: Colors.red),
                          tooltip: 'Demote to User',
                          onPressed: user.role == 'admin'
                              ? () => context.read<UserBloc>().add(
                                    DemoteUser(user.id),
                                  )
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.black),
                          tooltip: 'Delete User',
                          onPressed: () => _confirmDeletion(context, user.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Failed to load users'));
          }
          return Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  void _confirmDeletion(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              // onPressed: () => Navigator.of(dialogContext).pop(),
              onPressed: () => context.pop(),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<UserBloc>().add(DeleteUser(userId));
                // Navigator.of(dialogContext).pop();
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
