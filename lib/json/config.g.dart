// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config((json['favorites'] as List)?.map((e) => e as String)?.toSet());
}

Map<String, dynamic> _$ConfigToJson(Config instance) =>
    <String, dynamic>{'favorites': instance.favorites?.toList()};
