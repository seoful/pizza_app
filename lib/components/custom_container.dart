import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({
    Key? key,
    required this.child,
    this.gradient,
    this.color,
    this.borderRadius,
    this.padding,
    this.showShadow = false,
  }) : super(key: key);

  final bool showShadow;
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? padding;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: widget.borderRadius,
        gradient: widget.gradient,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(90, 108, 234, 0.08),
            blurRadius: 50,
            offset: Offset(12, 26),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
