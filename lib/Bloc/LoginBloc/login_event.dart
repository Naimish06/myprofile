part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginIntialEvent extends LoginEvent{
  final String email;
  final String password;

  LoginIntialEvent(this.email, this.password);
}

class LoginbtnClickEvent extends LoginEvent{
  final String email;
  final String password;
  final bool remmerb_btn;

  LoginbtnClickEvent(this.email, this.password,this.remmerb_btn);

}

/*class LoginrememberbtnClickEvent extends LoginEvent{
  final String email;
  final String password;

  LoginrememberbtnClickEvent(this.email, this.password);
}*/
