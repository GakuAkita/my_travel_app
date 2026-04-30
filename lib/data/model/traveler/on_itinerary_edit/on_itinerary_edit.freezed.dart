// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'on_itinerary_edit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnItineraryEdit {

 String get uid; String get email; bool get on_edit;
/// Create a copy of OnItineraryEdit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnItineraryEditCopyWith<OnItineraryEdit> get copyWith => _$OnItineraryEditCopyWithImpl<OnItineraryEdit>(this as OnItineraryEdit, _$identity);

  /// Serializes this OnItineraryEdit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnItineraryEdit&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.on_edit, on_edit) || other.on_edit == on_edit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,on_edit);

@override
String toString() {
  return 'OnItineraryEdit(uid: $uid, email: $email, on_edit: $on_edit)';
}


}

/// @nodoc
abstract mixin class $OnItineraryEditCopyWith<$Res>  {
  factory $OnItineraryEditCopyWith(OnItineraryEdit value, $Res Function(OnItineraryEdit) _then) = _$OnItineraryEditCopyWithImpl;
@useResult
$Res call({
 String uid, String email, bool on_edit
});




}
/// @nodoc
class _$OnItineraryEditCopyWithImpl<$Res>
    implements $OnItineraryEditCopyWith<$Res> {
  _$OnItineraryEditCopyWithImpl(this._self, this._then);

  final OnItineraryEdit _self;
  final $Res Function(OnItineraryEdit) _then;

/// Create a copy of OnItineraryEdit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? on_edit = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,on_edit: null == on_edit ? _self.on_edit : on_edit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnItineraryEdit].
extension OnItineraryEditPatterns on OnItineraryEdit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnItineraryEdit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnItineraryEdit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnItineraryEdit value)  $default,){
final _that = this;
switch (_that) {
case _OnItineraryEdit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnItineraryEdit value)?  $default,){
final _that = this;
switch (_that) {
case _OnItineraryEdit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  bool on_edit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnItineraryEdit() when $default != null:
return $default(_that.uid,_that.email,_that.on_edit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  bool on_edit)  $default,) {final _that = this;
switch (_that) {
case _OnItineraryEdit():
return $default(_that.uid,_that.email,_that.on_edit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  bool on_edit)?  $default,) {final _that = this;
switch (_that) {
case _OnItineraryEdit() when $default != null:
return $default(_that.uid,_that.email,_that.on_edit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnItineraryEdit extends OnItineraryEdit {
  const _OnItineraryEdit({required this.uid, required this.email, required this.on_edit}): super._();
  factory _OnItineraryEdit.fromJson(Map<String, dynamic> json) => _$OnItineraryEditFromJson(json);

@override final  String uid;
@override final  String email;
@override final  bool on_edit;

/// Create a copy of OnItineraryEdit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnItineraryEditCopyWith<_OnItineraryEdit> get copyWith => __$OnItineraryEditCopyWithImpl<_OnItineraryEdit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnItineraryEditToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnItineraryEdit&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.on_edit, on_edit) || other.on_edit == on_edit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,on_edit);

@override
String toString() {
  return 'OnItineraryEdit(uid: $uid, email: $email, on_edit: $on_edit)';
}


}

/// @nodoc
abstract mixin class _$OnItineraryEditCopyWith<$Res> implements $OnItineraryEditCopyWith<$Res> {
  factory _$OnItineraryEditCopyWith(_OnItineraryEdit value, $Res Function(_OnItineraryEdit) _then) = __$OnItineraryEditCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, bool on_edit
});




}
/// @nodoc
class __$OnItineraryEditCopyWithImpl<$Res>
    implements _$OnItineraryEditCopyWith<$Res> {
  __$OnItineraryEditCopyWithImpl(this._self, this._then);

  final _OnItineraryEdit _self;
  final $Res Function(_OnItineraryEdit) _then;

/// Create a copy of OnItineraryEdit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? on_edit = null,}) {
  return _then(_OnItineraryEdit(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,on_edit: null == on_edit ? _self.on_edit : on_edit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
