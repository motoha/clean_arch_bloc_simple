part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;

  const LoginEvent({
    required this.username,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [username, password, rememberMe];
}

class LogoutEvent extends AuthEvent {}
