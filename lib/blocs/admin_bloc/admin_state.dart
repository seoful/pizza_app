part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

class AdminEmpty extends AdminState {}

class AdminUpdated extends AdminState {
  final List<PizzaAdminItem> items;

  AdminUpdated(this.items);
}
