import '../entities/task.dart';

abstract class HomeRepository {
  Future<Task> getTasks();
}
