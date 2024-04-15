import 'dart:typed_data';

import 'package:bitcoin_message_signer/bitcoin_message_signer.dart';
import 'package:blockchain_utils/binary/utils.dart';
import 'package:test/test.dart';

void main() async {
  test('sign message with uncompressed P2PKH', () async {
    final privateKey = 'f620b018e293ab0d9da7684f2a05468c973a76a45437371d52c1f9d004a8fd7f'; // 5KggamFVV1cKFrTLPcRQYfq47eFEneopWWNvJZXQMHvtn5oSXx6
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2PKH(compressed: false),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'G2a0QoonIo88uWISveHE3ZUR4d+bdZUVDxdhQ9hJ7wOAOQEfdtPeR0KE6Eg3/v73yQHKgT2um+tPl6QgQqaLwwM=');
  });

  test('sign message with uncompressed P2PKH and recoveryId == 1', () async {
    final privateKey = '3f02cf1d2efc78b7c0ad035e8a227d32824008cf32a0e7c312bcebcebc0e45fa'; // 5JJ37Tq2Got1yj6kgsexSKgmvKq5gEcP78mu1KBkmrcMdt9b638
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2PKH(compressed: false),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'HAseJPmrVTbKlJynTJ4sMnTSTaEvFk+G4ygJywixWqDt67P1+sqUBJxLLMm/0AWXkZwLmn1RdkktXqLIluQ14sc=');
  });

  test('sign message with compressed P2PKH', () async {
    final privateKey = '22c26cb9adb12d17fe3450702b7f370c820cdaf1f71e25259151b76563658641'; // KxPH7yTvEayd6Qj8h67J3FQBWzswbcwin3E8nfSy1eAAGFeK9eGo
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2PKH(compressed: true),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'H6wAsrDvIYDutMqdQDpGj7ZMbospq6V5cw+7neflqNXPJ7S3GJzzwRZA3rM76m3o4Ba4LHPrDoG2GJi5cTtE2Jo=');
  });

  test('sign message with compressed P2PKH and recoveryId == 1', () async {
    final privateKey = 'c6dcacc30be146df8f64e081e5cd0d9f8f1160d2f9f9b2ee913047f67da1f23f'; // L3tGmRvWu2V2anHuYVDmQPhkY8hhsvoFe7Pj4r7WwneDC2x3tQsQ
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2PKH(compressed: true),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'IM2PkjZk13ztGqh3vb0HsL5UQCF0p/wvWqpSc2XsU5a1UAlkr4pCwjJNsN7l+5b8vM8G8EpEwzqVyp3gZf2rSoI=');
  });

  test('sign message with P2SH', () async {
    final privateKey = '481c2b35ce143b1baa3b147a7d4b3b18f7304ca9e9452eb1a0278fe90d43bf1b'; // KydtBtnbPss4AmR98motzDPSSg3y9gLQFaqxVVfYF5iXmsjm9hTf
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2SH(),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'I2So298Xf/7kxysGPthnUNHbeKYj3nr2Yxw0x9pRIPn8Dr4lvtLHrhrS1VmkHhg5bbFB4mSHHfIrrEscno2b6AQ=');
  });

  test('sign message with P2SH and recoveryId == 1', () async {
    final privateKey = 'f3c112677b79d6e12c459a5a182402c2ef5a14b9edcf9ff001df600d5dffd404'; // L5PY7HgidUp57Fbk5xvuZPNhiZ3mY6Xin1u257iWS3sxSkT34DMb
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2SH(),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'JFjUxtiS2G7PaTh93bdcyTd9SRGe5uDHB8B6fuhps5OYYoAkqCO6LzviE+7JSwTsaat3si7yswL4GSJyXW0nLwU=');
  });

  test('sign message with P2WPKH', () async {
    final privateKey = 'fbd41ddbd2d877fa9b7911aeefd12f0d354a582a951172ce1fa3519aa7f2dfae'; // L5fETAwYWGRA1eWCHk8AgH2FX2rxLp64winwoAoRGpz1aQMp3Rai
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2WPKH(),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'J9Nz1joGRs/TefibvImAXPCN1bgj9PcXgM8D8rcgo2N5V4V3oaPp4YhG1Ga8Ced/lZZtkQFPAey9jlm7eipzPE4=');
  });

  test('sign message with P2WPKH and recoveryId == 1', () async {
    final privateKey = 'b9078f929af3278d11f157698c357b36f8237b3d9a289a7bdbd41dc675ecf196'; // L3RPERdnWEtYXttJ9V9rtTjZVjDZB4xCuqdneNpFkZJ1PHx9dE5s
    final signer = BitcoinMessageSigner(
      privateKey: Uint8List.fromList(BytesUtils.fromHexString(privateKey)),
      scriptType: P2WPKH(),
    );
    final signature = signer.signMessage(message: 'hello');
    expect(signature, 'KIQp5daJG950+rxaBig2HtlCCi2yCCJv9xmXaP3i+zppGTWvQzk9LNczLcS/ykOP0keHXxZMX1lGpRY8LPKi3Wk=');
  });
}
