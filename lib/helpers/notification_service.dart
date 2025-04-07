import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      debugPrint('user denied permission');
    }
  }

  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidInitializationSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) async {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        // Provider.of<NotificationProvider>(
        //   context,
        //   listen: false,
        // ).setNotification(true);
      }
      if (Platform.isIOS) {
        if (context.mounted) {
          initLocalNotifications(context, message);
        }
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        if (context.mounted) {
          initLocalNotifications(context, message);
        }
        showNotification(message);
      }
    });
  }

  DarwinNotificationDetails darwinNotificationDetails =
      const DarwinNotificationDetails(
        presentSound: true,
        presentBadge: true,
        presentAlert: true,
      );

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      enableVibration: true,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: 'your channel description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: message.data['image'],
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      debugPrint('refresh');
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (context.mounted) {
        handleMessage(context, event);
      }
    });
  }

  Future<void> handleMessage(
    BuildContext context,
    RemoteMessage message,
  ) async {
    debugPrint('handle message function');
    // if (await logged()) {
    //   debugPrint('Product Data: ${message.data['product']}');
    //   var product = message.data['product']?.toString() ?? '';
    //   if (product.isNotEmpty) {
    //     navigatorKey.currentState?.push(
    //       MaterialPageRoute(
    //         builder: (context) => ProductDetail(id: message.data['product']),
    //       ),
    //     );
    //   } else {
    //     navigatorKey.currentState?.push(
    //       MaterialPageRoute(builder: (context) => const NotificationList()),
    //     );
    //   }
    // }
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<bool> logged() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString('userDetails') ?? '';
    debugPrint('logged check ===');
    debugPrint('token======>$token');
    return Future.value(token.isNotEmpty);
  }

  void handleMessageOnBackground(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {
      if (remoteMessage != null) {
        if (context.mounted) {
          handleMessage(context, remoteMessage);
        }
      }
    });
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleDailyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'mid_day_meal_id123',
          'Mid day Meal',
          channelDescription: 'Reminder to add student count for meal',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Mid Day Meal Reminder',
      'Please add the total number of students for the midday meal.',
      platformChannelSpecifics,
      payload: 'Reminder Payload',
    );
  }

  // Show a simple notification
  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'mid_day_meal_id123',
          'Mid day Meal',
          channelDescription: 'Reminder to add student count for meal',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Mid Day Meal Reminder',
      'Please add the total number of students for the midday meal.',
      platformChannelSpecifics,
      payload: 'Reminder Payload',
    );
  }
}
*/
