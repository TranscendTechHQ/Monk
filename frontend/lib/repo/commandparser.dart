import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repo/titles.dart';
part 'commandparser.g.dart';

enum Commands {
  journal('/new-journal'),
  thread('/new-thread'),
  plan('/new-plan'),
  news('/news'),
  report('/new-report'),
  project('/new-project'),
  task('/new-task'),
  note('/new-note'),
  idea('/new-idea'),
  event('/new-event'),
  blocker('/new-blocker'),
  think('/new-thought'),
  strategy('/new-strategy'),
  private('/new-private'),
  go('/go'),
  ;

  const Commands(this.name);

  final String name;
}

final List<String> commandList = Commands.values.map((e) => e.name).toList();

@riverpod
class CurrentCommand extends _$CurrentCommand {
  @override
  Commands build() => Commands.journal;
  void setCommand(Commands command) {
    state = command;
  }

  Commands get() => state;
}

class CommandParser {
  WidgetRef _ref;
  CommandParser(this._ref);

  String parseCommand(String commandString) {
    if (!commandString.startsWith('/')) {
      throw ArgumentError('Command should start with "/"');
    }

    var parts = commandString.split(' ');

    var command = parts[0];

    if (!commandList.contains(command)) {
      throw ArgumentError('Command not found');
    }

    return command;
  }

  String parseTitle(String commandString) {
    var parts = commandString.split(' ');
    if (parts.length > 2) {
      throw ArgumentError('Command should have at most one argument');
    }
    if (parts.length < 2) {
      throw ArgumentError('Command should have at least one argument');
    }

    var title = parts.length > 1 ? parts[1] : '';

    if (!isAlphanumeric(title)) {
      throw ArgumentError('Title should be alphanumeric');
    }

    if (!isUnique(title)) {
      throw ArgumentError('Title must be unique');
    }

    return title;
  }

  List<String> patternMatchingCommands(String pattern) {
    List<String> matchedPatterns = [];
    if (pattern.isEmpty) return matchedPatterns;
    var parts = pattern.split(' ');
    String commandPattern = parts[0];
    matchedPatterns = commandList.where((String option) {
      return option.contains(commandPattern.toLowerCase());
    }).toList();
    return matchedPatterns;
  }

  void validateCommand(String commandString) {
    try {
      String command = parseCommand(commandString);
      String title = parseTitle(commandString);
      _ref
          .read(currentCommandProvider.notifier)
          .setCommand(Commands.values[commandList.indexOf(command)]);
      _ref.read(titlesProvider.notifier).add(AlphaNumericTitle(title));
    } on ArgumentError {
      rethrow;
    }
  }

  bool isAlphanumeric(String argument) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(argument);
  }

  bool isUnique(String argument) {
    return !_ref.read(titlesProvider.notifier).get().contains(argument);
  }
}
