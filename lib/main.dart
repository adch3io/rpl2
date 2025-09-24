import 'package:flutter/material.dart';

import 'edit_profile_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'notification_page.dart';

void main() {
  runApp(const ElearningApp());
}

class ElearningApp extends StatelessWidget {
  const ElearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Learning',
      // theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/edit': (context) => const EditProfilePage(),
        '/notification': (context) => const NotificationPage(),
      },
    );
  }
}
