// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz_data;

// /// Notification Service for Cebuano Journey
// /// Handles local notifications for daily reminders, quest alerts, etc.
// class NotificationService {
//   // Singleton pattern
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;
//   bool _notificationsEnabled = true;
//   bool _dailyReminderEnabled = true;
//   TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);

//   // Getters
//   bool get isInitialized => _isInitialized;
//   bool get notificationsEnabled => _notificationsEnabled;
//   bool get dailyReminderEnabled => _dailyReminderEnabled;
//   TimeOfDay get dailyReminderTime => _dailyReminderTime;

//   // ========== Initialization ==========

//   /// Initialize the notification service
//   Future<bool> initialize() async {
//     if (_isInitialized) return true;

//     try {
//       // Initialize timezone
//       tz_data.initializeTimeZones();

//       // Android initialization settings
//       const AndroidInitializationSettings initializationSettingsAndroid =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       // iOS initialization settings
//       const DarwinInitializationSettings initializationSettingsIOS =
//           DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//           );

//       // Combined initialization settings
//       const InitializationSettings initializationSettings =
//           InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS,
//           );

//       // Initialize the plugin
//       await _notificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: _onNotificationTapped,
//       );

//       _isInitialized = true;
//       debugPrint('NotificationService: Initialized successfully');
//       return true;
//     } catch (e) {
//       debugPrint('NotificationService: Initialization failed - $e');
//       return false;
//     }
//   }

//   /// Handle notification tap
//   void _onNotificationTapped(NotificationResponse response) {
//     debugPrint(
//       'NotificationService: Notification tapped - ${response.payload}',
//     );
//     // TODO: Navigate to appropriate screen based on payload
//   }

//   // ========== Permission Management ==========

//   /// Request notification permissions
//   Future<bool> requestPermissions() async {
//     try {
//       final result = await _notificationsPlugin
//           .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin
//           >()
//           ?.requestNotificationsPermission();

//       final bool granted = result ?? false;
//       _notificationsEnabled = granted;

//       if (granted) {
//         debugPrint('NotificationService: Permissions granted');
//       } else {
//         debugPrint('NotificationService: Permissions denied');
//       }

//       return granted;
//     } catch (e) {
//       debugPrint('NotificationService: Failed to request permissions - $e');
//       return false;
//     }
//   }

//   /// Check if notifications are enabled
//   Future<bool> areNotificationsEnabled() async {
//     try {
//       final androidPlugin = _notificationsPlugin
//           .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin
//           >();
//       final bool? enabled = await androidPlugin?.areNotificationsEnabled();
//       return enabled ?? false;
//     } catch (e) {
//       debugPrint('NotificationService: Failed to check permissions - $e');
//       return false;
//     }
//   }

//   // ========== Notification Management ==========

//   /// Show an immediate notification
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//     NotificationType type = NotificationType.general,
//   }) async {
//     if (!_notificationsEnabled) return;

//     try {
//       final AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             _getChannelId(type),
//             _getChannelName(type),
//             channelDescription: _getChannelDescription(type),
//             importance: _getImportance(type),
//             priority: _getPriority(type),
//             icon: '@mipmap/ic_launcher',
//             styleInformation: _getStyleInformation(type),
//             playSound: true,
//             enableVibration: true,
//           );

//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );

//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       await _notificationsPlugin.show(
//         id,
//         title,
//         body,
//         notificationDetails,
//         payload: payload,
//       );

//       debugPrint('NotificationService: Showed notification - $title');
//     } catch (e) {
//       debugPrint('NotificationService: Failed to show notification - $e');
//     }
//   }

//   /// Schedule a notification for a specific time
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     String? payload,
//     NotificationType type = NotificationType.general,
//   }) async {
//     if (!_notificationsEnabled) return;

//     try {
//       final AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             _getChannelId(type),
//             _getChannelName(type),
//             channelDescription: _getChannelDescription(type),
//             importance: _getImportance(type),
//             priority: _getPriority(type),
//             icon: '@mipmap/ic_launcher',
//           );

//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );

//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(scheduledTime, tz.local),
//         notificationDetails,
//         payload: payload,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//       );

//       debugPrint('NotificationService: Scheduled notification - $title');
//     } catch (e) {
//       debugPrint('NotificationService: Failed to schedule notification - $e');
//     }
//   }

//   /// Schedule a recurring daily notification
//   Future<void> scheduleDailyReminder({
//     required int id,
//     required String title,
//     required String body,
//     required TimeOfDay time,
//     String? payload,
//   }) async {
//     if (!_notificationsEnabled || !_dailyReminderEnabled) return;

