// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItineraryTable {

 List<String> get header; List<List<String>> get tableCells; List<int> get flexes;
/// Create a copy of ItineraryTable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItineraryTableCopyWith<ItineraryTable> get copyWith => _$ItineraryTableCopyWithImpl<ItineraryTable>(this as ItineraryTable, _$identity);

  /// Serializes this ItineraryTable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItineraryTable&&const DeepCollectionEquality().equals(other.header, header)&&const DeepCollectionEquality().equals(other.tableCells, tableCells)&&const DeepCollectionEquality().equals(other.flexes, flexes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(header),const DeepCollectionEquality().hash(tableCells),const DeepCollectionEquality().hash(flexes));

@override
String toString() {
  return 'ItineraryTable(header: $header, tableCells: $tableCells, flexes: $flexes)';
}


}

/// @nodoc
abstract mixin class $ItineraryTableCopyWith<$Res>  {
  factory $ItineraryTableCopyWith(ItineraryTable value, $Res Function(ItineraryTable) _then) = _$ItineraryTableCopyWithImpl;
@useResult
$Res call({
 List<String> header, List<List<String>> tableCells, List<int> flexes
});




}
/// @nodoc
class _$ItineraryTableCopyWithImpl<$Res>
    implements $ItineraryTableCopyWith<$Res> {
  _$ItineraryTableCopyWithImpl(this._self, this._then);

  final ItineraryTable _self;
  final $Res Function(ItineraryTable) _then;

/// Create a copy of ItineraryTable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? header = null,Object? tableCells = null,Object? flexes = null,}) {
  return _then(_self.copyWith(
header: null == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as List<String>,tableCells: null == tableCells ? _self.tableCells : tableCells // ignore: cast_nullable_to_non_nullable
as List<List<String>>,flexes: null == flexes ? _self.flexes : flexes // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItineraryTable].
extension ItineraryTablePatterns on ItineraryTable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItineraryTable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItineraryTable() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItineraryTable value)  $default,){
final _that = this;
switch (_that) {
case _ItineraryTable():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItineraryTable value)?  $default,){
final _that = this;
switch (_that) {
case _ItineraryTable() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> header,  List<List<String>> tableCells,  List<int> flexes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItineraryTable() when $default != null:
return $default(_that.header,_that.tableCells,_that.flexes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> header,  List<List<String>> tableCells,  List<int> flexes)  $default,) {final _that = this;
switch (_that) {
case _ItineraryTable():
return $default(_that.header,_that.tableCells,_that.flexes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> header,  List<List<String>> tableCells,  List<int> flexes)?  $default,) {final _that = this;
switch (_that) {
case _ItineraryTable() when $default != null:
return $default(_that.header,_that.tableCells,_that.flexes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItineraryTable implements ItineraryTable {
  const _ItineraryTable({final  List<String> header = const ["時間", "場所", "メモ"], final  List<List<String>> tableCells = const [], final  List<int> flexes = const [2, 3, 3]}): _header = header,_tableCells = tableCells,_flexes = flexes;
  factory _ItineraryTable.fromJson(Map<String, dynamic> json) => _$ItineraryTableFromJson(json);

 final  List<String> _header;
@override@JsonKey() List<String> get header {
  if (_header is EqualUnmodifiableListView) return _header;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_header);
}

 final  List<List<String>> _tableCells;
@override@JsonKey() List<List<String>> get tableCells {
  if (_tableCells is EqualUnmodifiableListView) return _tableCells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tableCells);
}

 final  List<int> _flexes;
@override@JsonKey() List<int> get flexes {
  if (_flexes is EqualUnmodifiableListView) return _flexes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flexes);
}


/// Create a copy of ItineraryTable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItineraryTableCopyWith<_ItineraryTable> get copyWith => __$ItineraryTableCopyWithImpl<_ItineraryTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItineraryTableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItineraryTable&&const DeepCollectionEquality().equals(other._header, _header)&&const DeepCollectionEquality().equals(other._tableCells, _tableCells)&&const DeepCollectionEquality().equals(other._flexes, _flexes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_header),const DeepCollectionEquality().hash(_tableCells),const DeepCollectionEquality().hash(_flexes));

@override
String toString() {
  return 'ItineraryTable(header: $header, tableCells: $tableCells, flexes: $flexes)';
}


}

/// @nodoc
abstract mixin class _$ItineraryTableCopyWith<$Res> implements $ItineraryTableCopyWith<$Res> {
  factory _$ItineraryTableCopyWith(_ItineraryTable value, $Res Function(_ItineraryTable) _then) = __$ItineraryTableCopyWithImpl;
@override @useResult
$Res call({
 List<String> header, List<List<String>> tableCells, List<int> flexes
});




}
/// @nodoc
class __$ItineraryTableCopyWithImpl<$Res>
    implements _$ItineraryTableCopyWith<$Res> {
  __$ItineraryTableCopyWithImpl(this._self, this._then);

  final _ItineraryTable _self;
  final $Res Function(_ItineraryTable) _then;

/// Create a copy of ItineraryTable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? header = null,Object? tableCells = null,Object? flexes = null,}) {
  return _then(_ItineraryTable(
header: null == header ? _self._header : header // ignore: cast_nullable_to_non_nullable
as List<String>,tableCells: null == tableCells ? _self._tableCells : tableCells // ignore: cast_nullable_to_non_nullable
as List<List<String>>,flexes: null == flexes ? _self._flexes : flexes // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
