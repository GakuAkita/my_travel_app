// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseInfo {

 String? get id; TravelerCore get payer; Map<String, Map<String, String>> get reimbursedBy; String get expenseItem; int get expense;/* nameを変える場合はFirebaseDatabaseServiceも変えないとだめ */
@JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson) int? get createdAt;
/// Create a copy of ExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseInfoCopyWith<ExpenseInfo> get copyWith => _$ExpenseInfoCopyWithImpl<ExpenseInfo>(this as ExpenseInfo, _$identity);

  /// Serializes this ExpenseInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.payer, payer) || other.payer == payer)&&const DeepCollectionEquality().equals(other.reimbursedBy, reimbursedBy)&&(identical(other.expenseItem, expenseItem) || other.expenseItem == expenseItem)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,payer,const DeepCollectionEquality().hash(reimbursedBy),expenseItem,expense,createdAt);

@override
String toString() {
  return 'ExpenseInfo(id: $id, payer: $payer, reimbursedBy: $reimbursedBy, expenseItem: $expenseItem, expense: $expense, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExpenseInfoCopyWith<$Res>  {
  factory $ExpenseInfoCopyWith(ExpenseInfo value, $Res Function(ExpenseInfo) _then) = _$ExpenseInfoCopyWithImpl;
@useResult
$Res call({
 String? id, TravelerCore payer, Map<String, Map<String, String>> reimbursedBy, String expenseItem, int expense,@JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson) int? createdAt
});


$TravelerCoreCopyWith<$Res> get payer;

}
/// @nodoc
class _$ExpenseInfoCopyWithImpl<$Res>
    implements $ExpenseInfoCopyWith<$Res> {
  _$ExpenseInfoCopyWithImpl(this._self, this._then);

  final ExpenseInfo _self;
  final $Res Function(ExpenseInfo) _then;

/// Create a copy of ExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? payer = null,Object? reimbursedBy = null,Object? expenseItem = null,Object? expense = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,payer: null == payer ? _self.payer : payer // ignore: cast_nullable_to_non_nullable
as TravelerCore,reimbursedBy: null == reimbursedBy ? _self.reimbursedBy : reimbursedBy // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, String>>,expenseItem: null == expenseItem ? _self.expenseItem : expenseItem // ignore: cast_nullable_to_non_nullable
as String,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of ExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TravelerCoreCopyWith<$Res> get payer {
  
  return $TravelerCoreCopyWith<$Res>(_self.payer, (value) {
    return _then(_self.copyWith(payer: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExpenseInfo].
extension ExpenseInfoPatterns on ExpenseInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseInfo value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  TravelerCore payer,  Map<String, Map<String, String>> reimbursedBy,  String expenseItem,  int expense, @JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson)  int? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseInfo() when $default != null:
return $default(_that.id,_that.payer,_that.reimbursedBy,_that.expenseItem,_that.expense,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  TravelerCore payer,  Map<String, Map<String, String>> reimbursedBy,  String expenseItem,  int expense, @JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson)  int? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExpenseInfo():
return $default(_that.id,_that.payer,_that.reimbursedBy,_that.expenseItem,_that.expense,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  TravelerCore payer,  Map<String, Map<String, String>> reimbursedBy,  String expenseItem,  int expense, @JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson)  int? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseInfo() when $default != null:
return $default(_that.id,_that.payer,_that.reimbursedBy,_that.expenseItem,_that.expense,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseInfo implements ExpenseInfo {
  const _ExpenseInfo({required this.id, required this.payer, required final  Map<String, Map<String, String>> reimbursedBy, required this.expenseItem, required this.expense, @JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson) this.createdAt}): _reimbursedBy = reimbursedBy;
  factory _ExpenseInfo.fromJson(Map<String, dynamic> json) => _$ExpenseInfoFromJson(json);

@override final  String? id;
@override final  TravelerCore payer;
 final  Map<String, Map<String, String>> _reimbursedBy;
@override Map<String, Map<String, String>> get reimbursedBy {
  if (_reimbursedBy is EqualUnmodifiableMapView) return _reimbursedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reimbursedBy);
}

@override final  String expenseItem;
@override final  int expense;
/* nameを変える場合はFirebaseDatabaseServiceも変えないとだめ */
@override@JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson) final  int? createdAt;

/// Create a copy of ExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseInfoCopyWith<_ExpenseInfo> get copyWith => __$ExpenseInfoCopyWithImpl<_ExpenseInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.payer, payer) || other.payer == payer)&&const DeepCollectionEquality().equals(other._reimbursedBy, _reimbursedBy)&&(identical(other.expenseItem, expenseItem) || other.expenseItem == expenseItem)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,payer,const DeepCollectionEquality().hash(_reimbursedBy),expenseItem,expense,createdAt);

@override
String toString() {
  return 'ExpenseInfo(id: $id, payer: $payer, reimbursedBy: $reimbursedBy, expenseItem: $expenseItem, expense: $expense, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseInfoCopyWith<$Res> implements $ExpenseInfoCopyWith<$Res> {
  factory _$ExpenseInfoCopyWith(_ExpenseInfo value, $Res Function(_ExpenseInfo) _then) = __$ExpenseInfoCopyWithImpl;
@override @useResult
$Res call({
 String? id, TravelerCore payer, Map<String, Map<String, String>> reimbursedBy, String expenseItem, int expense,@JsonKey(name: 'createdAt', fromJson: _createdAtFromJson, toJson: _createdAtToJson) int? createdAt
});


@override $TravelerCoreCopyWith<$Res> get payer;

}
/// @nodoc
class __$ExpenseInfoCopyWithImpl<$Res>
    implements _$ExpenseInfoCopyWith<$Res> {
  __$ExpenseInfoCopyWithImpl(this._self, this._then);

  final _ExpenseInfo _self;
  final $Res Function(_ExpenseInfo) _then;

/// Create a copy of ExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? payer = null,Object? reimbursedBy = null,Object? expenseItem = null,Object? expense = null,Object? createdAt = freezed,}) {
  return _then(_ExpenseInfo(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,payer: null == payer ? _self.payer : payer // ignore: cast_nullable_to_non_nullable
as TravelerCore,reimbursedBy: null == reimbursedBy ? _self._reimbursedBy : reimbursedBy // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, String>>,expenseItem: null == expenseItem ? _self.expenseItem : expenseItem // ignore: cast_nullable_to_non_nullable
as String,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of ExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TravelerCoreCopyWith<$Res> get payer {
  
  return $TravelerCoreCopyWith<$Res>(_self.payer, (value) {
    return _then(_self.copyWith(payer: value));
  });
}
}

// dart format on
