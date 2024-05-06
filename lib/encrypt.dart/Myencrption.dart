import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption {
  // AES encryption key and IV
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(String text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static decryptAES(String base64Encoded) {
    final encrypted = encrypt.Encrypted.fromBase64(base64Encoded);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}


void main() {
  // Example usage
  String text = 'Hello, world!';
  
  // Encrypt
  final encryptedText = MyEncryptionDecryption.encryptAES(text);
  print('Encrypted: $encryptedText');
  
  // Decrypt
  final decryptedText = MyEncryptionDecryption.decryptAES(encryptedText);
  print('Decrypted: $decryptedText');
}
