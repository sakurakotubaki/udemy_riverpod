import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy_riverpod/AsyncNotifier/view/user_view_model.dart';

class UserListView extends ConsumerWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: switch (users) {
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final user = value[index];
            return ListTile(title: Text(user.name), subtitle: Text(user.email));
          },
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
