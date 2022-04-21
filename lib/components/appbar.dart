import 'package:flutter/material.dart';
import 'package:pizza_market_app/utils/colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    padding,
    required this.title,
    this.leading,
    this.trailing,
    this.top = 28.5,
    this.bottom = 28.5,
    this.left = 24,
    this.right = 24,
  }) : super(key: key);

  final double top;
  final double bottom;
  final double left;
  final double right;

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: bottom,
        right: right,
        left: left,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 24),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: CustomColors.blackTextColor,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
