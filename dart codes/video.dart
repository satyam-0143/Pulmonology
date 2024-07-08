import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:try1/doctorlogin.dart';
import 'package:video_player/video_player.dart';

class Uploadvideo extends StatefulWidget {
  final String userId;

  Uploadvideo({Key? key, required this.userId}) : super(key: key);

  @override
  _UploadvideoState createState() => _UploadvideoState();
}

class _UploadvideoState extends State<Uploadvideo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedVideo;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/placeholder_video.mp4');
  }

  Future<void> _pickVideo(BuildContext context) async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = pickedFile;
        _videoPlayerController = VideoPlayerController.file(File(_selectedVideo!.path));
        _videoPlayerController.initialize().then((_) {
          setState(() {});
        });
      });
    }
  }

  Future<void> _submitVideo(BuildContext context) async {
    if (_selectedVideo != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Upload'),
            content: Text('Do you want to upload this video?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the dialog
                  // Proceed with video upload and database save
                  var request = http.MultipartRequest(
                    'POST',
                    Uri.parse('http://192.168.148.130:80/test/addVideos.php'),
                  );

                  request.files.add(
                    await http.MultipartFile.fromPath(
                      'uploaded_file',
                      _selectedVideo!.path,
                    ),
                  );

                  try {
                    var streamedResponse = await request.send();
                    if (streamedResponse.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Video uploaded successfully')),
                      );
                      // Pop current route and navigate to the home page
                      Navigator.pop(context); // Pop UploadVideo page
                      Navigator.pop(context); // Pop previous page (if any)
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomCardView(userId: widget.userId)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to upload video')),
                      );
                    }
                  } catch (e) {
                    print('Error uploading video: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error uploading video')),
                    );
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a video first.')),
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickVideo(context),
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: _selectedVideo != null
                    ? VideoPlayer(_videoPlayerController)
                    : Icon(
                  Icons.video_collection_outlined,
                  size: 60,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Tap to select video',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _submitVideo(context),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
