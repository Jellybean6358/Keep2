import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Duration for one full cycle of wave and progress
    )..repeat(); // Repeat indefinitely

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // Smooth curve for transformations
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column( // Use Column to stack the elements
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Wavy Line with MD3 expressive animation
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _WavyLinePainter(
                    animationValue: _animation.value,
                    lineColor: colorScheme.primary, // Primary color for the wave
                    strokeWidth: 4.0, // Thickness of the wave line
                  ),
                  size: const Size(120, 40), // Size for the wavy line. Adjust height as needed.
                );
              },
            ),
            const SizedBox(height: 20), // Space between wave and circle

            // 2. Empty circle that fills with respect to loading
            /*AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // We can use a derived progress value if the animation loop
                // is shorter than actual loading, or just _animation.value
                // if the animation itself represents the loading progress.
                // For a continuous loop, let's make progress go 0 -> 1 -> 0
                double progressValue = _animation.value; // For a simple 0 to 1 fill

                return CustomPaint(
                  painter: _FillingCirclePainter(
                    progressValue: progressValue,
                    fillColor: colorScheme.primary,
                    trackColor: colorScheme.primaryContainer.withOpacity(0.5), // Lighter track color
                  ),
                  size: const Size(80, 80), // Size for the circle
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// New CustomPainters
// -----------------------------------------------------------------------------

class _WavyLinePainter extends CustomPainter {
  final double animationValue;
  final Color lineColor;
  final double strokeWidth;

  _WavyLinePainter({
    required this.animationValue,
    required this.lineColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Parameters for the wave
    final double waveFrequency = 2; // Number of waves across the line
    final double waveAmplitude = size.height * 0.2 * (1 + math.sin(animationValue * math.pi * 2)); // Amplitude pulsates
    final double waveOffset = animationValue * size.width * 0.5; // Wave moves horizontally

    // Start drawing the wave from the left edge
    path.moveTo(0, size.height / 2);

    for (double i = 0; i <= size.width; i += 1) { // Iterate across the width
      final x = i;
      // Use sine wave to create the curve
      // The phase shift (waveOffset) makes the wave appear to move
      final y = size.height / 2 + math.sin((x / size.width * waveFrequency * 2 * math.pi) + waveOffset) * waveAmplitude;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavyLinePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _FillingCirclePainter extends CustomPainter {
  final double progressValue; // 0.0 to 1.0
  final Color fillColor;
  final Color trackColor;

  _FillingCirclePainter({
    required this.progressValue,
    required this.fillColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.15; // Thickness of the ring

    // 1. Draw the track (empty part of the circle)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // 2. Draw the filled part of the circle (arc)
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // Round caps for the ends of the arc

    // Calculate the sweep angle based on progressValue
    final double sweepAngle = 2 * math.pi * progressValue;

    // Draw the arc starting from the top (-math.pi / 2 radians)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2, // Start angle (top)
      sweepAngle, // Sweep angle
      false, // Use center is false for stroke style
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FillingCirclePainter oldDelegate) {
    return oldDelegate.progressValue != progressValue ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.trackColor != trackColor;
  }
}

/*class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Duration for one full cycle of shape change
    )..repeat(); // Repeat the animation indefinitely

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // Smooth curve for transformations
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // For a determinate-like fill, we can use the animation value directly
            // or modify it to create a specific fill pattern.
            // Let's use the animation value to simulate progress and shape morphing.
            // The fill will go from 0% to 100% and back as the shape morphs.
            double progressValue = _animation.value;

            return CustomPaint(
              painter: _MD3DeterminateMorphingPainter(
                animationValue: _animation.value,
                progressValue: progressValue,
                startColor: colorScheme.primary,
                endColor: colorScheme.primaryContainer, // Use a lighter shade for the track/background part
              ),
              size: const Size(60, 60), // Adjust size as needed
            );
          },
        ),
      ),
    );
  }
}

class _MD3DeterminateMorphingPainter extends CustomPainter {
  final double animationValue;
  final double progressValue; // Represents the fill progress (0.0 to 1.0)
  final Color startColor;
  final Color endColor;

  _MD3DeterminateMorphingPainter({
    required this.animationValue,
    required this.progressValue,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final strokeWidth = maxRadius * 0.15; // Thickness of the ring

    // 1. Draw the "track" or background part of the ring (lighter color)
    final trackPaint = Paint()
      ..color = endColor // A lighter or background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // Round caps for the ends

    // The base circle for the track
    canvas.drawCircle(center, maxRadius - strokeWidth / 2, trackPaint);


    // 2. Define the morphing path for the "determinate" foreground part
    Path foregroundPath = Path();

    // The shape will transition between different forms based on animationValue
    // 0.0 - 0.25: Circle -> Square
    // 0.25 - 0.50: Square -> Star/Flower
    // 0.50 - 0.75: Star/Flower -> Triangle
    // 0.75 - 1.0: Triangle -> Circle (completing the loop)

    double currentRadius;
    int numPoints;
    double innerIrregularity = 0.0;
    double outerIrregularity = 0.0;

    if (animationValue < 0.25) {
      // Phase 1: Circle to Square/Rounded Square
      final phaseNormalized = animationValue / 0.25;
      currentRadius = maxRadius - strokeWidth / 2;
      numPoints = 4; // Approaching a square
      innerIrregularity = 0.0;
      outerIrregularity = phaseNormalized * 0.2; // Increases corner sharpness
    } else if (animationValue < 0.5) {
      // Phase 2: Square to Star/Flower
      final phaseNormalized = (animationValue - 0.25) / 0.25;
      currentRadius = maxRadius - strokeWidth / 2;
      numPoints = 8; // More points for a star/flower
      innerIrregularity = phaseNormalized * 0.2; // Creates inward dents
      outerIrregularity = 0.2; // Maintains some corner effect
    } else if (animationValue < 0.75) {
      // Phase 3: Star/Flower to Triangle
      final phaseNormalized = (animationValue - 0.5) / 0.25;
      currentRadius = maxRadius - strokeWidth / 2;
      numPoints = 3; // Approaching a triangle
      innerIrregularity = 0.2 * (1 - phaseNormalized); // Dents recede
      outerIrregularity = 0.2 * (1 - phaseNormalized); // Corners soften for triangle
    } else {
      // Phase 4: Triangle to Circle
      final phaseNormalized = (animationValue - 0.75) / 0.25;
      currentRadius = maxRadius - strokeWidth / 2;
      numPoints = 16; // Many points to approximate a circle
      innerIrregularity = 0.0;
      outerIrregularity = 0.2 * (1 - phaseNormalized); // Smooths back to circle
    }

    // Generate points for the morphing shape
    for (int i = 0; i < numPoints; i++) {
      final angle = (i / numPoints) * 2 * math.pi - math.pi / 2; // Start from top

      double effectiveRadius = currentRadius;

      // Add irregularities based on phase
      if (numPoints == 4) { // Square/Rectangle morphing
        double x = math.cos(angle);
        double y = math.sin(angle);
        // Map unit square to circle for morphing
        double rectX = (x / (math.max(x.abs(), y.abs()))) * (1 - outerIrregularity) + x * outerIrregularity;
        double rectY = (y / (math.max(x.abs(), y.abs()))) * (1 - outerIrregularity) + y * outerIrregularity;
        effectiveRadius = math.sqrt(rectX * rectX + rectY * rectY) * currentRadius;
      } else if (numPoints == 8) { // Star/Flower
        effectiveRadius = currentRadius +
            currentRadius * innerIrregularity * math.cos(angle * 4) - // Inward/outward dents
            currentRadius * outerIrregularity * math.sin(angle * 2); // Slight overall deformation
      } else if (numPoints == 3) { // Triangle
        // Interpolate between a rounded circle and a triangle
        double triangleOffset = (angle + math.pi / 2) % (2 * math.pi / 3);
        double distanceToEdge = currentRadius / math.cos(math.pi / 6 - triangleOffset);
        effectiveRadius = currentRadius * (1 - outerIrregularity) + distanceToEdge * outerIrregularity;
      }

      final x = center.dx + effectiveRadius * math.cos(angle);
      final y = center.dy + effectiveRadius * math.sin(angle);

      if (i == 0) {
        foregroundPath.moveTo(x, y);
      } else {
        foregroundPath.lineTo(x, y);
      }
    }
    foregroundPath.close();

    // 3. Draw the "fill" part of the ring
    final fillPaint = Paint()
      ..color = startColor // The main color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // Round caps for the ends

    // To simulate "determinate" fill, we draw only a segment of the morphed path.
    // This is more complex than just drawing an arc.
    // For simplicity, we'll draw the full morphed path and then use a clip or
    // modify the path segments to only draw up to the `progressValue`.
    // A simpler way for a _CustomPainter_ is to use `PathMetric` but that can be heavy.
    // For now, let's draw the full shape and rely on the animation to imply progress
    // combined with a gradient or subtle color shift on the fill itself.

    // To truly show progress, we need to draw only a segment of the current morphed path.
    // This requires PathMetric which is more complex for a continuously morphing path.
    // Let's create a *visual representation* of progress by changing a gradient or length.
    // A simple visual determinate: Draw a arc over the morphed shape.
    // This isn't exactly "filling" the morphed shape but will give the determinate feel.

    // A more direct approach: Draw an arc on top of the morphing shape
    // The arc should be centered, with the same radius, and only draw up to `progressValue`
    final double sweepAngle = 2 * math.pi * progressValue; // Angle for progress

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius - strokeWidth / 2),
      -math.pi / 2, // Start at top
      sweepAngle,
      false, // Not used for stroke
      fillPaint,
    );

    // To truly fill the *morphed* path determinately, we'd need to
    // calculate sub-paths based on `PathMetrics` and `progressValue`.
    // That adds significant complexity and might be overkill for visual effect.
    // The image implies the _entire ring_ changes shape, not just a segment of it.
    // So, let's draw the full morphed shape, and use the pulsating color to imply activity.

    // Instead of drawing a partial arc, let's draw the morphed shape and make
    // its color imply "determinate" progress by animating its vibrancy or shade.

    final double pulsatingProgress = (animationValue * 2 * math.pi).remainder(2 * math.pi);
    final fillPaintDynamic = Paint()
      ..style = PaintingStyle.stroke // Use stroke for the ring
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Color.lerp(
        startColor.withOpacity(0.5), // Start with lighter shade
        startColor, // End with full shade
        math.sin(pulsatingProgress).abs(), // Pulses from light to dark
      )!;

    // Draw the full morphed path with dynamic color
    canvas.drawPath(foregroundPath, fillPaintDynamic);
  }

  @override
  bool shouldRepaint(covariant _MD3DeterminateMorphingPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.progressValue != progressValue ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
  }
}*/