//     try {
//       final now = DateTime.now();
//       DateTime scheduledDate = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         time.hour,
//         time.minute,
//       );

//       // If time has passed today, schedule for tomorrow
//       if (scheduledDate.isBefore(now)) {
//         scheduledDate = scheduledDate.add(const Duration(days: 1));
//       }

//       final AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'daily_reminders',
//             'Daily Reminders',
//             channelDescription: 'Daily learning reminders',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//           );

//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );

//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(scheduledDate, tz.local),
//         notificationDetails,
//         payload: payload,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//       );

//       debugPrint('NotificationService: Scheduled daily reminder - $time');
//     } catch (e) {
//       debugPrint('NotificationService: Failed to schedule reminder - $e');
//     }
//   }

//   /// Cancel a specific notification
//   Future<void> cancelNotification(int id) async {
//     try {
//       await _notificationsPlugin.cancel(id);
//       debugPrint('NotificationService: Cancelled notification - $id');
//     } catch (e) {
//       debugPrint('NotificationService: Failed to cancel notification - $e');
//     }
//   }

//   /// Cancel all notifications
//   Future<void> cancelAllNotifications() async {
//     try {
//       await _notificationsPlugin.cancelAll();
//       debugPrint('NotificationService: Cancelled all notifications');
//     } catch (e) {
//       debugPrint('NotificationService: Failed to cancel all - $e');
//     }
//   }

//   /// Get pending notifications
//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     try {
//       return await _notificationsPlugin.pendingNotificationRequests();
//     } catch (e) {
//       debugPrint('NotificationService: Failed to get pending - $e');
//       return [];
//     }
//   }

//   // ========== Game-Specific Notifications ==========

//   /// Show daily quest reminder
//   Future<void> showDailyQuestReminder(int questsRemaining) async {
//     await showNotification(
//       id: 1001,
//       title: 'Daily Quests Available!',
//       body: 'You have $questsRemaining daily quests waiting for you.',
//       type: NotificationType.quest,
//       payload: 'daily_quests',
//     );
//   }

//   /// Show streak reminder
//   Future<void> showStreakReminder(int streakDays) async {
//     await showNotification(
//       id: 1002,
//       title: 'Keep Your Streak Going!',
//       body: 'You\'re on a $streakDays day streak! Don\'t lose it.',
//       type: NotificationType.streak,
//       payload: 'streak',
//     );
//   }

//   /// Show level unlock notification
//   Future<void> showLevelUnlocked(int level, String levelName) async {
//     await showNotification(
//       id: 1003,
//       title: 'New Level Unlocked!',
//       body: 'Level $level: $levelName is now available!',
//       type: NotificationType.achievement,
//       payload: 'level_$level',
//     );
//   }

//   /// Show achievement unlocked notification
//   Future<void> showAchievementUnlocked(String achievementName) async {
//     await showNotification(
//       id: 1004,
//       title: 'Achievement Unlocked!',
//       body: 'Congratulations! You earned: $achievementName',
//       type: NotificationType.achievement,
//       payload: 'achievement',
//     );
//   }

//   /// Show word of the day notification
//   Future<void> showWordOfTheDay(String cebuanoWord, String englishWord) async {
//     await showNotification(
//       id: 1005,
//       title: 'Word of the Day',
//       body: '$cebuanoWord means $englishWord',
//       type: NotificationType.learning,
//       payload: 'word_of_day',
//     );
//   }

//   /// Show shop update notification
//   Future<void> showShopUpdate(String itemName) async {
//     await showNotification(
//       id: 1006,
//       title: 'New Item in Shop!',
//       body: 'Check out the new item: $itemName',
//       type: NotificationType.shop,
//       payload: 'shop',
//     );
//   }

//   /// Show event notification
//   Future<void> showEventNotification(
//     String eventName,
//     DateTime eventEnd,
//   ) async {
//     await showNotification(
//       id: 1007,
//       title: 'Special Event!',
//       body: '$eventName is happening now! Ends ${_formatDate(eventEnd)}',
//       type: NotificationType.event,
//       payload: 'event',
//     );
//   }

//   /// Show NPC dialogue notification
//   Future<void> showNPCDialogue(String npcName, String message) async {
//     await showNotification(
//       id: 1008,
//       title: '$npcName has a message for you',
//       body: message,
//       type: NotificationType.npc,
//       payload: 'npc_dialogue',
//     );
//   }

//   // ========== Settings Management ==========

//   /// Enable or disable notifications
//   void setNotificationsEnabled(bool enabled) {
//     _notificationsEnabled = enabled;
//     if (!enabled) {
//       cancelAllNotifications();
//     }
//   }

