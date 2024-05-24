import 'book_model.dart';

class Event {
  int id;
  String eventName;
  DateTime eventDate;
  String location;
  String description;
  bool isCanceled;
  int? maxBooking;
  List<Booking> bookings;

  Event({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.location,
    required this.description,
    this.isCanceled = false,
    this.maxBooking,
    List<Booking>? bookings,
  }) : bookings = bookings ?? [];

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      eventName: json['eventName'] as String,
      eventDate: DateTime.parse(json['eventDate']),
      location: json['location'] as String,
      description: json['description'] as String,
      isCanceled: json['isCanceled'] as bool? ?? false,
      maxBooking: json['maxBooking'] as int?,
      bookings: (json['bookings'] as List<dynamic>?)
              ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'location': location,
      'description': description,
      'isCanceled': isCanceled,
      'maxBooking': maxBooking,
      'bookings': bookings.map((booking) => booking.toJson()).toList(),
    };
  }
}
