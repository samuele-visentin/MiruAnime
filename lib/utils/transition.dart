import 'package:flutter/material.dart';

@pragma('vm:prefer-inline')
AnimatedWidget transitionBuilder(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child
) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.fastOutSlowIn;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
        position: animation.drive(tween),
        child: child,
    );
}