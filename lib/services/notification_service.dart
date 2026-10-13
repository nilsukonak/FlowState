import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/services/notification_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'flowstate_task_reminders';

  Future<void> initialize() async {
    tz.initializeTimeZones();

    // Türkiye saat dilimi
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Tarih seçicideki d/m/yyyy formatını okur.
  DateTime _parseDate(String date) {
    final parts = date.split('/');

    if (parts.length != 3) {
      throw FormatException('Geçersiz görev tarihi: $date');
    }

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

  // Aynı görev için iki sabit bildirim ID'si üretir.
  int _notificationId(String taskId, int hour) {
    var hash = hour;

    for (final unit in taskId.codeUnits) {
      hash = (hash * 31 + unit) & 0x3fffffff;
    }

    return hash;
  }

  Future<void> scheduleTaskReminders({
    required String taskId,
    required String taskTitle,
    required DateTime selectedDate,
  }) async {
    await cancelTaskReminders(taskId: taskId);

    final now = tz.TZDateTime.now(tz.local);

    for (final hour in [9, 17]) {
      final scheduled = tz.TZDateTime(
        tz.local,
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
      );

      if (!scheduled.isAfter(now)) continue;

      await _notifications.zonedSchedule(
        _notificationId(taskId, hour),
        'Görev hatırlatması',
        taskTitle,
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'Görev hatırlatmaları',
            channelDescription: 'Görevler için zamanlanmış hatırlatmalar',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelTaskReminders({required String taskId}) async {
    await _notifications.cancel(_notificationId(taskId, 9));
    await _notifications.cancel(_notificationId(taskId, 17));
  }

  Future<void> scheduleTestNotification() async {
    final scheduled = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(minutes: 1));

    await _notifications.zonedSchedule(
      999999,
      'FlowState test bildirimi',
      'Cano, bildirimler çalışıyor! 🎉',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Görev hatırlatmaları',
          channelDescription: 'Görevler için zamanlanmış hatırlatmalar',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
