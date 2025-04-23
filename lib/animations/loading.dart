import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

extension on ColorScheme {
  Animatable<Color?> animate() {
    return TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: primary, end: secondary),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: secondary, end: primary),
        weight: 0.5,
      ),
    ]).chain(CurveTween(curve: Curves.easeInOut));
  }
}