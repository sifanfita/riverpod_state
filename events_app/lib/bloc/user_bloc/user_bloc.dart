// lib/blocs/user_bloc/user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:events_app/api/user_api.dart';
import 'package:events_app/models/user_model.dart';

import '../../utils/auth_utils.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {}

class UpdateUserDetails extends UserEvent {
  final Map<String, dynamic> userDetails;
  UpdateUserDetails(this.userDetails);
}

class DeleteUser extends UserEvent {}

class UserDeleteSuccess extends UserState {}

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserUpdateSuccess extends UserState {}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUserDetails>(_onUpdateUserDetails);
    on<DeleteUser>(_onDeleteUser);
  }

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.getSelf(token);
        if (result['success']) {
          print(result['data']);
          var user = User.fromJson(result['data']);
          emit(UserLoaded(user));
        } else {
          emit(UserError("Failed to fetch user details"));
        }
      } else {
        emit(UserError("Authentication token is missing"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUpdateUserDetails(
      UpdateUserDetails event, Emitter<UserState> emit) async {
    emit(UserLoading());
    String? token = await AuthUtils.getToken();
    if (token != null) {
      var result = await UserApi.updateSelf(event.userDetails, token);
      if (result['success']) {
        emit(UserUpdateSuccess());
        add(LoadUser()); // Re-load user data
      } else {
        emit(UserError("Failed to update user details: ${result['error']}"));
      }
    } else {
      emit(UserError("Authentication token is missing"));
    }
  }

  void _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.deleteSelf(token);
        if (result['success']) {
          emit(UserDeleteSuccess());
          emit(UserInitial()); // User deleted, go back to initial state
          AuthUtils.setToken(null); // Clear the token as the user is deleted
        } else {
          emit(UserError("Failed to delete user"));
        }
      } else {
        emit(UserError("Authentication token is missing"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
