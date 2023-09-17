part of 'editbloc_bloc.dart';

@immutable
abstract class EditblocEvent {}

class EditInitialEvent extends EditblocEvent{
}

class EditSaveBtnClickEvent extends EditblocEvent{
  final String imagepath;
  final String name;
  final String email;
  final String education;
  final String skill;
  final String hobby;

  EditSaveBtnClickEvent(this.imagepath, this.name, this.email,
      this.education, this.skill, this.hobby);

}

