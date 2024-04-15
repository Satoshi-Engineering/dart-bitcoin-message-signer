import 'dart:typed_data';

import 'package:blockchain_utils/hex/hex.dart';
import 'package:pointycastle/export.dart';

import 'signature.dart' as signature_facade;

final ECDomainParameters domainParameters = ECDomainParameters('secp256k1');

class PrivateKey {
  PrivateKey({
    required Uint8List privateKey,
  }) :
    _privateKey = _generatePrivateKey(privateKey);
  final ECPrivateKey _privateKey;

  signature_facade.Signature sign(Uint8List message) {
    final signer = ECDSASigner(null, HMac(SHA256Digest(), 64))..init(true, PrivateKeyParameter<ECPrivateKey>(_privateKey));
    final signature = signer.generateSignature(message) as ECSignature;
    return signature_facade.Signature(signature: signature);
  }

  Uint8List get publicKey {
    final publicKey = ECPublicKey(domainParameters.G * _privateKey.d, domainParameters);
    return publicKey.Q!.getEncoded();
  }

  static ECPrivateKey _generatePrivateKey(Uint8List privateKey) {
    return ECPrivateKey(BigInt.parse(hex.encode(privateKey), radix: 16), domainParameters);
  }
}
