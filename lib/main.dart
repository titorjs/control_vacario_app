import 'package:flutter/material.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/cow/cow_screen.dart';
//import 'presentation/screens/daily_production/daily_production_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/remedy/remedios_screen.dart';
import 'presentation/screens/user/users_screen.dart';
//import 'presentation/screens/total_production/total_production_screen.dart';
import 'presentation/screens/statistics/statistics_screend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Vacario App',
      debugShowCheckedModeBanner: false,
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
        //'/daily_production': (context) => DailyProductionScreen(),
        '/remedies': (context) => RemediesScreen(),
        //'/total_production': (context) => ProductionTotalScreen(),
        '/statistic': (context) => ProductionStatsScreen(),
      },
    );
  }
}