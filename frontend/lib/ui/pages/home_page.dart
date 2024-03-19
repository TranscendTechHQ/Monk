import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/news_page.dart';
import 'package:frontend/ui/pages/thread_page.dart';
import 'package:openapi/openapi.dart';
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
    /*final response = await threadApi.mdMetadataGet();
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch matching threads");
    }
    final results = response.data!;*/
    CreateChildThreadModel createChildThreadModel = CreateChildThreadModel(
      title: "myownchildthread",
      type: "/new-plan",
      parentBlockId: "b342a310-cd4e-444e-8f0f-8e511d908b7f",
      parentThreadId: "713059f7-b4ca-49ed-a35c-d28e6569da81",
    );
    await threadApi.childThreadBlocksChildPost(
        createChildThreadModel: createChildThreadModel);
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Hello, ",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                    text: fullName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Text(
              'Welcome to Monk!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.tertiaryContainer),
              ),
              onPressed: () async {
                // Navigator.pushNamed(context, ThreadPage.route);
                //testOpenApi();
                Navigator.pushNamed(context, NewsPage.route);
              },
              child: Text(
                "Go to News",
                style: Theme.of(context).textTheme.labelSmall,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Tooltip(
                      message: "Sign Out",
                      child: InkWell(
                        onTap: () {
                          signOut();
                        },
                        child: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.onError,
                          size: 18,
                        ),
                      )),
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
