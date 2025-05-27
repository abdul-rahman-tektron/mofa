
import 'package:mofa/utils/regex.dart';

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

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile Number is required.';
    }
    final regex = RegExp(LocalInputRegex.phone);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid number.';
    }
    return null;
  }

  String? companyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company is Required';
    }
    return null;
  }

  String? visitorNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Visitor Name is Required';
    }
    return null;
  }

  String? vehicleNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle Number is Required';
    }
    return null;
  }

  String? nationalityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nationality is Required';
    }
    return null;
  }

  String? iDTypeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID Type is Required';
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

  String? validateIqama(String? value) {
      if (value == null || value.isEmpty) {
        return 'Iqama is required.';
      }
      if (!RegExp(LocalInputRegex.iqamaNumber).hasMatch(value)) {
        return 'Enter a valid iqama number.';
      }
    return null;
  }

  String? validateNationalId(String? value) {
      if (value == null || value.isEmpty) {
        return 'National ID is required.';
      }
      if (!RegExp(LocalInputRegex.nationalId).hasMatch(value)) {
        return 'Enter a valid National ID.';
      }
    return null;
  }

  String? validateNationalIdExpiryDate(String? value) {
      if (value == null || value.isEmpty) {
        return 'National ID Expiry Date is required.';
      }
    return null;
  }

  String? validateIqamaExpiryDate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Iqama Expiry Date is required.';
      }
    return null;
  }

  String? validatePassportExpiryDate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Passport Expiry Date is required.';
      }
    return null;
  }

  String? validateDocumentExpiryDate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Document Expiry Date is required.';
      }
    return null;
  }

  String? validatePassport(String? value) {
      if (value == null || value.isEmpty) {
        return 'Passport Number is required.';
      }
      if (!RegExp(LocalInputRegex.passportNumber).hasMatch(value)) {
        return 'Enter valid Passport Number';
      }
    return null;
  }

  String? lastnameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Lastname';
    }
    return null;
  }

  // Validates location input
  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

// Validates visit request type input
  String? validateVisitRequestType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Visit request type is required';
    }
    return null;
  }

// Validates visit purpose input
  String? validateVisitPurpose(String? value) {
    if (value == null || value.isEmpty) {
      return 'Visit purpose is required';
    }
    return null;
  }

// Validates MOFA host email input
  String? validateMofaHostEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Basic email format check
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

// Validates visit start date input
  String? validateVisitStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Visit start date is required';
    }
    return null;
  }

// Validates visit end date input
  String? validateVisitEndDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Visit end date is required';
    }
    return null;
  }

  // Validates device type
  String? validateDeviceType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Device type is required';
    }
    return null;
  }

  // Validates device model
  String? validateDeviceModel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Device model is required';
    }
    return null;
  }

  // Validates serial number
  String? validateSerialNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Serial number is required';
    }
    return null;
  }

  // Validates device purpose
  String? validateDevicePurpose(String? value) {
    if (value == null || value.isEmpty) {
      return 'Device purpose is required';
    }
    return null;
  }

}
