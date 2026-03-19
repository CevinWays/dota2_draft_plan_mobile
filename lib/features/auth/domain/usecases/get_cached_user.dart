import 'package:dota2_draft_plan_mobile/features/auth/domain/entities/user.dart';
import 'package:dota2_draft_plan_mobile/features/auth/domain/repositories/auth_repository.dart';

class GetCachedUser {
  final AuthRepository repository;

  GetCachedUser(this.repository);

  Future<User?> call() => repository.getCachedUser();
}
