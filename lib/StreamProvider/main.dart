import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'main.g.dart';

/// [webSocketStreamProvider]は、WebSocketからのメッセージを非同期で取得するためのプロバイダーです。/// このプロバイダーは、WebSocketの接続を管理し、メッセージのストリームを提供します。
/// - WebSocketの接続先は`wss://echo.websocket.events`です。
/// - プロバイダーは、WebSocketのストリームを返します。
/// - プロバイダーが破棄されるときにWebSocketを閉じるために、`ref.onDispose`を使用しています。
/// - WebSocketからのメッセージは、`String`型としてキャストされます。
@riverpod
Stream<String> webSocketStream(Ref ref) {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  /// [ref.onDispose]を使用して、プロバイダーが破棄されるときにWebSocketを閉じる
  /// これにより、WebSocketの接続が不要になったときにリソースを解放できます。
  ref.onDispose(() {
    channel.sink.close();
  });

  return channel.stream.cast<String>();
}

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

// List<Map<String, dynamic>>だと長いと思い、エイリアスを定義
typedef ListMapStringDynamic = List<Map<String, dynamic>>;

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  // 通常は、Map<String, dynamic>を使用
  // final List<Map<String, dynamic>> _messages = [];
  // tyepdefで定義したエイリアスを使用
  final ListMapStringDynamic _messages = [];
  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  void _initWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.events'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final webSocketStream = ref.watch(webSocketStreamProvider);

    // WebSocketからのメッセージを監視
    ref.listen<AsyncValue<String>>(webSocketStreamProvider, (previous, next) {
      if (next is AsyncData<String>) {
        setState(() {
          _messages.add({
            'text': next.value,
            'isMe': false,
            'time': DateTime.now(),
          });
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06C755),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _reconnect,
            tooltip: '再接続',
          ),
        ],
      ),
      body: Stack(
        children: [
          // メッセージ表示エリア
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 80,
            child: switch (webSocketStream) {
              AsyncData() => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['isMe'] as bool;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isMe) ...[
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFF06C755),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFF06C755)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              message['text'] as String,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              AsyncError(:final error) => Center(child: Text('Error: $error')),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
          // 入力エリア
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'メッセージを入力',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF06C755),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final messageText = _controller.text;

      // 自分のメッセージを追加
      setState(() {
        _messages.add({
          'text': messageText,
          'isMe': true,
          'time': DateTime.now(),
        });
      });

      // WebSocketを通してメッセージを送信
      _channel?.sink.add(messageText);

      _controller.clear();
    }
  }

  void _reconnect() {
    // メッセージをクリア
    setState(() {
      _messages.clear();
    });

    // 新しいページに遷移して再接続
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: widget.title)),
    );
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
