import 'package:fe_passkey/features/auth/data/models/passkey_options_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses wrapped response shape with challengeId and publicKey', () {
    final model = PasskeyOptionsModel.fromJson({
      'challengeId': 'challenge-id-123',
      'publicKey': {
        'challenge': 'challenge-raw',
        'rp': {'id': 'localhost', 'name': 'PassAuth Starter'},
      },
    });

    expect(model.challengeId, 'challenge-id-123');
    expect(model.publicKey['challenge'], 'challenge-raw');
  });

  test('parses raw WebAuthn options response shape', () {
    final model = PasskeyOptionsModel.fromJson({
      'challenge': 'challenge-raw',
      'rp': {'id': 'localhost', 'name': 'PassAuth Starter'},
      'user': {
        'id': 'abc',
        'name': 'the@tormentor.com',
        'displayName': 'the@tormentor.com',
      },
    });

    expect(model.challengeId, 'challenge-raw');
    expect(model.publicKey['rp']['id'], 'localhost');
    expect(model.publicKey['challenge'], 'challenge-raw');
  });
}
