import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ใช้ rootBundle โหลดไฟล์
import 'package:gunpai/screen/events.dart';
import 'package:gunpai/screen/event_detail.dart';
import 'package:gunpai/screen/image.dart';
import 'package:gunpai/screen/mapicon.dart';
import 'package:gunpai/screen/video.dart';
import 'package:gunpai/screen/home.dart';
import 'package:gunpai/screen/event_archive.dart';
class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const MainLayout({required this.child, this.title = 'App Title', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 45, 106), // AppBar color
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 254, 252, 252)),  // Back button
            onPressed: () {
            Navigator.pop(context);  // Navigate back to the previous screen
            },
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,  // Align all children to the start
            children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/logo.png', width: 30, height: 30),
            ),
            //Spacer(),  // This will push the text to the center
            Text(
                "GUNPAI by ESM",
                style: TextStyle(
                color: Colors.white,  // Text color
                fontSize: 20,  // Text size
                fontWeight: FontWeight.bold,  // Text weight
                ),
            ),
            Spacer(),  // This makes sure "Gunpai" is truly in the center
            ],
        ),
        ),
      body: child,
      bottomNavigationBar:  BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 33, 45, 106), // BottomNavigationBar color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.image, color: Colors.white), label: 'Image'),
          BottomNavigationBarItem(icon: Icon(Icons.video_camera_back, color: Colors.white), label: 'Archive'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ImageScreen()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveEventScreen()));
          }
        },
      ),
    );
  }
}