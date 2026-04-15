// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ItinerarySection _$ItinerarySectionFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'markdown':
          return MarkdownSection.fromJson(
            json
          );
                case 'table':
          return TableSection.fromJson(
            json
          );
                case 'space':
          return SpaceSection.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'ItinerarySection',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ItinerarySection {



  /// Serializes this ItinerarySection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItinerarySection);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ItinerarySection()';
}


}

/// @nodoc
class $ItinerarySectionCopyWith<$Res>  {
$ItinerarySectionCopyWith(ItinerarySection _, $Res Function(ItinerarySection) __);
}


/// Adds pattern-matching-related methods to [ItinerarySection].
extension ItinerarySectionPatterns on ItinerarySection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MarkdownSection value)?  markdown,TResult Function( TableSection value)?  table,TResult Function( SpaceSection value)?  space,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MarkdownSection() when markdown != null:
return markdown(_that);case TableSection() when table != null:
return table(_that);case SpaceSection() when space != null:
return space(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MarkdownSection value)  markdown,required TResult Function( TableSection value)  table,required TResult Function( SpaceSection value)  space,}){
final _that = this;
switch (_that) {
case MarkdownSection():
return markdown(_that);case TableSection():
return table(_that);case SpaceSection():
return space(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MarkdownSection value)?  markdown,TResult? Function( TableSection value)?  table,TResult? Function( SpaceSection value)?  space,}){
final _that = this;
switch (_that) {
case MarkdownSection() when markdown != null:
return markdown(_that);case TableSection() when table != null:
return table(_that);case SpaceSection() when space != null:
return space(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  String content)?  markdown,TResult Function( ItineraryTable tableData)?  table,TResult Function()?  space,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MarkdownSection() when markdown != null:
return markdown(_that.title,_that.content);case TableSection() when table != null:
return table(_that.tableData);case SpaceSection() when space != null:
return space();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  String content)  markdown,required TResult Function( ItineraryTable tableData)  table,required TResult Function()  space,}) {final _that = this;
switch (_that) {
case MarkdownSection():
return markdown(_that.title,_that.content);case TableSection():
return table(_that.tableData);case SpaceSection():
return space();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  String content)?  markdown,TResult? Function( ItineraryTable tableData)?  table,TResult? Function()?  space,}) {final _that = this;
switch (_that) {
case MarkdownSection() when markdown != null:
return markdown(_that.title,_that.content);case TableSection() when table != null:
return table(_that.tableData);case SpaceSection() when space != null:
return space();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class MarkdownSection implements ItinerarySection {
  const MarkdownSection({required this.title, required this.content, final  String? $type}): $type = $type ?? 'markdown';
  factory MarkdownSection.fromJson(Map<String, dynamic> json) => _$MarkdownSectionFromJson(json);

 final  String title;
 final  String content;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkdownSectionCopyWith<MarkdownSection> get copyWith => _$MarkdownSectionCopyWithImpl<MarkdownSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarkdownSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkdownSection&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,content);

@override
String toString() {
  return 'ItinerarySection.markdown(title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class $MarkdownSectionCopyWith<$Res> implements $ItinerarySectionCopyWith<$Res> {
  factory $MarkdownSectionCopyWith(MarkdownSection value, $Res Function(MarkdownSection) _then) = _$MarkdownSectionCopyWithImpl;
@useResult
$Res call({
 String title, String content
});




}
/// @nodoc
class _$MarkdownSectionCopyWithImpl<$Res>
    implements $MarkdownSectionCopyWith<$Res> {
  _$MarkdownSectionCopyWithImpl(this._self, this._then);

  final MarkdownSection _self;
  final $Res Function(MarkdownSection) _then;

/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,}) {
  return _then(MarkdownSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TableSection implements ItinerarySection {
  const TableSection({required this.tableData, final  String? $type}): $type = $type ?? 'table';
  factory TableSection.fromJson(Map<String, dynamic> json) => _$TableSectionFromJson(json);

 final  ItineraryTable tableData;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSectionCopyWith<TableSection> get copyWith => _$TableSectionCopyWithImpl<TableSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSection&&(identical(other.tableData, tableData) || other.tableData == tableData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tableData);

@override
String toString() {
  return 'ItinerarySection.table(tableData: $tableData)';
}


}

/// @nodoc
abstract mixin class $TableSectionCopyWith<$Res> implements $ItinerarySectionCopyWith<$Res> {
  factory $TableSectionCopyWith(TableSection value, $Res Function(TableSection) _then) = _$TableSectionCopyWithImpl;
@useResult
$Res call({
 ItineraryTable tableData
});


$ItineraryTableCopyWith<$Res> get tableData;

}
/// @nodoc
class _$TableSectionCopyWithImpl<$Res>
    implements $TableSectionCopyWith<$Res> {
  _$TableSectionCopyWithImpl(this._self, this._then);

  final TableSection _self;
  final $Res Function(TableSection) _then;

/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tableData = null,}) {
  return _then(TableSection(
tableData: null == tableData ? _self.tableData : tableData // ignore: cast_nullable_to_non_nullable
as ItineraryTable,
  ));
}

/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItineraryTableCopyWith<$Res> get tableData {
  
  return $ItineraryTableCopyWith<$Res>(_self.tableData, (value) {
    return _then(_self.copyWith(tableData: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class SpaceSection implements ItinerarySection {
  const SpaceSection({final  String? $type}): $type = $type ?? 'space';
  factory SpaceSection.fromJson(Map<String, dynamic> json) => _$SpaceSectionFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$SpaceSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceSection);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ItinerarySection.space()';
}


}




// dart format on
