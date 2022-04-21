import 'package:flutter/cupertino.dart';
import 'package:pizza_market_app/model/pizza_model.dart';
import 'package:pizza_market_app/utils/assets.dart';

typedef PizzaWithCount = Map<PizzaModel, int>;

class PizzaStockRepository {
  static final PizzaStockRepository instance = PizzaStockRepository._internal();

  PizzaStockRepository._internal() {
    pizzaInStockNotifier = ValueNotifier<PizzaWithCount>(pizzaInStock);
  }

  late ValueNotifier<PizzaWithCount> pizzaInStockNotifier;

  final PizzaWithCount _pizzaInStock = {
    PizzaModel(1, "Original", 8, Assets.pizzaImagesUrls[0]): 5,
    PizzaModel(2, "Buffalo", 10, Assets.pizzaImagesUrls[1]): 2,
    PizzaModel(3, "San Marzano", 6, Assets.pizzaImagesUrls[2]): 1,
    PizzaModel(4, "Pepperoni", 11, Assets.pizzaImagesUrls[3]): 10,
    PizzaModel(5, "Mexican", 13, Assets.pizzaImagesUrls[4]): 4,
  };

  PizzaWithCount get pizzaInStock => Map.from(_pizzaInStock);

  void _notifyListeners() {
    pizzaInStockNotifier.value = _pizzaInStock;
  }

  void addPizzas(PizzaWithCount pizzas) {
    _pizzaInStock.addAll(pizzas);
    _notifyListeners();
  }

  void placeOrder(PizzaWithCount pizzas) {
    pizzas.forEach((pizza, count) {
      _pizzaInStock.update(pizza, (value) => value - count);
      _pizzaInStock.removeWhere((key, value) => value <= 0);
    });
    _notifyListeners();
  }
}
