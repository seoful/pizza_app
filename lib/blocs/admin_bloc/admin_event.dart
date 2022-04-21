part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class AddPizzaAdmin extends AdminEvent {}

class ChangePizza extends AdminEvent {
  final int index;
  final String? name;
  final int? price;
  final int? count;

  ChangePizza({required this.index, this.name, this.price, this.count});
}

class ProceedAdding extends AdminEvent {}
