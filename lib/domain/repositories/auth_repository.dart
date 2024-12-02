import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password, bool rememberMe);
  Future<String?> getToken();
  Future<void> logout();
  Future<bool> isRemembered();
}
