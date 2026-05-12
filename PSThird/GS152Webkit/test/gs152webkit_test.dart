import 'package:flutter_test/flutter_test.dart';
import 'package:gs152webkit/gs152webkit.dart';
import 'package:gs152webkit/gs152webkit_platform_interface.dart';
import 'package:gs152webkit/gs152webkit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGs152webkitPlatform
    with MockPlatformInterfaceMixin
    implements Gs152webkitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Gs152webkitPlatform initialPlatform = Gs152webkitPlatform.instance;

  test('$MethodChannelGs152webkit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGs152webkit>());
  });

  test('getPlatformVersion', () async {
    Gs152webkit gs152webkitPlugin = Gs152webkit();
    MockGs152webkitPlatform fakePlatform = MockGs152webkitPlatform();
    Gs152webkitPlatform.instance = fakePlatform;

    expect(await gs152webkitPlugin.getPlatformVersion(), '42');
  });
}
