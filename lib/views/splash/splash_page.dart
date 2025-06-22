import 'package:flutter/material.dart';
import 'package:sisfo_sarpras_revisi/services/auth_service.dart';
import 'package:sisfo_sarpras_revisi/views/auth/login_page.dart';
import 'package:sisfo_sarpras_revisi/views/main_wrapper.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // efek delay splash
    final isLoggedIn = await AuthService().isLoggedIn();

    if (context.mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainWrapper()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Sisfo Sarpras',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Sistem Informasi Sarana & Prasarana',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
