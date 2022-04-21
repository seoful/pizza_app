import 'package:flutter/cupertino.dart';
import 'package:pizza_market_app/screens/admin_screen.dart';
import 'package:pizza_market_app/screens/cart_screen.dart';
import 'package:pizza_market_app/screens/pizza_list_screen.dart';

class Routes {
  static const String pizzaListScreen = "pizza_list_screen";
  static const String cartScreen = "cart_screen";
  static const String adminScreen = "admin_screen";

  static Route onGenerateRoute(RouteSettings settings) {
    Widget page = Container();
    switch (settings.name) {
      case pizzaListScreen:
        page = const PizzaListScreen();
        break;
      case cartScreen:
        page = const CartScreen();
        break;
      case adminScreen:
        page = const AdminScreen();
    }

    return CupertinoPageRoute(
      builder: (context) => page,
      settings: RouteSettings(name: settings.name),
    );
  }
}
