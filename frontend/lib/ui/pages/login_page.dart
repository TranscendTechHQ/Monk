import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix;
//import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/helper/monk-exception.dart';

import 'package:frontend/ui/pages/home_page.dart';
import 'package:frontend/ui/pages/news/news_page.dart';
import 'package:frontend/ui/pages/verify-orgnisation/verify_orgnization_page.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
//import 'package:flutter/services.dart';

//import 'package:google_sign_in/google_sign_in.dart';

/*import 'package:sign_in_with_apple/sign_in_with_apple.dart'
    hide AuthorizationRequest;*/
import '../../helper/network.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String route = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //late FlutterAppAuth appAuth;
  late Auth0 auth0;
  late Auth0Web auth0Web;

  @override
  void initState() {
    super.initState();
    //appAuth = const FlutterAppAuth();
    auth0 = Auth0(Constants.auth0Domain, Constants.auth0ClientId);
    auth0Web = Auth0Web(Constants.auth0Domain, Constants.auth0ClientId);
    if (kIsWeb) {
      auth0Web.onLoad().then(
            (final credentials) => setState(
              () {
                if (credentials != null) {
                  verifyCredentials(
                          credentials.accessToken, credentials.idToken)
                      .then((value) => null);
                }
              },
            ),
          );
    }
  }

/*
  Future<void> loginWithGoogle() async {
    GoogleSignIn googleSignIn;

    googleSignIn = GoogleSignIn(
      clientId: Constants.googleClientId,
      serverClientId: Constants.backendGoogleClientId,
      scopes: [
        'email',
      ],
    );

    if (googleSignIn.currentUser != null) {
      // This cleans up the current user from the google sign in package if there is any active user
      await googleSignIn.signOut();
    }

    try {
      loader.showLoader(context, message: "processing.");
      GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        logger.i("Google sign in was aborted");
        loader.hideLoader();
        return;
      }

      String? authCode = account.serverAuthCode;
      //print('authCode: $authCode');
      if (authCode == null) {
        logger.e("Google sign in did not return a server auth code");
        loader.hideLoader();
        return;
      }

      var result = await NetworkManager.instance.client.post(
        "/auth/signinup",
        data: {
          "thirdPartyId": "google_authcode",
          "redirectURIInfo": {
            "redirectURIOnProviderDashboard": "",
            "redirectURIQueryParams": {
              "code": authCode,
            },
          },
        },
      );
      loader.hideLoader();
      if (result.statusCode == 200) {
        Future.delayed(Duration.zero, () {
          // ...

          prefix.Navigator.of(context).pushReplacementNamed(HomePage.route);
        });
      }
    } on DioExceptionType {
      logger.e("Google sign in failed");
      loader.hideLoader();
    }
  }
*/
  Future<void> loginWithOauth() async {
    loader.showLoader(context, message: "processing.");
    // await logout();
    try {
      if (kIsWeb) {
        await auth0Web.loginWithRedirect(
            redirectUrl: kDebugMode
                ? 'http://localhost:3000'
                : 'https://web.heymonk.app/');

        return;
      } else {
        var credentials = await auth0
            .webAuthentication(scheme: Constants.auth0CustomScheme)
            // Use a Universal Link callback URL on iOS 17.4+ / macOS 14.4+
            // useHTTPS is ignored on Android
            .login(useHTTPS: true);
        loader.hideLoader();
        loader.showLoader(context, message: "processing.");
        // print(const JsonEncoder.withIndent(' ',).convert(credentials.toMap()));
        await verifyCredentials(credentials.accessToken, credentials.idToken);
      }
    } catch (e) {
      logger.e(e);
    } finally {
      loader.hideLoader();
    }
  }

