// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkdownSection _$MarkdownSectionFromJson(Map<String, dynamic> json) =>
    MarkdownSection(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MarkdownSectionToJson(MarkdownSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'runtimeType': instance.$type,
    };

TableSection _$TableSectionFromJson(Map<String, dynamic> json) => TableSection(
  id: json['id'] as String,
  tableData: ItineraryTable.fromJson(json['tableData'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$TableSectionToJson(TableSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableData': instance.tableData.toJson(),
      'runtimeType': instance.$type,
    };

SpaceSection _$SpaceSectionFromJson(Map<String, dynamic> json) => SpaceSection(
  id: json['id'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SpaceSectionToJson(SpaceSection instance) =>
    <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};
