import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

class AyurSathiApp extends StatefulWidget {
  const AyurSathiApp({super.key});

  @override
  State<AyurSathiApp> createState() => _AyurSathiAppState();
}

class _AyurSathiAppState extends State<AyurSathiApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF16856B);
    return MaterialApp(
      title: 'AyurSathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF5FAF7),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF5FAF7), elevation: 0),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
