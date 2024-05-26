import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../api/auth_api.dart';
import '../../utils/auth_utils.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
  }

  void _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var response = await AuthApi.register({
        'firstName': event.firstName,
        'lastName': event.lastName,
        'email': event.email,
        'password': event.password,
      });
      print("Response: $response");
      if (response['success']) {
        await AuthUtils.setToken(response['data']['access_token']);
        emit(AuthSuccess(response['data']['user']['role'] ?? 'user'));
      } else {
        String errorMessage = response['data']["message"];
        emit(AuthFailure('Failed to register: $errorMessage'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  void _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var response = await AuthApi.login({
        'email': event.email,
        'password': event.password,
      });
      if (response['success']) {
        await AuthUtils.setToken(response['data']['access_token']);
        emit(AuthSuccess(response['data']['user']['role'] ?? 'user'));
      } else {
        var errorMessage = response['data']["message"];
        emit(AuthFailure('Failed to sign in: $errorMessage'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }
}
