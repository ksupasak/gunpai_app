// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gungun/screennew/mapscreen.dart';  // นำเข้า MapScreen
// import 'package:video_player/video_player.dart'; // ใช้สำหรับเล่นวีดีโอ

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   List<dynamic> locations = [];
//   late VideoPlayerController _controller;
//   bool isLoading = false;
//   bool isError = false;

//   @override
//   void initState() {
//     super.initState();
//     loadJsonData(); // โหลดข้อมูลจาก JSON
//   }

//   Future<void> loadJsonData() async {
//     try {
//       String jsonString = await rootBundle.loadString('assets/data.json');
//       final jsonData = json.decode(jsonString);
//       setState(() {
//         locations = jsonData['locations'];
//       });
//     } catch (e) {
//       print('Error loading JSON: $e');
//     }
//   }

//   // ฟังก์ชันเล่นวิดีโอ HLS
//   void playVideo(String videoUrl) {
    

//     _controller = VideoPlayerController.network(videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       }).catchError((e) {
//         setState(() {
//           isLoading = false;
//           isError = true;
//         });
//         print("Error loading video: $e");
//       });
//       setState(() {
//       isLoading = true;
//       isError = false;
//     });
//   }

//   // ฟังก์ชันหยุดการเล่นวิดีโอ
//   void stopvideo() {
//     if (_controller.value.isInitialized) {
//       _controller.dispose();
//     }
//     setState(() {
//       isLoading = false;
//       isError = false;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (_controller.value.isInitialized) {
//       _controller.dispose();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Map Screen')),
//       body: isLoading 
//           ? SizedBox(
//               child: ListView(
//                 children: [
//                   _controller.value.isInitialized
//                       ? AspectRatio(
//                           aspectRatio: _controller.value.aspectRatio,
//                           child: VideoPlayer(_controller),
//                         )
//                       : SizedBox(),
//                   IconButton(onPressed: stopvideo, icon: Icon(Icons.stop)),
//                   Mapscreen() // เรียกใช้ MapScreen ที่นี่
//                 ],
//               ),
//             )
//           : locations.isEmpty
//               ? Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                   itemCount: locations.length,
//                   itemBuilder: (context, index) {
//                     final location = locations[index];
//                     return Card(
//                       elevation: 5,
//                       child: ListTile(
//                         leading: Image.network(location['image']),
//                         title: Text(location['ls']),
//                         subtitle: Text(location['video']),
//                         trailing: IconButton(
//                           icon: Icon(Icons.play_arrow),
//                           onPressed: () {
//                             playVideo(location['video']); // เรียกฟังก์ชัน playVideo เมื่อกดที่ไอคอน play
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MapScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EventMonitorScreen(),
    );
  }
}

class EventMonitorScreen extends StatefulWidget {
  @override
  _EventMonitorScreenState createState() => _EventMonitorScreenState();
}

class _EventMonitorScreenState extends State<EventMonitorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUNPAI Events'),
      ),
      body: Stack(
        children: [
          // ด้านล่าง Event และ Monitoring
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ส่วน Events
                  Text(
                    'Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // รายละเอียดของ Alert และ Warn
                  Container(
                    color: Colors.red[100],
                    child: ListTile(
                      leading: Icon(Icons.warning, color: Colors.red),
                      title: Text('Alert'),
                      subtitle: Text('Detail: 3 people\nDatetime: 12/1/2025 08:32'),
                    ),
                  ),
                  Container(
                    color: Colors.yellow[100],
                    child: ListTile(
                      leading: Icon(Icons.warning, color: Colors.yellow),
                      title: Text('Warn'),
                      subtitle: Text('Detail: 3 people\nDatetime: 12/1/2025 08:32'),
                    ),
                  ),
                  SizedBox(height: 10),
                  // ส่วน Monitoring
                  Text(
                    'Monitor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // ช่องสำหรับแสดงข้อมูล Monitoring
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 8, // จำนวนช่องที่ต้องการ
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        color: Colors.blue[100],
                        child: Center(
                          child: Text('Item ${index + 1}'),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  // ปุ่ม Action
                                    // ปุ่ม Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 6, 59, 102), // เปลี่ยนสีพื้นหลังเป็นสีน้ำเงิน
                        ),
                        child: Text('Act1'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 6, 59, 102), // เปลี่ยนสีพื้นหลังเป็นสีน้ำเงิน
                        ),
                        child: Text('Act2'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 6, 59, 102), // เปลี่ยนสีพื้นหลังเป็นสีน้ำเงิน
                        ),
                        child: Text('Act3'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 6, 59, 102), // เปลี่ยนสีพื้นหลังเป็นสีน้ำเงิน
                        ),
                        child: Text('Act4'),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
