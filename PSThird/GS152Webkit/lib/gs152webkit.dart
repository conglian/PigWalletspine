
import 'gs152webkit_platform_interface.dart';

class Gs152webkit {
  Future<String?> getPlatformVersion() {
    return Gs152webkitPlatform.instance.getPlatformVersion();
  }

  /// 打开浏览器 / intent:// 链接
  Future<void> openBrowser(String url) {
    return Gs152webkitPlatform.instance.openBrowser(url);
  }
}
