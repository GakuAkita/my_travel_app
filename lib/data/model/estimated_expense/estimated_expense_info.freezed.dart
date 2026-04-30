// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estimated_expense_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EstimatedExpenseInfo {

 String get id; String get expenseItem; double get amount; int get reimbursedByCnt;
/// Create a copy of EstimatedExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EstimatedExpenseInfoCopyWith<EstimatedExpenseInfo> get copyWith => _$EstimatedExpenseInfoCopyWithImpl<EstimatedExpenseInfo>(this as EstimatedExpenseInfo, _$identity);

  /// Serializes this EstimatedExpenseInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EstimatedExpenseInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseItem, expenseItem) || other.expenseItem == expenseItem)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reimbursedByCnt, reimbursedByCnt) || other.reimbursedByCnt == reimbursedByCnt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expenseItem,amount,reimbursedByCnt);

@override
String toString() {
  return 'EstimatedExpenseInfo(id: $id, expenseItem: $expenseItem, amount: $amount, reimbursedByCnt: $reimbursedByCnt)';
}


}

/// @nodoc
abstract mixin class $EstimatedExpenseInfoCopyWith<$Res>  {
  factory $EstimatedExpenseInfoCopyWith(EstimatedExpenseInfo value, $Res Function(EstimatedExpenseInfo) _then) = _$EstimatedExpenseInfoCopyWithImpl;
@useResult
$Res call({
 String id, String expenseItem, double amount, int reimbursedByCnt
});




}
/// @nodoc
class _$EstimatedExpenseInfoCopyWithImpl<$Res>
    implements $EstimatedExpenseInfoCopyWith<$Res> {
  _$EstimatedExpenseInfoCopyWithImpl(this._self, this._then);

  final EstimatedExpenseInfo _self;
  final $Res Function(EstimatedExpenseInfo) _then;

/// Create a copy of EstimatedExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? expenseItem = null,Object? amount = null,Object? reimbursedByCnt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseItem: null == expenseItem ? _self.expenseItem : expenseItem // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,reimbursedByCnt: null == reimbursedByCnt ? _self.reimbursedByCnt : reimbursedByCnt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EstimatedExpenseInfo].
extension EstimatedExpenseInfoPatterns on EstimatedExpenseInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EstimatedExpenseInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EstimatedExpenseInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EstimatedExpenseInfo value)  $default,){
final _that = this;
switch (_that) {
case _EstimatedExpenseInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EstimatedExpenseInfo value)?  $default,){
final _that = this;
switch (_that) {
case _EstimatedExpenseInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String expenseItem,  double amount,  int reimbursedByCnt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EstimatedExpenseInfo() when $default != null:
return $default(_that.id,_that.expenseItem,_that.amount,_that.reimbursedByCnt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String expenseItem,  double amount,  int reimbursedByCnt)  $default,) {final _that = this;
switch (_that) {
case _EstimatedExpenseInfo():
return $default(_that.id,_that.expenseItem,_that.amount,_that.reimbursedByCnt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String expenseItem,  double amount,  int reimbursedByCnt)?  $default,) {final _that = this;
switch (_that) {
case _EstimatedExpenseInfo() when $default != null:
return $default(_that.id,_that.expenseItem,_that.amount,_that.reimbursedByCnt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EstimatedExpenseInfo implements EstimatedExpenseInfo {
  const _EstimatedExpenseInfo({required this.id, required this.expenseItem, required this.amount, required this.reimbursedByCnt});
  factory _EstimatedExpenseInfo.fromJson(Map<String, dynamic> json) => _$EstimatedExpenseInfoFromJson(json);

@override final  String id;
@override final  String expenseItem;
@override final  double amount;
@override final  int reimbursedByCnt;

/// Create a copy of EstimatedExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EstimatedExpenseInfoCopyWith<_EstimatedExpenseInfo> get copyWith => __$EstimatedExpenseInfoCopyWithImpl<_EstimatedExpenseInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EstimatedExpenseInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EstimatedExpenseInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseItem, expenseItem) || other.expenseItem == expenseItem)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reimbursedByCnt, reimbursedByCnt) || other.reimbursedByCnt == reimbursedByCnt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expenseItem,amount,reimbursedByCnt);

@override
String toString() {
  return 'EstimatedExpenseInfo(id: $id, expenseItem: $expenseItem, amount: $amount, reimbursedByCnt: $reimbursedByCnt)';
}


}

/// @nodoc
abstract mixin class _$EstimatedExpenseInfoCopyWith<$Res> implements $EstimatedExpenseInfoCopyWith<$Res> {
  factory _$EstimatedExpenseInfoCopyWith(_EstimatedExpenseInfo value, $Res Function(_EstimatedExpenseInfo) _then) = __$EstimatedExpenseInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String expenseItem, double amount, int reimbursedByCnt
});




}
/// @nodoc
class __$EstimatedExpenseInfoCopyWithImpl<$Res>
    implements _$EstimatedExpenseInfoCopyWith<$Res> {
  __$EstimatedExpenseInfoCopyWithImpl(this._self, this._then);

  final _EstimatedExpenseInfo _self;
  final $Res Function(_EstimatedExpenseInfo) _then;

/// Create a copy of EstimatedExpenseInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? expenseItem = null,Object? amount = null,Object? reimbursedByCnt = null,}) {
  return _then(_EstimatedExpenseInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseItem: null == expenseItem ? _self.expenseItem : expenseItem // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,reimbursedByCnt: null == reimbursedByCnt ? _self.reimbursedByCnt : reimbursedByCnt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
