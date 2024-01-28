import 'package:frontend/screens/commandbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'titles.g.dart';

class AlphaNumericTitle {
  final String _value;

  AlphaNumericTitle(String value)
      : assert(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)),
        _value = value;

  static bool checkAlphaNumeric(String value) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }

  String get value => _value;
}

@riverpod
class Titles extends _$Titles {
  @override
  List<AlphaNumericTitle> build() => [];

  bool add(AlphaNumericTitle title) {
    if (state.contains(title)) {
      return false;
    }
    state = [...state, title];
    return true;
  }

  List<AlphaNumericTitle> get() => state;
}
