import 'package:pizza_market_app/model/pizza_model.dart';

class PizzaCartItem {
  final PizzaModel pizza;
  int count;
  bool isMaximum;

  PizzaCartItem(this.pizza, this.count, this.isMaximum);
}
