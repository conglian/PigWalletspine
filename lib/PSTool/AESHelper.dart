import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class AESHelper {
  /// 32字节 = AES-256
  static final _key = Key.fromUtf8('12345678901234567890123456789012');

  /// 16字节 IV
  static final _iv = IV.fromUtf8('1234567890123456');

  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  /// 加密
  static String encryptString(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// 解密
  static String decryptString(String encryptedText) {
    final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
