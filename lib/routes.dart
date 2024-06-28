// routes.dart
import 'package:flutter/material.dart';
import 'screens/category_list_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/course_details_screen.dart';
import 'screens/enrollment_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/mentor_details_screen.dart';
import 'screens/mentor_list_screen.dart';
import 'screens/my_courses_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'widgets/splash_screen.dart';
import 'models/course.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
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
        final course = settings.arguments as Course;
        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(course: course),
        );
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
      case '/enrollment':
        return MaterialPageRoute(builder: (_) => EnrollmentScreen());
      case '/payment':
        final args = settings.arguments as Map<String, dynamic>;
        final subscriptionType = args['subscriptionType'] as String;
        final price = args['price'] as double;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            subscriptionType: subscriptionType,
            amount: price,
          ),
        );
      case '/payment-success':
        return MaterialPageRoute(builder: (_) => PaymentSuccessScreen());
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
