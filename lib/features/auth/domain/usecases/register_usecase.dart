import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call(
    String fullName,
    String email,
    String password,
    String passwordConfirmation,
  ) {
    return repository.register(
      fullName,
      email,
      password,
      passwordConfirmation,
    );
  }
}
