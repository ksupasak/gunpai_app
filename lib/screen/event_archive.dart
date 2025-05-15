import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gunpai/screen/event_detail.dart';
import 'package:gunpai/screen/events.dart';
import 'package:gunpai/layouts/default/layout.dart';

class ArchiveEventScreen extends StatefulWidget {
  @override
  _ArchiveEventScreenState createState() => _ArchiveEventScreenState();
}

class _ArchiveEventScreenState extends State<ArchiveEventScreen> {
  List<Event> archivedEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArchivedEvents();
  }

  Future<void> fetchArchivedEvents() async {
    final url = Uri.parse('https://siaminterlink.com/esm/udirt/www/Api/data?station=C001/E00101&status=Archive');

    try {
      final response = await http.get(url);
      print('📦 Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ Decoded JSON: $jsonData');

        if (jsonData.containsKey('events') && jsonData['events'] is List) {
          setState(() {
            archivedEvents = (jsonData['events'] as List)
                .map((e) => Event.fromJson(e))
                .where((event) => event.status == 'Archive')
                .toList();
            isLoading = false;
            print('✅ Archived events: ${archivedEvents.length}');
          });
        } else {
          print('⚠️ ไม่มี key "events" หรือไม่ใช่ List');
          setState(() {
            archivedEvents = [];
            isLoading = false;
          });
        }
      } else {
        print('❌ Failed to load archived events: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e,stackTrace) {
      print('⚠️ Error fetching archived events: $e');
      setState(() => isLoading = false);
      print(stackTrace);
    }
  }

  // Callback function for refreshing the list
  void _refreshEventList() {
    fetchArchivedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Archived Events',
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : archivedEvents.isEmpty
              ? Center(child: Text('No archived events found.'))
              : ListView.builder(
                  itemCount: archivedEvents.length,
                  itemBuilder: (context, index) {
                    final event = archivedEvents[index];
                    return Card(
                      color: Colors.grey[200],
                      child: ListTile(
                        leading: Icon(
                          event.type == 'Alert'
                              ? Icons.warning
                              : Icons.warning_amber,
                          color: event.type == 'Alert'
                              ? Colors.red
                              : Colors.orange,
                        ),
                        title: Text(event.type,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Detail: ${event.detail}\nDatetime: ${event.datetime}',
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(Icons.archive),
                        onTap: () {
                          // Pass the callback to EventDetailScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(
                                event: event,
                                refreshList: _refreshEventList, // Pass callback
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
