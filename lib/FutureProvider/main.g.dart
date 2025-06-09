// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesAsyncHash() =>
    r'0b8f456e6d16373846c3e6aec30e77542f310b3f';

/// See also [sharedPreferencesAsync].
@ProviderFor(sharedPreferencesAsync)
final sharedPreferencesAsyncProvider =
    AutoDisposeFutureProvider<SharedPreferencesAsync>.internal(
      sharedPreferencesAsync,
      name: r'sharedPreferencesAsyncProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sharedPreferencesAsyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesAsyncRef =
    AutoDisposeFutureProviderRef<SharedPreferencesAsync>;
String _$tutorialStateHash() => r'c717bce4e0ce77b9874f175c7fe7c9707ae69fa5';

/// [TutorialStateProvider]は、アプリのチュートリアルの状態を非同期で取得するためのプロバイダーです。
/// このプロバイダーは、SharedPreferencesを使用して、ユーザーがアプリを初めて起動したかどうかを判定します。
/// - 初回起動時は`TutorialState.first`を返し、チュートリアルを表示します。
/// - 2回目以降の起動時は`TutorialState.second`を返し、チュートリアルを表示しません。
///
/// Copied from [tutorialState].
@ProviderFor(tutorialState)
final tutorialStateProvider = AutoDisposeFutureProvider<TutorialState>.internal(
  tutorialState,
  name: r'tutorialStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tutorialStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TutorialStateRef = AutoDisposeFutureProviderRef<TutorialState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
