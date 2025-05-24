import 'package:flutter/material.dart';
import 'package:liquid_pull_refresh/liquid_pull_refresh.dart';

/// A wrapper widget that provides a Liquid Pull to Refresh animation.
/// It encapsulates the LiquidPullRefresh widget, allowing for a cleaner
/// integration into other parts of the application.
class LiquidRefreshAnimation extends StatelessWidget {
  /// The scrollable widget that will be refreshed.
  final Widget child;

  /// The callback function to be executed when the pull-to-refresh gesture is completed.
  /// This function should return a Future<void>.
  final Future<void> Function() onRefresh;

  const LiquidRefreshAnimation({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidPullRefresh(
      onRefresh: onRefresh,
      // Optional: Customize the appearance of the liquid refresh indicator
      showChildOpacityTransition: false, // Set to true for a fade transition
      height: 120, // Height of the liquid indicator
      color: Theme.of(context).colorScheme.primary, // Color of the liquid
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant, // Background color of the liquid
      springAnimationDurationInMilliseconds: 500, // Duration of the spring effect
      child: child,
    );
  }
}
