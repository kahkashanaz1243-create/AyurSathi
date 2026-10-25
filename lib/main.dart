
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const AyurSathiLauncher());
}

class AyurSathiLauncher extends StatelessWidget {
  const AyurSathiLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AyurSathiSplashScreen(),
    );
  }
}

class AyurSathiSplashScreen extends StatefulWidget {
  const AyurSathiSplashScreen({super.key});

  @override
  State<AyurSathiSplashScreen> createState() =>
      _AyurSathiSplashScreenState();
}

class _AyurSathiSplashScreenState
    extends State<AyurSathiSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => const AyurSathiApp(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFFFC),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value * 2 * math.pi;

          return Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFDFD),
                      Color(0xFFF3FFF5),
                      Color(0xFFF1FAFF),
                      Color(0xFFFFF8F6),
                    ],
                  ),
                ),
              ),

              // Soft red, green and blue moving light effects.
              _glow(
                left: -100 + 35 * math.sin(t),
                top: 100 + 65 * math.cos(t),
                color: const Color(0xFFFF5555),
                size: 280,
              ),
              _glow(
                right: -100 + 40 * math.cos(t),
                top: 250 + 70 * math.sin(t),
                color: const Color(0xFF43D66C),
                size: 300,
              ),
              _glow(
                right: -90 + 30 * math.sin(t + 1),
                bottom: 100 + 60 * math.cos(t),
                color: const Color(0xFF42A5FF),
                size: 300,
              ),

              // Animated flowing color ribbons.
              CustomPaint(
                painter: _RibbonPainter(t),
                size: Size.infinite,
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.94),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF16856B)
                            .withOpacity(0.10),
                        blurRadius: 35,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/ayursathi_logo.png',
                    width: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.spa_rounded,
                          size: 100,
                          color: Color(0xFF16856B),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'AyurSathi',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16856B),
                          ),
                        ),
                        Text(
                          'Natural Wellness Guide',
                          style: TextStyle(
                            color: Color(0xFF52776D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 45,
                child: Column(
                  children: [
                    const Text(
                      'NATURAL WELLNESS • HEALTHY LIVING',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF52776D),
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 90,
                      child: LinearProgressIndicator(
                        value: null,
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: const Color(0xFFDDF1E6),
                        color: const Color(0xFF16856B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _glow({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required Color color,
    required double size,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.10),
                color.withOpacity(0.04),
                color.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  final double phase;

  _RibbonPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFF5252),
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
    ];

    for (int i = 0; i < colors.length; i++) {
      final path = Path();
      final offset = i * 2.1;

      path.moveTo(
        -size.width * 0.2,
        size.height * (0.22 + i * 0.22),
      );

      path.cubicTo(
        size.width * (0.25 + 0.08 * math.sin(phase + offset)),
        size.height * (0.05 + i * 0.18),
        size.width * (0.65 + 0.08 * math.cos(phase + offset)),
        size.height * (0.85 - i * 0.12),
        size.width * 1.2,
        size.height * (0.45 + i * 0.15),
      );

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..color = colors[i].withOpacity(0.10);

      canvas.drawPath(path, paint);

      final highlight = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = colors[i].withOpacity(0.18);

      canvas.drawPath(path, highlight);
    }
  }

  @override
  bool shouldRepaint(covariant _RibbonPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
