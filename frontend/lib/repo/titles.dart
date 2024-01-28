import 'package:frontend/screens/commandbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'titles.g.dart';

@riverpod
class Titles extends _$Titles {
  @override
  List<String> build() => [];

  bool add(String title) {
    if (state.contains(title)) {
      return false;
    }
    state = [...state, title];
    return true;
  }

  List<String> get() => state;
}
