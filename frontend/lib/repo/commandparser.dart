import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'commandparser.g.dart';

enum Commands {
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
  experiment('/new-experiment'),
  go('/go'),
  ;

  const Commands(this.name);

  final String name;
}

final List<String> commandList = Commands.values.map((e) => e.name).toList();

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
  CommandParser();

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

    if (!isUnique(title, titlesList)) {
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

  List<String> patternMatchingTitles(String pattern, List<String> titleList) {
    List<String> matchedPatterns = [];
    if (pattern.isEmpty) return matchedPatterns;
    var parts = pattern.split(' ');
    String titlePattern = parts[1];

    if (titlePattern.startsWith('#')) {
      String title = titlePattern.substring(1);
      matchedPatterns = titleList.where((String option) {
        return option.contains(title.toLowerCase());
      }).toList();
    }

    return matchedPatterns;
  }

  Map<String, String> validateCommand(
      String commandString, titlesList, commandHintTextNotifier) {
    try {
      String command = parseCommand(commandString);
      String title = parseTitle(commandString, titlesList);

      if (!isUnique(title, titlesList)) {
        throw ArgumentError('Title must be unique');
      } else {
        commandHintTextNotifier.set('Title added');
      }
      return {'command': command, 'title': title};
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
