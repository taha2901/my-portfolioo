import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/admin/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyPortfolio());
}

class MyPortfolio extends StatefulWidget {
  const MyPortfolio({super.key});

  @override
  State<MyPortfolio> createState() => _MyPortfolioState();
}

class _MyPortfolioState extends State<MyPortfolio> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taha Hamada - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routes: {
        '/': (context) => HomeScreen(
              onThemeToggle: toggleTheme,
              isDark: _themeMode == ThemeMode.dark,
            ),
        '/admin-login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminGuard(),
      },
      initialRoute: '/',
    );
  }
}

class AdminGuard extends StatelessWidget {
  const AdminGuard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    if (auth.isLoggedIn) {
      // يتم استيراده من admin panel
      return const _AdminRedirect();
    }
    return const LoginScreen();
  }
}

class _AdminRedirect extends StatelessWidget {
  const _AdminRedirect();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/admin-login');
    });
    return const SizedBox();
  }
}