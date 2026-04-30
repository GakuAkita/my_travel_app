// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shown_travel_basic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShownTravelBasic {

 String? get travelId; String? get groupId;
/// Create a copy of ShownTravelBasic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShownTravelBasicCopyWith<ShownTravelBasic> get copyWith => _$ShownTravelBasicCopyWithImpl<ShownTravelBasic>(this as ShownTravelBasic, _$identity);

  /// Serializes this ShownTravelBasic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShownTravelBasic&&(identical(other.travelId, travelId) || other.travelId == travelId)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,travelId,groupId);

@override
String toString() {
  return 'ShownTravelBasic(travelId: $travelId, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class $ShownTravelBasicCopyWith<$Res>  {
  factory $ShownTravelBasicCopyWith(ShownTravelBasic value, $Res Function(ShownTravelBasic) _then) = _$ShownTravelBasicCopyWithImpl;
@useResult
$Res call({
 String? travelId, String? groupId
});




}
/// @nodoc
class _$ShownTravelBasicCopyWithImpl<$Res>
    implements $ShownTravelBasicCopyWith<$Res> {
  _$ShownTravelBasicCopyWithImpl(this._self, this._then);

  final ShownTravelBasic _self;
  final $Res Function(ShownTravelBasic) _then;

/// Create a copy of ShownTravelBasic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? travelId = freezed,Object? groupId = freezed,}) {
  return _then(_self.copyWith(
travelId: freezed == travelId ? _self.travelId : travelId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShownTravelBasic].
extension ShownTravelBasicPatterns on ShownTravelBasic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShownTravelBasic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShownTravelBasic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShownTravelBasic value)  $default,){
final _that = this;
switch (_that) {
case _ShownTravelBasic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShownTravelBasic value)?  $default,){
final _that = this;
switch (_that) {
case _ShownTravelBasic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? travelId,  String? groupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShownTravelBasic() when $default != null:
return $default(_that.travelId,_that.groupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? travelId,  String? groupId)  $default,) {final _that = this;
switch (_that) {
case _ShownTravelBasic():
return $default(_that.travelId,_that.groupId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? travelId,  String? groupId)?  $default,) {final _that = this;
switch (_that) {
case _ShownTravelBasic() when $default != null:
return $default(_that.travelId,_that.groupId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShownTravelBasic implements ShownTravelBasic {
  const _ShownTravelBasic({this.travelId, this.groupId});
  factory _ShownTravelBasic.fromJson(Map<String, dynamic> json) => _$ShownTravelBasicFromJson(json);

@override final  String? travelId;
@override final  String? groupId;

/// Create a copy of ShownTravelBasic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShownTravelBasicCopyWith<_ShownTravelBasic> get copyWith => __$ShownTravelBasicCopyWithImpl<_ShownTravelBasic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShownTravelBasicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShownTravelBasic&&(identical(other.travelId, travelId) || other.travelId == travelId)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,travelId,groupId);

@override
String toString() {
  return 'ShownTravelBasic(travelId: $travelId, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class _$ShownTravelBasicCopyWith<$Res> implements $ShownTravelBasicCopyWith<$Res> {
  factory _$ShownTravelBasicCopyWith(_ShownTravelBasic value, $Res Function(_ShownTravelBasic) _then) = __$ShownTravelBasicCopyWithImpl;
@override @useResult
$Res call({
 String? travelId, String? groupId
});




}
/// @nodoc
class __$ShownTravelBasicCopyWithImpl<$Res>
    implements _$ShownTravelBasicCopyWith<$Res> {
  __$ShownTravelBasicCopyWithImpl(this._self, this._then);

  final _ShownTravelBasic _self;
  final $Res Function(_ShownTravelBasic) _then;

/// Create a copy of ShownTravelBasic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? travelId = freezed,Object? groupId = freezed,}) {
  return _then(_ShownTravelBasic(
travelId: freezed == travelId ? _self.travelId : travelId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
