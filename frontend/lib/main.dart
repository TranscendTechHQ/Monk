import 'package:flutter/material.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'constants.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/splash.dart';

void main() {
  SuperTokens.init(apiDomain: apiDomain);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomeScreen(),
        "/login": (context) => const LoginScreen(),
      },
    );
  }
}
