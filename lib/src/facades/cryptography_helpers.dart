import 'dart:typed_data';

import 'package:blockchain_utils/hex/hex.dart';
import 'package:pointycastle/digests/sha256.dart';

Uint8List sha256(Uint8List bytes) {
  return SHA256Digest().process(bytes);
}

Uint8List doubleSha256(Uint8List bytes) {
  return sha256(sha256(bytes));
}

String toHex(Uint8List bytes) {
  return hex.encode(bytes);
}

String bigIntToHex(BigInt bigInt) {
  final hex = bigInt.toRadixString(16);
  if (hex.length % 2 == 1) {
    return '0$hex';
  }
  return hex;
}
