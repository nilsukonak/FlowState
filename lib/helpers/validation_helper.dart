//edittask ve newtaskta titleyi kontrol etmke için helper func
String? validateNotEmpty(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return '$fieldName bos donemez';
    //return Error();
  }
  return null;
}
