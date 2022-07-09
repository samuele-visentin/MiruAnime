import 'package:flutter/material.dart';


class NoScrollBehavior extends ScrollBehavior {
  const NoScrollBehavior();

  @override
  Widget buildViewportChrome(
      final BuildContext context, final Widget child, final AxisDirection axisDirection) {
    return child;
  }
}