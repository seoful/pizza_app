import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_market_app/blocs/cart_bloc/cart_bloc.dart';
import 'package:pizza_market_app/components/animated_button.dart';
import 'package:pizza_market_app/components/appbar.dart';
import 'package:pizza_market_app/components/custom_container.dart';
import 'package:pizza_market_app/components/screen_base.dart';
import 'package:pizza_market_app/main.dart';
import 'package:pizza_market_app/model/pizza_cart_item.dart';
import 'package:pizza_market_app/utils/colors.dart';
import 'package:pizza_market_app/utils/strings.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<CartBloc>().state;

    int totalPrice = 0;

    if (state is CartUpdated) {
      for (var element in state.items) {
        totalPrice += element.pizza.price * element.count;
      }
    }

    return ScreenBase(
      appbar: CustomAppBar(
        title: Strings.orderDetails,
        leading: AnimatedButton(
          onTap: () => PizzaApp.navigatorKey.currentState?.pop(),
          child: CustomContainer(
            borderRadius: BorderRadius.circular(9.8),
            color: CustomColors.buttonLightColor,
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 19.64,
              color: CustomColors.iconLightColor,
            ),
          ),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == state.items.length) {
                    return const SizedBox(height: 197);
                  }
                  return _buildPizzaCard(context, state.items[index]);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 32),
                itemCount: state.items.length + 1,
              ),
            );
          }
          if (state is CartEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 197),
                child: Text(
                  Strings.cartEmpty,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: CustomColors.blackTextColor,
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
      overlay: CustomContainer(
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(24),
        gradient: CustomColors.primaryGradient,
        child: Center(
          child: Column(
            children: [
              const Divider(
                thickness: 1,
                height: 0,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    Strings.total,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    Strings.dollarSign + totalPrice.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AnimatedButton(
                onTap: () {
                  if (totalPrice > 0) {
                    PizzaApp.navigatorKey.currentState?.pop();
                    context.read<CartBloc>().add(MakeOrder());
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  child: Center(
                    child: Text(
                      Strings.placeMyOrder,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: CustomColors.accentColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPizzaCard(BuildContext context, PizzaCartItem item) {
    return CustomContainer(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.only(left: 12, right: 32, bottom: 12, top: 12),
      showShadow: true,
      child: Row(
        children: [
          Image.asset(item.pizza.imageUrl),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.pizza.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: CustomColors.blackTextColor,
                ),
              ),
              Text(
                Strings.dollarSign + item.pizza.price.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: CustomColors.accentColor,
                ),
              )
            ],
          ),
          const Spacer(),
          AnimatedButton(
            onTap: () {
              context
                  .read<CartBloc>()
                  .add(ChangePizzaAmount(item.pizza, item.count - 1));
            },
            child: CustomContainer(
              borderRadius: BorderRadius.circular(9.8),
              padding: const EdgeInsets.all(6),
              color: CustomColors.buttonLightColor,
              child: Icon(
                Icons.remove,
                size: 16,
                color: CustomColors.iconLightColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item.count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: CustomColors.blackTextColor,
            ),
          ),
          const SizedBox(width: 12),
          AnimatedButton(
            onTap: () {
              if (!item.isMaximum) {
                context
                    .read<CartBloc>()
                    .add(ChangePizzaAmount(item.pizza, item.count + 1));
              }
            },
            child: CustomContainer(
              borderRadius: BorderRadius.circular(9.8),
              padding: const EdgeInsets.all(6),
              gradient: CustomColors.primaryGradient,
              child: const Icon(
                Icons.add_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
