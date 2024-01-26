import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/titles.dart';
import 'package:frontend/screens/commandbox.dart';

class CommandParamScreen extends ConsumerWidget {
  const CommandParamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final command = ref.watch(currentCommandProvider);
    return Scaffold(
        body: Center(
            child: Row(
      children: [
        Text(command.name + '  '),
        TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a valid title';
              }
              return null;
            },
            onSaved: (value) {
              ref.read(titlesProvider.notifier).add(AlphaNumericTitle(value!));
            },
            decoration: const InputDecoration(
              labelText: 'EnterASingleWordAlphaNumericTitleHere',
              border: OutlineInputBorder(),
            )),
      ],
    )));
  }
}
