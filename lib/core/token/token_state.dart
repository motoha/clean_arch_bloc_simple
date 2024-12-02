part of 'token_bloc.dart';

abstract class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object> get props => [];
}

class TokenInitial extends TokenState {}

class TokenSet extends TokenState {
  final String? token;

  const TokenSet(this.token);

  @override
  List<Object> get props => [token ?? ''];
}

class TokenCleared extends TokenState {}
