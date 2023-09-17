import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myprofile/Bloc/LoginBloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginIntialEvent>(loginIntialEvent);
    on<LoginbtnClickEvent>(loginbtnClickEvent);

  }

  FutureOr<void> loginIntialEvent(
      LoginIntialEvent event, Emitter<LoginState> emit) async{
    emit(LoginLodingState());
    await Future.delayed(Duration(seconds: 1));
    emit(LoginLoadedState(event.email,event.password));
  }

  FutureOr<void> loginbtnClickEvent(LoginbtnClickEvent event, Emitter<LoginState> emit) async{
    print("login Check");

    if(await checkAuth(event.email, event.password, event.remmerb_btn)){
      emit(LoginSucessState());
    }else{
      print("login failed");
      emit(LoginFailedState());
    }
  }

  Future<bool> checkAuth(String email,String password,bool rememberBtn) async {
    final SharedPreferences sp=await SharedPreferences.getInstance();
    print("$email--$password");
    String? qq=sp.getString("mainemail");
    String? pp=sp.getString("mainpassword");
    print("$qq--$pp");


    if(email == qq && password == pp){
      sp.setString("main_id", "1");
      print("main id set");
      if(rememberBtn){
        sp.setString("rem_email", email);
        sp.setString("rem_pass", password);
      }
      sp.setString("imagepath", "");
      sp.setString("name", "Naimish Rafaliya");
      sp.setString("email", "naimishrafaliya8850@gmail.com");
      sp.setString("education", "B.Sc(Information Technology)");
      sp.setString("hoby", "Playing Game,Solve Maths Query,Watching Movie");
      sp.setString("skill", "Flutter,Android,Java,Firebase,Json Parshing,Mysql");
      return true;
    }else{
      return false;
    }

  }
}
