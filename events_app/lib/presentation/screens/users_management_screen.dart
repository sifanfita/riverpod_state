import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userProvider.notifier).loadAllUsers();
      });
      _isFirstBuild = false;
    }

    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
        backgroundColor: Colors.deepPurple,
      ),
      body: userState is UserLoading
          ? Center(child: CircularProgressIndicator())
          : userState is UsersLoaded
              ? ListView.builder(
                  itemCount: userState.users.length,
                  itemBuilder: (context, index) {
                    final user = userState.users[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(user.email),
                        subtitle: Text("Role: ${user.role}"),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            IconButton(
                              icon:
                                  Icon(Icons.arrow_upward, color: Colors.green),
                              tooltip: 'Promote to Admin',
                              onPressed: user.role != 'admin'
                                  ? () => ref
                                      .read(userProvider.notifier)
                                      .promoteUser(user.id)
                                  : null,
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.arrow_downward, color: Colors.red),
                              tooltip: 'Demote to User',
                              onPressed: user.role == 'admin'
                                  ? () => ref
                                      .read(userProvider.notifier)
                                      .demoteUser(user.id)
                                  : null,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              tooltip: 'Delete User',
                              onPressed: () =>
                                  _confirmDeletion(context, user.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : userState is UserError
                  ? Center(
                      child: Text('Failed to load users: ${userState.message}'))
                  : Center(child: Text('Unknown state')),
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
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref.read(userProvider.notifier).deleteUser(userId);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
