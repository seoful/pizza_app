import 'dart:math';

import 'package:pizza_market_app/model/pizza_model.dart';
import 'package:pizza_market_app/utils/assets.dart';

class PizzaAdminItem {
  final int id;
  final String imageUrl;
  String name = "";
  int? price;
  int count = 1;

  PizzaAdminItem(this.id, this.imageUrl, this.name, this.price, this.count);

  PizzaAdminItem.empty(this.id)
      : imageUrl = Assets.pizzaImagesUrls[
            Random().nextInt(Assets.pizzaImagesUrls.length - 1)];

  PizzaModel toPizzaModel() => PizzaModel(id, name, price!, imageUrl);
}
