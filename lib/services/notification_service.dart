import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // ฟังก์ชันสำหรับการตั้งค่าเริ่มต้นของการแจ้งเตือน
  void initialize() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // ฟังก์ชันแสดงการแจ้งเตือน
  Future<void> showNotification(String message) async {
    var androidDetails = AndroidNotificationDetails(
      'your_channel_id', // ID ช่องการแจ้งเตือน
      'your_channel_name', // ชื่อช่อง
      importance: Importance.high, // การตั้งค่า importance ให้สูงสุด
      priority: Priority.high, // การตั้งค่าความสำคัญ
      ticker: 'ticker',
    );
    var iOSDetails = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // แสดงการแจ้งเตือน
    await flutterLocalNotificationsPlugin.show(
      0, // หมายเลขการแจ้งเตือน
      'New Event Alert', // หัวข้อของการแจ้งเตือน
      message, // ข้อความของการแจ้งเตือน
      notificationDetails, // รายละเอียดการแจ้งเตือน
    );
  }
}
