import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
///example local notification
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initNotification();
  }

  Future<void> initNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        String? payload = response.payload;
        if (payload != null) {
          handleNotificationTap(payload);
        }
      },
    );

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void handleNotificationTap(String payload) {
    // Global navigator key ishlatish
    if (navigatorKey.currentState != null) {
      if (payload == 'page2') {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => Setting(),
          ),
        );
      }
    }
  }

  /// Oddiy notification
  Future<void> showSimpleNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'simple_channel',
      'Simple Notification',
      channelDescription: 'Bu oddiy notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Sarlavha: Oddiy Notification',
      'Bu test notification',
      platformChannelSpecifics,
    );
  }

  /// Navigation bilan notification
  Future<void> notificationWithNavigation() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'navigation_channel',
      'Navigation Notification',
      channelDescription: 'Bu navigation uchun channel',
      importance: Importance.max,
      priority: Priority.high,
      // Icon va boshqa sozlamalar
      icon: '@mipmap/ic_launcher',
      autoCancel: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      'Title: Settings Page',
      'Bosing va Setting sahifaga o\'tasiz',
      notificationDetails,
      payload: 'page2',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: HomeScreen(
        showSimpleNotification: showSimpleNotification,
        notificationWithNavigation: notificationWithNavigation,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback showSimpleNotification;
  final VoidCallback notificationWithNavigation;

  const HomeScreen({
    Key? key,
    required this.showSimpleNotification,
    required this.notificationWithNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notification Misol')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: showSimpleNotification,
              child: Text('Oddiy notification yuborish'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: notificationWithNavigation,
              child: Text('Notification bilan Settings page ga o\'tish'),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Page'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Siz notification orqali Settings sahifaga keldingiz!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Orqaga qaytish'),
            ),
          ],
        ),
      ),
    );
  }
}