import '../../core/constants/constants.dart';
import '../../core/network/http_handler.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpHandler httpHandler;

  AuthRemoteDataSourceImpl({required this.httpHandler});

  @override
  Future<UserModel> login(String username, String password) async {
    final url = '${Constants.baseUrl}/sign-in';
    final body = {'username': username, 'password': password};
    final headers = {'Content-Type': 'application/json'};

    try {
      final responseBody = await httpHandler.postx(
        url,
        body,
        headers: headers,
        type: RequestType.public,
      );
      return UserModel.fromJson(responseBody);
    } catch (e) {
      throw ServerException('Failed to connect to the server: $e');
    }
  }
}
