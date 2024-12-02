part of 'token_bloc.dart';

abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object> get props => [];
}

class SetTokenEvent extends TokenEvent {
  final String? token;

  const SetTokenEvent(this.token);

  @override
  List<Object> get props => [token ?? ''];
}

class ClearTokenEvent extends TokenEvent {}
