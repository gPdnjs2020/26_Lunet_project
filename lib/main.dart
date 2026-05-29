import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/home/home.dart';
import 'pages/auth/login.dart';
import 'pages/auth/signup.dart';
import 'pages/profile/profile.dart';
import 'pages/history/history.dart';
import 'pages/profile/setting.dart';
import 'pages/profile/security.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        '/security': (context) => const SecurityPage(),
      },
    );
  }
}
