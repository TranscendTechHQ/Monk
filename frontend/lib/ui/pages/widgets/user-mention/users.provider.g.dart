// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usersHash() => r'1a46c70da0379c1f34c28d362b26dc7ac5dd5f26';

/// See also [Users].
@ProviderFor(Users)
final usersProvider =
    AutoDisposeAsyncNotifierProvider<Users, List<UserModel>>.internal(
  Users.new,
  name: r'usersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Users = AutoDisposeAsyncNotifier<List<UserModel>>;
String _$filteredUserHash() => r'329cec5c2fa4d1985609d892d6a7cb37195803d9';

/// See also [FilteredUser].
@ProviderFor(FilteredUser)
final filteredUserProvider =
    AutoDisposeAsyncNotifierProvider<FilteredUser, List<UserModel>>.internal(
  FilteredUser.new,
  name: r'filteredUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filteredUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilteredUser = AutoDisposeAsyncNotifier<List<UserModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
