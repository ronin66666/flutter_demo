part of 'login_bloc.dart';

@immutable
class LoginEvent extends Equatable {

  const LoginEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginUsernameChanged extends LoginEvent {

  const LoginUsernameChanged(this.username);

  final String username;

  @override
  // TODO: implement props
  List<Object?> get props => [username];

}

class LoginPasswordChanged extends LoginEvent {

  const LoginPasswordChanged(this.password);

  final String password;

  @override
  // TODO: implement props
  List<Object?> get props => [password];
}


class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}



