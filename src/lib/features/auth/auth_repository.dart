import 'package:my_app/services/api_service.dart';
import 'package:my_app/features/auth/models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String specialization,
  }) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
        'phoneNumber': phoneNumber,
        'specialization': specialization,
      });
      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout', {});
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/user');
      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _apiService.post('/auth/reset-password', {
        'email': email,
      });
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is String) {
      if (error.contains('401')) {
        return 'Invalid credentials. Please check your email and password.';
      } else if (error.contains('403')) {
        return 'Your account has been locked. Please contact support.';
      } else if (error.contains('404')) {
        return 'Account not found. Please check your email or register.';
      } else if (error.contains('409')) {
        return 'An account with this email already exists.';
      }
      return error;
    }
    return 'An unexpected authentication error occurred. Please try again.';
  }
}
