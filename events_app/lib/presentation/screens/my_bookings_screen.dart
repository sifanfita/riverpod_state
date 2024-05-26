import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/booking_bloc/book_bloc.dart';
import '../../bloc/booking_bloc/book_event.dart';
import '../../bloc/booking_bloc/book_state.dart';
import '../../models/book_model.dart';
import '../../utils/auth_utils.dart';
import '../../api/book_api.dart';

class MyBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<BookingBloc>().add(LoadBookings());

    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is BookingCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Booking successfully cancelled!")));
            context
                .read<BookingBloc>()
                .add(LoadBookings()); // Refresh the list after cancellation
          }
        },
        builder: (context, state) {
          if (state is BookingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BookingsLoaded) {
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                Booking booking = state.bookings[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.event, color: Colors.deepPurple),
                    title: Text(booking.event.eventName),
                    subtitle:
                        Text('Date: ${booking.bookingDate.toIso8601String()}'),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => _cancelBooking(context, booking.id),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No bookings found'));
          }
        },
      ),
    );
  }

  void _cancelBooking(BuildContext context, int bookingId) async {
    String? token = await AuthUtils.getToken();
    if (token != null) {
      var result = await BookApi.deleteBooking(bookingId, token);
      if (result['success']) {
        // Dispatch a CancelBooking event to the Bloc
        BlocProvider.of<BookingBloc>(context).add(CancelBooking(bookingId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to cancel booking: ${result['error']}"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Authentication error. Please log in again."),
      ));
    }
  }
}
