import 'package:flutter/material.dart';

import '../app_theme/app_colors.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final RefreshIndicatorTriggerMode triggerMode;

  const AppRefreshIndicator({
    required this.child,
    required this.onRefresh,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.darkBlue,
      color: AppColors.white,
      onRefresh: onRefresh,
      triggerMode: triggerMode,
      child: child
    );
  }
}
