import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'constants.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/splash.dart';

void main() {
  SuperTokens.init(apiDomain: apiDomain);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monk',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorSchemeSeed: ColorSeed.baseColor.color,
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomeScreen(),
        "/login": (context) => const LoginScreen(),
      },
    );
  }
}
