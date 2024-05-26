import 'book_model.dart';

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  List<Booking>? bookings;
  String role;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bookings,
    this.role = 'User',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      bookings: json['bookings'] != null
          ? List<Booking>.from(
              json['bookings'].map((model) => Booking.fromJson(model)))
          : null,
      role: json['role'] != null ? "admin" : "user",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'bookings': bookings?.map((booking) => booking.toJson()).toList(),
      'role': role,
    };
  }
}
