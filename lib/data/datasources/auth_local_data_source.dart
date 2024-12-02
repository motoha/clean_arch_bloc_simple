import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
  Future<void> saveRememberMe(bool rememberMe);
  Future<bool> getRememberMe();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('token', token);
  }

  @override
  Future<String?> getToken() async {
    final Logger logger = Logger();
    var token = sharedPreferences.getString('token');
    logger.e("Token $token");
    return sharedPreferences.getString('token');
  }

  @override
  Future<void> removeToken() async {
    await sharedPreferences.remove('token');
  }

  @override
  Future<void> saveRememberMe(bool rememberMe) async {
    await sharedPreferences.setBool('rememberMe', rememberMe);
  }

  @override
  Future<bool> getRememberMe() async {
    return sharedPreferences.getBool('rememberMe') ?? false;
  }
}
