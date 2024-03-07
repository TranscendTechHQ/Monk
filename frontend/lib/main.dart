import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/splash_page.dart';
import 'package:frontend/ui/pages/thread_page.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/home_page.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'helper/constants.dart';

void main() {
  SuperTokens.init(apiDomain: apiDomain);
  runApp(const ProviderScope(child: MonkApp()));
}

class MonkApp extends ConsumerWidget {
  const MonkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Monk',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        "/": (context) => const SplashPage(),
        HomePage.route: (context) => const HomePage(),
        LoginPage.route: (context) => const LoginPage(),
        ThreadPage.route: (context) =>
            const ThreadPage(title: "journal", type: "/new-thread"),
      },
    );
  }
}
