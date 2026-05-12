import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gs152webkit_platform_interface.dart';

/// An implementation of [Gs152webkitPlatform] that uses method channels.
class MethodChannelGs152webkit extends Gs152webkitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gs152webkit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> openBrowser(String url) async {
    try {
      await methodChannel.invokeMethod('openBrowser', {'url': url});
    } catch (e) {
      print('Gs152pacess openBrowser error: $e');
    }
  }
}
