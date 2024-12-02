import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../core/usecases/usecase.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<User> call(LoginParams params) {
    return repository.login(
        params.username, params.password, params.rememberMe);
  }
}

class LoginParams {
  final String username;
  final String password;
  final bool rememberMe;

  LoginParams({
    required this.username,
    required this.password,
    required this.rememberMe,
  });
}
