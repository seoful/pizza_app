import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_market_app/blocs/admin_bloc/admin_bloc.dart';
import 'package:pizza_market_app/blocs/cart_bloc/cart_bloc.dart';
import 'package:pizza_market_app/routes.dart';
import 'package:pizza_market_app/utils/assets.dart';

void main() {
  runApp(const PizzaApp());
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({Key? key}) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => CartBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => AdminBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Source Sans Pro",
        ),
        home: Material(
          child: Stack(
            children: [
              ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (Rect bounds) => LinearGradient(
                  colors: [Colors.white.withOpacity(0), Colors.white],
                  stops: const [0.0, 0.2188],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ).createShader(bounds),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.backgroundImage),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Navigator(
                  key: navigatorKey,
                  initialRoute: Routes.pizzaListScreen,
                  onGenerateRoute: Routes.onGenerateRoute,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
