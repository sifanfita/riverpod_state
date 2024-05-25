import '../models/validation_model.dart';

class ValidationUtils {
  static ValidationResult validateEmail(String email) {
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
    return ValidationResult(
      isValid: emailRegex.hasMatch(email),
      error: 'Invalid email address',
    );
  }

  static ValidationResult validatePassword(String password) {
    return ValidationResult(
      isValid: password.length > 6,
      error: 'Password must be at least 6 characters',
    );
  }

  static ValidationResult validateName(String name) {
    return ValidationResult(
      isValid: name.length > 2,
      error: 'Name must be at least 2 characters',
    );
  }

  static ValidationResult validateRequiredField(String value) {
    return ValidationResult(
      isValid: value.trim().isNotEmpty,
      error: 'This field is required',
    );
  }

  static ValidationResult validateNumber(String value) {
    RegExp numberRegex = RegExp(r'^\d+$');
    return ValidationResult(
      isValid: numberRegex.hasMatch(value),
      error: 'This field must be a number',
    );
  }

  static ValidationResult validateDate(String value) {
    RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return ValidationResult(
      isValid: dateRegex.hasMatch(value),
      error: 'This field must be a date in the form of YYYY-MM-DD',
    );
  }

  static ValidationResult validateMatch(String value, String matchValue) {
    return ValidationResult(
      isValid: value == matchValue,
      error: 'This field must match the previous field',
    );
  }
}
