import 'package:flutter/material.dart';
import 'package:meal_back/theme.dart';
import 'package:meal_back/services/auth_service.dart';
import 'package:meal_back/services/storage_service.dart';
import 'package:meal_back/screens/login_screen.dart';
import 'package:meal_back/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.init();
  await StorageService.initializeSampleData();
  await AuthService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassMate - Avaliação de Merenda Escolar',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: AuthService.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
