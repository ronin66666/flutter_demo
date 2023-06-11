part of 'authentication_bloc.dart';

@immutable
class AuthenticationEvent {
  const AuthenticationEvent();
}

class _AuthenticationStatusChanged extends AuthenticationEvent{

  const _AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

}

class AuthenticationLogoutRequested  extends AuthenticationEvent {}