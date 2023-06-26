// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:my_film_list_flutter/screens/home_screen.dart';
import 'package:my_film_list_flutter/screens/login_screen.dart';
import 'package:my_film_list_flutter/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen()
      },
    );
  }
}