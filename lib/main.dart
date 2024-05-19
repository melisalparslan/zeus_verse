import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'create_story_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'register_screen.dart';
import 'story_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/auth': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/story': (context) => const StoryDetailScreen(
              title: '',
              imagePath: '',
              content: '',
              author: '',
              subject: '',
            ),
        '/createStory': (context) =>
            const CreateStoryScreen(), // Yeni rotayı ekliyoruz
      },
    );
  }
}
