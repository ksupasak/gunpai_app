import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const MainLayout({required this.child, this.title = 'App Title', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: child,
      bottomNavigationBar:  BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 33, 45, 106), // BottomNavigationBar color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.image, color: Colors.white), label: 'Image'),
          BottomNavigationBarItem(icon: Icon(Icons.video_camera_back, color: Colors.white), label: 'Video'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Imagegun()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen()));
          }
        },
      ),
    );
  }
}