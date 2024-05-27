import 'package:events_app/models/user_model.dart';

// User States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UsersLoaded extends UserState {
  final List<User> users;
  UsersLoaded(this.users);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserUpdateSuccess extends UserState {}

class UserDeleteSuccess extends UserState {}
