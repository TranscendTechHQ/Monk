import 'package:flutter/material.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecorations.pageDecoration(),
          width: context.width,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: containerWidth,
              minWidth: 420,
            ),
            alignment: Alignment.center,
            child: body,
          ),
        ),
      ),
    );
  }
}

class WithMonkAppbar extends StatelessWidget {
  const WithMonkAppbar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/monk-small-logo.png',
                  width: 40,
                  height: 40,
                  cacheWidth: 50,
                  cacheHeight: 50,
                ),
                const SizedBox(width: 16),
                Text(
                  'MONK',
                  style: TextStyle(
                    fontSize: 28,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
