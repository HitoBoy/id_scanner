// Created by Crt Vavros, copyright © 2022 ZeroPass. All rights reserved.
// ignore_for_file: constant_identifier_names

import 'dart:typed_data';
import '../tlv.dart';
import 'dg.dart';
import '../dg13data.dart';



class EfDG13 extends DataGroup {
  static const FID = 0x010D;
  static const SFI = 0x0D;
  static const TAG = DgTag(0x6D);

  late final DG13data _dg13data;
  DG13data get dg13data => _dg13data;

  EfDG13.fromBytes(Uint8List data) : super.fromBytes(data);

  @override
  int get fid => FID;

  @override
  int get sfi => SFI;

  @override
  int get tag => TAG.value;

  @override
  void parseContent(final Uint8List content) {
    final tlv = TLV.fromBytes(content);
    _dg13data = DG13data(tlv.value);
  }
}