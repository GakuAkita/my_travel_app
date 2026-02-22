// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'traveler_basic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TravelerBasic {

 String get uid; String get email;@JsonKey(includeToJson: false, includeFromJson: false) String? get profile_name;
/// Create a copy of TravelerBasic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TravelerBasicCopyWith<TravelerBasic> get copyWith => _$TravelerBasicCopyWithImpl<TravelerBasic>(this as TravelerBasic, _$identity);

  /// Serializes this TravelerBasic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TravelerBasic&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,profile_name);

@override
String toString() {
  return 'TravelerBasic(uid: $uid, email: $email, profile_name: $profile_name)';
}


}

/// @nodoc
abstract mixin class $TravelerBasicCopyWith<$Res>  {
  factory $TravelerBasicCopyWith(TravelerBasic value, $Res Function(TravelerBasic) _then) = _$TravelerBasicCopyWithImpl;
@useResult
$Res call({
 String uid, String email,@JsonKey(includeToJson: false, includeFromJson: false) String? profile_name
});




}
/// @nodoc
class _$TravelerBasicCopyWithImpl<$Res>
    implements $TravelerBasicCopyWith<$Res> {
  _$TravelerBasicCopyWithImpl(this._self, this._then);

  final TravelerBasic _self;
  final $Res Function(TravelerBasic) _then;

/// Create a copy of TravelerBasic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? profile_name = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,profile_name: freezed == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TravelerBasic].
extension TravelerBasicPatterns on TravelerBasic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TravelerBasic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TravelerBasic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TravelerBasic value)  $default,){
final _that = this;
switch (_that) {
case _TravelerBasic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TravelerBasic value)?  $default,){
final _that = this;
switch (_that) {
case _TravelerBasic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email, @JsonKey(includeToJson: false, includeFromJson: false)  String? profile_name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TravelerBasic() when $default != null:
return $default(_that.uid,_that.email,_that.profile_name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email, @JsonKey(includeToJson: false, includeFromJson: false)  String? profile_name)  $default,) {final _that = this;
switch (_that) {
case _TravelerBasic():
return $default(_that.uid,_that.email,_that.profile_name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email, @JsonKey(includeToJson: false, includeFromJson: false)  String? profile_name)?  $default,) {final _that = this;
switch (_that) {
case _TravelerBasic() when $default != null:
return $default(_that.uid,_that.email,_that.profile_name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TravelerBasic implements TravelerBasic {
  const _TravelerBasic({required this.uid, required this.email, @JsonKey(includeToJson: false, includeFromJson: false) this.profile_name});
  factory _TravelerBasic.fromJson(Map<String, dynamic> json) => _$TravelerBasicFromJson(json);

@override final  String uid;
@override final  String email;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  String? profile_name;

/// Create a copy of TravelerBasic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TravelerBasicCopyWith<_TravelerBasic> get copyWith => __$TravelerBasicCopyWithImpl<_TravelerBasic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TravelerBasicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TravelerBasic&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,profile_name);

@override
String toString() {
  return 'TravelerBasic(uid: $uid, email: $email, profile_name: $profile_name)';
}


}

/// @nodoc
abstract mixin class _$TravelerBasicCopyWith<$Res> implements $TravelerBasicCopyWith<$Res> {
  factory _$TravelerBasicCopyWith(_TravelerBasic value, $Res Function(_TravelerBasic) _then) = __$TravelerBasicCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email,@JsonKey(includeToJson: false, includeFromJson: false) String? profile_name
});




}
/// @nodoc
class __$TravelerBasicCopyWithImpl<$Res>
    implements _$TravelerBasicCopyWith<$Res> {
  __$TravelerBasicCopyWithImpl(this._self, this._then);

  final _TravelerBasic _self;
  final $Res Function(_TravelerBasic) _then;

/// Create a copy of TravelerBasic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? profile_name = freezed,}) {
  return _then(_TravelerBasic(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,profile_name: freezed == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
