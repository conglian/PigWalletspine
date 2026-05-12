import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gs152webkit_method_channel.dart';

abstract class Gs152webkitPlatform extends PlatformInterface {
  /// Constructs a Gs152webkitPlatform.
  Gs152webkitPlatform() : super(token: _token);

  static final Object _token = Object();

  static Gs152webkitPlatform _instance = MethodChannelGs152webkit();

  /// The default instance of [Gs152webkitPlatform] to use.
  ///
  /// Defaults to [MethodChannelGs152webkit].
  static Gs152webkitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Gs152webkitPlatform] when
  /// they register themselves.
  static set instance(Gs152webkitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }


  /// 打开浏览器 / intent:// 链接
  Future<void> openBrowser(String url) {
    throw UnimplementedError('openBrowser() has not been implemented.');
  }
}
