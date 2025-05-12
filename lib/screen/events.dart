// lib/models/event.dart
import 'dart:convert';
class Event {
  String type;
  String detail;
  String datetime;
  String video;
  String image;
  //String map_url;

  Event({
    required this.type,
    required this.detail,
    required this.datetime,
    required this.video,
    required this.image,
    //required this.map_url,
  });

  // Convert JSON to Dart object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      type: json['type'],
      detail: json['detail'],
      datetime: json['datetime'],
      video: json['video'],
      image: json['image'],
      //map_url: json['map_url'],
    );
  }

  void add(Event events) {}

  // Convert Dart object to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'type': type,
  //     'detail': detail,
  //     'datetime': datetime,
  //     'video': video,
  //     'image': image,
  //   };
  // }
}

