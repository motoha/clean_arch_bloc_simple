part of 'http_handler.dart';

abstract class HttpHandlerState extends Equatable {
  const HttpHandlerState();

  @override
  List<Object> get props => [];
}

class HttpHandlerInitial extends HttpHandlerState {}

class HttpHandlerTokenSet extends HttpHandlerState {
  final String? token;

  const HttpHandlerTokenSet(this.token);

  @override
  List<Object> get props => [token ?? ''];
}

class HttpHandlerTokenCleared extends HttpHandlerState {}
