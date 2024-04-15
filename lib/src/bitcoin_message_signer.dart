import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'facades/cryptography_helpers.dart';
import 'facades/private_key.dart';
import 'facades/signature.dart';
import 'script_type.dart';

class BitcoinMessageSigner {
  BitcoinMessageSigner({
    required Uint8List privateKey,
    required ScriptType scriptType,
  }) :
    _privateKey = PrivateKey(privateKey: privateKey),
    _scriptType = scriptType;
  final PrivateKey _privateKey;
  final ScriptType _scriptType;

  String signMessage({
    String messagePrefix = 'Bitcoin Signed Message:\n',
    required String message,
  }) {
    final messageHash = _generateMessageHash(messagePrefix, message);
    final signature = _privateKey.sign(messageHash);
    final signatureHeader = _generateSignatureHeaderByte(signature, messageHash);
    return _encodeSignature(signatureHeader, signature);
  }

  Uint8List _generateMessageHash(messagePrefix, message) {
    final messagePrefixBytes = utf8.encode(messagePrefix);
    final messagePrefixSize = _getByteListSize(messagePrefixBytes);
    final messageBytes = utf8.encode(message);
    final messageSize = _getByteListSize(messageBytes);
    final magicMessageBytes = Uint8List.fromList([
      ...messagePrefixSize,
      ...messagePrefixBytes,
      ...messageSize,
      ...messageBytes,
    ]);
    return doubleSha256(magicMessageBytes);
  }

  Uint8List _getByteListSize(Uint8List messageBytes) {
    final messageBytesLength = messageBytes.length;
    if (messageBytesLength < 0xfd) {
      return Uint8List.fromList([messageBytesLength]);
    } else if (messageBytesLength < 0xffff) {
      return Uint8List.fromList([0xfd, messageBytesLength & 0xff, messageBytesLength >> 8]);
    } else if (messageBytesLength < 0xffffffff) {
      return Uint8List.fromList([0xfe, messageBytesLength & 0xff, (messageBytesLength >> 8) & 0xff, (messageBytesLength >> 16) & 0xff, messageBytesLength >> 24]);
    } else {
      return Uint8List.fromList([0xff, messageBytesLength & 0xff, (messageBytesLength >> 8) & 0xff, (messageBytesLength >> 16) & 0xff, (messageBytesLength >> 24) & 0xff, (messageBytesLength >> 32) & 0xff, (messageBytesLength >> 40) & 0xff, (messageBytesLength >> 48) & 0xff, messageBytesLength >> 56]);
    }
  }

  int _generateSignatureHeaderByte(Signature signature, Uint8List messageHash) {
    return _scriptTypeHeaderByte + _getRecoveryId(signature, messageHash);
  }

  int _getRecoveryId(Signature signature, Uint8List messageHash) {
    final publicKey = _privateKey.publicKey;
    for (var recoveryId = 0; recoveryId < 4; recoveryId++) {
      final recoveredPublicKey = signature.recoverPublicKey(messageHash, recoveryId);
      if (listEquals(recoveredPublicKey, publicKey)) {
        print('recoveryId: $recoveryId');
        return recoveryId;
      }
    }
    throw Exception('Could not find recovery id');
  }

  int get _scriptTypeHeaderByte {
    final scriptType = _scriptType;
    switch (scriptType) {
      case P2PKH():
        return scriptType.compressed ? 31 : 27;
      case P2SH():
        return 35;
      case P2WPKH():
        return 39;
    }
  }

  String _encodeSignature(int headerByte, Signature signature) {
    return base64Encode([headerByte, ...signature.bytes]);
  }
}
