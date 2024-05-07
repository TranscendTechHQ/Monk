import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/repo/auth/auth_provider.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/news/news_page.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:openapi/openapi.dart';
import 'package:supertokens_flutter/supertokens.dart';

import 'subscribed-channels/channels_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static String route = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    
    CreateChildThreadModel createChildThreadModel = CreateChildThreadModel(
      title: "myownchildthread",
      type: "chat",
      parentBlockId: "a73a294e-367a-437d-b71e-e53f7058b49f",
      mainThreadId: "b110eabb-62e6-4f7d-bafa-fe4ce5cb4f54",
    );
    await threadApi.childThreadBlocksChildPost(
        createChildThreadModel: createChildThreadModel);
    final response = await threadApi.getThreadIdThreadsIdGet(
        id: "2bcad996-8391-4ddf-a274-bf84d6904906");*/
/*
    UpdateBlockModel block = UpdateBlockModel(
      content: "Ding dong, o baby sing a song",
    );
    final response = await threadApi.updateBlocksIdPut(
        id: "8a7708a0-8598-4133-9b28-b0ad7c65652b",
        threadTitle: "ding",
        updateBlockModel: block);

    await threadApi.updateThThreadsIdPut(
        id: "56007383-3f47-4d82-9fc1-0da3510b2da8",
        updateThreadTitleModel: UpdateThreadTitleModel(title: "dong"));
*/
    await threadApi.createTfThreadFlagPost(
        createUserThreadFlagModel: CreateUserThreadFlagModel(
            threadId: "7ffefd35-2286-4377-ae4d-02bcfe9b121a",
            upvote: null,
            bookmark: null,
            read: true));
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

  // Future<bool> getAndSetUserInfo() async {
  //   final api = NetworkManager.instance.openApi.getSessionApi();

  //   final response = await api.secureApiSessioninfoGet();
  //   if (response.statusCode == 200) {
  //     final sessionInfo = response.data!;
  //     setState(() {
  //       fullName = sessionInfo.fullName;
  //       email = sessionInfo.email;
  //       // print(JsonEncoder.withIndent(' ').convert(sessionInfo.toJson()));
  //     });
  //     return true;
  //   }
  //   return false;
  // }

  Future<String> getUserId() async {
    return await SuperTokens.getUserId();
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
    final authState = ref.watch(authProvider);

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
              if (authState.value is AsyncLoading) ...[
                const SizedBox(height: 100),
                const CircularProgressIndicator.adaptive()
              ] else if (authState.value?.session != null)
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
                      "Focus. Clarity. Alignment.",
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
                    const SizedBox(height: 18),
                    Text(
                      "Welcome ${authState.value?.session?.fullName}.",
                      textAlign: TextAlign.center,
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
                        //testOpenApi();

                        // Navigator.pushNamed(context, ThreadPage.route);
                        /* Navigator.push(
                          context,
                          SubscribedChannelsPage.launchRoute(
                            ifAlreadySubscribed: () =>
                                Navigator.pushReplacementNamed(
                              context,
                              NewsPage.route,
                            ),
                          ),
                        );
                        */
                        Navigator.pushReplacementNamed(context, NewsPage.route);
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
