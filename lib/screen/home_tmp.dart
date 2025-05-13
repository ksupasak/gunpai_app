// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // ใช้ rootBundle โหลดไฟล์
// import 'package:webview_flutter/webview_flutter.dart';

// class MapNewScreen extends StatefulWidget {
//   @override
//   _MapNewScreenState createState() => _MapNewScreenState();
// }

// class _MapNewScreenState extends State<MapNewScreen> {
//   late WebViewController _controller;
//   List<dynamic> locations = [];  // เก็บข้อมูลจาก JSON
//   List<dynamic> events = []; // เก็บข้อมูล Event (Alert, Warn)

//   @override
//   void initState() {
//     super.initState();
//     loadJsonData(); // โหลด JSON ตอนเริ่มต้น

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse('https://map.pcm-life.com/styles/basic/#2.89/1.61/93.34'));
//   }

//   // ฟังก์ชันโหลด JSON จาก assets
//   Future<void> loadJsonData() async {
//     String jsonString = await rootBundle.loadString('assets/data.json');
//     final jsonData = json.decode(jsonString);
//     setState(() {
//       locations = jsonData['locations'];
//       events = jsonData['events']; // เพิ่มการโหลดข้อมูล Event
//     });
//   }

//   // ฟังก์ชันเล่นวิดีโอ
//   void playVideo(String videoUrl) {
//     print('Playing video from URL: $videoUrl');
//     // ฟังก์ชันเล่นวิดีโอจะมาอยู่ที่นี่ในอนาคต
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('PCM Map')),
//       body: Column(
//         children: [
//           // ส่วนแสดง WebView ที่โหลดแผนที่
//           Expanded(
//             child: WebViewWidget(controller: _controller),
//           ),
//           // ส่วนแสดงข้อมูล Event (Alert, Warn)
//           Expanded(
//             child: ListView.builder(
//               itemCount: events.length,
//               itemBuilder: (context, index) {
//                 final event = events[index];
//                 return Container(
//                   color: event['type'] == 'Alert' ? Colors.red[100] : Colors.yellow[100],
//                   child: ListTile(
//                     leading: Icon(
//                       event['type'] == 'Alert' ? Icons.warning : Icons.warning_amber,
//                       color: event['type'] == 'Alert' ? Colors.red : Colors.yellow,
//                     ),
//                     title: Text(event['type']),
//                     subtitle: Text('Detail: ${event['detail']}\nDatetime: ${event['datetime']}'),
//                     trailing: IconButton(
//                       onPressed: () {
//                         playVideo(event['video']); // เล่นวิดีโอจาก URL
//                       },
//                       icon: Icon(Icons.play_arrow),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // ปุ่ม Action (Act1, Act2, Act3, Act4)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(onPressed: () {}, child: Text('Act1')),
//                 ElevatedButton(onPressed: () {}, child: Text('Act2')),
//                 ElevatedButton(onPressed: () {}, child: Text('Act3')),
//                 ElevatedButton(onPressed: () {}, child: Text('Act4')),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

