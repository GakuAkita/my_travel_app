// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_exchange.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoneyExchange {

 String get sender; String get receiver; double get amount;
/// Create a copy of MoneyExchange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyExchangeCopyWith<MoneyExchange> get copyWith => _$MoneyExchangeCopyWithImpl<MoneyExchange>(this as MoneyExchange, _$identity);

  /// Serializes this MoneyExchange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyExchange&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receiver, receiver) || other.receiver == receiver)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sender,receiver,amount);

@override
String toString() {
  return 'MoneyExchange(sender: $sender, receiver: $receiver, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $MoneyExchangeCopyWith<$Res>  {
  factory $MoneyExchangeCopyWith(MoneyExchange value, $Res Function(MoneyExchange) _then) = _$MoneyExchangeCopyWithImpl;
@useResult
$Res call({
 String sender, String receiver, double amount
});




}
/// @nodoc
class _$MoneyExchangeCopyWithImpl<$Res>
    implements $MoneyExchangeCopyWith<$Res> {
  _$MoneyExchangeCopyWithImpl(this._self, this._then);

  final MoneyExchange _self;
  final $Res Function(MoneyExchange) _then;

/// Create a copy of MoneyExchange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sender = null,Object? receiver = null,Object? amount = null,}) {
  return _then(_self.copyWith(
sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,receiver: null == receiver ? _self.receiver : receiver // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MoneyExchange].
extension MoneyExchangePatterns on MoneyExchange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoneyExchange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoneyExchange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoneyExchange value)  $default,){
final _that = this;
switch (_that) {
case _MoneyExchange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoneyExchange value)?  $default,){
final _that = this;
switch (_that) {
case _MoneyExchange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sender,  String receiver,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoneyExchange() when $default != null:
return $default(_that.sender,_that.receiver,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sender,  String receiver,  double amount)  $default,) {final _that = this;
switch (_that) {
case _MoneyExchange():
return $default(_that.sender,_that.receiver,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sender,  String receiver,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _MoneyExchange() when $default != null:
return $default(_that.sender,_that.receiver,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoneyExchange implements MoneyExchange {
  const _MoneyExchange({required this.sender, required this.receiver, required this.amount});
  factory _MoneyExchange.fromJson(Map<String, dynamic> json) => _$MoneyExchangeFromJson(json);

@override final  String sender;
@override final  String receiver;
@override final  double amount;

/// Create a copy of MoneyExchange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoneyExchangeCopyWith<_MoneyExchange> get copyWith => __$MoneyExchangeCopyWithImpl<_MoneyExchange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoneyExchangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoneyExchange&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receiver, receiver) || other.receiver == receiver)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sender,receiver,amount);

@override
String toString() {
  return 'MoneyExchange(sender: $sender, receiver: $receiver, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$MoneyExchangeCopyWith<$Res> implements $MoneyExchangeCopyWith<$Res> {
  factory _$MoneyExchangeCopyWith(_MoneyExchange value, $Res Function(_MoneyExchange) _then) = __$MoneyExchangeCopyWithImpl;
@override @useResult
$Res call({
 String sender, String receiver, double amount
});




}
/// @nodoc
class __$MoneyExchangeCopyWithImpl<$Res>
    implements _$MoneyExchangeCopyWith<$Res> {
  __$MoneyExchangeCopyWithImpl(this._self, this._then);

  final _MoneyExchange _self;
  final $Res Function(_MoneyExchange) _then;

/// Create a copy of MoneyExchange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sender = null,Object? receiver = null,Object? amount = null,}) {
  return _then(_MoneyExchange(
sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,receiver: null == receiver ? _self.receiver : receiver // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
