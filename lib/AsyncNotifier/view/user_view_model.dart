import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:udemy_riverpod/AsyncNotifier/interface/user_interface.dart';
import 'package:udemy_riverpod/AsyncNotifier/model/user_state.dart';
part 'user_view_model.g.dart';

@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  FutureOr<List<UserState>> build() {
    return fetchUsers();
  }

  FutureOr<List<UserState>> fetchUsers() async {
    // 通常はロジックを直接呼ぶこともできる。
    // final response = await UserDatasource().fetchUsers();
    // interfaceを使った場合。Providerを使用して、ref.read()で呼び出す。
    final response = await ref.read(userInterfaceProviderProvider).fetchUsers();
    return response;
  }
}
