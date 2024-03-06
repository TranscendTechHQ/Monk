import 'package:flutter/widgets.dart' as prefix;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
//import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';
/*import 'package:sign_in_with_apple/sign_in_with_apple.dart'
    hide AuthorizationRequest;*/
import '../network.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        print("Google sign in was aborted");
        return;
      }

      String? authCode = account.serverAuthCode;

      if (authCode == null) {
        print("Google sign in did not return a server auth code");
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

      if (result.statusCode == 200) {
        Future.delayed(Duration.zero, () {
          // ...

          prefix.Navigator.of(context).pushReplacementNamed("/home");
        });
      }
    } on DioExceptionType {
      print("Google sign in failed");
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
          ],
        ),
      ),
    );
  }
}
