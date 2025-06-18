import 'package:flutter/widgets.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/regex.dart';

class CommonValidation {
  String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.emailRequired);
    }
    final emailRegex = RegExp(LocalInputRegex.email);
    if (!emailRegex.hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.emailInvalid);
    }
    return null;
  }

  String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.passwordRequired);
    }
    return null;
  }

  String? validateConfirmPassword(BuildContext context, String? oldValue, String? newValue) {
    if (newValue == null || newValue.isEmpty) {
      return context.readLang.translate(AppLanguageText.confirmPasswordRequired);
    }
    if (oldValue != newValue) {
      return context.readLang.translate(AppLanguageText.confirmPasswordMismatch);
    }
    return null;
  }

  String? commonValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.pleaseEnterData);

  String? dobValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.dobRequired);

  String? nameValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.nameRequired);

  String? validateMobile(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.mobileRequired);
    }
    if (!RegExp(LocalInputRegex.phone).hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.mobileInvalid);
    }
    return null;
  }

  String? companyValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.companyRequired);

  String? visitorNameValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.visitorNameRequired);
    }
    if (!RegExp(LocalInputRegex.onlyAlphabets).hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.visitorNameNumber);
    }
    return null;
  }


  String? vehicleNumberValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.vehicleNumberRequired);

  String? nationalityValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.nationalityRequired);

  String? iDTypeValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.idTypeRequired);

  String? documentNumberValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.documentNumberRequired);

  String? documentNameValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.documentNameRequired);

  String? validateIqama(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.iqamaRequired);
    }
    if (!RegExp(LocalInputRegex.iqamaNumber).hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.iqamaInvalid);
    }
    return null;
  }

  String? validateNationalId(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.nationalIdRequired);
    }
    if (!RegExp(LocalInputRegex.nationalId).hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.nationalIdInvalid);
    }
    return null;
  }

  String? validatePassport(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.passportRequired);
    }
    if (!RegExp(LocalInputRegex.passportNumber).hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.passportInvalid);
    }
    return null;
  }

  String? validateNationalIdExpiryDate(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.nationalIdExpiryRequired);

  String? validateIqamaExpiryDate(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.iqamaExpiryRequired);

  String? validatePassportExpiryDate(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.passportExpiryRequired);

  String? validateDocumentExpiryDate(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.documentExpiryRequired);

  String? lastnameValidator(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.lastnameRequired);

  String? validateLocation(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.locationRequired);

  String? validateVisitRequestType(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.visitRequestTypeRequired);

  String? validateVisitPurpose(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.visitPurposeRequired);

  String? validateMofaHostEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.mofaEmailRequired);
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.invalidMofaEmail);
    }
    return null;
  }

  String? validateVisitStartDate(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.visitStartDateRequired);

  String? validateVisitEndDate(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.visitEndDateRequired);

  String? validateDeviceType(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.deviceTypeRequired);

  String? validateDeviceModel(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.deviceModelRequired);

  String? validateSerialNumber(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.serialNumberRequired);

  String? validateDevicePurpose(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.devicePurposeRequired);

  String? validatePlateType(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.plateTypeRequired);

  String? validatePlateLetter1(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.plateLetter1Required);

  String? validatePlateLetter2(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.plateLetter2Required);

  String? validatePlateLetter3(BuildContext context, String? value) =>
      _requiredFieldValidator(context, value, AppLanguageText.plateLetter3Required);

  String? validatePlateNumber(BuildContext context, String? value)  {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(AppLanguageText.plateNumberRequired);
    }
    if (!RegExp(LocalInputRegex.plateNumber).hasMatch(value)) {
      return context.readLang.translate(AppLanguageText.plateNumberValid);
    }
    return null;
  }

  // Helper method for common required field validations
  String? _requiredFieldValidator(BuildContext context, String? value, String key) {
    if (value == null || value.isEmpty) {
      return context.readLang.translate(key);
    }
    return null;
  }
}

