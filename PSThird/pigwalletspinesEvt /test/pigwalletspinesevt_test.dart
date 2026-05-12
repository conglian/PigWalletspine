import 'package:flutter_test/flutter_test.dart';
import 'package:pigwalletspinesevt/pigwalletspinesevt.dart';
import 'package:pigwalletspinesevt/pigwalletspinesevt_platform_interface.dart';
import 'package:pigwalletspinesevt/pigwalletspinesevt_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPigwalletspinesevtPlatform
    with MockPlatformInterfaceMixin
    implements PigwalletspinesevtPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PigwalletspinesevtPlatform initialPlatform = PigwalletspinesevtPlatform.instance;

  test('$MethodChannelPigwalletspinesevt is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPigwalletspinesevt>());
  });

  test('getPlatformVersion', () async {
    Pigwalletspinesevt pigwalletspinesevtPlugin = Pigwalletspinesevt();
    MockPigwalletspinesevtPlatform fakePlatform = MockPigwalletspinesevtPlatform();
    PigwalletspinesevtPlatform.instance = fakePlatform;

    expect(await pigwalletspinesevtPlugin.getPlatformVersion(), '42');
  });
}
