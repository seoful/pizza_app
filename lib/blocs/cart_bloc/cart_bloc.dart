import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pizza_market_app/model/pizza_cart_item.dart';
import 'package:pizza_market_app/model/pizza_model.dart';
import 'package:pizza_market_app/repository/pizza_stock_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final _stockRepository = PizzaStockRepository.instance;

  List<PizzaCartItem> _pizzas = [];

  CartBloc() : super(CartEmpty()) {
    on<AddToCart>((event, emit) {
      _pizzas.add(
        PizzaCartItem(
          event.pizza,
          1,
          _stockRepository.pizzaInStock[event.pizza] == 1,
        ),
      );
      emit(CartUpdated(_pizzas));
    });

    on<ChangePizzaAmount>((event, emit) {
      final index =
          _pizzas.indexWhere((element) => event.pizza.id == element.pizza.id);
      final pizza = _pizzas[index];
      pizza.count = event.newAmount;
      pizza.isMaximum =
          _stockRepository.pizzaInStock[event.pizza] == pizza.count;
      if (pizza.count == 0) _pizzas.removeAt(index);
      if (_pizzas.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartUpdated(_pizzas));
      }
    });

    on<MakeOrder>((event, emit) {
      if (_pizzas.isNotEmpty) {
        final order =
            Map.fromEntries(_pizzas.map((e) => MapEntry(e.pizza, e.count)));
        _stockRepository.placeOrder(order);
        _pizzas = [];
        emit(CartEmpty());
      }
    });
  }
}
