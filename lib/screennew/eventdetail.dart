import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EventDetailScreen extends StatefulWidget {
  final dynamic event; // รับข้อมูลเหตุการณ์จากหน้าหลัก

  EventDetailScreen({required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late VideoPlayerController _controller;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();

    // ตรวจสอบว่ามี URL ของวิดีโอหรือไม่
    if (widget.event['video'] != null) {
      _controller = VideoPlayerController.network(widget.event['video'])
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
          _controller.play();
        }).catchError((e) {
          setState(() {
            isError = true;
            isLoading = true;
          });
          print("Error loading video: $e");
        });
    }
  }

  // ฟังก์ชันหยุดเล่นวิดีโอ
  void stopVideo() {
    setState(() {
      _controller.pause(); // หยุดการเล่นวิดีโอ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 249, 249, 249),
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // กลับไปหน้าก่อนหน้า
              },
            ),
            // โลโก้ในมุมซ้าย
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.asset(
            //     'assets/logo.png', 
            //     width: 20, 
            //     height: 20
            //   ),
            // ),
          ],
        ),
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // แสดง WebView ที่โหลดแผนที่
            Container(
              height: 300,
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(
                    Uri.parse('https://emr-life.com/esm/lifescope_master/endo/Report/map'),
                  ),
              ),
            ),
            // แสดงข้อมูล Event
            Card(
              color: widget.event['type'] == 'Alert' ? Colors.red[100] : Colors.yellow[100],
              elevation: 5,
              child: ListTile(
                leading: Icon(
                  widget.event['type'] == 'Alert'
                      ? Icons.warning
                      : Icons.warning_amber,
                  color: widget.event['type'] == 'Alert' ? Colors.red : Colors.yellow,
                ),
                title: Text(
                  widget.event['type'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Detail: ${widget.event['detail']}\nDatetime: ${widget.event['datetime']}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            // ถ้ามีภาพจาก URL
            if (widget.event['image'] != null)
              Image.network(
                widget.event['image'],
                width: double.infinity, // กำหนดขนาดภาพเต็มหน้าจอ
                fit: BoxFit.cover, // ปรับภาพให้เหมาะสม
              ),
            // ถ้ามี URL ของวิดีโอให้เล่น
            if (widget.event['video'] != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.black12,
                        height: 250, 
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : VideoPlayer(_controller),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (widget.event['video'] != null)
              ElevatedButton(
                onPressed: stopVideo,
                child: Text('Stop Video'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); 
  }
}

