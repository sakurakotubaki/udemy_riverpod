import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy_riverpod/domain/notes_domain.dart';
import 'package:udemy_riverpod/model/notes_model.dart';
import 'package:udemy_riverpod/state/note_notifier.dart';
import 'package:udemy_riverpod/view/next_view.dart';
import 'package:udemy_riverpod/view/notes_view_model.dart';

class NoteGeneratePage extends ConsumerWidget {
  const NoteGeneratePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watchで、初期値が空のリストを呼び出して、監視する。
    final noteAppGenerater = ref.watch(noteNotifierProvider);
    // 入力フォームの値をリストに保存するTextEditingController.
    final bodyController = TextEditingController();
    // ランダムな数値を作り出す変数.
    final randomId = Random().nextInt(100) + 50;
    // 現在時刻を表取得する変数.
    DateTime createdAt = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Notes Generate')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: bodyController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // NoteModelクラスに、ダミーのデータを引数として渡して保存する.
                  ref
                      .read(noteNotifierProvider.notifier)
                      .addNote(
                        NotesModel(
                          id: randomId, // ランダムな数値をidに設定.
                          body: bodyController.text, // 入力フォームの値をbodyに設定.
                          createdAt: createdAt, // 現在時刻をcreatedAtに設定.
                        ),
                      );
                },
                child: const Text('Add note'),
              ),
              const SizedBox(height: 20),
              noteAppGenerater.isEmpty
                  ? const Text('Add notes ')
                  : ListView.builder(
                      itemCount: noteAppGenerater
                          .length, // StateNotifierのリストに追加されたデータの数を数える.
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final note = noteAppGenerater[index];
                        return ListTile(
                          onTap: () {
                            final notesDomain = NotesDomain(
                              id: note.id,
                              body: note.body,
                              createdAt: note.createdAt,
                            );

                            ref
                                .read(notesViewModelProvider.notifier)
                                .updateNotes(notesDomain);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NextView(),
                              ),
                            );
                          },
                          title: Text(
                            'id: $note memo: ${note.body}',
                          ), // idとフォームから入力された値を表示.
                          subtitle: Text(
                            note.createdAt.toIso8601String(),
                          ), // リストにデータを追加した時刻を表示.
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // リストのidを取得してボタンを押したリストだけ削除する.
                              ref
                                  .read(noteNotifierProvider.notifier)
                                  .removeNoteById(note.id);
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
