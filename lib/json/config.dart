import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
    final Set<String> favorites;

    Config(this.favorites);

    factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

    Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
