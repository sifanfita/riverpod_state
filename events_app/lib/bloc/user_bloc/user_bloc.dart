import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:events_app/api/user_api.dart';
import 'package:events_app/models/user_model.dart';
import '../../utils/auth_utils.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<LoadAllUsers>(_onLoadAllUsers);
    on<UpdateUserDetails>(_onUpdateUserDetails);
    on<DeleteUser>(_onDeleteUser);
    on<DeleteSelf>(_onDeleteSelf);
    on<PromoteUser>(_onPromoteUser);
    on<DemoteUser>(_onDemoteUser);
  }

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      String? token = await AuthUtils.getToken();
      if (token != null) {
        final result = await UserApi.getSelf(token);
        if (result['success']) {
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

  void _onLoadAllUsers(LoadAllUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    String? token = await AuthUtils.getToken();
    if (token != null) {
      var result = await UserApi.getUsers(token);

      if (result['success']) {
        print(result['data']);

        List<User> users =
            (result['data'] as List<dynamic>).asMap().entries.map((entry) {
          Map<String, dynamic> userJson = entry.value as Map<String,
              dynamic>; // Add the index as 'id' into the JSON data
          return User.fromJson(userJson);
        }).toList();

        emit(UsersLoaded(users));
      } else {
        emit(UserError("Failed to load users"));
      }
    } else {
      emit(UserError("Authentication token is missing"));
    }
  }

  void _onUpdateUserDetails(
      UpdateUserDetails event, Emitter<UserState> emit) async {
    emit(UserLoading());
    String? token = await AuthUtils.getToken();
    if (token != null) {
      var result = await UserApi.updateUser(
          event.userDetails['id'], event.userDetails, token);
      if (result['success']) {
        emit(UserUpdateSuccess());
        add(LoadAllUsers()); // Reload all users to update the list
      } else {
        emit(UserError("Failed to update user details: ${result['error']}"));
      }
    } else {
      emit(UserError("Authentication token is missing"));
    }
  }

  void _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    String? token = await AuthUtils.getToken();
    if (token != null) {
      final result = await UserApi.deleteUser(event.userId, token);
      if (result['success']) {
        emit(UserDeleteSuccess());
        add(LoadAllUsers()); // Reload all users
      } else {
        emit(UserError("Failed to delete user: ${result['error']}"));
      }
    } else {
      emit(UserError("Authentication token is missing"));
    }
  }

  void _onDeleteSelf(DeleteSelf event, Emitter<UserState> emit) async {
    String? token = await AuthUtils.getToken();
    if (token != null) {
      final result = await UserApi.deleteSelf(token);
      if (result['success']) {
        emit(UserDeleteSuccess());
      } else {
        emit(UserError("Failed to delete user: ${result['error']}"));
      }
    } else {
      emit(UserError("Authentication token is missing"));
    }
  }

  void _onPromoteUser(PromoteUser event, Emitter<UserState> emit) async {
    String? token = await AuthUtils.getToken();
    if (token == null) {
      emit(UserError("Authentication token is missing"));
      return;
    }
    var result = await UserApi.promoteUser(event.userId, token);
    // Check if the event handler has completed
    if (result['success']) {
      emit(UserUpdateSuccess());
      // Re-load users to update their states
    } else {
      emit(UserError(
          "Failed to update user role: ${result['data']['message']}"));
    }
  }

  void _onDemoteUser(DemoteUser event, Emitter<UserState> emit) async {
    String? token = await AuthUtils.getToken();
    if (token == null) {
      emit(UserError("Authentication token is missing"));
      return;
    }

    var result = await UserApi.demoteUser(event.userId, token);
    // Check if the event handler has completed
    if (result['success']) {
      emit(UserUpdateSuccess());
      // Re-load users to update their states
    } else {
      emit(UserError(
          "Failed to update user role: ${result['data']['message']}"));
    }
  }
}
