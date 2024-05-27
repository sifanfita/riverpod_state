// User Events
abstract class UserEvent {}

class LoadUser extends UserEvent {}

class LoadAllUsers extends UserEvent {}

class UpdateUserDetails extends UserEvent {
  final Map<String, dynamic> userDetails;
  UpdateUserDetails(this.userDetails);
}

class DeleteUser extends UserEvent {
  final int userId;
  DeleteUser(this.userId);
}

class DeleteSelf extends UserEvent {}

class PromoteUser extends UserEvent {
  final int userId;
  PromoteUser(this.userId);
}

class DemoteUser extends UserEvent {
  final int userId;
  DemoteUser(this.userId);
}
