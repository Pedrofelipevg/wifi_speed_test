import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/speed_test_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';
import 'views/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpeedTestViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wi-Fi Speed Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2A2A40),
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
