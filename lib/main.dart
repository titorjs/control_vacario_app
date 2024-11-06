import 'package:flutter/material.dart';
import './presentation/screens/login_screen.dart';
import 'presentation/screens/cow_screen.dart';
import 'presentation/screens/daily_production_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/remedios_screen.dart';
import 'presentation/screens/users_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Vacario App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/users': (context) => UsersScreen(),
        '/cows': (context) => CowsScreen(),
        '/daily_production': (context) => DailyProductionScreen(),
        '/remedies': (context) => RemediesScreen(),
      },
    );
  }
}