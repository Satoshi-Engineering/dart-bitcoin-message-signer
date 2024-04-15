### Bitcoin Message Signer

A dart library to sign message like Bitcoin core.


### How to use

Add the dependency: `dart pub add bitcoin_message_signer` or `flutter pub add bitcoin_message_signer`


Use it to sign messages with a bech32 script (`bc1...` address):
```dart
import 'package:bitcoin_message_signer/bitcoin_message_signer.dart';

/// ...

final signer = BitcoinMessageSigner(
  privateKey: Uint8List.fromList(privateKey),
  scriptType: P2WPKH(),
);
final signature = signer.signMessage(message: 'Hello Bitcoin-World!');
```


### Supported script types

* P2PKH uncompressed: `1...` address from an uncompressed private key (`5...`)
* P2PKH compressed: `1...` address from a compressed private key (`L...` or `K...`)
* P2SH: `3...` addresses
* P2WPKH: `bc1...` addresses

Checkout examples in the [tests](test/bitcoin_message_signer_test.dart).


### Where do I get the private key from?

This depends on the bitcoin library you use. E.g. [bdk_flutter](https://pub.dev/packages/bdk_flutter) returns the private key as `List<int>`, therefore you can simply transform it using `Uint8List.fromList(privateKey)`. Most other libraries probably return the private key either as list too, as hex string or in WIF format. In either case you probably need another library to transform the private key into a `Uint8List`.
