import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:short_time_app/api/api_client.dart';
// ... other imports

class AuthState extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final ShortTimeApiClient _apiClient; // Add API client
  Timer? _tokenCheckTimer; // Timer for token check

  bool isLoggedIn = false;
  bool isLoading = true;

  AuthState({required ShortTimeApiClient apiClient}) : _apiClient = apiClient {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final result = await _storage.read(key: 'access_token');
    if (result != null && result.isNotEmpty) {
      isLoggedIn = true;
    }
    isLoading = true;
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
      // Make a request to a protected endpoint that checks token validity
      // Choose a lightweight endpoint if possible to minimize overhead
      print("token is valid");
      await _apiClient.makeRequest<String>('POST',
          '/auth/verify-token'); // Replace with your token validation endpoint
      // Token is still valid, do nothing
      print("token is valid");

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
