import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
}

const cachedTokenKey = 'CACHED_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) {
    return sharedPreferences.setString(cachedTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(cachedTokenKey);
  }

  @override
  Future<void> removeToken() {
    return sharedPreferences.remove(cachedTokenKey);
  }

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString(
      'CACHED_USER',
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString('CACHED_USER');
    if (jsonString != null) {
      return UserModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    }
    return null;
  }
}
