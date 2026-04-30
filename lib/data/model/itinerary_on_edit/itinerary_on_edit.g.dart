// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_on_edit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItineraryOnEdit _$ItineraryOnEditFromJson(Map<String, dynamic> json) =>
    _ItineraryOnEdit(
      onEdit: json['onEdit'] as bool?,
      editor:
          json['editor'] == null
              ? null
              : TravelerCore.fromJson(json['editor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItineraryOnEditToJson(_ItineraryOnEdit instance) =>
    <String, dynamic>{
      'onEdit': instance.onEdit,
      'editor': instance.editor?.toJson(),
    };
