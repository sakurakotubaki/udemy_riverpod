# udemy_riverpod
Udemy用のサンプルコード

## 開発環境
- Flutter 3.32.1
- Dart 3.8.1
- flutter_riverpod 2.6.1

**flutter_riverpodを追加**

```shell
flutter pub add \
flutter_riverpod \
riverpod_annotation \
dev:riverpod_generator \
dev:build_runner \
dev:custom_lint \
dev:riverpod_lint
```

**freezedを追加**

```shell
flutter pub add \
  freezed_annotation \
  --dev build_runner \
  --dev freezed \
  json_annotation \
  --dev json_serializable
```

**自動生成のコマンド**

```shell
flutter pub run build_runner watch --delete-conflicting-outputs
```

Makefileなるものを作ると、コマンドが短くなって作業が楽になります。プロジェクト直下に作成します。

```shell
.PHONY: setup
setup:
	flutter clean
	flutter pub get

.PHONY: watch
watch:
	flutter pub run build_runner watch --delete-conflicting-outputs
```