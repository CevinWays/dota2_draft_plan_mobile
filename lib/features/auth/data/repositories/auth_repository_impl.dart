import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    // The data source returns a UserModel, which extends User.
    final user = await remoteDataSource.login(email, password);
    await localDataSource.cacheToken(user.token);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<User> register(
    String fullName,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final user = await remoteDataSource.register(
      fullName,
      email,
      password,
      passwordConfirmation,
    );
    await localDataSource.cacheToken(user.token);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<bool> checkAuthStatus() async {
    final token = await localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.removeToken();
  }

  @override
  Future<User?> getCachedUser() async {
    return await localDataSource.getCachedUser();
  }
}
