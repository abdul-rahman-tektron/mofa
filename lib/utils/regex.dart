class LocalInputRegex {
  // Regular expression for validating email addresses
  static const String email =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  // Regular expression for validating passwords
  static const String password =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  // Regular expression for validating full names
  static const String fullName = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";

  // Regular expression for validating phone numbers
  static const String phone = r'^\d{1,14}$';

  // Regular expression for matching only alphabetic characters
  static const String onlyAlphabets = r'[a-zA-Z]';

  // Regular expression for matching alphanumeric characters
  static const String onlyAlphaNumeric = r'[a-zA-Z0-9]';

  static const String iqamaNumber = r'^\d{1,10}$';

  static const String nationalId = r'^\d{1,10}$';

  static const String passportNumber = r'^[A-PR-WY][0-9]{6,9}$';
}
