import 'package:flutter/material.dart';
import 'package:supertokens_flutter/supertokens.dart';
import '../network.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = "";

  @override
  void initState() {
    super.initState();
    SuperTokens.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  Future<void> signOut() async {
    await SuperTokens.signOut();
    Future.delayed(Duration.zero, () {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    });
  }

  // get user name
  Future<String> getUserId() async {
    return await SuperTokens.getUserId();
  }

  // refresh session
  Future<void> manualRefresh() async {
    // Returns true if session was refreshed, false if session is expired
    var success = await SuperTokens.attemptRefreshingSession();
  }

  Future<void> testOpenApi() async {
    //final api = Openapi().getPetApi();
//    final taskApi = NetworkManager.instance.openApi.getTasksApi();

    ;
  }

  Widget renderContent() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
      ),
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 16,
        ),
        width: double.infinity,
        // clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Center(
                  child: Text(
                "Login successful",
                style: Theme.of(context).textTheme.headlineSmall,
              )),
            ), // this is login successful box
            const Padding(
              padding: EdgeInsets.only(
                top: 24.0,
              ),
              child: Center(
                child: Text("Your userID is:"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                ),
                child: Text(userId),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.tertiaryContainer),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/journal");
                },
                child: Text(
                  "Go to Journal",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.tertiaryContainer),
                  ),
                  onPressed: () async {
                    await signOut();
                  },
                  child: Text(
                    "Sign Out",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
              renderContent(),
            ],
          ),
        ),
      ),
    );
  }
}
