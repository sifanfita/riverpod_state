import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/book_model.dart';
import '../../providers/booking_provider.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bookingProvider.notifier).loadBookings();
      });
      _isFirstBuild = false;
    }

    final bookingState = ref.watch(bookingProvider);

    ref.listen<BookingState>(bookingProvider, (previous, next) {
      if (next is BookingError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
      if (next is BookingCancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking successfully cancelled!")),
        );
        ref
            .read(bookingProvider.notifier)
            .loadBookings(); // Refresh the list after cancellation
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: bookingState is BookingLoading
          ? Center(child: CircularProgressIndicator())
          : bookingState is BookingsLoaded
              ? ListView.builder(
                  itemCount: bookingState.bookings.length,
                  itemBuilder: (context, index) {
                    Booking booking = bookingState.bookings[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(Icons.event, color: Colors.deepPurple),
                        title: Text(booking.event.eventName),
                        subtitle: Text(
                            'Date: ${booking.bookingDate.toIso8601String()}'),
                        trailing: IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => _cancelBooking(context, booking.id),
                        ),
                      ),
                    );
                  },
                )
              : Center(child: Text('No bookings found')),
    );
  }

  void _cancelBooking(BuildContext context, int bookingId) async {
    ref.read(bookingProvider.notifier).cancelBooking(bookingId);
  }
}
