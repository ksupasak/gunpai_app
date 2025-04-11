import 'package:flutter/material.dart';
import 'package:gungun/screennew/mapnew.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // สีพื้นหลังเป็นสีดำ
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // โลโก้ที่อยู่ตรงกลาง
            Align(
              alignment: Alignment.topCenter, // ตั้งโลโก้ให้ชิดกลางด้านบน
              child: Image.asset(
                'assets/logo.png', // โลโก้ที่เก็บใน assets
                width: 120, // ขนาดของโลโก้
                height: 120, // ขนาดของโลโก้
              ),
            ),
            SizedBox(height: 40), // ช่องว่างหลังโลโก้
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Username or Email address',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // เมื่อกดปุ่ม Login
                print("Login pressed");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapNewScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
               backgroundColor: const Color.fromARGB(255, 33, 45, 106),
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 0),
              ),
              child: Text(  
                'Log in',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // การทำงานเมื่อกด "Forgotten your password?"
                print("Forgotten your password pressed");
              },
              child: Text(
                'Forgotten your password?',
                style: TextStyle(color: const Color.fromARGB(255, 15, 85, 176)),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("OR", style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // การทำงานเมื่อกด "Log in with Facebook"
                print("Log in with email pressed");
              },
              //icon: Icon(Icons.facebook, color: Colors.white),
              label: Text('Log in with email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(0, 237, 207, 13), // Facebook สี
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
