import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:udemy_riverpod/AsyncNotifier/model/user_state.dart';

class UserDatasource {
  Future<List<UserState>> fetchUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://jsonplaceholder.typicode.com/users'),
            headers: {'Accept': 'application/json', 'Connection': 'keep-alive'},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<UserState> users = [];
        // JSONをDartのリストに変換
        final List<dynamic> jsonData = jsonDecode(response.body);
        for (final user in jsonData) {
          // freezedに値を渡して保持させる。
          users.add(UserState.fromJson(user));
        }

        return users;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } on HttpException {
      throw Exception('HTTP error occurred');
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
