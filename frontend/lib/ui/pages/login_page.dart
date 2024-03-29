import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/home_page.dart';
import 'package:frontend/ui/theme/theme.dart';
//import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';
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
  FlutterAppAuth appAuth = FlutterAppAuth();
  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0(Constants.AUTH0_DOMAIN, Constants.AUTH0_CLIENT_ID);
  }

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

  Future<void> loginWithOauth() async {
    loader.showLoader(context, message: "processing.");
    // await logout();
    try {
      var credentials = await auth0
          .webAuthentication(scheme: Constants.AUTH0_CUSTOM_SCHEME)
          // Use a Universal Link callback URL on iOS 17.4+ / macOS 14.4+
          // useHTTPS is ignored on Android
          .login(useHTTPS: true);
      loader.hideLoader();
      loader.showLoader(context, message: "processing.");
      var result = await NetworkManager.instance.client.post(
        "/auth/signinup",
        data: {
          "thirdPartyId": "auth0",
          "oAuthTokens": {
            "access_token": credentials.accessToken,
            "id_token": credentials.idToken
          },
        },
      );
      if (result.statusCode == 200) {
        Future.delayed(
          Duration.zero,
          () {
            prefix.Navigator.of(context).pushReplacementNamed(HomePage.route);
          },
        );
      }
    } catch (e) {
      print(e);
    } finally {
      loader.hideLoader();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: Image.asset(
            //     "assets/signin_with_google_small.png",
            //     //width: 100,
            //   ),
            //   onPressed: () {
            //     loginWithGoogle();
            //   },
            // ),
            FilledButton.tonal(
              onPressed: () async => loginWithOauth(),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              )),
              child: Text(
                'Login with Auth0',
                style: context.textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
