part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartEmpty extends CartState {}

class CartUpdated extends CartState {
  final List<PizzaCartItem> items;

  CartUpdated(this.items);
}
