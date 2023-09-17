import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:myprofile/Bloc/DashboardBloc/dashboardbloc_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dashboardbloc_event.dart';
part 'dashboardbloc_state.dart';

class DashboardblocBloc extends Bloc<DashboardblocEvent, DashboardblocState> {
  DashboardblocBloc() : super(DashboardblocInitial()) {
    on<DashboardInitialEvent>(dashboardInitialEvent);
    on<DashboardLogoutBtnClickEvent>(dashboardLogoutBtnClickEvent);
    on<DashboardEditBtnClickEvent>(dashboardEditBtnClickEvent);
  }

  FutureOr<void> dashboardInitialEvent(DashboardInitialEvent event, Emitter<DashboardblocState> emit) async{
    emit(DashboardblocLoadingState());
    await Future.delayed(Duration(seconds: 1));
    emit(DashBoardblocLoadedState());

  }

  FutureOr<void> dashboardLogoutBtnClickEvent(DashboardLogoutBtnClickEvent event, Emitter<DashboardblocState> emit) async{
    String? rem_email="";
    String? rem_pass="";
    final SharedPreferences sp=await SharedPreferences.getInstance();
    rem_email=sp.getString("rem_email");
    rem_pass=sp.getString("rem_pass");

    await sp.clear();
    final da=signinwithGoogle();
    if(rem_email !=null && rem_pass !=null){
      sp.setString("rem_email", rem_email);
      sp.setString("rem_pass", rem_pass);
    }else{
      sp.setString("rem_email", "");
      sp.setString("rem_pass", "");
    }

    print("log out call");
    emit(DashboardlogoutbtnClcickState());
  }

  FutureOr<void> dashboardEditBtnClickEvent(DashboardEditBtnClickEvent event, Emitter<DashboardblocState> emit) {
    emit(DashboardEditbtnclickState());
  }

  signinwithGoogle() async{
    final GoogleSignInAccount? gUser=await GoogleSignIn().signOut();

    final GoogleSignInAuthentication gAuth=await gUser!.authentication;

    final credential=GoogleAuthProvider.credential(accessToken: gAuth.accessToken,idToken: gAuth.idToken);
    final da=await FirebaseAuth.instance.signInWithCredential(credential);
    print("$da");
    return da;
  }
}
