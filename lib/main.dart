import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'edit_profile_page.dart';
import 'forgot_password_page.dart';
import 'notification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/edit': (context) => const EditProfilePage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/notification': (context) => const NotificationPage(),
      },
    );
  }
}
