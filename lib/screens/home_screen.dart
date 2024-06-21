import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:course_template/models/category.dart';
import 'package:course_template/models/course.dart';
import 'package:course_template/models/userinformation.dart';
import 'package:course_template/screens/category_list_screen.dart';
import 'package:course_template/screens/chat_screen.dart';
import 'package:course_template/screens/course_details_screen.dart';
import 'package:course_template/screens/search_results.dart';
import 'package:course_template/screens/profile_screen.dart';
import 'package:course_template/utils/PublicBaseURL.dart';
import 'package:course_template/widgets/course_chip.dart';

import 'course_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Category> _categories = [];
  List<Course> _courses = [];
  List<Map<String, dynamic>> _instructors =
      []; // List of instructors with course count
  bool _isLoading = true;
  bool _isEnrolled = false;
  String? _userFullname;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userFullname = prefs.getString("userFullname") ?? 'User';
    _userId = prefs.getInt("userId");

    if (_userId != null) {
      // Check enrollment status
      final enrollmentResponse = await http.get(Uri.parse(
          '$baseUrl/api/enrollments/check-enrollment?userId=$_userId'));
      if (enrollmentResponse.statusCode == 200) {
        _isEnrolled = jsonDecode(enrollmentResponse.body) as bool;
      }
    }

    final categoriesResponse =
        await http.get(Uri.parse('$baseUrl/api/category'));
    final coursesResponse = await http.get(Uri.parse('$baseUrl/api/course'));

    if (_isEnrolled) {
      final instructorsResponse =
          await http.get(Uri.parse('$baseUrl/api/profile/instructor'));
      if (instructorsResponse.statusCode == 200) {
        final List<dynamic> instructorsData =
            jsonDecode(instructorsResponse.body);

        List<Map<String, dynamic>> instructorsList = [];
        for (var instructorJson in instructorsData) {
          UserInformation instructor = UserInformation.fromJson(instructorJson);
          final coursesResponse = await http.get(
              Uri.parse('$baseUrl/api/course/instructor/${instructor.id}'));
          int courseCount = 0;
          if (coursesResponse.statusCode == 200) {
            final List<dynamic> coursesData = jsonDecode(coursesResponse.body);
            courseCount = coursesData.length;
          }
          instructorsList.add({
            'instructor': instructor,
            'courseCount': courseCount > 9 ? '9+' : courseCount.toString(),
          });
        }
        setState(() {
          _instructors = instructorsList;
        });
      }
    }

    if (categoriesResponse.statusCode == 200 &&
        coursesResponse.statusCode == 200) {
      final List<dynamic> categoriesData = jsonDecode(categoriesResponse.body);
      final List<dynamic> coursesData = jsonDecode(coursesResponse.body);

      final List<Category> fetchedCategories =
          categoriesData.map((json) => Category.fromJson(json)).toList();
      final List<Course> fetchedCourses =
          coursesData.map((json) => Course.fromJson(json)).toList();

      setState(() {
        _categories = fetchedCategories;
        _courses = fetchedCourses;
        _isLoading = false;
      });
    } else {
      setState(() {
        _categories = [];
        _courses = [];
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userFullname ?? 'User',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Find your course and enjoy new arrivals✨',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.notifications, size: 28),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  List<Widget> get _widgetOptions => [
        HomePage(
          courses: _courses,
          categories: _categories,
          instructors: _instructors,
          isEnrolled: _isEnrolled,
        ),
        const CategoryListScreen(),
        const ChatScreen(),
        const ProfileScreen(),
      ];
}

class HomePage extends StatefulWidget {
  final List<Course> courses;
  final List<Category> categories;
  final List<Map<String, dynamic>> instructors;
  final bool isEnrolled;

  const HomePage({
    super.key,
    required this.courses,
    required this.categories,
    required this.instructors,
    required this.isEnrolled,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  Future<List<Course>> searchCourses(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/course/search-by-name?courseName=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _onSearchSubmitted(String query) async {
    setState(() {
      _isSearching = true;
    });
    try {
      final results = await searchCourses(query);
      setState(() {
        _isSearching = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(searchResults: results),
        ),
      );
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          Stack(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Courses Here',
                ),
                onSubmitted: _onSearchSubmitted,
              ),
              if (_isSearching)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 48,
                  child: Container(
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.isEnrolled) ...[
            _buildSectionHeader('Prestigious Instructors', onTap: () {
              // Handle "See more" action
            }),
            _buildInstructors(context),
            const SizedBox(height: 16),
          ],
          _buildSectionHeader('Courses You May Like', onTap: () {
            // Handle "See more" action
          }),
          _buildTodaySessions(context),
          const SizedBox(height: 16),
          _buildSectionHeader('Categories', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoryListScreen(),
              ),
            );
          }),
          _buildCategories(context),
          const SizedBox(height: 16),
          _buildPaymentButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'See more',
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required Course course,
  }) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(course: course),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenSize.height * 0.1348,
              width: screenSize.width * 0.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  course.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Image not available'));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    course.instructorName,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorCard(
    BuildContext context, {
    required String name,
    required String email,
    required String courseCount,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1),
              child: Image.network(
                'https://th.bing.com/th/id/OIP.sBQJtDsY_UZgLVKFekPZAAHaK7?w=880&h=1298&rs=1&pid=ImgDetMain',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Image not available'));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Courses: $courseCount",
                  style: const TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 0, 138, 23)),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    children: <TextSpan>[
                      const TextSpan(text: 'Contact: '),
                      TextSpan(
                        text: email,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructors(BuildContext context) {
    if (widget.instructors.isEmpty) {
      return const Text('No instructors available now.');
    }

    final random = Random();
    final displayedInstructors =
        (widget.instructors.toList()..shuffle(random)).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ...displayedInstructors
            .map((instructor) => _buildInstructorCard(
                  context,
                  name: instructor['instructor'].fullName,
                  email: instructor['instructor'].email,
                  courseCount: instructor['courseCount'],
                ))
            .toList(),
      ],
    );
  }

  Widget _buildTodaySessions(BuildContext context) {
    if (widget.courses.isEmpty) {
      return const Text('No courses available now.');
    }

    final random = Random();
    final shuffledCourses = widget.courses.toList()..shuffle(random);
    final selectedCourses =
        shuffledCourses.take(2 + random.nextInt(2)).toList();

    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: selectedCourses.map((course) {
          return _buildCourseCard(
            context,
            course: course,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const Text('No categories available now.');
    }

    final random = Random();
    final shuffledCategories = widget.categories.toList()..shuffle(random);
    final selectedCategories =
        shuffledCategories.take((4 + random.nextInt(3))).toList();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: selectedCategories.map((category) {
        return CourseChip(
          label: category.name,
          backgroundColor: Colors.purple[100],
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CourseListScreen(category: category)),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/enrollment');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(
        'Proceed to Payment',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
