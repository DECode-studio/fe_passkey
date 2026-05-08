import 'package:json_annotation/json_annotation.dart';

part 'passkey_options_model.g.dart';

@JsonSerializable(createFactory: false)
class PasskeyOptionsModel {
  const PasskeyOptionsModel({
    required this.challengeId,
    required this.publicKey,
  });

  final String challengeId;
  final Map<String, dynamic> publicKey;

  factory PasskeyOptionsModel.fromJson(Map<String, dynamic> json) {
    final publicKey = json['publicKey'] is Map
        ? Map<String, dynamic>.from(json['publicKey'] as Map)
        : Map<String, dynamic>.from(json);

    final challengeId = (json['challengeId'] as String?) ??
        (publicKey['challenge'] as String?) ??
        '';

    return PasskeyOptionsModel(
      challengeId: challengeId,
      publicKey: publicKey,
    );
  }

  Map<String, dynamic> toJson() => _$PasskeyOptionsModelToJson(this);
}
