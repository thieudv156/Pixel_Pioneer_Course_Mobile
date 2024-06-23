import 'dart:developer';
import 'package:course_template/screens/sublesson_content_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:course_template/models/courseFull.dart';
import 'package:course_template/models/course.dart' as course_models;
import 'package:http/http.dart' as http;
import 'package:course_template/utils/PublicBaseURL.dart';
import 'package:course_template/models/review.dart';
import 'package:course_template/models/progress.dart';

class CourseDetailsScreen extends StatefulWidget {
  final course_models.Course course;

  const CourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isFavorite = false;
  Course? fullCourse;
  double averageRating = 0.0;
  List<Review> reviews = [];
  List<Progress> progresses = [];
  bool hasProgress = false;
  TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;
  int _currentPage = 1;
  static const int _reviewsPerPage = 5;

  int? _editingReviewId;
  TextEditingController _editCommentController = TextEditingController();
  int _editRating = 0;

  @override
  void initState() {
    super.initState();
    _fetchFullCourseDetails();
    _checkIfFavorite();
    _fetchReviews();
    _checkAndCreateProgress();
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];
    setState(() {
      isFavorite = favoriteCourseJsonList.any((courseJson) {
        var storedCourse = jsonDecode(courseJson);
        return storedCourse['id'] == widget.course.id;
      });
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];

    if (isFavorite) {
      favoriteCourseJsonList.removeWhere((courseJson) {
        var storedCourse = jsonDecode(courseJson);
        return storedCourse['id'] == widget.course.id;
      });
    } else {
      var courseMap = {
        'id': widget.course.id,
        'title': widget.course.title,
        'instructorName': widget.course.instructorName,
        'imageUrl': widget.course.imageUrl,
        'price': widget.course.price,
      };
      favoriteCourseJsonList.add(jsonEncode(courseMap));
    }

    await prefs.setStringList('favoriteCourses', favoriteCourseJsonList);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _fetchFullCourseDetails() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/course/${widget.course.id}'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        fullCourse = Course.fromJson(jsonResponse);
      });
    } else {
      log('Failed to load full course details');
    }
  }

  Future<void> _fetchReviews() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/reviews/course?courseId=${widget.course.id}'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          reviews = jsonResponse
              .map((reviewJson) =>
                  Review.fromJson(reviewJson as Map<String, dynamic>))
              .toList();
          averageRating = _calculateAverageRating(reviews);
        });
      } else {
        log('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching reviews: $e');
    }
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  Future<void> _submitReview() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;
      final response = await http.post(
        Uri.parse('$baseUrl/api/reviews/uploadReview'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'courseId': widget.course.id,
          'userId': userId,
          'rating': _rating,
          'content': _commentController.text,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _commentController.clear();
          _rating = 0;
          _isSubmitting = false;
        });
        _fetchReviews();
      } else {
        log('Failed to submit review: ${response.statusCode}');
        setState(() {
          _isSubmitting = false;
        });
      }
    } catch (e) {
      log('Error submitting review: $e');
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _editReview(int reviewId) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/reviews/editReview?reviewId=$reviewId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'courseId': widget.course.id,
          'userId': await _getUserId(),
          'rating': _editRating,
          'content': _editCommentController.text,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _editingReviewId = null;
          _editCommentController.clear();
          _editRating = 0;
          _isSubmitting = false;
        });
        _fetchReviews();
      } else {
        log('Failed to edit review: ${response.statusCode}');
        setState(() {
          _isSubmitting = false;
        });
      }
    } catch (e) {
      log('Error editing review: $e');
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _deleteReview(int reviewId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/reviews/deleteReview?reviewId=$reviewId'),
      );

      if (response.statusCode == 200) {
        _fetchReviews();
      } else {
        log('Failed to delete review: ${response.statusCode}');
      }
    } catch (e) {
      log('Error deleting review: $e');
    }
  }

  Future<int> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  Future<void> _checkAndCreateProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/progress/check-and-create-missing-progress?courseId=${widget.course.id}&userId=$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        progresses =
            jsonResponse.map((json) => Progress.fromJson(json)).toList();
        hasProgress = progresses.isNotEmpty;
      });
    }
  }

  List<Review> get _paginatedReviews {
    final startIndex = (_currentPage - 1) * _reviewsPerPage;
    final endIndex = startIndex + _reviewsPerPage;
    return reviews.sublist(
        startIndex, endIndex > reviews.length ? reviews.length : endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: fullCourse == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Image.network(widget.course.imageUrl),
                const SizedBox(height: 16),
                Text(
                  widget.course.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
                const Text(
                  'Instructor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/000/505/708/original/vector-teaching-icon-design.jpg'),
                  ),
                  title: Text(widget.course.instructorName),
                  subtitle:
                      Text("Creator of this course: ${widget.course.title}"),
                ),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Lessons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (!hasProgress)
                  ElevatedButton(
                    onPressed: _checkAndCreateProgress,
                    child: Text('Start Learning'),
                  ),
                if (hasProgress)
                  ...fullCourse!.lessons
                      .map((lesson) => ExpansionTile(
                            title:
                                Text('${lesson.orderNumber}. ${lesson.title}'),
                            children: lesson.subLessons.map((subLesson) {
                              bool isCompleted = progresses.any((p) =>
                                  p.subLesson.id == subLesson.id &&
                                  p.isCompleted);

                              return ListTile(
                                leading: Icon(isCompleted
                                    ? Icons.check_circle
                                    : Icons.circle),
                                title: Text(subLesson.title),
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SubLessonContentScreen(
                                        subLesson: subLesson,
                                        instructorName:
                                            widget.course.instructorName,
                                        courseId: widget.course.id,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    _checkAndCreateProgress();
                                  }
                                },
                              );
                            }).toList(),
                          ))
                      .toList(),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Average Rating: ${(averageRating).toStringAsFixed(1)} / 5.0',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Based on ${reviews.length} reviews',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Review',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Add a comment',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed:
                          _rating > 0 && _commentController.text.isNotEmpty
                              ? _isSubmitting
                                  ? null
                                  : _submitReview
                              : null,
                      child: _isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Submit Review'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._paginatedReviews.map((review) {
                      bool isEditing = _editingReviewId == review.id;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isEditing)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _editCommentController,
                                  decoration: const InputDecoration(
                                    labelText: 'Edit comment',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(5, (index) {
                                    return IconButton(
                                      icon: Icon(
                                        index < _editRating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _editRating = index + 1;
                                        });
                                      },
                                    );
                                  }),
                                ),
                              ],
                            )
                          else
                            Text(review.content),
                          Text(
                            "Rating: ${review.rating.toString()} stars",
                            style: const TextStyle(
                              color: Colors.deepOrange,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${review.user.fullName}",
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                              ),
                              Row(
                                children: [
                                  if (isEditing)
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: _editCommentController
                                                      .text.isNotEmpty &&
                                                  _editRating > 0
                                              ? () => _editReview(review.id)
                                              : null,
                                          child: const Text('Save Changes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _editingReviewId = null;
                                              _editCommentController.clear();
                                              _editRating = 0;
                                            });
                                          },
                                          child: const Text('Cancel Edit'),
                                        ),
                                      ],
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          _editingReviewId = review.id;
                                          _editCommentController.text =
                                              review.content;
                                          _editRating = review.rating;
                                        });
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteReview(review.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 1)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentPage--;
                              });
                            },
                            child: const Text('Previous'),
                          ),
                        if (_currentPage * _reviewsPerPage < reviews.length)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentPage++;
                              });
                            },
                            child: const Text('Next'),
                          ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
