// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  const CourseDetailsScreen({super.key});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  final CourseDetailsController _controller =
      Get.put(CourseDetailsController());

  final Color imageColor = const Color.fromARGB(255, 116, 85, 247);

  bool showMore = false;
  bool isDescriptionVisible = false;
  List<bool> isDescriptionVisibleList = [];
  bool showFullDescription = false;

  // List<bool> isExpanded = [];

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    if (_controller.courseData['sections'] != null) {
      isDescriptionVisibleList = List.filled(
        _controller.courseData['sections'].length,
        false,
      );
    }
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
        setState(() {});
      } catch (error) {
        print('Error initializing video: $error');
      }
    } else {}
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
      backgroundColor: const Color(0xFF7455F7),
      //backgroundColor: const Color.fromARGB(255, 133, 94, 251),
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
                  height: 20,
                  child: Image.asset(
                    'images/align-left.png',
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'Course Details',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: SizedBox(
                  height: 16.56,
                  width: 18,
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
              //color: const Color(0xFFF7F8FA),
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
                                      const Color.fromARGB(255, 133, 94, 251),
                                  size: 80,
                                )
                              : const CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // gradient: const LinearGradient(
                                //   begin: Alignment.centerLeft,
                                //   end: Alignment.centerRight,
                                //   colors: [
                                //     Color(0xFF7455F7),
                                //     Color.fromARGB(255, 73, 66, 103),
                                //   ],
                                // ),
                              ),
                              child: _controller.courseData['thumb'] != null
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            _controller.courseData['thumb'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 160,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Color.fromRGBO(
                                                      116, 85, 247, 1),
                                                  // Color(0xFF7455F7),
                                                  // Color(0xFF7455F7),
                                                  Color.fromARGB(
                                                      255, 121, 107, 185),
                                                  Colors.transparent,
                                                  // Color.fromARGB(
                                                  //     255, 187, 182, 209),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Image.asset(
                                                    'images/Group1000005087.png',
                                                    width: 55,
                                                    height: 55,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    bottom: 3,
                                                    child: Image.asset(
                                                      // height: 20,
                                                      // width: 20,
                                                      'images/Rectangle 8251.png',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),

                            const SizedBox(height: 40),
                            Text(
                              '${_controller.courseData['title']}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${_controller.courseData['sub_title']}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                height: 1.33,
                                // textAlign: TextAlign.left,
                              ),
                            ),

                            const SizedBox(height: 7),
                            Row(
                              children: [
                                Text(
                                  '${_controller.courseData['category_id']}.0',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  'images/stars.png',
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '(${_controller.courseData['sub_category_id']})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(153, 153, 153, 1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_controller.courseData['sub_category_id']} students',
                              style: const TextStyle(
                                color: Color.fromRGBO(102, 102, 102, 1),
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Text(
                            //   'Completed Lessons: ${_controller.courseData['completedLessons']}',
                            //   style: const TextStyle(fontSize: 16.0),
                            // ),
                            Row(
                              children: [
                                const Text(
                                  'Mentor',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Color.fromRGBO(102, 102, 102, 1),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${_controller.courseData['instructor_name'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(116, 85, 247, 1),
                                    // color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Image.asset(
                                  "images/appointment 1.png",
                                  // width: 25,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Last Update ${DateFormat('MM/yyyy').format(DateTime.parse(_controller.courseData['updated_at']))}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),

                            Row(
                              children: [
                                Image.asset(
                                  "images/Group 1000005816.png",
                                  // height: 30,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'English',
                                  //'${_controller.courseData['learning_topic'] != null ? _controller.courseData['learning_topic'].join(', ') : 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'BDT ${NumberFormat('#,##0.00', 'en_US').format(_controller.courseData['price'] * 109.83)}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20.0,
                                color: Color.fromRGBO(102, 102, 102, 1),
                                fontWeight: FontWeight.w700,
                                height: 14.0 / 20.0,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 350,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7455F7),

                                      // color: const Color.fromARGB(
                                      //     255, 133, 94, 251),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Buy Now',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // color: const Color(0xFFEDEBFA),
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 245, 244, 248),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 133, 94, 251),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          // Add to Cart functionality
                                        },
                                        child: const Text('Add to Cart'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      // color: const Color(0xFFEDEBFA),
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 245, 244, 248),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 133, 94, 251),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text('Add to Wishlist'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "What you'll learn",
                                  style: TextStyle(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ..._controller.courseData['learning_topic']
                                        .take(showMore
                                            ? _controller
                                                .courseData['learning_topic']
                                                .length
                                            : 3)
                                        .map<Widget>((topic) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ImageIcon(
                                            const AssetImage(
                                                'images/Ellipse.png'),
                                            color: imageColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              topic,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                                height: 1.33,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                          // const SizedBox(height: 8),
                                        ],
                                      );
                                    }).toList(),
                                    if (!showMore &&
                                        _controller.courseData['learning_topic']
                                                .length >
                                            3)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showMore = true;
                                          });
                                        },
                                        child: const Text(
                                          'Show more',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Display descriptions here
                            // Show more button functionality here
                            //
                            //
                            //
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Course Curriculum',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ..._controller.courseData['sections']
                                      .asMap()
                                      .entries
                                      .map<Widget>((entry) {
                                    final int index = entry.key;
                                    final section = entry.value;
                                    final description = section['description'];
                                    final lessons = section['lessons'];
                                    final bool isDescriptionVisible =
                                        isDescriptionVisibleList.length > index
                                            ? isDescriptionVisibleList[index]
                                            : false;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // color: Colors.green,
                                          alignment: Alignment.center,
                                          // padding: const EdgeInsets.symmetric(
                                          //     horizontal: 15, vertical: 10),
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 250, 251, 252),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                spreadRadius: 0.5,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      section['topic'] ?? '',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            isDescriptionVisible
                                                                ? const Color
                                                                    .fromRGBO(
                                                                    163,
                                                                    53,
                                                                    243,
                                                                    1)
                                                                : const Color
                                                                    .fromRGBO(
                                                                    51,
                                                                    51,
                                                                    51,
                                                                    1),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        // Toggle the visibility of the description part
                                                        if (isDescriptionVisibleList
                                                                .length >
                                                            index) {
                                                          isDescriptionVisibleList[
                                                                  index] =
                                                              !isDescriptionVisibleList[
                                                                  index];
                                                        } else {
                                                          isDescriptionVisibleList
                                                              .add(true);
                                                        }
                                                      });
                                                    },
                                                    icon: Icon(
                                                      isDescriptionVisible
                                                          ? Icons
                                                              .keyboard_arrow_up_rounded
                                                          : Icons
                                                              .keyboard_arrow_down_rounded,
                                                      color: const Color(
                                                          0xFF7455F7),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              if (isDescriptionVisible)
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Description's introduction with image and text
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 12,
                                                              child:
                                                                  Image.asset(
                                                                'images/Polygon6.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 16),
                                                            const Flexible(
                                                              child: Text(
                                                                'Course Introduction',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          102,
                                                                          102,
                                                                          102,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          description != null &&
                                                                  description
                                                                          .length >
                                                                      50
                                                              ? '${description.substring(0, 50)}...'
                                                              : description ??
                                                                  '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        if (description !=
                                                                null &&
                                                            description.length >
                                                                50)
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                isDescriptionVisibleList[
                                                                        index] =
                                                                    true;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Text(
                                                                description.length >
                                                                        50
                                                                    ? 'Show more'
                                                                    : '',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          116,
                                                                          85,
                                                                          247,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              height: 12,
                                                              child:
                                                                  Image.asset(
                                                                'images/Polygon6.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 16),
                                                            const Flexible(
                                                              child: Text(
                                                                'Expressions for Discussion',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          169,
                                                                          169,
                                                                          169),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 45),
                                                            SizedBox(
                                                              height: 16,
                                                              child:
                                                                  Image.asset(
                                                                'images/lock.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 14,
                                                              child:
                                                                  Image.asset(
                                                                'images/mic.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 9),
                                                            const Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Text(
                                                                  'Ask for & Provide Information',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            102,
                                                                            102,
                                                                            102,
                                                                            1),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              height: 11.5,
                                                              child:
                                                                  Image.asset(
                                                                'images/document 1.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 16),
                                                            const Flexible(
                                                              child: Text(
                                                                'Emmergency Vocabulary',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          169,
                                                                          169,
                                                                          169),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 58),
                                                            SizedBox(
                                                              height: 16,
                                                              child:
                                                                  Image.asset(
                                                                'images/lock.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              //
                                              //
                                              //

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: lessons
                                                    .map<Widget>((lesson) {
                                                  return Text(
                                                    lesson['lesson_title'] ??
                                                        '',
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black87,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                  if (_controller
                                          .courseData['sections'].length >
                                      4)
                                    ElevatedButton(
                                      onPressed: () {
                                        if (kDebugMode) {
                                          print('Show remaining sections');
                                        }
                                      },
                                      child: Text(
                                        'Show ${_controller.courseData['sections'].length - 4} more sections',
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Display sections here
                            // If more than 4 sections, display 'rest of (number) other sections' button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'This course includes',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset(
                                      height: 16,
                                      'images/youtube.png',
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '0.34 total hours on-demand video',
                                      style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset(
                                      height: 16,
                                      'images/document 1.png',
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Support Files',
                                      style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset(
                                      height: 16,
                                      'images/book.png',
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '5 Articles',
                                      style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset(
                                      height: 16,
                                      'images/infinity.png',
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Full lifetime access',
                                      style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset(
                                      height: 16,
                                      'images/smartphone 1.png',
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Access on mobile, desktop, and TV',
                                      style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Image.asset(
                                      height: 16,
                                      'images/certificate.png',
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Certificate of completion',
                                      style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 70),
                            // Display course details here

                            //
                            //
                            //
                            // const SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Requirements',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const ImageIcon(
                                      AssetImage('images/Ellipse.png'),
                                      color: Color.fromARGB(255, 116, 85, 247),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 1),
                                    Flexible(
                                      child: Text(
                                        _controller
                                                .courseData['requirements'] ??
                                            '',
                                        style: const TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Display course requirements here
                            const SizedBox(height: 20.0),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  showFullDescription
                                      ? _controller.courseData['description'] ??
                                          ''
                                      : _truncateDescription(_controller
                                              .courseData['description'] ??
                                          ''),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 17.0,
                                    color: Color.fromRGBO(102, 102, 102, 1),
                                  ),
                                ),
                                if (_controller
                                        .courseData['description'].length >
                                    200) // Adjust the threshold as needed
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showFullDescription =
                                            !showFullDescription;
                                      });
                                    },
                                    child: Text(
                                      showFullDescription
                                          ? 'Show less'
                                          : 'Show more',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(116, 85, 247, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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

String _truncateDescription(String description) {
  // Truncate the description to 200 characters
  if (description.length > 200) {
    return '${description.substring(0, 200)}...';
  }
  return description;
}
