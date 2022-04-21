import 'package:flutter/material.dart';

class ScreenBase extends StatelessWidget {
  const ScreenBase(
      {Key? key, required this.appbar, required this.body, this.overlay})
      : super(key: key);

  final Widget? appbar;
  final Widget body;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Column(
            children: [
              if (appbar != null) appbar!,
              Expanded(child: body),
            ],
          ),
          if (overlay != null)
            Positioned(
              child: overlay!,
              left: 24,
              right: 24,
              bottom: 24,
            ),
        ],
      ),
    );
  }
}
