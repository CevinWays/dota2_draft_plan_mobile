import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(
    String fullName,
    String email,
    String password,
    String passwordConfirmation,
  );
  Future<bool> checkAuthStatus();
  Future<void> logout();
  Future<User?> getCachedUser();
}
