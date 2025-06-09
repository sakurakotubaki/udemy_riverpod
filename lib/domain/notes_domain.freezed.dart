// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotesDomain implements DiagnosticableTreeMixin {

 int get id; String get body; DateTime get createdAt;

  /// Serializes this NotesDomain to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NotesDomain'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('createdAt', createdAt));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NotesDomain(id: $id, body: $body, createdAt: $createdAt)';
}


}




/// @nodoc
@JsonSerializable()

class _NotesDomain with DiagnosticableTreeMixin implements NotesDomain {
  const _NotesDomain({required this.id, required this.body, required this.createdAt});
  factory _NotesDomain.fromJson(Map<String, dynamic> json) => _$NotesDomainFromJson(json);

@override final  int id;
@override final  String body;
@override final  DateTime createdAt;


@override
Map<String, dynamic> toJson() {
  return _$NotesDomainToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NotesDomain'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('createdAt', createdAt));
}



@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NotesDomain(id: $id, body: $body, createdAt: $createdAt)';
}


}




// dart format on
