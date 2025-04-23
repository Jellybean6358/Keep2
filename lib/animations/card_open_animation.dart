import 'package:flutter/material.dart';

Widget buildCardOpenAnimation({
  required Animation<double> animation,
  required Widget child,
  required Rect startRect,
  required BuildContext context,
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final double tweenValue = animation.value;
      final RectTween rectTween = RectTween(begin: startRect, end: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height));
      final Rect currentRect = rectTween.lerp(tweenValue)!;
      final double scaleX = currentRect.width / startRect.width;
      final double scaleY = currentRect.height / startRect.height;
      final double translateX = currentRect.left - startRect.left * tweenValue;
      final double translateY = currentRect.top - startRect.top * tweenValue;

      return Transform(
        transform: Matrix4.identity()
          ..translate(translateX, translateY)
          ..scale(scaleX, scaleY),
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          alignment: Alignment.topLeft,
          child: child,
        ),
      );
    },
    child: child,
  );
}