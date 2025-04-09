import 'package:flutter/material.dart';
import 'package:gungun/screennew/imagenew.dart';
import 'package:gungun/screennew/mapnew.dart';  // ใช้ MapNewScreen ที่นี่
import 'package:gungun/screennew/videonew.dart';
import 'package:gungun/screennew/videoscreen.dart'; 
import 'package:gungun/screennew/videoscreen.dart' as videoscreen;

class WidgetScreen extends StatelessWidget {
  const WidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าหลัก
          },
        ),
        title: Text(
          "WIDGET",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomButton(
              icon: Icons.image,
              label: 'Photo',
              onPressed: () {
                //เมื่อกดปุ่ม Photo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Imagegun()), // ไปที่หน้า Imagegun
                );
              },
            ),
            CustomButton(
              icon: Icons.video_camera_back,
              label: 'Video',
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoScreen()), // ไปที่หน้า VideoScreen
                );
                print("Video pressed");
              },
            ),
            CustomButton(
              icon: Icons.location_on,
              label: 'Map',
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapNewScreen()), // ไปที่หน้า MapNewScreen
                );
                print("Map pressed");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 30),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          minimumSize: Size(double.infinity, 60),
        ),
      ),
    );
  }
}
