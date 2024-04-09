import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/news_page.dart';
import 'package:frontend/ui/pages/verify-orgnisation/provider/verify_orgnization_provider.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:supertokens_flutter/supertokens.dart';

class VerifyOrganization extends ConsumerWidget {
  const VerifyOrganization({super.key});

  static String route = "/verify-organization";
  static Route launchRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const VerifyOrganization(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = verifyOrganizationProvider(teamId: '');
    final verifyOrganization = ref.watch(provider);

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

    ref.listen(provider, (previous, next) {
      if (next is AsyncData) {
        final data = next.value;
        if (data != null && data) {
          Navigator.pushNamed(context, NewsPage.route);
        }
      }
    });
    return Scaffold(
      body: Center(
        child: verifyOrganization.maybeWhen(
          orElse: () {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: context.scale(140),
                  height: context.scale(140),
                ),
                const SizedBox(height: 32),
                Text('Verifying workspace',
                    style: context.textTheme.headlineSmall),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            );
          },
          data: (value) {
            if (value) {
              return const Text('Organization verified');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/logo.png',
                    width: context.scale(140),
                    height: context.scale(140),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Monk app is not installed',
                    style: context.textTheme.headlineSmall),
                const SizedBox(height: 16),
                Text(
                  'Please contact your workspace admin and ask him to install Monk app.',
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ).p16,
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
            );
          },
          error: (error, stackTrace) {
            return const Text('Error verifying organization');
          },
        ),
      ),
    );
  }
}
