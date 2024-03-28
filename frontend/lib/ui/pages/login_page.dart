import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:frontend/helper/constants.dart';
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
                /*final result1 = await appAuth.authorizeAndExchangeCode(
                  AuthorizationTokenRequest(
                    Constants.googleClientId,
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
                print(result1 != null ? result1.accessToken : "null");
                print(result1 != null ? result1.idToken : "null");
                print("here 2");*/
                final access_token =
                    "eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiaXNzIjoiaHR0cHM6Ly9kZXYtMTdzMGkwYXVrdnN0NHlpdi51cy5hdXRoMC5jb20vIn0..2OwQdG3lsMU11O_r.mgqUikmBj9LSCYKfb8esJxIp40SDsOJZrZkQr7byrhWybbIbtyQg5hGNdcMyMMjzYhJ5m1nJsh21FpZjUhqC_CGz3swje0ExClwmgu2qnp8O0Pw-W-5YKNHXzh2Orp9-KWspjnZJ3CnXxMdMQdPz7n6KmnzBx6tUVe2Px52SjFjzQ5uFxa-XQD2X42tzicGe3Ffr2SA_VcmE-LyhoQX1Go9S6Ue1A329gyVr2ZHbkw9unM9EJvhVf9bWOuSlNRIr3Nc-6uMz_3ufsxlFLYHPDo64oSVUGzSqGawLLTPPE0iFFL4c9KnfLHGlyYd9G273vmyhYcLvpVA6esAkK5hjfHY_UX9tEMxwgyrePQClvQWcaYuuhfySnOjATpG6wDyPY8zyug.7Y0UGYHRvyAqFZ66hBIZ_w";
                final id_token =
                    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjhySUNiWW1IT1laMHRfS3JsRTRhRCJ9.eyJuaWNrbmFtZSI6Inlrc29uaSIsIm5hbWUiOiJZb2dlc2ggc29uaSIsInBpY3R1cmUiOiJodHRwczovL3MuZ3JhdmF0YXIuY29tL2F2YXRhci82OWI2YmZlNzdmNTVjMjdjZDI3ZTIzZmM2YzAwMWVlOD9zPTQ4MCZyPXBnJmQ9aHR0cHMlM0ElMkYlMkZjZG4uYXV0aDAuY29tJTJGYXZhdGFycyUyRnlzLnBuZyIsInVwZGF0ZWRfYXQiOiIyMDI0LTAzLTI4VDAzOjM4OjE0LjkyNFoiLCJlbWFpbCI6Inlrc29uaUB0cmFuc2NlbmR0ZWNoLmlvIiwiaXNzIjoiaHR0cHM6Ly9kZXYtMTdzMGkwYXVrdnN0NHlpdi51cy5hdXRoMC5jb20vIiwiYXVkIjoiS2RyRlVpaVdJblpZOFBYbG5adzBkemJyeEs0c2p3cTYiLCJpYXQiOjE3MTE1OTcwOTYsImV4cCI6MTcxMTYzMzA5Niwic3ViIjoib2F1dGgyfHNpZ24taW4td2l0aC1zbGFja3xUMDQ4RjBBTlMxTS1VMDY2UTlKQVUzQiIsInNpZCI6InkxSXdOUjhQeXhtZEtCTmhjOGlhSUJBbjlCSzlVei1yIn0.L5hUWZa8XUCmVhxbZGzGNbPappWrJK0p9Rb00zeZwNcwa3PmTePlX3F5jBu6krgSAXVHhaiGlc63T6ltsqf3kwCFkd0IVT8djlndpkNsHzkM2HPOwHEHuaWJBxwDZXBIIAzTwUJ_K0E337ZOxeFyuHV0KFPVvZrG4nfGl13cxxq2_wEKe9BNMyNuacZLP3x5XHreTDHiyEd-chFR_vmjWeDtpUzCsztogRJBl0pRHfKCFWP7hj-zwoEnrqSScBDt3dFmGR4lLEd2Kaw3BuralcNVd2hdXBN7gg0LgChHULuV7M_THDaTKJnw0coLO1K_Lzj84Z9XaRzUw0olFCFOpw";
                var result = await NetworkManager.instance.client.post(
                  "/auth/signinup",
                  data: {
                    "thirdPartyId": "auth0",
                    "oAuthTokens": {
                      "access_token": access_token,
                      "id_token": id_token
                    },
                  },
                  /* options: Options(
                    headers: {'rid': 'thirdpartypasswordless'},
                  ),*/
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
