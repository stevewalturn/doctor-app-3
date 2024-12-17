import 'package:my_app/models/user.dart';
import 'package:my_app/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  User? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;

  Future<void> login(String email, String password) async {
    try {
      await _authService.login(email, password);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      await _authService.register(userData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateProfile(Map<String, dynamic> userData) async {
    try {
      return await _authService.updateProfile(userData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is String) {
      return error;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
