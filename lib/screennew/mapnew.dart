import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ใช้ rootBundle โหลดไฟล์
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gungun/screennew/events.dart';
import 'package:gungun/screennew/eventdetail.dart';
import 'package:gungun/screennew/mapicon.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

// นำเข้าไฟล์ที่เกี่ยวข้องกับหน้าต่าง
import 'package:gungun/screennew/imagenew.dart'; // หน้า Imagegun
import 'package:gungun/screennew/videonew.dart'; // หน้า VideoScreen
import 'package:gungun/screennew/mapnew.dart'; // หน้า MapNewScreen
import 'package:gungun/services/mqtt_service.dart'; // ใช้ไฟล์ MQTTService ที่สร้างขึ้น
import 'package:gungun/services/notification_service.dart'; // ใช้ NotificationService ที่สร้างขึ้น

class MapNewScreen extends StatefulWidget {
  @override
  _MapNewScreenState createState() => _MapNewScreenState();
}

class _MapNewScreenState extends State<MapNewScreen> {
  late WebViewController _controller;
  List<Event> events = [];
  late MQTTService mqttService;
  late NotificationService notificationService;
  String message = "No event yet";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    loadJsonData();

    notificationService = NotificationService();
    notificationService.initialize();

    // กำหนดค่าการแจ้งเตือนสำหรับทั้ง Android และ iOS
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

  
    mqttService = MQTTService();
    mqttService.connect();
    mqttService.listenToMessages((newMessage) {
      setState(() {
        
        var jsonMessage = json.decode(newMessage);  

       
        Event event = Event.fromJson(jsonMessage);
        
        print(event);
       
        //events.add(event);  
        events.insert(0, event);  // เพิ่ม event ใหม่ที่ตำแหน่งแรก (index 0)
      });

      
      _showNotification(message);
    });

    
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..loadRequest(
            Uri.parse(
              'https://emr-life.com/esm/lifescope_master/endo/Report/map',
            ),
          );

    
    _controller.runJavaScript('''
      map.dragging.enable();
      map.touchZoom.enable();
      map.scrollWheelZoom.enable();
      map.setCenter([100.9925, 15.8700]);
      map.setZoom(6);
    ''');
  }

  @override
  void dispose() {
    super.dispose();
    mqttService.disconnect();
  }

  // Load JSON data and map it to Event objects
  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    final jsonData = json.decode(jsonString);  // Decode JSON data
    setState(() {
      events = (jsonData['events'] as List)
          .map((e) => Event.fromJson(e))
          .toList();  // Convert JSON to Event objects and add them to the events list
    });
  }

  // Show a notification when a new message is received
  Future<void> _showNotification(String message) async {
    var androidDetails = AndroidNotificationDetails(
      'your_channel_id', 'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSDetails = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.show(
      0,  // Notification ID
      'New Event Alert',  // Notification title
      message,  // Message content
      notificationDetails,  // Notification details
    );
  }

  // Delete event from the list
  void deleteEvent(int index) {
    setState(() {
      events.removeAt(index);  // Remove the event at the given index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 45, 106),
 // AppBar color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 254, 252, 252)),  // Back button
          onPressed: () {
            Navigator.pop(context);  // Navigate back to the previous screen
          },
        ),
        title: Row(
          children: [
            // App logo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/logo.png', width: 30, height: 30),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 33, 45, 106),
  // BottomNavigationBar color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.image, color: Colors.white), label: 'Image'),
          BottomNavigationBarItem(icon: Icon(Icons.video_camera_back, color: Colors.white), label: 'Video'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MapNewScreen()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Imagegun()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen()));
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // WebView to display the map
            Container(
              height: 300,
              child: WebViewWidget(controller: _controller),
            ),
            // Display the events
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // Display the events from the list
                  ...events.map((event) {
                    int index = events.indexOf(event);
                    return Dismissible(
                      key : Key(index.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        deleteEvent(index);  // Delete event on swipe
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event deleted')));
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        color: event.type == 'Alert' ? Colors.red[100] : Colors.yellow[100],
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(
                            event.type == 'Alert' ? Icons.warning : Icons.warning_amber,
                            color: event.type == 'Alert' ? Colors.red : Colors.yellow,
                          ),
                          title: Text(event.type, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Detail: ${event.detail}\nDatetime: ${event.datetime}',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailScreen(event: event),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            // Monitoring section
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monitor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 8,
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
            // Display MQTT message
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Event: $message', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
















