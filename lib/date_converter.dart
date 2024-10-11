DateTime dateConverter(String yymmdd) {
  String yy = yymmdd.substring(0, 2);
  String mm = yymmdd.substring(2, 4);
  String dd = yymmdd.substring(4, 6);

  int yyyy = int.parse(yy) < 25 ? 2000 + int.parse(yy) : 1900 + int.parse(yy);
  DateTime date = DateTime(yyyy, int.parse(mm), int.parse(dd));
  return date;
}