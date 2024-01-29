import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:frontend/repo/titles.dart';

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  return container;
}

void main() {
  group('Titles', () {
    final container = createContainer();
    final titlesNotifier = container.read(titlesProvider.notifier);
    test('should add a title to the state', () {
      expect(titlesNotifier.add('Title 1'), isTrue);
      expect(titlesNotifier.get(), contains('Title 1'));
    });

    test('should not add a duplicate title to the state', () {
      expect(titlesNotifier.add('Title 1'), isFalse);
      expect(titlesNotifier.get(), contains('Title 1'));
    });

    test('should return the list of titles', () {
      expect(titlesNotifier.get(), isA<List<String>>());
    });
    // When the test ends, dispose the container.
    test('tearing down the container', () {
      addTearDown(container.dispose);
    });
  });
}
