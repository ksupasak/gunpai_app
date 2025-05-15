import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  // สร้าง mock data array (ชื่อของรูปและ URL ของรูปภาพ)
  final List<Map<String, String>> mockData = [
    {'title': 'Source1', 'imageUrl': 'https://files.worldwildlife.org/wwfcmsprod/images/Panda_in_Tree/hero_full/2wgwt9z093_Large_WW170579.jpg'},
    {'title': 'Source2', 'imageUrl': 'https://files.worldwildlife.org/wwfcmsprod/images/Pandas_204718/story_full_width/87o81dodvo_HI_204718.jpg'},
    {'title': 'Source3', 'imageUrl': 'https://files.worldwildlife.org/wwfcmsprod/images/Giant_Pandas/story_full_width/3gnwypezx0_Giant_Panda_Cubs_07.24.2012_Help.jpg'},
    {'title': 'Source4', 'imageUrl': 'https://acb0a5d73b67fccd4bbe-c2d8138f0ea10a18dd4c43ec3aa4240a.ssl.cf5.rackcdn.com/10114/2508_Activism_Jaguar_1050.jpg?v=1740085578000'},
    {'title': 'Source4', 'imageUrl': 'https://acb0a5d73b67fccd4bbe-c2d8138f0ea10a18dd4c43ec3aa4240a.ssl.cf5.rackcdn.com/10114/2508_Activism_Jaguar_1050.jpg?v=1740085578000'},
    {'title': 'Source4', 'imageUrl': 'https://acb0a5d73b67fccd4bbe-c2d8138f0ea10a18dd4c43ec3aa4240a.ssl.cf5.rackcdn.com/10114/2508_Activism_Jaguar_1050.jpg?v=1740085578000'},
    {'title': 'Source4', 'imageUrl': 'https://acb0a5d73b67fccd4bbe-c2d8138f0ea10a18dd4c43ec3aa4240a.ssl.cf5.rackcdn.com/10114/2508_Activism_Jaguar_1050.jpg?v=1740085578000'},
    {'title': 'Source4', 'imageUrl': 'https://acb0a5d73b67fccd4bbe-c2d8138f0ea10a18dd4c43ec3aa4240a.ssl.cf5.rackcdn.com/10114/2508_Activism_Jaguar_1050.jpg?v=1740085578000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // แสดง 2 คอลัมน์ในแต่ละแถว
          crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
          mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
        ),
        itemCount: mockData.length, // จำนวนรายการใน mock data
        itemBuilder: (context, index) {
          // ดึงข้อมูลจาก mockData ตาม index
          final item = mockData[index];

          return Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // แสดงภาพ
                GestureDetector(
                  onTap: () {
                    _showPopup(context, item['imageUrl']!); // เปิด Popup เมื่อคลิกที่รูป
                  },
                  child: Image.network(
                    item['imageUrl']!,
                    fit: BoxFit.cover,
                    height: 120, // กำหนดความสูงของภาพ
                    width: double.infinity, // กำหนดให้ภาพกว้างเต็มตาราง
                  ),
                ),
                SizedBox(height: 8),
                // แสดงชื่อรูป
                Text(
                  item['title']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ฟังก์ชันที่ใช้แสดง Popup เมื่อคลิกที่รูป
  void _showPopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selected Image"),
          content: Builder(
            builder: (BuildContext context) {
              // ใช้ MediaQuery เพื่อหาขนาดหน้าจอ
              double screenWidth = MediaQuery.of(context).size.width;
              double screenHeight = MediaQuery.of(context).size.height;

              return Container(
                width: screenWidth * 0.9,  // กำหนดให้กว้าง 90% ของหน้าจอ
                height: screenHeight * 0.6, // กำหนดให้สูง 60% ของหน้าจอ
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain, // ใช้ BoxFit.contain เพื่อให้รูปไม่ถูกครอป
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageScreen(),
  ));
}