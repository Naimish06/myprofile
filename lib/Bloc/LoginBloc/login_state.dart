part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState{}

class LoginInitial extends LoginState {}

class LoginLodingState extends LoginState{

}

class LoginLoadedState extends LoginState{
  final String rem_email;
  final String rem_pass;

  LoginLoadedState(this.rem_email, this.rem_pass);
}

class LoginSucessState extends LoginActionState{

}

class LoginFailedState extends LoginActionState{

}
