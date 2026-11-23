import 'package:flutter_test/flutter_test.dart';
import 'package:piggywalletspinearn/PSTool/PSToponChannel.dart';

void main() {
  group('TopOn channel from Adjust', () {
    for (final (network, channel) in [
      ('  UnItY  ', PSToponChannel.unity),
      ('TikTok for Business', PSToponChannel.tiktok),
      ('Mintegral', PSToponChannel.mintegral),
      ('Facebook', PSToponChannel.facebook),
      ('Instagram', PSToponChannel.facebook),
      ('moloco', PSToponChannel.moloco),
      ('  ORGANIC ', PSToponChannel.organic),
      ('Google Ads', PSToponChannel.other),
    ]) {
      test('maps Adjust network "$network" to ${channel.name}', () {
        expect(PSToponChannel.fromAdjust(network: network), channel);
      });
    }

    test('uses the tracker when the network is blank', () {
      expect(
        PSToponChannel.fromAdjust(network: '  ', trackerName: 'Instagram'),
        PSToponChannel.facebook,
      );
      expect(
        PSToponChannel.fromAdjust(trackerName: ' organic '),
        PSToponChannel.organic,
      );
    });

    test('uses the network for a tracker containing another network name', () {
      expect(
        PSToponChannel.fromAdjust(
          network: 'Google Ads',
          trackerName: 'Google campaign with Facebook creative',
        ),
        PSToponChannel.other,
      );
      expect(
        PSToponChannel.fromAdjust(
          network: 'Mintegral',
          trackerName: 'TikTok references',
        ),
        PSToponChannel.mintegral,
      );
    });

    test('leaves absent or blank attribution unresolved', () {
      expect(PSToponChannel.fromAdjust(), isNull);
      expect(
        PSToponChannel.fromAdjust(network: '  ', trackerName: '\n'),
        isNull,
      );
    });
  });
}
