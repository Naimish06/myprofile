part of 'dashboardbloc_bloc.dart';

@immutable
abstract class DashboardblocEvent {}

class DashboardInitialEvent extends DashboardblocEvent{

}

class DashboardLogoutBtnClickEvent extends DashboardblocEvent{}

class DashboardEditBtnClickEvent extends DashboardblocEvent{}


