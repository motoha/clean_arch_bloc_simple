import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<User> login(String username, String password, bool rememberMe) async {
    if (await networkInfo.isConnected) {
      final user = await remoteDataSource.login(username, password);
      if (rememberMe) {
        await localDataSource.saveToken(user.token);
        await localDataSource.saveRememberMe(true);
      } else {
        await localDataSource.removeToken();
        await localDataSource.saveRememberMe(false);
      }
      return user;
    } else {
      throw NoInternetConnectionException();
    }
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<void> logout() async {
    await localDataSource.removeToken();
    await localDataSource.saveRememberMe(false);
  }

  @override
  Future<bool> isRemembered() async {
    return await localDataSource.getRememberMe();
  }
}
