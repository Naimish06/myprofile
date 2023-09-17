part of 'dashboardbloc_bloc.dart';

@immutable
abstract class DashboardblocState {}

abstract class DashboardActionState extends DashboardblocState{}

class DashboardblocInitial extends DashboardblocState {}

class DashboardblocLoadingState extends DashboardblocState{}

class DashBoardblocLoadedState extends DashboardblocState{}

class DashboardlogoutbtnClcickState extends DashboardActionState{}

class DashboardEditbtnclickState extends DashboardActionState{}
