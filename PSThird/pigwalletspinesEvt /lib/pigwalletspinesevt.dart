
import 'pigwalletspinesevt_platform_interface.dart';

class Pigwalletspinesevt {
  Future<String?> getPlatformVersion() {
    return PigwalletspinesevtPlatform.instance.getPlatformVersion();
  }
}
