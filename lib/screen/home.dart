import 'dart:convert';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:gunpai/layouts/default/layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ใช้ rootBundle โหลดไฟล์
import 'package:gunpai/screen/events.dart';
import 'package:gunpai/screen/event_detail.dart';
import 'package:gunpai/screen/image.dart';
import 'package:gunpai/screen/mapicon.dart';
import 'package:gunpai/screen/video.dart';
import 'package:gunpai/services/mqtt_service.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController _controller;
  List<Event> events = [];
  late MQTTService mqttService;
  String message = "No event yet";

  @override
  void initState() {
    super.initState();
    // loadJsonData();
    loadEventsFromApi();

    saveTestVideo();
    // mqttService = MQTTService();
    // mqttService.connect();
    // mqttService.listenToMessages((newMessage) {
    //   setState(() {
    //     var jsonMessage = json.decode(newMessage);

    //     // Event event = Event.fromJson(jsonMessage);

    //     // Add the new event to the start of the events list
    //     // events.insert(0, event);  /
    //   });

    // });

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..loadRequest(
            Uri.parse(
              'https://emr-life.com/esm/lifescope_master/endo/Report/map',
            ),
          );

    // Additional JavaScript for controlling map
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
    // mqttService.disconnect();
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

   Future<void> loadEventsFromApi() async {
    final url = Uri.parse('https://siaminterlink.com/esm/udirt/www/Api/data?station=C001/E00101');
    final body = json.encode({'station': 'C001/E00101'});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("===============\n");
        print(jsonData);

        if (jsonData.containsKey('events') && jsonData['events'] is List) {
          setState(() {
            events = (jsonData['events'] as List)
                .map((e) => Event.fromJson(e))
                .where((event) => event.status?.toLowerCase() != 'archive')
                .toList();
          });
        } else {
          setState(() => events = []);
        }
      }
    } catch (e) {
      print('⚠️ Error loading events: $e');
    }
  }


  // Delete event from the list
  void deleteEvent(int index) {
    setState(() {
      events.removeAt(index);  // Remove the event at the given index
    });
  }


Future<void> saveTestVideo() async {
  await Permission.photos.request();

  final url = 'https://files.worldwildlife.org/wwfcmsprod/images/Pandas_204718/story_full_width/87o81dodvo_HI_204718.jpg';
  final result = await GallerySaver.saveVideo(url);

  if (result == true) {
    print('Saved to gallery');
  } else {
    print('Failed to save');
  }
}

void _confirmAndDelete(String? eventId) {
    if (eventId == null || eventId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❗ Event ID is invalid')),
      );
      return;
    }

    print("===============\n");
    Navigator.pop(context);
    deleteEventPermanently(eventId);
   

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Confirm Delete'),
    //     content: Text('Are you sure you want to permanently delete this event?'),
    //     actions: [
    //       TextButton(
    //         child: Text('Cancel'),
    //         onPressed: () => Navigator.pop(context),
    //       ),
    //       TextButton(
    //         child: Text('Delete', style: TextStyle(color: Colors.red)),
    //         onPressed: () async {
    //           Navigator.pop(context);
    //           await deleteEventPermanently(eventId);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  Future<void> deleteEventPermanently(String? eventId) async {
    if (eventId == null || eventId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❗ Event ID is invalid')),
      );
      return;
    }

    final url = Uri.parse(
      'https://siaminterlink.com/esm/udirt/www/Api/event_status?station=C001/E00101&id=$eventId&status=Archive',
    );

    try {
      final response = await http.get(url);
      print('🗑️ Delete API response: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          events.removeWhere((event) => event.id == eventId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event deleted permanently')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete event')),
        );
      }
    } catch (e) {
      print('❌ Error deleting event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while deleting')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              child: WebViewWidget(controller: _controller),
            ),
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
                            key: Key(event.id), // must be unique
                            direction: DismissDirection.endToStart, // swipe from right to left
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text('Are you sure you want to delete this event?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete')),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              _confirmAndDelete(event.id); // your delete function
                            },
                            child: Card(
                              color: event.type == 'Alert' ? Colors.red[100] : Colors.yellow[100],
                              elevation: 5,
                              child: ListTile(
                                leading: Icon(
                                  event.type == 'Alert' ? Icons.warning : Icons.warning_amber,
                                  color: event.type == 'Alert' ? Colors.red : Colors.orange,
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
                                        builder: (context) => EventDetailScreen(event: event, refreshList: () {}),
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

















