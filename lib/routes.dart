import 'package:course_template/screens/category_list_screen.dart';
import 'package:course_template/screens/change_password_screen.dart';
import 'package:course_template/screens/home_screen.dart';
import 'package:course_template/screens/login_screen.dart';
import 'package:course_template/screens/signup_screen.dart';
import 'package:course_template/screens/mentor_list_screen.dart';
import 'package:course_template/screens/mentor_details_screen.dart';
import 'package:course_template/screens/course_details_screen.dart';
import 'package:course_template/screens/payment_screen.dart';
import 'package:course_template/screens/chat_screen.dart';
import 'package:course_template/screens/settings_screen.dart';
import 'package:course_template/screens/my_courses_screen.dart';
import 'package:course_template/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/change-password':
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());
      case '/mentor-list':
        return MaterialPageRoute(builder: (_) => const MentorListScreen());
      case '/mentor-details':
        return MaterialPageRoute(
            builder: (_) => const MentorDetailsScreen(
                  mentorName: '',
                ));
      case '/course-details':
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(courseName: args['courseName']!),
        );
      case '/payment':
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/my-courses':
        return MaterialPageRoute(builder: (_) => const MyCoursesScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoryListScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
