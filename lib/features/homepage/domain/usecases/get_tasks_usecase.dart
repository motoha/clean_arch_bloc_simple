import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/home_repository.dart';

class GetTasksUseCase implements UseCase<Task, NoParams> {
  final HomeRepository repository;

  GetTasksUseCase(this.repository);

  @override
  Future<Task> call(NoParams params) {
    return repository.getTasks();
  }
}
