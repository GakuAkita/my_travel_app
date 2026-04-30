// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_on_edit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItineraryOnEdit {

 bool? get onEdit; TravelerCore? get editor;
/// Create a copy of ItineraryOnEdit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItineraryOnEditCopyWith<ItineraryOnEdit> get copyWith => _$ItineraryOnEditCopyWithImpl<ItineraryOnEdit>(this as ItineraryOnEdit, _$identity);

  /// Serializes this ItineraryOnEdit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItineraryOnEdit&&(identical(other.onEdit, onEdit) || other.onEdit == onEdit)&&(identical(other.editor, editor) || other.editor == editor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,onEdit,editor);

@override
String toString() {
  return 'ItineraryOnEdit(onEdit: $onEdit, editor: $editor)';
}


}

/// @nodoc
abstract mixin class $ItineraryOnEditCopyWith<$Res>  {
  factory $ItineraryOnEditCopyWith(ItineraryOnEdit value, $Res Function(ItineraryOnEdit) _then) = _$ItineraryOnEditCopyWithImpl;
@useResult
$Res call({
 bool? onEdit, TravelerCore? editor
});


$TravelerCoreCopyWith<$Res>? get editor;

}
/// @nodoc
class _$ItineraryOnEditCopyWithImpl<$Res>
    implements $ItineraryOnEditCopyWith<$Res> {
  _$ItineraryOnEditCopyWithImpl(this._self, this._then);

  final ItineraryOnEdit _self;
  final $Res Function(ItineraryOnEdit) _then;

/// Create a copy of ItineraryOnEdit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? onEdit = freezed,Object? editor = freezed,}) {
  return _then(_self.copyWith(
onEdit: freezed == onEdit ? _self.onEdit : onEdit // ignore: cast_nullable_to_non_nullable
as bool?,editor: freezed == editor ? _self.editor : editor // ignore: cast_nullable_to_non_nullable
as TravelerCore?,
  ));
}
/// Create a copy of ItineraryOnEdit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TravelerCoreCopyWith<$Res>? get editor {
    if (_self.editor == null) {
    return null;
  }

  return $TravelerCoreCopyWith<$Res>(_self.editor!, (value) {
    return _then(_self.copyWith(editor: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItineraryOnEdit].
extension ItineraryOnEditPatterns on ItineraryOnEdit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItineraryOnEdit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItineraryOnEdit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItineraryOnEdit value)  $default,){
final _that = this;
switch (_that) {
case _ItineraryOnEdit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItineraryOnEdit value)?  $default,){
final _that = this;
switch (_that) {
case _ItineraryOnEdit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? onEdit,  TravelerCore? editor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItineraryOnEdit() when $default != null:
return $default(_that.onEdit,_that.editor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? onEdit,  TravelerCore? editor)  $default,) {final _that = this;
switch (_that) {
case _ItineraryOnEdit():
return $default(_that.onEdit,_that.editor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? onEdit,  TravelerCore? editor)?  $default,) {final _that = this;
switch (_that) {
case _ItineraryOnEdit() when $default != null:
return $default(_that.onEdit,_that.editor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ItineraryOnEdit implements ItineraryOnEdit {
  const _ItineraryOnEdit({this.onEdit, this.editor});
  factory _ItineraryOnEdit.fromJson(Map<String, dynamic> json) => _$ItineraryOnEditFromJson(json);

@override final  bool? onEdit;
@override final  TravelerCore? editor;

/// Create a copy of ItineraryOnEdit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItineraryOnEditCopyWith<_ItineraryOnEdit> get copyWith => __$ItineraryOnEditCopyWithImpl<_ItineraryOnEdit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItineraryOnEditToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItineraryOnEdit&&(identical(other.onEdit, onEdit) || other.onEdit == onEdit)&&(identical(other.editor, editor) || other.editor == editor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,onEdit,editor);

@override
String toString() {
  return 'ItineraryOnEdit(onEdit: $onEdit, editor: $editor)';
}


}

/// @nodoc
abstract mixin class _$ItineraryOnEditCopyWith<$Res> implements $ItineraryOnEditCopyWith<$Res> {
  factory _$ItineraryOnEditCopyWith(_ItineraryOnEdit value, $Res Function(_ItineraryOnEdit) _then) = __$ItineraryOnEditCopyWithImpl;
@override @useResult
$Res call({
 bool? onEdit, TravelerCore? editor
});


@override $TravelerCoreCopyWith<$Res>? get editor;

}
/// @nodoc
class __$ItineraryOnEditCopyWithImpl<$Res>
    implements _$ItineraryOnEditCopyWith<$Res> {
  __$ItineraryOnEditCopyWithImpl(this._self, this._then);

  final _ItineraryOnEdit _self;
  final $Res Function(_ItineraryOnEdit) _then;

/// Create a copy of ItineraryOnEdit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? onEdit = freezed,Object? editor = freezed,}) {
  return _then(_ItineraryOnEdit(
onEdit: freezed == onEdit ? _self.onEdit : onEdit // ignore: cast_nullable_to_non_nullable
as bool?,editor: freezed == editor ? _self.editor : editor // ignore: cast_nullable_to_non_nullable
as TravelerCore?,
  ));
}

/// Create a copy of ItineraryOnEdit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TravelerCoreCopyWith<$Res>? get editor {
    if (_self.editor == null) {
    return null;
  }

  return $TravelerCoreCopyWith<$Res>(_self.editor!, (value) {
    return _then(_self.copyWith(editor: value));
  });
}
}

// dart format on
