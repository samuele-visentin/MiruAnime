import 'package:flutter/material.dart';


class NoScrollBehavior extends ScrollBehavior {

  @override
  Widget buildViewportChrome(
      final BuildContext context, final Widget child, final AxisDirection axisDirection) {
    return child;
  }

}