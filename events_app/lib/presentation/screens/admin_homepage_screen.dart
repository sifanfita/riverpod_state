import 'package:events_app/presentation/screens/create_event_screen.dart';
import 'package:flutter/material.dart';

class Event {
  String name;
  String location;
  String date;

  Event(this.name, this.location, this.date);
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final List<Event> events = [
    Event('January Tech Fest', 'Location: AAIT', 'Date: Jan 21, 2024'),
    Event('Girls can code', 'Location: AASTU', 'Date: March 23, 2024'),
    Event('Tech Networks', 'Location: Alx Hub', 'Date: June 21, 2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Upcoming Events',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  width: double.infinity,
                  height: 120,
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.6),
                    child: ListTile(
                      title: Text(
                        event.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.location),
                          Text(event.date),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Handle edit button pressed
                              print(
                                  'Edit button pressed for event at index $index');
                            },
                            child: const Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // Handle delete button pressed
                                events.removeAt(index);
                              });
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () {
            // Handle add event button pressed
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const CreateEventScreen()),
            );
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text(
            'Add Event',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
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
              Icons.person,
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
