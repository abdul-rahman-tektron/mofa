import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/register/register_request.dart';
import 'package:mofa/core/remote/service/apply_pass_repository.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/extensions.dart';

class RegisterNotifier extends BaseChangeNotifier with CommonFunctions{

  // Data Controller
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _visitorCompanyNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _nationalIdController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _idTypeController = TextEditingController();
  TextEditingController _documentNameController = TextEditingController();
  TextEditingController _documentNumberController = TextEditingController();
  TextEditingController _iqamaController = TextEditingController();
  TextEditingController _visaController = TextEditingController();
  TextEditingController _passportNumberController = TextEditingController();

  // Key
  final formKey = GlobalKey<FormState>();

  // String
  String? _selectedNationality;
  String? _selectedNationalityCodes;
  String? _selectedIdType = "National ID";
  String? _selectedIdValue;

  // List
  List<CountryData> _nationalityMenu = [];

  List<DocumentIdModel>? idTypeMenu;

  // Constructor
  // Initializes the RegisterNotifier and makes an API call for the country list
  RegisterNotifier(BuildContext context) {
    initData(context);
  }

  initData(BuildContext context) async {
    await countryApiCall(context, {});
    await apiDocumentIdDropdown(context);
    // Find National ID in idTypeMenu
    final nationalId = idTypeMenu?.firstWhere(
          (item) => item.sDescE?.toLowerCase() == "national id" || item.nDetailedCode == 24,
      orElse: () => idTypeMenu!.first, // fallback to first item if not found
    );

    idTypeController.text = nationalId?.sDescE ?? "";
    selectedIdValue = nationalId?.nDetailedCode.toString() ?? "";
  }
  // Building dropdown
  Future<void> apiDocumentIdDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiDocumentIdDropDown(
          {}, context);
      if (result is List<DocumentIdModel>) {
        idTypeMenu = result;
      } else {
        debugPrint("Unexpected result type in apiBuildingDropdown");
      }
    } catch (e) {
      debugPrint("Error in apiBuildingDropdown: $e");
    }
  }

  // Navigates to the login screen
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  // Makes an API call to fetch the country list
  Future<void> countryApiCall(BuildContext context, Map countryRequest) async {
    await AuthRepository().apiCountryList(
        countryRequest, context).then((value) {
          var countryData = value as List<CountryData>;
      nationalityMenu = List<CountryData>.from(countryData);
    });
  }

  // Performs registration process
  void performRegister(BuildContext context) {
    if (formKey.currentState!.validate()) {

      String encryptNationalId = nationalIdController.text.isEmpty
          ? ""
          : encryptAES(nationalIdController.text);

      String encryptPassport = passportNumberController.text.isEmpty
          ? ""
          : encryptAES(passportNumberController.text);

      String encryptIqama = iqamaController.text.isEmpty ? "" : encryptAES(
          iqamaController.text);

      String encryptOtherDocumentNumber = documentNumberController.text.isEmpty
          ? ""
          : encryptAES(documentNumberController.text);

      RegisterRequest registerRequest = RegisterRequest(
        sFullName: fullNameController.text,
        sEmail: emailAddressController.text,
        sMobileNumber: mobileNumberController.text,
        sUserName: emailAddressController.text,
        sCompanyName: visitorCompanyNameController.text,
        iso3: selectedNationality,
        nDocumentType: int.parse(selectedIdValue ?? ""),
        eidNumber: encryptNationalId,
        passportNumber: encryptPassport,
        sIqama: encryptIqama,
        sVisaNo: encryptIqama,
        sOthersDoc: documentNameController.text,
        sOthersValue: encryptOtherDocumentNumber,
        dtDateOfBirth: dateOfBirthController.text.apiDateFormat(),
      );

      runWithLoadingVoid(() => registerApiCall(context, registerRequest));
    }
  }

  // Makes an API call to register the user
  Future<void> registerApiCall(BuildContext context, RegisterRequest registerRequest) async {
    await AuthRepository().apiRegistration(
        registerRequest, context).then((value) {
      // if (value == "Not Found") {
      //   ToastHelper.showError("Incorrect Email or Password");
      // }
    });
  }

  // Getter and Setter
  TextEditingController get fullNameController => _fullNameController;

  set fullNameController(TextEditingController value) {
    if (_fullNameController == value) return;
    _fullNameController = value;
    notifyListeners();
  }

  TextEditingController get visitorCompanyNameController => _visitorCompanyNameController;

  set visitorCompanyNameController(TextEditingController value) {
    if (_visitorCompanyNameController == value) return;
    _visitorCompanyNameController = value;
    notifyListeners();
  }

  TextEditingController get mobileNumberController => _mobileNumberController;

  set mobileNumberController(TextEditingController value) {
    if (_mobileNumberController == value) return;
    _mobileNumberController = value;
    notifyListeners();
  }

  TextEditingController get emailAddressController => _emailAddressController;

  set emailAddressController(TextEditingController value) {
    if (_emailAddressController == value) return;
    _emailAddressController = value;
    notifyListeners();
  }

  TextEditingController get dateOfBirthController => _dateOfBirthController;

  set dateOfBirthController(TextEditingController value) {
    if (_dateOfBirthController == value) return;
    _dateOfBirthController = value;
    notifyListeners();
  }

  TextEditingController get nationalIdController => _nationalIdController;

  set nationalIdController(TextEditingController value) {
    if (_nationalIdController == value) return;
    _nationalIdController = value;
    notifyListeners();
  }

  TextEditingController get nationalityController => _nationalityController;

  set nationalityController(TextEditingController value) {
    if (_nationalityController == value) return;
    _nationalityController = value;
    notifyListeners();
  }

  TextEditingController get idTypeController => _idTypeController;

  set idTypeController(TextEditingController value) {
    if (_idTypeController == value) return;
    _idTypeController = value;
    notifyListeners();
  }

  TextEditingController get documentNameController => _documentNameController;

  set documentNameController(TextEditingController value) {
    if (_documentNameController == value) return;
    _documentNameController = value;
    notifyListeners();
  }

  TextEditingController get documentNumberController => _documentNumberController;

  set documentNumberController(TextEditingController value) {
    if (_documentNumberController == value) return;
    _documentNumberController = value;
    notifyListeners();
  }

  TextEditingController get iqamaController => _iqamaController;

  set iqamaController(TextEditingController value) {
    if (_iqamaController == value) return;
    _iqamaController = value;
    notifyListeners();
  }

  TextEditingController get visaController => _visaController;

  set visaController(TextEditingController value) {
    if (_visaController == value) return;
    _visaController = value;
    notifyListeners();
  }

  TextEditingController get passportNumberController => _passportNumberController;

  set passportNumberController(TextEditingController value) {
    if (_passportNumberController == value) return;
    _passportNumberController = value;
    notifyListeners();
  }

  String? get selectedNationality => _selectedNationality;

  set selectedNationality(String? value) {
    if (_selectedNationality == value) return;
    _selectedNationality = value;
    notifyListeners();
  }

  String? get selectedNationalityCodes => _selectedNationalityCodes;

  set selectedNationalityCodes(String? value) {
    if (_selectedNationalityCodes == value) return;
    _selectedNationalityCodes = value;
    notifyListeners();
  }

  String? get selectedIdType => _selectedIdType;

  set selectedIdType(String? value) {
    if (_selectedIdType == value) return;
    _selectedIdType = value;
    notifyListeners();
  }

  String? get selectedIdValue => _selectedIdValue;

  set selectedIdValue(String? value) {
    if (_selectedIdValue == value) return;
    _selectedIdValue = value;
    notifyListeners();
  }

  List<CountryData> get nationalityMenu => _nationalityMenu;

  set nationalityMenu(List<CountryData> value) {
    if (_nationalityMenu == value) return;
    _nationalityMenu = value;
    notifyListeners();
  }

}