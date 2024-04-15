sealed class ScriptType {}

final class P2PKH extends ScriptType {
  P2PKH({ required this.compressed });
  final bool compressed;
}

final class P2SH extends ScriptType {}

final class P2WPKH extends ScriptType {}
