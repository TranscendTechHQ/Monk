class CommandParser {
  List<String> arguments;

  CommandParser(this.arguments);

  String parseCommand(String command) {
    if (!command.startsWith('/')) {
      throw ArgumentError('Command should start with /');
    }

    command = command.substring(1);
    var parts = command.split(' ');

    if (parts.isEmpty) {
      throw ArgumentError('command cannot be empty');
    }

    var action = parts[0];
    var argument = parts.length > 1 ? parts[1] : '';

    if (action.isEmpty) {
      throw ArgumentError('Command cannot be empty');
    }

    if (!isAlphanumeric(argument)) {
      throw ArgumentError('Command should be alphanumeric');
    }

    if (!isUnique(argument)) {
      throw ArgumentError('Argument must be unique');
    }

    return argument;
  }

  bool isAlphanumeric(String argument) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(argument);
  }

  bool isUnique(String argument) {
    return !arguments.contains(argument);
  }
}
