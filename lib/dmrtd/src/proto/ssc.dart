// Created by Crt Vavros, copyright © 2022 ZeroPass. All rights reserved.
import 'dart:typed_data';

import '../../extensions.dart';
import '../crypto/aes.dart';
import '../crypto/des.dart';


/// Class represents Send Sequence Counter as specified in
/// section 9.8.2 of ICAO 9303 p11 doc.
///
/// SSC by definition is unsigned integer whose bit size
/// is equal to the block size of block cipher.
class SSC {
  final int bitSize;
  late BigInt _ssc;

  /// Constructs new [SSC] with [ssc] bytes.
  /// [bitSize] should be equal to the block size of block cipher.
  SSC(Uint8List ssc, this.bitSize) {
    if((bitSize % 8) != 0) {
      throw ArgumentError.value(bitSize, null, "(bitSize) must be multiple of 8");
    }

    _ssc = BigInt.parse(ssc.hex(), radix: 16);
    if(_ssc.bitLength > bitSize) {
      throw ArgumentError.value(ssc, null, "Bit size of provided argument (ssc) is greater than argument (bitSize)");
    }
  }

  void increment() {
    _ssc  += BigInt.from(1);
    if(_ssc.bitLength > bitSize) {
      _ssc = BigInt.from(0);
    }
  }

  Uint8List toBytes() {
    final padLen = (bitSize / 8).round() * 2;
    final hexSSC = _ssc.toRadixString(16)
                       .padLeft(padLen , '0');
    return hexSSC.parseHex();
  }
}

class DESedeSSC extends SSC {
  DESedeSSC(Uint8List ssc) :
    super(ssc, DESedeCipher.blockSize * 8);
}

class DESede_PACE_SSC extends SSC {
  DESede_PACE_SSC() :
        super(Uint8List(8), DESedeCipher.blockSize * 8);
}

class AES_SSC extends SSC {
  // icao 9303 p11 doc section 9.8.7.3 specifies that AES SSC is 16 bytes long and is initialized to 0.
  AES_SSC() : super(Uint8List(16), AESCipher128().size * 8);
}