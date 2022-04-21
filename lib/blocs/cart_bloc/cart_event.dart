part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final PizzaModel pizza;

  AddToCart(this.pizza);
}

class ChangePizzaAmount extends CartEvent {
  final PizzaModel pizza;
  final int newAmount;

  ChangePizzaAmount(this.pizza, this.newAmount);
}

class MakeOrder extends CartEvent {}
