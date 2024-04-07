import 'package:course_details_app/Screen/chewie_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CourseDetailsController extends GetxController {
  final courseData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    final response = await http.get(Uri.parse(
        'https://getlearn-admin.getbuildfirst.com/api/course/details/1'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      courseData.assignAll(data);
    } else {
      throw Exception('Failed to load course details');
    }
  }
}

class CourseDetailsScreen extends StatefulWidget {
  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  final CourseDetailsController _controller =
      Get.put(CourseDetailsController());

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() async {
    String videoLinkPath = _controller.courseData['video_link_path'] ?? '';
    if (videoLinkPath.isNotEmpty) {
      try {
        _videoController = VideoPlayerController.network(
          Uri.parse(videoLinkPath).toString(),
        );
        await _videoController.initialize();
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: true,
        );
        setState(() {}); // Trigger rebuild after initializing Chewie
      } catch (error) {
        print('Error initializing video: $error');
        // Handle error, e.g., display a placeholder or show an error message
      }
    } else {
      // Handle the case when the video link path is empty or null
      // For example, you can show a placeholder or display an error message.
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 136, 118, 191),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: SizedBox(
                  width: 24,
                  height: 30,
                  child: Image.asset(
                    'images/align-left.png',
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'Course Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: SizedBox(
                  height: 18,
                  width: 24,
                  child: Image.asset(
                    'images/Vector.png',
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              child: Obx(
                () => SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: _controller.courseData.isEmpty
                      ? Center(
                          child: _controller.courseData.isEmpty
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color:
                                      const Color.fromARGB(255, 163, 144, 219),
                                  size: 80,
                                )
                              : const CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_controller.courseData['video_link_path'] !=
                                null)
                              _chewieController != null
                                  ? ChewieListItem(
                                      videoPlayerController: _chewieController!
                                          .videoPlayerController!,
                                      chewieController: _chewieController!,
                                    )
                                  : Container(), // Placeholder or error message
                            const SizedBox(height: 10.0),
                            Text(
                              '${_controller.courseData['title']}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_controller.courseData['sub_title']}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              '${_controller.courseData['totalRating']}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            // Text(
                            //   'Completed Lessons: ${_controller.courseData['completedLessons']}',
                            //   style: const TextStyle(fontSize: 16.0),
                            // ),
                            Text(
                              'Mentor ${_controller.courseData['instructor_id']}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Row(
                              children: [
                                Image.asset("images/Group 1000005816.png"),
                                const SizedBox(width: 5),
                                Text(
                                  'Last Update: ${_controller.courseData['updated_at']}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            Text(
                              'Language: ${_controller.courseData['learning_topic'] != null ? _controller.courseData['learning_topic'].join(', ') : 'N/A'}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Amount: \$${_controller.courseData['price']}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              color: const Color(0xFF7455F7),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Add to Cart'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Add to Wishlist'),
                                ),
                              ],
                            ),
                            const Text(
                              'What you will learn:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Display descriptions here
                            // Show more button functionality here
                            const Text(
                              'Course Curriculum:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Display sections here
                            // If more than 4 sections, display 'rest of (number) other sections' button
                            const Text(
                              'This course includes:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Display course details here
                            const SizedBox(height: 20.0),
                            const Text(
                              'Requirements:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Display course requirements here
                            const SizedBox(height: 20.0),
                            const Text(
                              'Descriptions:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Display complete course descriptions here
                            // Show more button functionality here
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
