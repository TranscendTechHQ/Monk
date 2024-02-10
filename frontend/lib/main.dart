import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:frontend/repo/thread.dart';

import 'package:supertokens_flutter/supertokens.dart';
import 'constants.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/splash.dart';
import 'screens/thread.dart';

void main() {
  SuperTokens.init(apiDomain: apiDomain);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final commandList = ref.watch(fetchThreadTypesProvider);
    return MaterialApp(
      title: 'Monk',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorSchemeSeed: ColorSeed.baseColor.color,
        //colorSchemeSeed: Color.fromARGB(255, 40, 39, 43),
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomeScreen(),
        "/login": (context) => const LoginScreen(),
        "/journal": (context) =>
            ThreadScreen(title: "journal", type: "/new-thread"),
      },
    );
  }
}
