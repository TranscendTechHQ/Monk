import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/news_page.dart';
import 'package:frontend/ui/pages/splash_page.dart';
import 'package:frontend/ui/pages/thread_page.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/home_page.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'helper/constants.dart';
import 'ui/theme/color/color_schemes.g.dart';

void main() {
  SuperTokens.init(apiDomain: apiDomain);
  runApp(
    const ProviderScope(child: MonkApp()),
  );
}

class MonkApp extends ConsumerWidget {
  const MonkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ;
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // ColorScheme lightScheme;
        // ColorScheme darkScheme;

        // if (lightDynamic != null && darkDynamic != null) {
        //   lightScheme = lightDynamic.harmonized();
        //   lightCustomColors = lightCustomColors.harmonized(lightScheme);

        //   // Repeat for the dark color scheme.
        //   darkScheme = darkDynamic.harmonized();
        //   darkCustomColors = darkCustomColors.harmonized(darkScheme);
        // } else {
        //   // Otherwise, use fallback schemes.
        //   lightScheme = lightColorScheme;
        //   darkScheme = darkColorScheme;
        // }

        return MaterialApp(
          title: Constants.appName,
          onGenerateTitle: (BuildContext context) => Constants.appName,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: AppTheme.lightTheme(lightColorScheme),
          darkTheme: AppTheme.darkTheme(darkColorScheme),
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
