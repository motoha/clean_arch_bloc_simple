import '../../../../core/constants/constants.dart';
import '../../../../core/network/http_handler.dart';
import '../../../../core/errors/exceptions.dart';

import 'models/task_model.dart';

abstract class HomeRemoteDataSource {
  Future<TaskModel> getTasks();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HttpHandler httpHandler;

  HomeRemoteDataSourceImpl({required this.httpHandler});

  @override
  Future<TaskModel> getTasks() async {
    final url = '${Constants.baseUrl}/find-task-by-today';

    try {
      final responseBody = await httpHandler.get(
        url,
      );
      return TaskModel.fromJson(responseBody['data']);
    } catch (e) {
      throw ServerException('Failed to connect to the server: $e');
    }
  }
}
