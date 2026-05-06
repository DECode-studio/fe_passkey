import 'package:json_annotation/json_annotation.dart';

part 'passkey_options_model.g.dart';

@JsonSerializable()
class PasskeyOptionsModel {
  const PasskeyOptionsModel({
    required this.challengeId,
    required this.publicKey,
  });

  final String challengeId;
  final Map<String, dynamic> publicKey;

  factory PasskeyOptionsModel.fromJson(Map<String, dynamic> json) => _$PasskeyOptionsModelFromJson(json);
  Map<String, dynamic> toJson() => _$PasskeyOptionsModelToJson(this);
}
