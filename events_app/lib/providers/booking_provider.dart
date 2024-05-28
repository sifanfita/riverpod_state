import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:events_app/utils/auth_utils.dart';
import 'package:events_app/api/user_api.dart';
import 'package:events_app/api/book_api.dart';
import 'package:events_app/models/book_model.dart';

// Define the states
abstract class BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<Booking> bookings;
  BookingsLoaded(this.bookings);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingCancelled extends BookingState {}

// Define the provider
final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

// Define the StateNotifier
class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(BookingLoading());

  Future<void> loadBookings() async {
    state = BookingLoading();
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.getSelfBookings(token);
        if (result['success']) {
          final bookings =
              (result['data'] as List).map((e) => Booking.fromJson(e)).toList();
          state = BookingsLoaded(bookings);
        } else {
          state = BookingError("Failed to load bookings");
        }
      } else {
        state = BookingError("Authentication token is missing");
      }
    } catch (e) {
      state = BookingError("Failed to load bookings: ${e.toString()}");
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        var result = await BookApi.deleteBooking(bookingId, token);
        if (result['success']) {
          state = BookingCancelled();
          loadBookings(); // Re-load bookings after cancellation
        } else {
          state = BookingCancelled();
          loadBookings(); // You may want to emit an error state here instead
          // state = BookingError("Failed to cancel booking: ${result['data']?["message"]}");
        }
      } else {
        state = BookingError("Authentication token is missing");
      }
    } catch (e) {
      state = BookingError("Error cancelling booking: ${e.toString()}");
    }
  }
}
