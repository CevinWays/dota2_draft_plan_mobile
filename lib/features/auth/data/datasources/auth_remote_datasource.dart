import '../models/user_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String fullName, String email, String password);
}

// Temporary Mock implementation for offline UI testing
class AuthRemoteMockDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (password.length < 8) {
      throw Exception('Invalid credentials.');
    }

    return UserModel(
      id: 'mock-auth-id-1234',
      email: email,
      fullName: 'John Doe Strategist',
      token: 'mock-jwt-token-abcd',
    );
  }

  @override
  Future<UserModel> register(
    String fullName,
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: 'mock-auth-id-5678',
      email: email,
      fullName: fullName,
      token: 'mock-jwt-token-efgh',
    );
  }
}

// True API implementation
class AuthRemoteApiDataSource implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteApiDataSource({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Assume API returns { "data": { "id": "...", "email": "...", "full_name": "...", "token": "..." } }
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network Error');
    }
  }

  @override
  Future<UserModel> register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '/register',
        data: {'full_name': fullName, 'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network Error');
    }
  }
}
