import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:udemy_riverpod/domain/notes_domain.dart';
part 'notes_view_model.g.dart';

/// [@Riverpod(keepAlive: true)]だとアプリ全体で値が共有される。
/// [画面遷移]しても状態が保持される。
@Riverpod(keepAlive: true)
class NotesViewModel extends _$NotesViewModel {
  @override
  NotesDomain build() {
    return NotesDomain(id: 0, body: '', createdAt: DateTime.now());
  }

  void updateNotes(NotesDomain notes) {
    state = notes;
  }
}
