// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_usecase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginParamsDTO _$LoginParamsFromJson(Map<String, dynamic> json) =>
    LoginParamsDTO(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginParamsToJson(LoginParamsDTO instance) =>
    <String, dynamic>{
      'username': instance.email,
      'password': instance.password,
    };
