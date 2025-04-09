import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ใช้ rootBundle โหลดไฟล์
import 'package:gungun/screennew/eventdetail.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

// นำเข้าไฟล์ที่เกี่ยวข้องกับหน้าต่าง
import 'package:gungun/screennew/imagenew.dart'; // หน้า Imagegun
import 'package:gungun/screennew/videonew.dart'; // หน้า VideoScreen
import 'package:gungun/screennew/mapnew.dart'; // หน้า MapNewScreen

class MapNewScreen extends StatefulWidget {
  @override
  _MapNewScreenState createState() => _MapNewScreenState();
}

class _MapNewScreenState extends State<MapNewScreen> {
  late WebViewController _controller;
  List<dynamic> locations = []; // เก็บข้อมูลจาก JSON
  List<dynamic> events = []; // เก็บข้อมูล Event (Alert, Warn)

  @override
  void initState() {
    super.initState();
    loadJsonData(); // โหลด JSON ตอนเริ่มต้น

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..loadRequest(
            Uri.parse(
              'https://emr-life.com/esm/lifescope_master/endo/Report/map',
            ),
          );

    // เพิ่มคำสั่งเพื่อให้ผู้ใช้ลากแผนที่ได้
    _controller.runJavaScript('''
      map.dragging.enable(); // เปิดการลากแผนที่
      map.touchZoom.enable(); // เปิดการซูมด้วยการแตะ
      map.scrollWheelZoom.enable(); // เปิดการซูมด้วยการเลื่อนเมาส์
      map.setCenter([100.9925, 15.8700]); // โฟกัสแผนที่ไปที่ประเทศไทย
      map.setZoom(6); // ซูมแผนที่
    ''');
  }

  // ฟังก์ชันโหลด JSON จาก assets
  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      locations = jsonData['locations'];
      events = jsonData['events']; // เพิ่มการโหลดข้อมูล Event
    });
  }

  // ฟังก์ชันเล่นวิดีโอ
  void playVideo(String videoUrl) {
    print('Playing video from URL: $videoUrl');
    // ฟังก์ชันเล่นวิดีโอจะมาอยู่ที่นี่ในอนาคต
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 249, 249, 249),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // ปุ่มย้อนกลับ
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าหลัก
          },
        ),
        title: Row(
          children: [
            // โลโก้
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/logo.png', width: 30, height: 30),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_back),
            label: 'Video',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Map'),
        ],
        onTap: (index) {
          // เชื่อมโยงไปยังหน้าอื่น ๆ ตามปุ่มที่เลือก
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Imagegun(),
              ), // ไปที่หน้า Imagegun
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(),
              ), // ไปที่หน้า VideoScreen
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapNewScreen(),
              ), // ไปที่หน้า MapNewScreen
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ส่วนแสดง WebView ที่โหลดแผนที่
            Container(
              height: 300, // กำหนดความสูงของแผนที่
              child: WebViewWidget(controller: _controller),
            ),
            // ส่วนแสดงข้อมูล Event (Alert, Warn)
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // แสดง Event จาก JSON
                  ...events.map((event) {
                    return Card(
                      color:
                          event['type'] == 'Alert'
                              ? Colors.red[100]
                              : Colors.yellow[100],
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(
                          event['type'] == 'Alert'
                              ? Icons.warning
                              : Icons.warning_amber,
                          color:
                              event['type'] == 'Alert'
                                  ? Colors.red
                                  : Colors.yellow,
                        ),
                        title: Text(
                          event['type'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Detail: ${event['detail']}\nDatetime: ${event['datetime']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EventDetailScreen(
                                      event: event,
                                    ), // เชื่อมไปหน้ารายละเอียด
                              ),
                            );
                          },
                          icon: Icon(Icons.play_arrow),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            // ส่วน Monitoring (แสดงข้อมูลต่างๆ)
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monitor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 8, // จำนวนช่องใน Monitor
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        color: Colors.blue[100],
                        child: Center(child: Text('camera ${index + 1}')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _EventDetailScreenState extends State<EventDetailScreen> {
  late VideoPlayerController _controller;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();

    if (widget.event['video'] != null) {
      _controller = VideoPlayerController.network(widget.event['video'])
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
          _controller.play();
        }).catchError((error) {
          setState(() {
            isLoading = false;
            isError = true;
          });
          print("Error loading video: $error");
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 249, 249, 249),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // ปุ่มย้อนกลับ
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า
          },
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
                controller:
                    WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(
                        Uri.parse(
                          'https://emr-life.com/esm/lifescope_master/endo/Report/map',
                        ),
                      ),
              ),
            ),
            // แสดงข้อมูล Event
            Card(
              color:
                  widget.event['type'] == 'Alert'
                      ? Colors.red[100]
                      : Colors.yellow[100],
              elevation: 5,
              child: ListTile(
                leading: Icon(
                  widget.event['type'] == 'Alert'
                      ? Icons.warning
                      : Icons.warning_amber,
                  color:
                      widget.event['type'] == 'Alert'
                          ? Colors.red
                          : Colors.yellow,
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
            // แสดงวิดีโอจาก JSON
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
                      // กำหนดขนาดของ VideoPlayer
                      Container(
                        width: double.infinity,
                        color: Colors.black12,
                        height: 250, // กำหนดความสูงที่แน่นอน
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : VideoPlayer(_controller),
                      ),
                    ],
                  ),
                ),
              ),
            // แสดงภาพจาก JSON
            if (widget.event['image'] != null)
              Image.network(widget.event['image']),
          ],
        ),
      ),
    );
  }
}




