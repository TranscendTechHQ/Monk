import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/home_page.dart';
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
  Future<void> loginWithGoogle() async {
    GoogleSignIn googleSignIn;

    googleSignIn = GoogleSignIn(
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
          "thirdPartyId": "google",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Image.asset(
                "assets/signin_with_google_small.png",
                //width: 100,
              ),
              onPressed: () {
                loginWithGoogle();
              },
            ),
            // Slack login
            IconButton(
              onPressed: () async {
                // final result2 = await appAuth.authorizeAndExchangeCode(
                //   AuthorizationTokenRequest(
                //     '4287010774055.6810855127681',
                //     'https://a9ed-2405-201-6817-6087-20d9-7106-a3ac-f09d.ngrok-free.app/api/auth/calllback/slack',
                //     clientSecret: '34d290bec1981741d0f332d55e81c875',
                //     discoveryUrl:
                //         'https://slack.com/.well-known/openid-configuration',
                //     serviceConfiguration:
                //         const AuthorizationServiceConfiguration(
                //       authorizationEndpoint:
                //           "https://slack.com/openid/connect/authorize",
                //       tokenEndpoint:
                //           "https://slack.com/api/openid.connect.token",
                //       endSessionEndpoint:
                //           'https://oauth2.googleapis.com/revoke',
                //     ),
                //     scopes: ['openid', 'profile', 'email'],
                //   ),
                // );

                final result1 = await appAuth.authorizeAndExchangeCode(
                  AuthorizationTokenRequest(
                    '337392647778-3j84aqtmia13h4rnn76ud66q2aacjr56.apps.googleusercontent.com',
                    'app.heymonk:/oauthredirect',
                    serviceConfiguration:
                        const AuthorizationServiceConfiguration(
                      authorizationEndpoint:
                          'https://accounts.google.com/o/oauth2/v2/auth',
                      tokenEndpoint: 'https://oauth2.googleapis.com/token',
                      endSessionEndpoint:
                          'https://oauth2.googleapis.com/revoke',
                    ),
                    scopes: ['email', 'openid', 'profile'],
                  ),
                );
                // print(result1?.);
                var result = await NetworkManager.instance.client.post(
                  "/auth/signinup",
                  data: {
                    "thirdPartyId": "google",
                    "oAuthTokens": {
                      "access_token": result1?.accessToken,
                      "id_token": result1?.idToken
                    },
                  },
                  options: Options(
                    headers: {'rid': 'thirdpartypasswordless'},
                  ),
                );
                loader.hideLoader();
                if (result.statusCode == 200) {
                  Future.delayed(
                    Duration.zero,
                    () {
                      prefix.Navigator.of(context)
                          .pushReplacementNamed(HomePage.route);
                    },
                  );
                }
              },
              icon: const Icon(Icons.login),
            ),
          ],
        ),
      ),
    );
  }
}
