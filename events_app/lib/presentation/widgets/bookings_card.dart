import 'package:flutter/material.dart';
import '/presentation/widgets/models/bookings_data.dart';

class BookingsCard extends StatelessWidget {
  final BookData bookings;
  final VoidCallback cancelEvent;

  BookingsCard({required this.bookings, required this.cancelEvent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookings.eventName,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(bookings.eventPlace),
                Text(bookings.eventDate)
              ],
            ),
            TextButton(
              onPressed: cancelEvent,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent)),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
