import 'package:flutter/material.dart';
import '/presentation/widgets/models/bookings_data.dart';
import '/presentation/widgets/bookings_card.dart';

class BookingsCardList extends StatefulWidget {
  @override
  State<BookingsCardList> createState() => _BookingsCardListState();
}

class _BookingsCardListState extends State<BookingsCardList> {
  List<BookData> bookings = [
    BookData(
        eventName: 'Conference',
        eventPlace: 'Conference Center A',
        eventDate: '2024-05-15'),
    BookData(
        eventName: 'Workshop', eventPlace: 'Room B', eventDate: '2024-06-20'),
    BookData(
        eventName: 'Seminar',
        eventPlace: 'Auditorium C',
        eventDate: '2024-07-10'),
    BookData(
        eventName: 'Meeting',
        eventPlace: 'Boardroom D',
        eventDate: '2024-08-05'),
    BookData(
        eventName: 'Training',
        eventPlace: 'Training Room E',
        eventDate: '2024-09-15'),
    BookData(
        eventName: 'Webinar', eventPlace: 'Online', eventDate: '2024-10-20'),
    BookData(
        eventName: 'Product Launch',
        eventPlace: 'Exhibition Hall F',
        eventDate: '2024-11-10'),
    BookData(
        eventName: 'Team Building',
        eventPlace: 'Outdoor Park',
        eventDate: '2024-12-05'),
    BookData(
        eventName: 'Networking Event',
        eventPlace: 'Social Club G',
        eventDate: '2025-01-15'),
    BookData(
        eventName: 'Hackathon',
        eventPlace: 'Tech Hub',
        eventDate: '2025-02-20'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'My Bookings',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.cyan,
        actions: [
          Row(
            children: [
              Text(
                'USER NAME',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person),
                color: Colors.white,
                iconSize: 30,
              ),
              SizedBox(width: 10,)
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: bookings
              .map((unitBooking) => BookingsCard(
                    bookings: unitBooking,
                    cancelEvent: () {
                      setState(() {
                        bookings.remove(unitBooking);
                      });
                    },
                  ))
              .toList(),
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
