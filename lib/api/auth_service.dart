import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/api.dart';
import 'api_client.dart'; // Import your API client
import '../models/auth_models.dart'; // Import your auth DTOs

class AuthService {
  final ShortTimeApiClient _apiClient;
  final _storage = const FlutterSecureStorage();
  AuthService({required ShortTimeApiClient apiClient}) : _apiClient = apiClient;

  Future<void> storeAccessToken(String accessToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
  }

  Future<LoginResponseDto> login(String email, String password) async {
    final loginDto = LoginDto(email: email, password: password);
    try {
      return await _apiClient.makeRequest<LoginResponseDto>(
          'POST', '/auth/login',
          body: loginDto.toJson(), fromJson: LoginResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<RegisterResponseDto> register(RegisterDto registerDto) async {
    try {
      return await _apiClient.makeRequest<RegisterResponseDto>(
          'POST', '/auth/register',
          body: registerDto.toJson(), fromJson: RegisterResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> resendVerificationCode() async {
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
          'POST', '/auth/resend-verification-code',
          fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> changePassword(
      String email, String oldPassword, String newPassword) async {
    final changePasswordDto = ChangePasswordDto(
        email: email, oldPassword: oldPassword, newPassword: newPassword);
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
          'POST', '/auth/change-password',
          body: changePasswordDto.toJson(),
          fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> forgotPassword(String email) async {
    final forgotPasswordDto = ForgotPasswordDto(email: email);
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
          'POST', '/auth/forgot-password',
          body: forgotPasswordDto.toJson(),
          fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> verifyChangePassword(
      String email, String newPassword, int code) async {
    final verifyChangePasswordDto = VerifyChangePasswordDto(
        email: email, newPassword: newPassword, code: code);
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
          'POST', '/auth/verify-change-password',
          body: verifyChangePasswordDto.toJson(),
          fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<MessageResponseDto> verifyEmail(int code) async {
    final verifyEmailDto = VerifyEmailDto(code: code);
    try {
      return await _apiClient.makeRequest<MessageResponseDto>(
          'POST', '/auth/verify-email',
          body: verifyEmailDto.toJson(), fromJson: MessageResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  Future<VerifyTokenResponseDto> verifyToken() async {
    try {
      return await _apiClient.makeRequest<VerifyTokenResponseDto>(
          'POST', '/auth/verify-token',
          fromJson: VerifyTokenResponseDto.fromJson);
    } on ApiException catch (e) {
      rethrow;
    }
  }
}
