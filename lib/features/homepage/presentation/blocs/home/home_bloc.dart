import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/usecases/get_tasks_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTasksUseCase getTasksUseCase;

  HomeBloc({required this.getTasksUseCase}) : super(HomeInitial()) {
    on<GetTasksEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final tasks = await getTasksUseCase(NoParams());
        emit(HomeLoaded(tasks));
      } on NoInternetConnectionException {
        emit(TaskFailure('No internet connection'));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
