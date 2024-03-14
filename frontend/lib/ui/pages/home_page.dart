import 'package:flutter/material.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/news_page.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:supertokens_flutter/supertokens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userId = "";
  String email = "";
  String fullName = "";

  @override
  void initState() {
    super.initState();
    SuperTokens.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
    getAndSetUserInfo().then((value) => null);
  }

  Future<void> signOut() async {
    await SuperTokens.signOut();
    Future.delayed(Duration.zero, () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPage.route,
        (route) => false,
      );
    });
  }

  Future<bool> getAndSetUserInfo() async {
    final api = NetworkManager.instance.openApi.getSessionApi();

    final response = await api.secureApiSessioninfoGet();
    if (response.statusCode == 200) {
      final sessionInfo = response.data!;
      setState(() {
        fullName = sessionInfo.fullName;
        email = sessionInfo.email;
      });
      return true;
    }
    return false;
  }

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
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    /*final response = await threadApi.searchTitlesSearchTitlesGet(
        query: "thw thread with link to jira dataset");
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch matching threads");
    }
    final results = response.data!;
    print(results);
    final response = await threadApi.thThreadHeadlinesGet();
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch matching threads");
    }
    final results = response.data!;
    results.headlines.map((e) => print(e));*/
    final response = await threadApi.mdMetadataGet();
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch matching threads");
    }
    final results = response.data!;
    print(results);
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 240,
                height: 240,
              ),
              const SizedBox(width: 32),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    "Focus. Clarity Alignment",
                    style: context.textTheme.displayMedium!.copyWith(
                      color: context.customColors.sourceMonkBlue,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Welcome $fullName.",
                    style: Theme.of(context).textTheme.headlineLarge,
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
                    onPressed: () async {
                      // Navigator.pushNamed(context, ThreadPage.route);
                      Navigator.pushNamed(context, NewsPage.route);
                    },
                    child: Text(
                      "Continue",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextButton.icon(
                    onPressed: () {
                      signOut();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: context.customColors.sourceAlert,
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Log out',
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.customColors.sourceAlert,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
