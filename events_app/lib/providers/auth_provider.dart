import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/auth_api.dart';
import '../../utils/auth_utils.dart';

// Define the states
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String role;

  AuthSuccess(this.role);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

// Define the provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Define the StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthInitial());

  // Sign-up method
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    try {
      var response = await AuthApi.register({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      });
      print("Response: $response");
      if (response['success']) {
        await AuthUtils.setToken(response['data']['access_token']);
        state = AuthSuccess(response['data']['user']['role'] ?? 'user');
      } else {
        String errorMessage = response['data']["message"];
        state = AuthFailure('Failed to register: $errorMessage');
      }
    } catch (e) {
      state = AuthFailure('Error: $e');
    }
  }

  // Sign-in method
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    try {
      var response = await AuthApi.login({
        'email': email,
        'password': password,
      });
      if (response['success']) {
        await AuthUtils.setToken(response['data']['access_token']);
        state = AuthSuccess(response['data']['user']['role'] ?? 'user');
      } else {
        var errorMessage = response['data']["message"];
        state = AuthFailure('Failed to sign in: $errorMessage');
      }
    } catch (e) {
      state = AuthFailure('Error: $e');
    }
  }
}
