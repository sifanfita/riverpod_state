import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:events_app/api/user_api.dart';
import 'package:events_app/models/user_model.dart';
import '../../utils/auth_utils.dart';

// Define the states
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

// Define the provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

// Define the StateNotifier
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserInitial());

  Future<void> loadUser() async {
    state = UserLoading();
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.getSelf(token);
        if (result['success']) {
          var user = User.fromJson(result['data']);
          state = UserLoaded(user);
        } else {
          state = UserError("Failed to fetch user details");
        }
      } else {
        state = UserError("Authentication token is missing");
      }
    } catch (e) {
      state = UserError(e.toString());
    }
  }

  Future<void> loadAllUsers() async {
    state = UserLoading();
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        var result = await UserApi.getUsers(token);
        if (result['success']) {
          List<User> users = (result['data'] as List<dynamic>).map((e) {
            return User.fromJson(e as Map<String, dynamic>);
          }).toList();
          state = UsersLoaded(users);
        } else {
          state = UserError("Failed to load users");
        }
      } else {
        state = UserError("Authentication token is missing");
      }
    } catch (e) {
      state = UserError(e.toString());
    }
  }

  Future<void> updateUserDetails(Map<String, dynamic> userDetails) async {
    state = UserLoading();
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        var result =
            await UserApi.updateUser(userDetails['id'], userDetails, token);
        if (result['success']) {
          state = UserUpdateSuccess();
          loadAllUsers(); // Reload all users to update the list
        } else {
          state =
              UserError("Failed to update user details: ${result['error']}");
        }
      } else {
        state = UserError("Authentication token is missing");
      }
    } catch (e) {
      state = UserError(e.toString());
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.deleteUser(userId, token);
        if (result['success']) {
          state = UserDeleteSuccess();
          loadAllUsers(); // Reload all users
        } else {
          state = UserError("Failed to delete user: ${result['error']}");
        }
      } else {
        state = UserError("Authentication token is missing");
      }
    } catch (e) {
      state = UserError(e.toString());
    }
  }

  Future<void> deleteSelf() async {
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.deleteSelf(token);
        if (result['success']) {
          state = UserDeleteSuccess();
        } else {
          state = UserError("Failed to delete user: ${result['error']}");
        }
      } else {
        state = UserError("Authentication token is missing");
      }
    } catch (e) {
      state = UserError(e.toString());
    }
  }

  Future<void> promoteUser(int userId) async {
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        var result = await UserApi.promoteUser(userId, token);
        if (result['success']) {
          state = UserUpdateSuccess();
          loadAllUsers(); // Reload users to update their states
        } else {
          state = UserError(
              "Failed to update user role: ${result['data']['message']}");
        }
      } else {
        state = UserError("Authentication token is missing");
      }
    } catch (e) {
      state = UserError(e.toString());
    }
  }

  Future<void> demoteUser(int userId) async {
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        var result = await UserApi.demoteUser(userId, token);
        if (result['success']) {
          state = UserUpdateSuccess();
          loadAllUsers(); // Reload users to update their states
        } else {
          state = UserError(
              "Failed to update user role: ${result['data']['message']}");
        }
      } else {
        state = UserError("Authentication token is missing");
      }
    } catch (e) {
      state = UserError(e.toString());
    }
  }
}
