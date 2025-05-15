import 'package:flutter/material.dart';
import 'package:gunpai/screen/login.dart';
import 'package:permission_handler/permission_handler.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _askPhotoPermission();
  runApp(MyApp());  // ใช้ runApp() เพื่อเริ่มต้นแอป
}

Future<void> _askPhotoPermission() async {
  await Permission.photos.request(); // iOS
  await Permission.storage.request(); // Android
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUNPAI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),  // กำหนดให้แสดง HomeScreen เมื่อแอปเริ่ม
    );
  }
}
