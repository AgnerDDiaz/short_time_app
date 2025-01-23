import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:short_time_app/api/api_client.dart';
import 'package:short_time_app/api/auth_service.dart';
// ... other imports

class AuthState extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  // final ShortTimeApiClient _apiClient; // Add API client
  final AuthService authService;
  Timer? _tokenCheckTimer; // Timer for token check

  bool isLoggedIn = false;
  bool isLoading = true;

  AuthState({required this.authService})  {
    // _authService = AuthService(apiClient: apiClient);
    _loadToken();
  }

  Future<void> _loadToken() async {
    final result = await _storage.read(key: 'access_token');
    if (result != null && result.isNotEmpty) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    // isLoading = true;
    _startTokenCheckTimer();
  }

  void _startTokenCheckTimer() {
    _tokenCheckTimer?.cancel(); // Cancel any existing timer
    if (isLoggedIn) {
      _tokenCheckTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
        _checkTokenValidity();
      });
    }
  }

  Future<void> _checkTokenValidity() async {
    isLoading = true;
    try {
      await authService.verifyToken();
      isLoggedIn = true;
      isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      await logout();
      if (e.statusCode == 401) {
        // Token is invalid (e.g., expired), log the user out
        print("token is invalid");
        logout();
      } else {
        // Handle other API errors if needed
        print('Token check API Error: ${e.statusCode} - ${e.message}');
      }

      notifyListeners();
    }
  }

  Future<void> logout() async {
    isLoading = false;
    isLoggedIn = false;
    await _storage.delete(key: 'access_token');
    _tokenCheckTimer?.cancel(); // Cancel the timer on logout
    notifyListeners();
  }

  @override
  void dispose() {
    _tokenCheckTimer?.cancel(); // Important: Cancel the timer in dispose
    super.dispose();
  }
}
