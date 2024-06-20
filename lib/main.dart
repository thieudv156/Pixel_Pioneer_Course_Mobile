// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/enrollment_provider.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EnrollmentProvider()),
      ],
      child: MaterialApp(
        title: 'Enrollment App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
