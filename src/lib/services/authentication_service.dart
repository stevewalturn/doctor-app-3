import 'package:stacked/stacked.dart';
import 'package:my_app/features/auth/models/user_model.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/storage_service.dart';

class AuthenticationService implements InitializableDependency {
  final ApiService _apiService;
  final StorageService _storageService;
  UserModel? _currentUser;

  AuthenticationService(this._apiService, this._storageService);

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      _currentUser = UserModel.fromJson(userData);

      await _storageService.setString('token', token);
      await _storageService.setJson('user', userData);
      _apiService.setAuthToken(token);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> register({
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

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      _currentUser = UserModel.fromJson(userData);

      await _storageService.setString('token', token);
      await _storageService.setJson('user', userData);
      _apiService.setAuthToken(token);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout', {});
      await _clearAuthData();
    } catch (e) {
      // Still clear local data even if logout API fails
      await _clearAuthData();
      throw _handleAuthError(e);
    }
  }

  Future<void> _clearAuthData() async {
    _currentUser = null;
    await _storageService.remove('token');
    await _storageService.remove('user');
    _apiService.setAuthToken('');
  }

  String _handleAuthError(dynamic error) {
    if (error is String) {
      if (error.contains('401')) {
        return 'Invalid email or password';
      } else if (error.contains('403')) {
        return 'Account is locked. Please contact support';
      } else if (error.contains('404')) {
        return 'Account not found';
      }
      return error;
    }
    return 'An unexpected authentication error occurred';
  }

  @override
  Future<void> init() async {
    final token = await _storageService.getString('token');
    final userData = await _storageService.getJson('user');

    if (token != null && userData != null) {
      _currentUser = UserModel.fromJson(userData);
      _apiService.setAuthToken(token);
    }
  }
}
