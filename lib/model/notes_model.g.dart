// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotesModel _$NotesModelFromJson(Map<String, dynamic> json) => _NotesModel(
  id: (json['id'] as num).toInt(),
  body: json['body'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NotesModelToJson(_NotesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
    };
