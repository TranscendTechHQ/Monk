import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/widgets/user-mention/users.provider.dart';
import 'package:openapi/openapi.dart';
import 'package:zefyr/zefyr.dart';

class ZefyrRichEditor extends ConsumerWidget {
  const ZefyrRichEditor(
      {super.key,
      this.focusNode,
      required this.controller,
      required this.filteredUsersNotifier});
  final FocusNode? focusNode;
  final ZefyrController controller;
  final FilteredUser filteredUsersNotifier;

  // @override
  // void initState() {
  //   controller.addListener(mentionUser);
  //   ref.read(usersProvider);
  //   super.initState();
  // }

  void mentionUser(List<UserModel>? allUsers, WidgetRef ref) {
    if (allUsers == null) {
      return;
    }
    final value = controller.document.toPlainText();
    final provider = ref.read(filteredUserProvider.notifier);
    if (value.isNotEmpty) {
      List<String> words = value.split(' ');

      if (words.last.contains('@')) {
        // final list = ref.read(usersProvider).value ?? [];
        final name = words.last.split('@')[1].trim();
        if (name.isEmpty) {
          return;
        }
        final filteredUsers = allUsers
            .where(
                (user) => user.name!.toLowerCase().contains(name.toLowerCase()))
            .toList();

        if (filteredUsers.isNotEmpty) {
          provider.updateValue(filteredUsers);
          return;
        }
      }
      if (provider.state.value!.isNotEmpty) {
        provider.updateValue([]);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allUsers = ref.watch(usersProvider);
    // final filteredProvider = filteredUserProvider([]);
    // var filteredUsers = ref.watch(filteredProvider);

    controller.addListener(() => mentionUser(allUsers.value, ref));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ZefyrToolbar.basic(
          controller: controller,
          hideHorizontalRule: true,
          hideStrikeThrough: true,
          hideUnderLineButton: true,
        ),
        ZefyrEditor(
          controller: controller,
          autofocus: true,
          maxHeight: 200,
          minHeight: 100,
          showCursor: true,
          focusNode: focusNode,
        ),
      ],
    );
  }
}
