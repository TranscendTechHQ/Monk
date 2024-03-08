import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/home_page.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:supertokens_flutter/supertokens.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void checkForAuthAndNavigate() {
    SuperTokens.doesSessionExist().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(
          context,
          HomePage.route,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          LoginPage.route,
        );
      }
    });
  }

  @override
  void initState() {
    checkForAuthAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome to Monk!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
