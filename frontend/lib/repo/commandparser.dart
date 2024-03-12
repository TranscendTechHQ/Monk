import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'commandparser.g.dart';

@riverpod
class CommandHintText extends _$CommandHintText {
  @override
  String build() => 'press "/" for commands';
  void set(String text) {
    state = text;
  }

  String get() => state;
}

class CommandParser {
  CommandParser(this.commandList);
  List<String> commandList;

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

  String parseTitle(String commandString, titlesList) {
    var parts = commandString.split(' ');
    if (parts.length > 2) {
      throw ArgumentError('Command should have at most one argument');
    }
    if (parts.length < 2) {
      throw ArgumentError('Command should have at least one argument');
    }

    var title = parts.length > 1 ? parts[1] : '';

    if (!title.startsWith('#')) {
      throw ArgumentError('Title should start with "#"');
    }

    title = title.substring(1);

    if (!isAlphanumeric(title)) {
      throw ArgumentError('Title should be alphanumeric');
    }

    return title;
  }

  List<String> patternMatchingCommands(String pattern) {
    List<String> matchedPatterns = [];
    if (pattern.isEmpty) return matchedPatterns;
    var parts = pattern.split(' ');
    String commandPattern = parts[0];
    if (commandPattern.startsWith('/')) {
      commandPattern = commandPattern.substring(1);
    }
    matchedPatterns = commandList.where((String option) {
      return option.substring(1).contains(commandPattern.toLowerCase());
    }).toList();
    return matchedPatterns;
  }

  List<String> patternMatchingTitles(String pattern, List<String> titleList) {
    List<String> matchedPatterns = [];
    if (pattern.isEmpty) return matchedPatterns;
    var parts = pattern.split(' ');
    String titlePattern = parts[1];

    if (titlePattern.startsWith('#')) {
      String title = titlePattern.substring(1);
      matchedPatterns = titleList.where((String option) {
        return option.toLowerCase().contains(title.toLowerCase());
      }).toList();
    }

    return matchedPatterns;
  }

  Map<String, String> validateCommand(
      String commandString, titlesList, commandHintTextNotifier) {
    try {
      String command = parseCommand(commandString);
      String title = parseTitle(commandString, titlesList);

      if (command.startsWith('/new-')) {
        if (!isUnique(title, titlesList)) {
          throw ArgumentError('Title must be unique for creating new threads');
        } else {
          final threadType = command.substring(5);
          commandHintTextNotifier.set('New $threadType $title added');
        }
      } else if (command == '/go') {
        if (!titlesList.contains(title)) {
          throw ArgumentError(
              'Thread $title does not exist. Please create it first usng "/new-*" commands');
        }
        commandHintTextNotifier.set('Go to $title');
      }
      return {'type': command, 'title': title};
    } on ArgumentError {
      rethrow;
    }
  }

  bool isAlphanumeric(String argument) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(argument);
  }

  bool isUnique(String argument, List<String> titlesList) {
    return !titlesList.contains(argument);
  }
}
