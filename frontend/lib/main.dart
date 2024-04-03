import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/home_page.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/news_page.dart';
import 'package:frontend/ui/pages/splash_page.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/theme_builder_app.dart';
import 'package:frontend/ui/widgets/kit/overlay_loader.dart';
import 'package:logger/logger.dart';
import 'package:supertokens_flutter/supertokens.dart';

import 'helper/constants.dart';

final logger = Logger();
final loader = LoaderService.instance;
void main() async {
  SuperTokens.init(apiDomain: apiDomain);
  runApp(
    const ProviderScope(child: MonkApp()),
  );
}

class MonkApp extends ConsumerWidget {
  const MonkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeBuilderApp(
      builder: (context, darkTheme, lightTheme) {
        return MaterialApp(
          title: Constants.appName,
          onGenerateTitle: (BuildContext context) => Constants.appName,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,
          initialRoute: '/',
          routes: {
            "/": (context) => const SplashPage(),
            HomePage.route: (context) => const HomePage(),
            LoginPage.route: (context) => const LoginPage(),
            ThreadPage.route: (context) =>
                const ThreadPage(title: "journal", type: "/new-thread"),
            NewsPage.route: (context) =>
                const NewsPage(title: "journal", type: "/new-thread"),
          },
        );
      },
    );
  }
}
