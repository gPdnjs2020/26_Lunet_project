import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'profile.dart';
import 'history.dart';
import 'setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => LumiereHomePage(),
        '/signup': (context) => const SignupPage(),
        '/profile': (context) => const ProfilePage(),
        '/history': (context) => const HistoryPage(),
        '/setting': (context) => const SettingPage(),
      },
    );
  }
}
