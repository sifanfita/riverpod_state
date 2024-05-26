// Booking Bloc
import 'package:events_app/utils/auth_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'book_event.dart';
import 'book_state.dart';
import '../../api/user_api.dart';
import '../../api/book_api.dart';
import '../../models/book_model.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingLoading()) {
    on<LoadBookings>(_onLoadBookings);
    on<CancelBooking>(_onCancelBooking);
  }

  void _onLoadBookings(LoadBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.getSelfBookings(token);
        if (result['success']) {
          final bookings =
              (result['data'] as List).map((e) => Booking.fromJson(e)).toList();
          emit(BookingsLoaded(bookings));
        } else {
          emit(BookingError("Failed to load bookings"));
        }
      } else {
        emit(BookingError("Authentication token is missing"));
      }
    } catch (e) {
      emit(BookingError("Failed to load bookings: ${e.toString()}"));
    }
  }

  void _onCancelBooking(CancelBooking event, Emitter<BookingState> emit) async {
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        var result = await BookApi.deleteBooking(event.bookingId, token);
        print(result);
        if (result['success']) {
          emit(BookingCancelled());
          add(LoadBookings()); // Re-load bookings after cancellation
        } else {
          emit(BookingError(
              "Failed to cancel booking: ${result['data']?["message"]}"));
        }
      } else {
        emit(BookingError("Authentication token is missing"));
      }
    } catch (e) {
      emit(BookingError("Error cancelling booking: ${e.toString()}"));
    }
  }
}
