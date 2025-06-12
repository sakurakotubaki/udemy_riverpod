import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'notes_domain.freezed.dart';
part 'notes_domain.g.dart';

@freezed
abstract class NotesDomain with _$NotesDomain {
  const factory NotesDomain({
    required int id,
    required String body,
    required DateTime createdAt,
  }) = _NotesDomain;

  factory NotesDomain.fromJson(Map<String, Object?> json) =>
      _$NotesDomainFromJson(json);
}
