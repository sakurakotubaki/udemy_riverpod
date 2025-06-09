import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:udemy_riverpod/model/notes_model.dart';
part 'note_notifier.g.dart';

@riverpod
class NoteNotifier extends _$NoteNotifier {
  @override
  List<NotesModel> build() {
    return [];
  }

  // 空っぽのクラスに、id、フォームの値、現在時刻を保存する.
  void addNote(NotesModel note) {
    state = [...state, note];
  }

  // ダミーのデータを削除する.
  void removeNoteById(int id) {
    state = [
      for (final note in state)
        if (note.id != id) note,
    ];
  }
}
