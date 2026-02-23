// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'traveler_core.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TravelerCore {

 String get uid; String get email;
/// Create a copy of TravelerCore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TravelerCoreCopyWith<TravelerCore> get copyWith => _$TravelerCoreCopyWithImpl<TravelerCore>(this as TravelerCore, _$identity);

  /// Serializes this TravelerCore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TravelerCore&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email);

@override
String toString() {
  return 'TravelerCore(uid: $uid, email: $email)';
}


}

/// @nodoc
abstract mixin class $TravelerCoreCopyWith<$Res>  {
  factory $TravelerCoreCopyWith(TravelerCore value, $Res Function(TravelerCore) _then) = _$TravelerCoreCopyWithImpl;
@useResult
$Res call({
 String uid, String email
});




}
/// @nodoc
class _$TravelerCoreCopyWithImpl<$Res>
    implements $TravelerCoreCopyWith<$Res> {
  _$TravelerCoreCopyWithImpl(this._self, this._then);

  final TravelerCore _self;
  final $Res Function(TravelerCore) _then;

/// Create a copy of TravelerCore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TravelerCore].
extension TravelerCorePatterns on TravelerCore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TravelerCore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TravelerCore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TravelerCore value)  $default,){
final _that = this;
switch (_that) {
case _TravelerCore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TravelerCore value)?  $default,){
final _that = this;
switch (_that) {
case _TravelerCore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TravelerCore() when $default != null:
return $default(_that.uid,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email)  $default,) {final _that = this;
switch (_that) {
case _TravelerCore():
return $default(_that.uid,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email)?  $default,) {final _that = this;
switch (_that) {
case _TravelerCore() when $default != null:
return $default(_that.uid,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TravelerCore implements TravelerCore {
  const _TravelerCore({required this.uid, required this.email});
  factory _TravelerCore.fromJson(Map<String, dynamic> json) => _$TravelerCoreFromJson(json);

@override final  String uid;
@override final  String email;

/// Create a copy of TravelerCore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TravelerCoreCopyWith<_TravelerCore> get copyWith => __$TravelerCoreCopyWithImpl<_TravelerCore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TravelerCoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TravelerCore&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email);

@override
String toString() {
  return 'TravelerCore(uid: $uid, email: $email)';
}


}

/// @nodoc
abstract mixin class _$TravelerCoreCopyWith<$Res> implements $TravelerCoreCopyWith<$Res> {
  factory _$TravelerCoreCopyWith(_TravelerCore value, $Res Function(_TravelerCore) _then) = __$TravelerCoreCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email
});




}
/// @nodoc
class __$TravelerCoreCopyWithImpl<$Res>
    implements _$TravelerCoreCopyWith<$Res> {
  __$TravelerCoreCopyWithImpl(this._self, this._then);

  final _TravelerCore _self;
  final $Res Function(_TravelerCore) _then;

/// Create a copy of TravelerCore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,}) {
  return _then(_TravelerCore(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
