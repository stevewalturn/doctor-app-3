import 'package:stacked/stacked.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/storage_service.dart';

class AuthService implements InitializableDependency {
  final ApiService _apiService;
  final StorageService _storageService;

  User? _currentUser;
  String? _token;

  AuthService(this._apiService, this._storageService);

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _currentUser != null && _token != null;

  @override
  Future<void> init() async {
    await _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    try {
      _token = await _storageService.getToken();
      final userData = await _storageService.getUserData();
      if (userData != null) {
        _currentUser = User.fromJson(userData);
      }
    } catch (e) {
      await logout();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      _token = response['token'];
      _currentUser = User.fromJson(response['user']);

      await _storageService.saveToken(_token!);
      await _storageService.saveUserData(_currentUser!.toJson());
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post('/auth/register', userData);

      _token = response['token'];
      _currentUser = User.fromJson(response['user']);

      await _storageService.saveToken(_token!);
      await _storageService.saveUserData(_currentUser!.toJson());
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await _apiService.post('/auth/logout', {}, token: _token);
      }
    } catch (e) {
      // Ignore logout errors
    } finally {
      _token = null;
      _currentUser = null;
      await _storageService.clearAuth();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _apiService.post('/auth/reset-password', {'email': email});
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<User> updateProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.put(
        '/users/${_currentUser!.id}',
        userData,
        token: _token,
      );

      _currentUser = User.fromJson(response);
      await _storageService.saveUserData(_currentUser!.toJson());
      return _currentUser!;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is String) {
      if (error.contains('401')) {
        return 'Invalid email or password. Please try again.';
      }
      if (error.contains('404')) {
        return 'Account not found. Please check your credentials.';
      }
      if (error.contains('already exists')) {
        return 'An account with this email already exists.';
      }
    }
    return 'Authentication failed. Please try again later.';
  }
}
