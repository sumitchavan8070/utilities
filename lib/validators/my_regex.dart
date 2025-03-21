class MyRegex {
  static final RegExp alphabetRegex = RegExp(r'^[a-zA-Z\s]+$');
  static final numericRegex = RegExp(r'^[0-9]+(\.[0-9]*)?$');
  static final numericRegexWithoutDecimal = RegExp(r'^[0-9]+$');
  static final RegExp alphaNumeric = RegExp(r'[A-Z0-9]');
  static final RegExp emailPattern = RegExp(r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$');
  static final RegExp isPan = RegExp(r'^([A-Z]){5}([0-9]){4}([A-Z])$');
  static final RegExp email = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final RegExp gstNumberValidate = RegExp(
      r'^([0-9]{2})([A-Z]{5})([0-9]{4})([A-Z]{1})([1-9A-Z]{1})(Z)([0-9A-Z]{1})$');


}
