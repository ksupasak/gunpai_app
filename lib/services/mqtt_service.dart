import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;

class MQTTService {
  late mqtt.MqttServerClient client;
  final String broker = 'mqtt.pcm-life.com';
  final String username = 'gunpai_user';
  final String password = 'Minadadmin_';
  final String clientId = 'flutter_client';

  Future<void> connect() async {
    client = mqtt.MqttServerClient(broker, clientId);
    client.port = 8883;  // ใช้พอร์ต 8883 สำหรับ SSL

    final context = SecurityContext(withTrustedRoots: false);
    client.securityContext = context;

    // ตั้งค่าการเชื่อมต่อ SSL/TLS
    client.secure = true;
     client.onBadCertificate = (Object cert) {
      return true; // ข้ามการตรวจสอบใบรับรอง
    };

    // client.onBadCertificate = (cert) {
    //   print('Ignoring bad certificate');
    //   return true; // ให้ข้ามการตรวจสอบใบรับรอง
    // };
    
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    // สร้างข้อความเชื่อมต่อ (Connect Message)
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .authenticateAs(username, password)  // ใส่ข้อมูลการยืนยันตัวตน
        .withClientIdentifier(clientId)  // กำหนด Client ID
        .startClean()  // ใช้การเชื่อมต่อแบบ clean session
        .keepAliveFor(60);  // กำหนดระยะเวลาการเชื่อมต่อ

    print('Connecting to MQTT broker...');
    client.connectionMessage = connMess;

    // ลองเชื่อมต่อ
    try {
      await client.connect();  // เชื่อมต่อกับ MQTT
    } catch (e) {
      print('Error: $e');  // เปลี่ยนการจับข้อผิดพลาดเป็น Exception
      client.disconnect();  // หากไม่สำเร็จให้ตัดการเชื่อมต่อ
    }
  }

  // ฟังก์ชันเมื่อเชื่อมต่อสำเร็จ
  void onConnected() {
    print('Connected to MQTT broker');
    // เมื่อเชื่อมต่อสำเร็จ ให้ subscribe กับ topic ที่ต้องการ
    client.subscribe('gunpai/events/#', mqtt.MqttQos.atMostOnce);  // กำหนด topic
  }

  // ฟังก์ชันเมื่อเชื่อมต่อถูกตัด
  void onDisconnected() {
    print('Disconnected from MQTT broker');
  }

  // ฟังก์ชันรับข้อความจาก MQTT
  void listenToMessages(Function(String) onMessage) {
    client.updates?.listen((List<mqtt.MqttReceivedMessage> c) {
      final mqtt.MqttPublishMessage recMess = c[0].payload as mqtt.MqttPublishMessage;
      final message = mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('Received message: $message');
      onMessage(message);  // ส่งข้อความที่ได้รับไปยังฟังก์ชันที่รับข้อความ
    });
  }

  // ฟังก์ชันตัดการเชื่อมต่อ
  void disconnect() {
    client.disconnect();
    print('Disconnected');
  }
}



