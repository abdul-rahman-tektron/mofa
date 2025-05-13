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
  static const String phone = r"^((\+923))\d{9}$";

  // Regular expression for matching only alphabetic characters
  static const String onlyAlphabets = r'[a-zA-Z]';

  // Regular expression for matching alphanumeric characters
  static const String onlyAlphaNumeric = r'[a-zA-Z0-9]';
}
