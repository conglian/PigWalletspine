import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pigwalletspinesevt_method_channel.dart';

abstract class PigwalletspinesevtPlatform extends PlatformInterface {
  /// Constructs a PigwalletspinesevtPlatform.
  PigwalletspinesevtPlatform() : super(token: _token);

  static final Object _token = Object();

  static PigwalletspinesevtPlatform _instance = MethodChannelPigwalletspinesevt();

  /// The default instance of [PigwalletspinesevtPlatform] to use.
  ///
  /// Defaults to [MethodChannelPigwalletspinesevt].
  static PigwalletspinesevtPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PigwalletspinesevtPlatform] when
  /// they register themselves.
  static set instance(PigwalletspinesevtPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
