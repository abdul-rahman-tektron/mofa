import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

const key = "c4a96b70e821d3f9d2e6f1b8574c03ed";
const iv = "dabc2f931e84f670";

String encryptAES(String plainText) {
  if (plainText.isEmpty) return '';

  final keyBytes = encrypt.Key.fromUtf8(key);
  final ivBytes = encrypt.IV.fromUtf8(iv);

  final encrypter = encrypt.Encrypter(
    encrypt.AES(
      keyBytes,
      mode: encrypt.AESMode.cbc,
      padding: 'PKCS7',
    ),
  );

  final encrypted = encrypter.encrypt(plainText, iv: ivBytes);
  return encrypted.base64;
}


String decryptAES(String encryptedText) {
  final keyBytes = encrypt.Key.fromUtf8(key);
  final ivBytes = encrypt.IV.fromUtf8(iv);

  final encrypter = encrypt.Encrypter(
    encrypt.AES(
      keyBytes,
      mode: encrypt.AESMode.cbc,
      padding: 'PKCS7',
    ),
  );

  final decrypted = encrypter.decrypt64(encryptedText, iv: ivBytes);
  return decrypted;
}