
import 'package:flutter/material.dart';

import 'models/feature.dart';
import 'screens/feature_screen.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

class AyurSathiApp extends StatefulWidget {
  const AyurSathiApp({super.key});

  @override
  State<AyurSathiApp> createState() => _AyurSathiAppState();
}

class _AyurSathiAppState extends State<AyurSathiApp> {
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
  }

  void _openFeature(String routeInfo) {
    final parts = routeInfo.split('|');
    final id = int.tryParse(parts.first);

    final bool hindi =
        parts.length < 2 || parts[1].toLowerCase() == 'hi';

    if (id == null || id < 1 || id > features.length) {
      return;
    }

    final feature = features.firstWhere(
      (item) => item.id == id,
    );

    final navigator = _navigatorKey.currentState;

    if (navigator == null) {
      debugPrint('AyurSathi: Navigator is not ready.');
      return;
    }

    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => FeatureScreen(
          feature: feature,
          hindi: hindi,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF16856B);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'AyurSathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5FAF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5FAF7),
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: HomeScreen(
        onOpenFeature: _openFeature,
      ),
    );
  }
}
