import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myprofile/Bloc/EditBloc/editbloc_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'editbloc_event.dart';
part 'editbloc_state.dart';

class EditblocBloc extends Bloc<EditblocEvent, EditblocState> {
  EditblocBloc() : super(EditblocInitial()) {
    on<EditInitialEvent>(editInitialEvent);
    on<EditSaveBtnClickEvent>(editSaveBtnClickEvent);


  }

  FutureOr<void> editInitialEvent(EditInitialEvent event, Emitter<EditblocState> emit) async{
    emit(EditLoadingState());
    await Future.delayed(Duration(seconds: 2));
    emit(EditLoadedState());
  }

  FutureOr<void> editSaveBtnClickEvent(EditSaveBtnClickEvent event, Emitter<EditblocState> emit) async{
      final SharedPreferences sp=await SharedPreferences.getInstance();
      sp.setString("imagepath", event.imagepath);
      sp.setString("name",event.name);
      sp.setString("email",event.email);
      sp.setString("education",event.education);
      sp.setString("skill",event.skill);
      sp.setString("hoby",event.hobby);

      emit(EditSaveState());
  }


}
