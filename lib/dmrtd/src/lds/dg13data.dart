import 'package:archive/archive.dart';
import 'dart:core';
import 'dart:typed_data';
import 'dart:convert';

import '../extension/datetime_apis.dart';
import '../extension/string_apis.dart';

class DG13dataParseError implements Exception {
  final String message;
  DG13dataParseError(this.message);
  @override
  String toString() => message;
}

class DG13data {
  late final String dg13dataAfter;

  final Uint8List _encoded;

  DG13data(Uint8List encodedMRZ) : _encoded = encodedMRZ {
    _parse(encodedMRZ);
  }

  Uint8List toBytes() {
    return _encoded;
  }

  String toEncodedString() {
    var data = toBytes();
    final inputStream = InputStream(data);
    var result = _read(inputStream, data.length);

    return result;
  }

  void _parse(Uint8List data) {
    final istream = InputStream(data);
    String latin1Decoded = _read(istream, data.length);
    dg13dataAfter = utf8.decode(latin1.encode(latin1Decoded), allowMalformed: true);
  }

  static String _read(InputStream istream, int maxLength) {
    return istream.readString(size: maxLength);
  }
}