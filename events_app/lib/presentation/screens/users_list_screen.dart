import 'package:flutter/material.dart';
import 'package:events_app/presentation/widgets/models/users_data.dart';
import 'package:events_app/presentation/widgets/users_card.dart';

class UsersCardList extends StatefulWidget {
  @override
  State<UsersCardList> createState() => _UsersCardListState();
}

class _UsersCardListState extends State<UsersCardList> {
  List<UserData> usersData = [
    UserData(userName: 'Michael Brown', userEmail: 'michael@example.com', userRole: 'User'),
    UserData(userName: 'Emma Davis', userEmail: 'emma@example.com', userRole: 'Admin'),
    UserData(userName: 'William Wilson', userEmail: 'william@example.com', userRole: 'Moderator'),
    UserData(userName: 'Olivia Taylor', userEmail: 'olivia@example.com', userRole: 'User'),
    UserData(userName: 'James Martinez', userEmail: 'james@example.com', userRole: 'Admin'),
    UserData(userName: 'Ava Anderson', userEmail: 'ava@example.com', userRole: 'Moderator'),
    UserData(userName: 'Alexander Thomas', userEmail: 'alexander@example.com', userRole: 'User'),
    UserData(userName: 'Sophia Hernandez', userEmail: 'sophia@example.com', userRole: 'Admin'),
    UserData(userName: 'Daniel Miller', userEmail: 'daniel@example.com', userRole: 'Moderator'),
    UserData(userName: 'Isabella Jackson', userEmail: 'isabella@example.com', userRole: 'User'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Role Assignment board',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: usersData.map((user) => UsersCard(
            users: user,
            changeValue: (newValue) {
              setState(() {
                user.userRole = newValue;
              });
            },
          )).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyan,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              color: Colors.white,
            ),
            label: 'Users',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
