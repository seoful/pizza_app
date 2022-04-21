import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_market_app/blocs/cart_bloc/cart_bloc.dart';
import 'package:pizza_market_app/components/animated_button.dart';
import 'package:pizza_market_app/components/appbar.dart';
import 'package:pizza_market_app/components/custom_container.dart';
import 'package:pizza_market_app/components/screen_base.dart';
import 'package:pizza_market_app/main.dart';
import 'package:pizza_market_app/model/pizza_model.dart';
import 'package:pizza_market_app/repository/pizza_stock_repository.dart';
import 'package:pizza_market_app/routes.dart';
import 'package:pizza_market_app/utils/assets.dart';
import 'package:pizza_market_app/utils/colors.dart';
import 'package:pizza_market_app/utils/strings.dart';

class PizzaListScreen extends StatelessWidget {
  const PizzaListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
      appbar: CustomAppBar(
        title: Strings.pizzaMarket,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedButton(
              onTap: () => PizzaApp.navigatorKey.currentState
                  ?.pushNamed(Routes.cartScreen),
              padding: const EdgeInsets.all(12),
              child: Image.asset(Assets.cartIcon),
            ),
            const SizedBox(
              width: 26,
            ),
            AnimatedButton(
              onTap: () => PizzaApp.navigatorKey.currentState
                  ?.pushNamed(Routes.adminScreen),
              padding: const EdgeInsets.all(12),
              child: Image.asset(Assets.profileIcon),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ValueListenableBuilder<PizzaWithCount>(
          valueListenable: PizzaStockRepository.instance.pizzaInStockNotifier,
          builder: (context, value, _) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final itemsToShow = <PizzaModel>[];

                if (state is CartUpdated) {
                  value.forEach(
                    (key, value) {
                      if (state.items
                              .indexWhere((element) => element.pizza == key) ==
                          -1) itemsToShow.add(key);
                    },
                  );
                } else if (state is CartEmpty) {
                  itemsToShow.addAll(value.keys);
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, int index) {
                    if (index == itemsToShow.length) {
                      return const SizedBox(height: 24);
                    }
                    return _buildPizzaCard(context, itemsToShow[index]);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 32),
                  itemCount: itemsToShow.length + 1,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPizzaCard(BuildContext context, PizzaModel pizza) {
    return AnimatedButton(
      onTap: () => context.read<CartBloc>().add(AddToCart(pizza)),
      child: CustomContainer(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        padding:
            const EdgeInsets.only(left: 12, right: 32, bottom: 12, top: 12),
        showShadow: true,
        child: Row(
          children: [
            Image.asset(pizza.imageUrl),
            const SizedBox(width: 20),
            Text(
              pizza.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: CustomColors.blackTextColor,
              ),
            ),
            const Spacer(),
            Text(
              Strings.dollarSign + pizza.price.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 29,
                color: CustomColors.accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
