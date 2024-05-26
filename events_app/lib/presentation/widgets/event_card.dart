import 'package:flutter/material.dart';
import 'package:events_app/models/event_model.dart';
import 'package:events_app/presentation/screens/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    String status = event.isCanceled
        ? 'Cancelled'
        : (event.bookings.length >= (event.maxBooking ?? 999)
            ? 'Fully Booked'
            : 'Available');

    // Determine status color
    Color statusColor = event.isCanceled
        ? Colors.red
        : (event.bookings.length >= (event.maxBooking ?? 999)
            ? Colors.orange
            : Colors.green);

    return Card(
      margin: EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias, // Gives the card rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for the card
      ),
      elevation: 5, // Shadow effect
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Ink.image(
                image: AssetImage(
                    'assets/event_images/${event.id % 2}.jpg'), // Placeholder image
                height: 200,
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      Colors.black.withOpacity(0.5), // Semi-transparent overlay
                ),
                child: Text(
                  event.eventName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${event.eventDate.toIso8601String()}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Location: ${event.location}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailScreen(event: event),
                    ),
                  );
                },
                child: const Text('DETAILS'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
