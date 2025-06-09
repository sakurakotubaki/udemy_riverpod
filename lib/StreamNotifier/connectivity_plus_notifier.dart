import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connectivity_plus_notifier.g.dart';

/// ネットワーク接続状態を表すenum
enum NetworkStatus {
  /// オンライン状態（WiFi接続）
  wifiOnline,

  /// オンライン状態（モバイルデータ接続）
  mobileOnline,

  /// オンライン状態（イーサネット接続）
  ethernetOnline,

  /// オンライン状態（その他の接続）
  otherOnline,

  /// オフライン状態
  offline,

  /// 不明な状態
  unknown;

  /// オンライン状態かどうかを判定
  bool get isOnline =>
      this != NetworkStatus.offline && this != NetworkStatus.unknown;

  /// WiFi接続かどうかを判定
  bool get isWifi => this == NetworkStatus.wifiOnline;

  /// モバイルデータ接続かどうかを判定
  bool get isMobile => this == NetworkStatus.mobileOnline;
}

/// ネットワーク接続状態を監視するStreamNotifier
@riverpod
class ConnectivityPlusNotifier extends _$ConnectivityPlusNotifier {
  @override
  Stream<NetworkStatus> build() {
    // 接続状態の変更を監視
    return Connectivity().onConnectivityChanged.map(
      _mapConnectivityToNetworkStatus,
    );
  }

  /// ConnectivityResultをNetworkStatusにマップ
  NetworkStatus _mapConnectivityToNetworkStatus(
    List<ConnectivityResult> results,
  ) {
    // 接続状態をrecordにまとめる
    final connectionInfo = (
      hasWifi: results.contains(ConnectivityResult.wifi),
      hasMobile: results.contains(ConnectivityResult.mobile),
      hasEthernet: results.contains(ConnectivityResult.ethernet),
      hasOther: results.any(
        (result) => ![
          ConnectivityResult.wifi,
          ConnectivityResult.mobile,
          ConnectivityResult.ethernet,
          ConnectivityResult.none,
        ].contains(result),
      ),
      hasNone: results.contains(ConnectivityResult.none),
      isEmpty: results.isEmpty,
    );

    // パターンマッチングで優先順位に基づいて状態を決定
    // オフライン状態をチェック
    if (connectionInfo.hasNone || connectionInfo.isEmpty) {
      return NetworkStatus.offline;
    }

    // 優先順位に基づいて接続タイプを決定
    return switch (true) {
      _ when connectionInfo.hasWifi => NetworkStatus.wifiOnline,
      _ when connectionInfo.hasMobile => NetworkStatus.mobileOnline,
      _ when connectionInfo.hasEthernet => NetworkStatus.ethernetOnline,
      _ when connectionInfo.hasOther => NetworkStatus.otherOnline,
      _ => NetworkStatus.unknown,
    };
  }

  /// 接続状態を手動でチェック
  Future<NetworkStatus> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return _mapConnectivityToNetworkStatus(connectivityResult);
  }
}
