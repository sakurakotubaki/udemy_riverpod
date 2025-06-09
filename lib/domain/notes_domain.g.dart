// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotesDomain _$NotesDomainFromJson(Map<String, dynamic> json) => _NotesDomain(
  id: (json['id'] as num).toInt(),
  body: json['body'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NotesDomainToJson(_NotesDomain instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
    };
