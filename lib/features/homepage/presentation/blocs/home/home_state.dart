part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Task tasks;

  const HomeLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskFailure extends HomeState {
  final String message;

  const TaskFailure(this.message);

  @override
  List<Object> get props => [message];
}
