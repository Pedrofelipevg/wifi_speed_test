import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/speed_test_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';
import 'views/home_screen.dart';
import 'views/terms_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final StorageService storageService = StorageService();
  final bool termsAccepted = await storageService.getTermsAccepted();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpeedTestViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
      ],
      child: MyApp(termsAccepted: termsAccepted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool termsAccepted;
  const MyApp({super.key, required this.termsAccepted});

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
      home: termsAccepted ? const HomeScreen() : const TermsScreen(),
    );
  }
}
