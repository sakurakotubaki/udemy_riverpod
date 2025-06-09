// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketStreamHash() => r'0cb45c13aa135477e874fae783737cc8a4391d8a';

/// [webSocketStreamProvider]は、WebSocketからのメッセージを非同期で取得するためのプロバイダーです。/// このプロバイダーは、WebSocketの接続を管理し、メッセージのストリームを提供します。
/// - WebSocketの接続先は`wss://echo.websocket.events`です。
/// - プロバイダーは、WebSocketのストリームを返します。
/// - プロバイダーが破棄されるときにWebSocketを閉じるために、`ref.onDispose`を使用しています。
/// - WebSocketからのメッセージは、`String`型としてキャストされます。
///
/// Copied from [webSocketStream].
@ProviderFor(webSocketStream)
final webSocketStreamProvider = AutoDisposeStreamProvider<String>.internal(
  webSocketStream,
  name: r'webSocketStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$webSocketStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WebSocketStreamRef = AutoDisposeStreamProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
