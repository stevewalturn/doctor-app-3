class AppConstants {
  // API Constants
  static const String baseUrl = 'https://api.medicaldoc.com/v1';
  static const int apiTimeout = 30; // seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';

  // Validation Constants
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int phoneLength = 10;

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Please check your internet connection.';
  static const String authError = 'Invalid credentials. Please try again.';
  static const String validationError =
      'Please check your input and try again.';
  static const String sessionExpired =
      'Your session has expired. Please login again.';

  // Success Messages
  static const String loginSuccess = 'Successfully logged in';
  static const String registrationSuccess = 'Registration successful';
  static const String consultationAdded =
      'Consultation record added successfully';
  static const String patientAdded = 'Patient added successfully';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
  static const double cardElevation = 2.0;

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 350);
  static const Duration longDuration = Duration(milliseconds: 500);
}
