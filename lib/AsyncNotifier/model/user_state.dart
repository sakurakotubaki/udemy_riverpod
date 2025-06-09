import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_state.freezed.dart';
part 'user_state.g.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState({
    required int id,
    required String name,
    required String email,
  }) = _UserState;

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);
}
