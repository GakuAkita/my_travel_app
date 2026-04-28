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

 String get id;
/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItinerarySectionCopyWith<ItinerarySection> get copyWith => _$ItinerarySectionCopyWithImpl<ItinerarySection>(this as ItinerarySection, _$identity);

  /// Serializes this ItinerarySection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItinerarySection&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ItinerarySection(id: $id)';
}


}

/// @nodoc
abstract mixin class $ItinerarySectionCopyWith<$Res>  {
  factory $ItinerarySectionCopyWith(ItinerarySection value, $Res Function(ItinerarySection) _then) = _$ItinerarySectionCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$ItinerarySectionCopyWithImpl<$Res>
    implements $ItinerarySectionCopyWith<$Res> {
  _$ItinerarySectionCopyWithImpl(this._self, this._then);

  final ItinerarySection _self;
  final $Res Function(ItinerarySection) _then;

/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String title,  String content)?  markdown,TResult Function( String id,  ItineraryTable tableData)?  table,TResult Function( String id)?  space,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MarkdownSection() when markdown != null:
return markdown(_that.id,_that.title,_that.content);case TableSection() when table != null:
return table(_that.id,_that.tableData);case SpaceSection() when space != null:
return space(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String title,  String content)  markdown,required TResult Function( String id,  ItineraryTable tableData)  table,required TResult Function( String id)  space,}) {final _that = this;
switch (_that) {
case MarkdownSection():
return markdown(_that.id,_that.title,_that.content);case TableSection():
return table(_that.id,_that.tableData);case SpaceSection():
return space(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String title,  String content)?  markdown,TResult? Function( String id,  ItineraryTable tableData)?  table,TResult? Function( String id)?  space,}) {final _that = this;
switch (_that) {
case MarkdownSection() when markdown != null:
return markdown(_that.id,_that.title,_that.content);case TableSection() when table != null:
return table(_that.id,_that.tableData);case SpaceSection() when space != null:
return space(_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class MarkdownSection implements ItinerarySection {
  const MarkdownSection({required this.id, required this.title, required this.content, final  String? $type}): $type = $type ?? 'markdown';
  factory MarkdownSection.fromJson(Map<String, dynamic> json) => _$MarkdownSectionFromJson(json);

@override final  String id;
 final  String title;
 final  String content;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkdownSectionCopyWith<MarkdownSection> get copyWith => _$MarkdownSectionCopyWithImpl<MarkdownSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarkdownSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkdownSection&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content);

@override
String toString() {
  return 'ItinerarySection.markdown(id: $id, title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class $MarkdownSectionCopyWith<$Res> implements $ItinerarySectionCopyWith<$Res> {
  factory $MarkdownSectionCopyWith(MarkdownSection value, $Res Function(MarkdownSection) _then) = _$MarkdownSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,}) {
  return _then(MarkdownSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class TableSection implements ItinerarySection {
  const TableSection({required this.id, required this.tableData, final  String? $type}): $type = $type ?? 'table';
  factory TableSection.fromJson(Map<String, dynamic> json) => _$TableSectionFromJson(json);

@override final  String id;
 final  ItineraryTable tableData;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSectionCopyWith<TableSection> get copyWith => _$TableSectionCopyWithImpl<TableSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSection&&(identical(other.id, id) || other.id == id)&&(identical(other.tableData, tableData) || other.tableData == tableData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tableData);

@override
String toString() {
  return 'ItinerarySection.table(id: $id, tableData: $tableData)';
}


}

/// @nodoc
abstract mixin class $TableSectionCopyWith<$Res> implements $ItinerarySectionCopyWith<$Res> {
  factory $TableSectionCopyWith(TableSection value, $Res Function(TableSection) _then) = _$TableSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, ItineraryTable tableData
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tableData = null,}) {
  return _then(TableSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tableData: null == tableData ? _self.tableData : tableData // ignore: cast_nullable_to_non_nullable
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
  const SpaceSection({required this.id, final  String? $type}): $type = $type ?? 'space';
  factory SpaceSection.fromJson(Map<String, dynamic> json) => _$SpaceSectionFromJson(json);

@override final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceSectionCopyWith<SpaceSection> get copyWith => _$SpaceSectionCopyWithImpl<SpaceSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceSection&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ItinerarySection.space(id: $id)';
}


}

/// @nodoc
abstract mixin class $SpaceSectionCopyWith<$Res> implements $ItinerarySectionCopyWith<$Res> {
  factory $SpaceSectionCopyWith(SpaceSection value, $Res Function(SpaceSection) _then) = _$SpaceSectionCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SpaceSectionCopyWithImpl<$Res>
    implements $SpaceSectionCopyWith<$Res> {
  _$SpaceSectionCopyWithImpl(this._self, this._then);

  final SpaceSection _self;
  final $Res Function(SpaceSection) _then;

/// Create a copy of ItinerarySection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SpaceSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
