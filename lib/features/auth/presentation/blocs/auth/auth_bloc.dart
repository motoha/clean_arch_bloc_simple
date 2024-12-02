import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../domain/entities/user.dart';
import '../../../../../domain/usecases/login_usecase.dart';
import '../../../../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({required this.loginUseCase, required this.logoutUseCase})
      : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(LoginParams(
          username: event.username,
          password: event.password,
          rememberMe: event.rememberMe,
        ));
        emit(AuthSuccess(user));
      } on NoInternetConnectionException {
        emit(const AuthFailure('No internet connection'));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await logoutUseCase(NoParams());
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
