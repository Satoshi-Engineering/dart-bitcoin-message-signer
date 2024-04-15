import 'dart:typed_data';

import 'package:blockchain_utils/binary/utils.dart';
import 'package:blockchain_utils/crypto/crypto/cdsa/curve/curves.dart';
import 'package:blockchain_utils/crypto/crypto/cdsa/ecdsa/public_key.dart';
import 'package:blockchain_utils/crypto/crypto/cdsa/ecdsa/signature.dart';
import 'package:blockchain_utils/crypto/crypto/cdsa/point/ec_projective_point.dart';
import 'package:pointycastle/export.dart';

import 'cryptography_helpers.dart';

class Signature {
  Signature({
    required ECSignature signature,
  }) :
    _signature = signature;
  final ECSignature _signature;

  Uint8List get bytes {
    final hex = bigIntToHex(_signature.r) + bigIntToHex(_signature.s);
    return Uint8List.fromList(BytesUtils.fromHexString(hex));
  }

  Uint8List recoverPublicKey(Uint8List messageHash, int recoveryId) {
    final blockchainUtilsSignature = ECDSASignature(_getR(recoveryId), _signature.s);
    final publicKey = _recoverPublicKey(blockchainUtilsSignature, messageHash, recoveryId);
    return Uint8List.fromList(publicKey.point.toBytes());
  }

  BigInt _getR(int recoveryId) {
    // comment taken from: https://github.com/bitcoinj/bitcoinj/pull/3361/commits/39a75249404f442985fd250f65b6a1f29fa9b80b
    //
    // The value r in the signature (r,s) is the x-coordinate mod n of the point R
    // R is the public key of k (the nonce used when creating the signature)
    //
    // There are now 4 possible matching public keys R (the pubkey from the nonce k), indicated by recoveryId:
    //
    // - recoveryId 0: x-coordinate of R was smaller than n, the y-coordinate of R was even
    // - recoveryId 1: x-coordinate of R was smaller than n, the y-coordinate of R was odd
    // - recoveryId 2: x-coordinate of R was greater than n (but smaller than p), the y-coordinate of R was even
    // - recoveryId 3: x-coordinate of R was greater than n (but smaller than p), the y-coordinate of R was odd
    //
    // Keep in mind, that the value r was taken "mod n" (n = order of the curve) but the valid range for
    // coordinate values of points is 0 to p-1 (p being the prime of the prime field Fp which is larger than n).
    // So if the x-coordinate originally was >n, we need to add n to r here again to get the original value.

    // But it is very very unlikely (but not impossible) to ever see recoveryId 2 or 3, because
    // n is almost as large as p in secp256k1.
    // The chances to ever see this are 1 to 2.677 * 10^38  ( 1 to n/(p-n) )
    if (recoveryId > 1) {
      return _signature.r + Curves.generatorSecp256k1.order!;
    }
    return _signature.r;
  }

  ECDSAPublicKey _recoverPublicKey(ECDSASignature signature, Uint8List messageHash, int recoveryId) {
    final generator = ProjectiveECCPoint.fromAffine(Curves.generatorSecp256k1);
    final publicKey = signature.recoverPublicKey(messageHash, generator, recoveryId % 2);
    return publicKey!;
  }
}
