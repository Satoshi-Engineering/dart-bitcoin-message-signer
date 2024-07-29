## Bitcoin Message Signer
_by [#sathoshiengineeringcrew](https://satoshiengineering.com/)_

[![MIT License Badge](doc/img/licence-badge.svg)](LICENSE)

A dart library to sign messages like [Bitcoin core](https://bitcoincore.org/en/doc/27.0.0/rpc/util/signmessagewithprivkey/).


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

This depends on the bitcoin library you use: 
- [bdk_flutter](https://pub.dev/packages/bdk_flutter) returns the private key as `List<int>`, therefore you can simply transform it using `Uint8List.fromList(privateKey)`. 
- **Most other libraries** probably return the private key either as list too, as hex string or in WIF format.
- If the **private key is in WIF format**, you probably need another library to transform the private key into a `Uint8List`. You just have to find a library.

> [!TIP]
> **Testing a private key in (bitcoin) WIF format:** You will need to use a conversion tool, e.g. you can use a converter like the one found at https://privatekeys.pw/calc for testing these keys (*WIF --> Priv*). Additionally, a simple Google search for "bitcoin WIF to HEX" will provide multiple tool options.


### Verify the signature

https://www.verifybitcoinmessage.com/


### Tip us

If you like this project, add ideas, contribute or why not [send some tip love?](https://satoshiengineering.com/tipjar/)
