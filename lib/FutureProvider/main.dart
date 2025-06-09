import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
part 'main.g.dart';

/// [TutorialState]は、アプリのチュートリアルの状態を管理するための列挙型です。
/// - `first`: 初回起動時のチュートリアルを表示する状態
/// - `second`: 2回目以降の起動時にチュートリアルを表示しない状態
/// この状態を使用して、ユーザーがアプリを初めて起動したときにのみチュートリアルを表示することができます。
/// チュートリアルの状態は、SharedPreferencesを使用して永続化されます。
enum TutorialState { first, second }

/*
バージョン2.3.0以降、このパッケージで使用可能なAPIは3つあります。
[SharedPreferences]はレガシーなAPIで、将来的に非推奨となる予定です。
プラグインを新規に使用する場合は、より新しい[SharedPreferencesAsync]または
[SharedPreferencesWithCache]APIを使用することを強く推奨します。
 */
@riverpod
Future<SharedPreferencesAsync> sharedPreferencesAsync(Ref ref) async {
  final prefs = SharedPreferencesAsync();
  return prefs;
}

/// [TutorialStateProvider]は、アプリのチュートリアルの状態を非同期で取得するためのプロバイダーです。
/// このプロバイダーは、SharedPreferencesを使用して、ユーザーがアプリを初めて起動したかどうかを判定します。
/// - 初回起動時は`TutorialState.first`を返し、チュートリアルを表示します。
/// - 2回目以降の起動時は`TutorialState.second`を返し、チュートリアルを表示しません。
@riverpod
Future<TutorialState> tutorialState(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesAsyncProvider.future);
  final isFirstTime = await prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    await prefs.setBool('isFirstTime', false);
    return TutorialState.first;
  }
  return TutorialState.second;
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;
  late TutorialCoachMark tutorialCoachMark;
  final counterTextKey = GlobalKey();
  final incrementButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    createTutorial();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowTutorial();
    });
  }

  void checkAndShowTutorial() async {
    try {
      // Futureが完了するまで待機してから判定
      final tutorialState = await ref.read(tutorialStateProvider.future);

      debugPrint('🔍Tutorial state: $tutorialState'); // デバッグ用ログ

      // if文で確実に判定
      if (tutorialState == TutorialState.first && mounted) {
        // 少し遅延を入れてからアニメーション表示
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            debugPrint('🌀Showing tutorial...'); // デバッグ用ログ
            showTutorial();
          }
        });
      }
    } catch (e) {
      // エラー時はログ出力（デバッグ用）
      debugPrint('👻Tutorial state error: $e');
    }
  }

  /// チュートリアルの作成
  /// - `targets`: チュートリアルのターゲットを定義します。
  ///   - `TargetFocus`: ターゲットの識別子とキーを指定します。
  ///   - `TargetContent`: ターゲットのコンテンツを定義します。
  ///     - `align`: コンテンツの位置を指定します。
  ///     - `builder`: コンテンツのウィジェットを構築するための関数を指定します。
  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: [
        // 1. カウンター表示の説明（最初に表示）
        TargetFocus(
          identify: "counter_text",
          keyTarget: counterTextKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "カウンター表示",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "ここにカウントの値が表示されます",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        // 2. カウンターボタンの説明（2番目に表示）
        TargetFocus(
          identify: "floating_action_button",
          keyTarget: incrementButtonKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "プラスボタン",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "画面右下の丸いボタンです。\nタップするたびにカウンターの数字が1つ増えます。",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// チュートリアルを表示するメソッドです。
  /// - `context`: チュートリアルを表示するためのビルドコンテキストを指定します。
  /// このメソッドは、`TutorialCoachMark`の`show`メソッドを呼び出して、定義されたターゲットに基づいてチュートリアルを表示します。
  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tutorial Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              key: counterTextKey,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: incrementButtonKey,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
