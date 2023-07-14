import 'package:flutter/material.dart';


class NoScrollBehavior extends ScrollBehavior {
  const NoScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
      final BuildContext context,
      final Widget child,
      final ScrollableDetails details) {
    return child;
  }
}