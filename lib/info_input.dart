import 'date_converter.dart';

class InfoInput {

  late final String documentNumber;
  late final DateTime birthdate;
  late final DateTime expirydate;

  InfoInput(List<String> mrzCode) {
    documentNumber = mrzCode.first.substring(5,14);
    birthdate = dateConverter(mrzCode[1].substring(0,6));
    expirydate = dateConverter(mrzCode[1].substring(8,14));
  }
}