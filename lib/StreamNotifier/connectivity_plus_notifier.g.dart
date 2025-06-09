// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_plus_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityPlusNotifierHash() =>
    r'cc4cf07967b2f057c02b16a589b0bd94ec302a85';

/// ネットワーク接続状態を監視するStreamNotifier
///
/// Copied from [ConnectivityPlusNotifier].
@ProviderFor(ConnectivityPlusNotifier)
final connectivityPlusNotifierProvider =
    AutoDisposeStreamNotifierProvider<
      ConnectivityPlusNotifier,
      NetworkStatus
    >.internal(
      ConnectivityPlusNotifier.new,
      name: r'connectivityPlusNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectivityPlusNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConnectivityPlusNotifier = AutoDisposeStreamNotifier<NetworkStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
