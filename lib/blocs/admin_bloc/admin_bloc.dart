import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pizza_market_app/model/pizza_admin_item.dart';
import 'package:pizza_market_app/repository/pizza_stock_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final _stockRepository = PizzaStockRepository.instance;

  var _pizzas = <PizzaAdminItem>[];

  var _lastId = 1000;

  AdminBloc() : super(AdminEmpty()) {
    on<AddPizzaAdmin>((event, emit) {
      _pizzas.add(PizzaAdminItem.empty(++_lastId));
      emit(AdminUpdated(List.from(_pizzas)));
    });

    on<ChangePizza>((event, emit) {
      final pizza = _pizzas[event.index];
      pizza.count = event.count ?? pizza.count;
      if (event.count == null) {
        pizza.price = event.price;
      }
      pizza.name = event.name ?? pizza.name;
      if (pizza.count == 0) {
        _pizzas.removeAt(event.index);
      }
      if (_pizzas.isNotEmpty) {
        emit(AdminUpdated(List.from(_pizzas)));
      } else {
        emit(AdminEmpty());
      }
    });

    on<ProceedAdding>((event, emit) {
      PizzaWithCount map = {};
      for (var element in _pizzas) {
        map.addAll({element.toPizzaModel(): element.count});
      }
      _stockRepository.addPizzas(map);
      _pizzas = [];

      emit(AdminEmpty());
    });
  }
}
