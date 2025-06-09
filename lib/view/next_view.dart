import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy_riverpod/view/notes_view_model.dart';

class NextView extends ConsumerWidget {
  const NextView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Next View')),
      body: Center(
        child: ListView(
          children: [
            Text('ID: ${notes.id}'),
            Text('Body: ${notes.body}'),
            Text('Created At: ${notes.createdAt}'),
          ],
        ),
      ),
    );
  }
}
