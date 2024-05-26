import 'user_model.dart';
import 'event_model.dart';

class Booking {
  int id;
  DateTime bookingDate;
  Event event;

  Booking({
    required this.id,
    required this.bookingDate,
    required this.event,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      bookingDate: DateTime.parse(json['bookingDate']),
      event: Event.fromJson(json['event']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingDate': bookingDate.toIso8601String(),
      'event': event.toJson(),
    };
  }
}
