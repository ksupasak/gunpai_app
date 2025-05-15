// lib/models/event.dart
import 'dart:convert';
class Event {
  final String id;
  final String type;
  final String detail;
  final DateTime datetime;
  final String video;
  final String image;
  final String status;
  final String url;
  final String? channelId;
  final String? customerId;
  final String? edgeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? eventData;
  final String? latlng;
  final String? name;

  Event({
    required this.id,
    required this.type,
    required this.detail,
    required this.datetime,
    required this.video,
    required this.image,
    required this.status,
    required this.url,
    this.channelId,
    this.customerId,
    this.edgeId,
    this.createdAt,
    this.updatedAt,
    this.eventData,
    this.latlng,
    this.name,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    print("\n");
    print('Event: ${json}\n');
    print('Datetime: ${json.keys.join(', ')}\n');

    return Event(
      id: json['id'],
      type: json['type'] ?? '',
      detail: json['detail'] ?? '',
      datetime: DateTime.parse(json['datetime'] ?? ''),
      video: json['video_path'] ?? '',
      image: json['image_path'] ?? '',
      status: json['status'] ?? '',
      url: json['video_path'] ?? '',
      channelId: json['channel_id'],
      customerId: json['customer_id'],
      edgeId: json['edge_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      eventData: json['event_data'],
      latlng: json['latlng'],
      name: json['name'],
    );
  }
}