//   /// Enable or disable daily reminders
//   void setDailyReminderEnabled(bool enabled) {
//     _dailyReminderEnabled = enabled;
//     if (!enabled) {
//       cancelNotification(1001); // Daily quest reminder ID
//     }
//   }

//   /// Set daily reminder time
//   Future<void> setDailyReminderTime(TimeOfDay time) async {
//     _dailyReminderTime = time;
//     // Reschedule the daily reminder
//     if (_dailyReminderEnabled) {
//       await scheduleDailyReminder(
//         id: 1001,
//         title: 'Daily Quests Available!',
//         body: 'Complete your daily quests to earn rewards!',
//         time: time,
//         payload: 'daily_quests',
//       );
//     }
//   }

//   // ========== Helper Methods ==========

//   String _getChannelId(NotificationType type) {
//     switch (type) {
//       case NotificationType.quest:
//         return 'quests';
//       case NotificationType.achievement:
//         return 'achievements';
//       case NotificationType.streak:
//         return 'streaks';
//       case NotificationType.learning:
//         return 'learning';
//       case NotificationType.shop:
//         return 'shop';
//       case NotificationType.event:
//         return 'events';
//       case NotificationType.npc:
//         return 'npc';
//       case NotificationType.general:
//         return 'general';
//     }
//   }

//   String _getChannelName(NotificationType type) {
//     switch (type) {
//       case NotificationType.quest:
//         return 'Quests';
//       case NotificationType.achievement:
//         return 'Achievements';
//       case NotificationType.streak:
//         return 'Streaks';
//       case NotificationType.learning:
//         return 'Learning';
//       case NotificationType.shop:
//         return 'Shop';
//       case NotificationType.event:
//         return 'Events';
//       case NotificationType.npc:
//         return 'NPC Messages';
//       case NotificationType.general:
//         return 'General Notifications';
//     }
//   }

//   String _getChannelDescription(NotificationType type) {
//     switch (type) {
//       case NotificationType.quest:
//         return 'Notifications about daily and weekly quests';
//       case NotificationType.achievement:
//         return 'Notifications about achievements';
//       case NotificationType.streak:
//         return 'Notifications about your learning streak';
//       case NotificationType.learning:
//         return 'Learning tips and word of the day';
//       case NotificationType.shop:
//         return 'Notifications about new shop items';
//       case NotificationType.event:
//         return 'Notifications about special events';
//       case NotificationType.npc:
//         return 'Messages from game characters';
//       case NotificationType.general:
//         return 'General notifications';
//     }
//   }

//   Importance _getImportance(NotificationType type) {
//     switch (type) {
//       case NotificationType.quest:
//       case NotificationType.achievement:
//       case NotificationType.streak:
//         return Importance.high;
//       case NotificationType.learning:
//       case NotificationType.event:
//         return Importance.defaultImportance;
//       case NotificationType.shop:
//       case NotificationType.npc:
//       case NotificationType.general:
//         return Importance.low;
//     }
//   }

//   Priority _getPriority(NotificationType type) {
//     switch (type) {
//       case NotificationType.quest:
//       case NotificationType.achievement:
//       case NotificationType.streak:
//         return Priority.high;
//       case NotificationType.learning:
//       case NotificationType.event:
//         return Priority.defaultPriority;
//       case NotificationType.shop:
//       case NotificationType.npc:
//       case NotificationType.general:
//         return Priority.low;
//     }
//   }

//   StyleInformation? _getStyleInformation(NotificationType type) {
//     switch (type) {
//       case NotificationType.quest:
//       case NotificationType.achievement:
//       case NotificationType.streak:
//         return BigTextStyleInformation('');
//       case NotificationType.learning:
//       case NotificationType.event:
//       case NotificationType.shop:
//       case NotificationType.npc:
//       case NotificationType.general:
//         return null;
//     }
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = date.difference(now);

//     if (difference.inDays == 0) {
//       return 'today';
//     } else if (difference.inDays == 1) {
//       return 'tomorrow';
//     } else if (difference.inDays < 7) {
//       return 'in ${difference.inDays} days';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
// }

// /// Notification types for categorization
// enum NotificationType {
//   general,
//   quest,
//   achievement,
//   streak,
//   learning,
//   shop,
//   event,
//   npc,
// }

// /// Time of day helper class
// class TimeOfDay {
//   final int hour;
//   final int minute;

//   const TimeOfDay({required this.hour, required this.minute});

//   @override
//   String toString() =>
//       '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
// }
