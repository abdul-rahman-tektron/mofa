
import 'package:mofa/utils/common/regex.dart';

class CommonValidation {
  // Validates email input
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(LocalInputRegex.email);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validates password input
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  // Validates password input
  String? validateConfirmPassword(String? oldValue, String? newValue) {
    if (newValue == null || newValue.isEmpty) {
      return 'Required confirm password';
    }
    if (oldValue != newValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Common validator for generic input validation
  String? commonValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter data';
    }
    return null;
  }

  String? dobValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required dob';
    }
    return null;
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is Required';
    }
    return null;
  }

  String? mobileNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile Number is Required';
    }
    return null;
  }

  String? companyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company is Required';
    }
    return null;
  }

  String? documentNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Document Number is Required';
    }
    return null;
  }

  String? documentNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Document Name is Required';
    }
    return null;
  }

  String? passportNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Passport Number is Required';
    }
    return null;
  }

  String? iqamaValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Iqama is Required';
    }
    return null;
  }

  String? nationalityIdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nationality ID is Required';
    }
    return null;
  }

  String? lastnameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Lastname';
    }
    return null;
  }

}
