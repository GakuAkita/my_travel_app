// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItineraryTable _$ItineraryTableFromJson(
  Map<String, dynamic> json,
) => _ItineraryTable(
  header:
      (json['header'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const ["時間", "場所", "メモ"],
  tableCells:
      (json['tableCells'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList() ??
      const [],
  flexes:
      (json['flexes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [2, 3, 3],
);

Map<String, dynamic> _$ItineraryTableToJson(_ItineraryTable instance) =>
    <String, dynamic>{
      'header': instance.header,
      'tableCells': instance.tableCells,
      'flexes': instance.flexes,
    };
