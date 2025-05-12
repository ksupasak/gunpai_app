import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VideoScreen(),
  ));
}

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool isLoading = true;
  bool isError = false; // เพิ่มตัวแปรเพื่อเช็คข้อผิดพลาด

  final List<String> videoUrls = [
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrls[0])
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
        _controller.play();
      }).catchError((e) {
        setState(() {
          isError = true;
        });
        print("Error initializing video: $e");
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HLS Video Player')),
      body: isError
          ? Center(child: Text('Error loading video.'))
          : isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: videoUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          
                          isLoading = true;
                        });
                        _controller = VideoPlayerController.network(videoUrls[index])
                          ..initialize().then((_) {
                            setState(() {
                              isLoading = false;
                            });
                            _controller.play();
                          }).catchError((e) {
                            setState(() {
                              isError = true;
                            });
                            print("Error loading video: $e");
                          });
                      },
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: Colors.black12,
                                child: isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : VideoPlayer(_controller),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Video ${index + 1}',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
