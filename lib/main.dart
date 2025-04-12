import 'package:flutter/material.dart';
import 'package:gunpai/screennew/homenew.dart';



void main() {
  runApp(MyApp());  // ใช้ runApp() เพื่อเริ่มต้นแอป
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),  // กำหนดให้แสดง HomeScreen เมื่อแอปเริ่ม
    );
  }
}
