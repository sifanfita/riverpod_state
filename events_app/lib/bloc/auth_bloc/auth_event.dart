abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignUpRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}
