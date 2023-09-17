part of 'editbloc_bloc.dart';

@immutable
abstract class EditblocState {}

class EditblocInitial extends EditblocState {}

class EditLoadingState extends EditblocState{}

class EditLoadedState extends EditblocState{}

class EditSaveState extends EditblocState{}


