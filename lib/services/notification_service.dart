import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> scheduleEyeBreakReminder({
    required bool enabled,
    required int intervalMinutes,
  }) async {
    await _plugin.cancel(2001);
    if (!enabled) return;
    // Repeating interval alarms are intentionally not scheduled here because
    // exact-alarm/Doze behavior differs across Android versions. The in-app
    // timer works while the app is open; this method leaves a safe extension
    // point for a future platform-tested reminder implementation.
  }
}
