import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:udemy_riverpod/AsyncNotifier/model/user_datasource.dart';
import 'package:udemy_riverpod/AsyncNotifier/model/user_state.dart';
part 'user_interface.g.dart';

@riverpod
UserInterface userInterfaceProvider(Ref ref) {
  final UserDatasource userDatasource = UserDatasource();
  return UserInterfaceImpl(userDatasource);
}

abstract interface class UserInterface {
  Future<List<UserState>> fetchUsers();
}

class UserInterfaceImpl implements UserInterface {
  final UserDatasource _userDatasource;
  UserInterfaceImpl(this._userDatasource);

  @override
  Future<List<UserState>> fetchUsers() async {
    final response = await _userDatasource.fetchUsers();
    return response;
  }
}
