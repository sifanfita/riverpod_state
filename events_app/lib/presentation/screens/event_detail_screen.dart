import 'package:events_app/api/book_api.dart';
import 'package:flutter/material.dart';
import 'package:events_app/models/event_model.dart';
import 'package:events_app/models/book_model.dart';
import 'package:events_app/utils/auth_utils.dart';
import 'package:events_app/api/event_api.dart';
import 'package:events_app/api/user_api.dart';
import 'package:events_app/utils/notification_utils.dart';
import 'package:events_app/presentation/screens/sign_in_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool? isBooked;
  int? bookingId;

  @override
  void initState() {
    super.initState();
    _checkIfBooked();
  }

  Future<void> _checkIfBooked() async {
    String? accessToken = await AuthUtils.getToken();
    if (accessToken != null) {
      var bookingsResult = await UserApi.getSelfBookings(accessToken);
      if (bookingsResult['success']) {
        var bookings = List<Booking>.from(
            bookingsResult['data'].map((model) => Booking.fromJson(model)));

        setState(() {
          isBooked =
              bookings.any((booking) => booking.event.id == widget.event.id);
          bookingId = (bookings
              .firstWhere((booking) => booking.event.id == widget.event.id)).id;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/event_images/${widget.event.id % 2}.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.eventName),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'event-image-${widget.event.id}',
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${widget.event.eventDate.toIso8601String()}',
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 10),
                  Text('Location: ${widget.event.location}',
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 10),
                  Text('Description:',
                      style: Theme.of(context).textTheme.headline5),
                  Text(widget.event.description,
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 20),
                  if (isBooked != null)
                    ElevatedButton(
                      onPressed: () => _handleEventBooking(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBooked!
                            ? Colors.red
                            : Colors.green, // Red for cancel, green for book
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isBooked! ? 'Cancel Booking' : 'Book Now'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEventBooking(BuildContext context) async {
    String? accessToken = await AuthUtils.getToken();
    if (accessToken != null) {
      var result = isBooked!
          ? await BookApi.deleteBooking(
              bookingId ?? 0, accessToken) // Assuming this method exists
          : await EventApi.bookEvent(widget.event.id, accessToken);

      if (result['success']) {
        NotificationUtils.showSnackBar(
            context,
            isBooked!
                ? 'Booking canceled successfully!'
                : 'Booking successful!',
            isError: false);
        setState(() {
          isBooked = !isBooked!;
        });
      } else {
        NotificationUtils.showSnackBar(context,
            'Operation failed: ${result["data"]?["message"] ?? "Unknown Error Occurred."}',
            isError: true);
      }
    } else {
      NotificationUtils.showSnackBar(
          context, 'Error: No access token found, please log in.',
          isError: true);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => SignInScreen()));
    }
  }
}