/*
  // Login with Google using `FlutterAppAuth`
  Future<void> loginWithGoogleV2() async {
    loader.showLoader(context, message: "processing.");
    final result1 = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        Constants.googleClientId,
        'app.heymonk:/oauthredirect',
        serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint: 'https://accounts.google.com/o/oauth2/v2/auth',
          tokenEndpoint: 'https://oauth2.googleapis.com/token',
          endSessionEndpoint: 'https://oauth2.googleapis.com/revoke',
        ),
        scopes: ['email', 'openid', 'profile'],
      ),
    );
    print(result1 != null ? result1.accessToken : "null");
    print(result1 != null ? result1.idToken : "null");
    var result = await NetworkManager.instance.client.post(
      "/auth/signinup",
      data: {
        "thirdPartyId": "google",
        "oAuthTokens": {
          "access_token": result1?.accessToken,
          "id_token": result1?.idToken
        },
      },
    );
    loader.hideLoader();
    if (result.statusCode == 200) {
      Future.delayed(
        Duration.zero,
        () {
          prefix.Navigator.of(context).pushReplacementNamed(HomePage.route);
        },
      );
    }
  }

  // Login with Slack using `FlutterAppAuth`
  Future<void> loginWithSlack() async {
    final result2 = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        '4287010774055.6810855127681',
        'https://5ec3-2405-201-6817-6087-e9b2-4805-9e9e-c533.ngrok-free.app/api/auth/calllback/slack',
        serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint: "https://slack.com/openid/connect/authorize",
          tokenEndpoint: "https://slack.com/api/openid.connect.token",
          // endSessionEndpoint: 'https://slack.com/api/auth.revoke',
        ),
        scopes: ['openid', 'profile', 'email'],
        preferEphemeralSession: true,
      ),
    );
    loader.hideLoader();
    var result = await NetworkManager.instance.client.post(
      "/auth/signinup",
      data: {
        "thirdPartyId": "slack",
        "oAuthTokens": {
          "access_token": result2?.accessToken,
          "id_token": result2?.idToken
        },
      },
    );
    loader.hideLoader();
    if (result.statusCode == 200) {
      Future.delayed(
        Duration.zero,
        () {
          prefix.Navigator.of(context).pushReplacementNamed(HomePage.route);
        },
      );
    }
  }
*/
  Future<void> verifyCredentials(String? accessToken, String? idToken) async {
    if (idToken.isNullOrEmpty || accessToken.isNullOrEmpty) {
      logger.e('Access token or idToken is null. Can not proceed');
      return;
    }
    await NetworkManager.instance.client.get("/healthcheck");
    var result = await AsyncRequest.handle<Response<dynamic>>(
        () => NetworkManager.instance.client.post(
              "/auth/signinup",
              data: {
                "thirdPartyId": "auth0",
                "oAuthTokens": {
                  "access_token": accessToken,
                  "id_token": idToken
                },
              },
            ));
    result.fold((l) {
      logger.e('Failed to verify credentials', error: l.response?.data);
      throw Exception(l.message);
    }, (r) {
      final map = r.data as Map<String, dynamic>?;
      final userId = map?['user']?['thirdParty']?['userId'];

      // print(JsonEncoder.withIndent(' ').convert(map?['user']));

      // For slack authentication we don't need to verify the organization
      if (userId is String && userId.startsWith("oauth2|sign-in-with-slack")) {
        prefix.Navigator.of(context).pushReplacementNamed(HomePage.route);
      } else if (map?['status'] == "GENERAL_ERROR") {
        final message = map?['message'] ??
            'Unable to login this time. Please try again later.';
        logger.e(message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: context.customColors.sourceMonkBlue,
          ),
        );
      } else {
        logger.i(
            'Google sign in was successful. Verifying if user is a part of an client workspace.');
        final email = map?['user']?['email'];
        Navigator.of(context)
            .push(VerifyOrganization.launchRoute(email, onVerified: () {
          logger.i('✅ Verification success. Redirecting to news page');
          Navigator.pushNamed(context, NewsPage.route);
        }, onVerifyFailed: () {
          logger.i(
              '❌ Verification failed. Perhaps user is not affiliated with the client workspace.');
        }));
      }
    });
  }

  Widget wrapper(
      {required BuildContext context, required List<Widget> children}) {
    if (context.isTablet || context.isMobile) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: wrapper(
            context: context,
            children: [
              Image.asset(
                'assets/logo.png',
                width: context.scale(240, 200, 160),
                height: context.scale(240, 200, 160),
              ),
              const SizedBox(width: 100),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: context.isMobile || context.isTablet
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Welcome to Monk",
                    textAlign: TextAlign.center,
                    style: context.textTheme.displayMedium!
                        .copyWith(
                          color: context.customColors.sourceMonkBlue,
                          fontWeight: FontWeight.w400,
                        )
                        .scaleFont(
                          large: 32,
                          medium: 28,
                          small: 24,
                        ),
                  ),
                  const SizedBox(height: 62),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 68,
                        vertical: 18,
                      ),
                    ),
                    onPressed: () => loginWithOauth(),
                    child: Text(
                      "Login",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
