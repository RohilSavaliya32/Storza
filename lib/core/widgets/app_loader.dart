import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

class AppLoader extends StatefulWidget {
  final double size;
  const AppLoader({super.key, this.size = 60.0});

  @override
  State<AppLoader> createState() => _AppLoaderState();

  /// Smooth Navigation Helper: 
  /// Ye function loader dikhayega aur phir smoothly next page par transition karega.
  static Future<void> navigateTo(BuildContext context, Widget targetPage) async {
    // 1. Show Loader Overlay
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.background.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const PopScope(
        canPop: false,
        child: Center(child: AppLoader(size: 80)),
      ),
    );

    // 2. Chota sa artificial delay (Smoothness ke liye)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (context.mounted) {
      // 3. Remove Loader
      Navigator.pop(context);

      // 4. Push Target Page with Fade + Scale Transition
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeOutCubic;
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: curve),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }
}

class _AppLoaderState extends State<AppLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _LiquidPainter(_controller.value),
        );
      },
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final double value;
  _LiquidPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    final colors = [AppColors.primary, AppColors.secondary, AppColors.orange];

    for (int i = 0; i < 3; i++) {
      final angle = (value * 2 * math.pi) + (i * 2 * math.pi / 3);
      
      // Liquid-like morphing logic
      final x = center.dx + radius * math.cos(angle) * (1 + 0.15 * math.sin(value * 4 * math.pi + i));
      final y = center.dy + radius * math.sin(angle) * (1 + 0.15 * math.cos(value * 4 * math.pi + i));

      final paint = Paint()
        ..color = colors[i]
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      // Unique glowing blobs
      canvas.drawCircle(Offset(x, y), 14, paint..color = colors[i].withOpacity(0.4));
      canvas.drawCircle(Offset(x, y), 10, paint..color = colors[i]..maskFilter = null);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
