import 'package:flutter/material.dart';
import 'package:events_app/presentation/widgets/models/users_data.dart';

class UsersCard extends StatelessWidget {
  final UserData users;
  final Function(String)? changeValue;

  UsersCard({required this.users, this.changeValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  users.userName,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(users.userEmail),
              ],
            ),
            Container(
              child: DropdownButton<String>(
                value: users.userRole,
                style: const TextStyle(color: Colors.black),
                onChanged: (newValue) {
                  if (changeValue != null) {
                    changeValue!(newValue!);
                  }
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Moderator',
                    child: Text('Moderator'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'User',
                    child: Text('User'),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
