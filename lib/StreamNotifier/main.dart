import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy_riverpod/StreamNotifier/connectivity_plus_notifier.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectivity Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConnectivityPage(),
    );
  }
}

class ConnectivityPage extends ConsumerWidget {
  const ConnectivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityPlusNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ネットワーク接続状態'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final notifier = ref.read(
                connectivityPlusNotifierProvider.notifier,
              );
              final status = await notifier.checkConnectivity();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('現在の状態: ${_getStatusText(status)}')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ネットワーク状態表示
            switch (connectivityAsync) {
              AsyncData(:final value) => _buildNetworkStatusCard(
                context,
                value,
              ),
              AsyncError(:final error) => _buildErrorCard(context, error),
              _ => const CircularProgressIndicator(),
            },

            const SizedBox(height: 20),

            // オフライン時の警告表示
            switch (connectivityAsync) {
              AsyncData(:final value) when value == NetworkStatus.offline =>
                _buildOfflineWarning(context),
              _ => const SizedBox.shrink(),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkStatusCard(BuildContext context, NetworkStatus status) {
    final (icon, color, title, subtitle) = _getStatusInfo(status);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildStatusChips(status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChips(NetworkStatus status) {
    return Wrap(
      spacing: 8,
      children: [
        Chip(
          label: Text('オンライン: ${status.isOnline ? "はい" : "いいえ"}'),
          backgroundColor: status.isOnline
              ? Colors.green.shade100
              : Colors.red.shade100,
          avatar: Icon(
            status.isOnline ? Icons.check_circle : Icons.error,
            color: status.isOnline ? Colors.green : Colors.red,
            size: 18,
          ),
        ),
        if (status.isWifi)
          Chip(
            label: const Text('WiFi接続'),
            backgroundColor: Colors.blue.shade100,
            avatar: const Icon(Icons.wifi, color: Colors.blue, size: 18),
          ),
        if (status.isMobile)
          Chip(
            label: const Text('モバイルデータ'),
            backgroundColor: Colors.orange.shade100,
            avatar: const Icon(
              Icons.signal_cellular_alt,
              color: Colors.orange,
              size: 18,
            ),
          ),
      ],
    );
  }

  Widget _buildOfflineWarning(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'オフライン状態',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                Text(
                  'インターネット接続が利用できません。WiFiまたはモバイルデータ接続を確認してください。',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, Object error) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'エラーが発生しました',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, String, String) _getStatusInfo(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.wifiOnline:
        return (Icons.wifi, Colors.green, 'WiFi接続中', 'WiFiネットワークに接続されています');
      case NetworkStatus.mobileOnline:
        return (
          Icons.signal_cellular_alt,
          Colors.orange,
          'モバイルデータ接続中',
          'モバイルデータネットワークに接続されています',
        );
      case NetworkStatus.ethernetOnline:
        return (
          Icons.network_wifi,
          Colors.blue,
          'イーサネット接続中',
          '有線ネットワークに接続されています',
        );
      case NetworkStatus.otherOnline:
        return (
          Icons.network_check,
          Colors.purple,
          'その他のネットワーク接続中',
          '不明なタイプのネットワークに接続されています',
        );
      case NetworkStatus.offline:
        return (Icons.wifi_off, Colors.red, 'オフライン', 'インターネット接続がありません');
      case NetworkStatus.unknown:
        return (Icons.help_outline, Colors.grey, '不明', 'ネットワークの状態を確認できません');
    }
  }

  String _getStatusText(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.wifiOnline:
        return 'WiFi接続中';
      case NetworkStatus.mobileOnline:
        return 'モバイルデータ接続中';
      case NetworkStatus.ethernetOnline:
        return 'イーサネット接続中';
      case NetworkStatus.otherOnline:
        return 'その他のネットワーク接続中';
      case NetworkStatus.offline:
        return 'オフライン';
      case NetworkStatus.unknown:
        return '不明';
    }
  }
}
