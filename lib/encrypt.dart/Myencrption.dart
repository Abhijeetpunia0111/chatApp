import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption {
  static final key = encrypt.Key.fromLength(32);

  static String encryptAES(String text, String iv) {
    final ivData = encrypt.IV.fromBase64(iv);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: ivData);
    return encrypted.base64;
  }

  static String decryptAES(String base64Encoded, String iv) {
    final ivData = encrypt.IV.fromBase64(iv);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(base64Encoded, iv: ivData);
    return decrypted;
  }

  static String generateRandomIV() {
    final random = encrypt.Encrypted.fromBase64(base64Encode(encrypt.IV.fromLength(16).bytes));
    return random.base64;
  }
}
