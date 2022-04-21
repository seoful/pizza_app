import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_market_app/blocs/admin_bloc/admin_bloc.dart';
import 'package:pizza_market_app/components/animated_button.dart';
import 'package:pizza_market_app/components/appbar.dart';
import 'package:pizza_market_app/components/custom_container.dart';
import 'package:pizza_market_app/components/screen_base.dart';
import 'package:pizza_market_app/main.dart';
import 'package:pizza_market_app/model/pizza_admin_item.dart';
import 'package:pizza_market_app/utils/colors.dart';
import 'package:pizza_market_app/utils/strings.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenBase(
        appbar: CustomAppBar(
          title: Strings.addPizza,
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
          trailing: AnimatedButton(
            onTap: () {
              context.read<AdminBloc>().add(AddPizzaAdmin());
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
        ),
        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state is AdminUpdated) {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return const SizedBox(height: 123);
                      }
                      return AdminPizzaCard(
                        item: state.items[index],
                        onCountChanged: (newCount) {
                          context
                              .read<AdminBloc>()
                              .add(ChangePizza(index: index, count: newCount));
                        },
                        onNameChanged: (String text) {
                          context
                              .read<AdminBloc>()
                              .add(ChangePizza(index: index, name: text));
                        },
                        onPriceChanged: (String text) {
                          if (text != "") {
                            context.read<AdminBloc>().add(ChangePizza(
                                index: index, price: int.parse(text)));
                          } else {
                            context
                                .read<AdminBloc>()
                                .add(ChangePizza(index: index, price: null));
                          }
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 32),
                    itemCount: state.items.length + 1,
                  ),
                ),
              );
            }
            if (state is AdminEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 123),
                  child: Text(
                    Strings.pressPlus,
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
        overlay: AnimatedButton(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              context.read<AdminBloc>().add(ProceedAdding());
            }
          },
          child: CustomContainer(
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.all(24),
            gradient: CustomColors.primaryGradient,
            child: const Center(
              child: Text(
                Strings.save,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminPizzaCard extends StatefulWidget {
  const AdminPizzaCard(
      {Key? key,
      required this.item,
      required this.onCountChanged,
      required this.onNameChanged,
      required this.onPriceChanged})
      : super(key: key);

  final PizzaAdminItem item;

  final Function(String text) onNameChanged;
  final Function(String text) onPriceChanged;

  final Function(int newCount) onCountChanged;

  @override
  State<AdminPizzaCard> createState() => _AdminPizzaCardState();
}

class _AdminPizzaCardState extends State<AdminPizzaCard> {
  late TextEditingController _priceController;

  late TextEditingController _nameController;

  final focusOne = FocusNode();
  final focusTwo = FocusNode();

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.item.name);
    _priceController =
        TextEditingController(text: widget.item.price?.toString() ?? "");
    _nameController.addListener(() {
      widget.onNameChanged(_nameController.value.text);
    });
    _priceController.addListener(() {
      widget.onPriceChanged(_priceController.value.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      padding:
          const EdgeInsets.only(left: 17.5, right: 32, bottom: 40, top: 40),
      showShadow: true,
      child: Row(
        children: [
          Image.asset(widget.item.imageUrl),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: CustomColors.blackTextColor,
                  ),
                ),
                TextFormField(
                  cursorColor: CustomColors.greyColor,
                  // cursorHeight: 16,
                  cursorWidth: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.blackTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(height: 0),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: CustomColors.greyColor,
                        width: 1,
                      ),
                    ),
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: CustomColors.greyColor,
                        width: 1,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: CustomColors.grayTextInputBorderColor,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                        bottom: 8, left: 12, right: 0, top: 8),
                    suffixIconConstraints:
                        const BoxConstraints.expand(width: 39, height: 23),
                    suffixIcon: AnimatedButton(
                      onTap: () {
                        _nameController.clear();
                      },
                      child: Icon(
                        CupertinoIcons.clear,
                        color: CustomColors.greyColor,
                      ),
                    ),
                  ),
                  validator: (text) => text == "" ? "" : null,
                  focusNode: focusOne,
                  controller: _nameController,
                  onFieldSubmitted: (_) =>
                      FocusManager.instance.primaryFocus?.nextFocus(),
                ),
                const SizedBox(height: 20),
                Text(
                  Strings.price,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: CustomColors.blackTextColor,
                  ),
                ),
                TextFormField(
                  cursorColor: CustomColors.greyColor,
                  // cursorHeight: 16,
                  cursorWidth: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.blackTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(height: 0),
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: CustomColors.greyColor,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: CustomColors.greyColor,
                        width: 1,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: CustomColors.grayTextInputBorderColor,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                        bottom: 8, left: 12, right: 0, top: 8),
                    suffixIconConstraints:
                        const BoxConstraints.expand(width: 39, height: 23),
                    suffixIcon: AnimatedButton(
                      onTap: () {
                        _priceController.clear();
                      },
                      child: Icon(
                        CupertinoIcons.clear,
                        color: CustomColors.greyColor,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (text) => text == "" ? "" : null,
                  keyboardType: TextInputType.number,
                  focusNode: focusTwo,
                  controller: _priceController,
                  onFieldSubmitted: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                ),
              ],
            ),
          ),
          // const Spacer(),
          const SizedBox(
            width: 18.5,
          ),
          AnimatedButton(
            onTap: () {
              widget.onCountChanged(widget.item.count - 1);
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
            widget.item.count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: CustomColors.blackTextColor,
            ),
          ),
          const SizedBox(width: 12),
          AnimatedButton(
            onTap: () {
              widget.onCountChanged(widget.item.count + 1);
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

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
