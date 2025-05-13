import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/register/register_request.dart';
import 'package:mofa/core/remote/service/auth_provider.dart';
import 'package:mofa/model/document/document_id_model.dart';

class RegisterNotifier extends BaseChangeNotifier {

  //Data Controller
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _visitorCompanyNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _nationalIdController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _idTypeController = TextEditingController();
  TextEditingController _documentNameController = TextEditingController();
  TextEditingController _documentNumberController = TextEditingController();
  TextEditingController _iqamaController = TextEditingController();
  TextEditingController _passportNumberController = TextEditingController();

  //key
  final formKey = GlobalKey<FormState>();

  //String
  String? _selectedNationality;
  String? _selectedIdType = "National ID";
  String? _selectedIdValue;

  //List
  List<CountryData> _nationalityMenu = [];

  final List<DocumentIdModel> idTypeMenu = [
    DocumentIdModel(labelEn: "Iqama", labelAr: "الإقامة", value: 2244),
    DocumentIdModel(labelEn: "National ID", labelAr: "الهوية_الوطنية", value: 24),
    DocumentIdModel(labelEn: "Passport", labelAr: "جواز_السفر", value: 26),
    DocumentIdModel(labelEn: "Other", labelAr: "أخرى", value: 2245),
  ];

  //Functions
  RegisterNotifier(BuildContext context) {
    idTypeController.text = "National ID";
    print("Function is called");
    countryApiCall(context, {});
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pop(context);
  }

  void countryApiCall(BuildContext context, Map countryRequest) async {
    print("Registre Api Called");
    await AuthRepository().apiCountryList(
        countryRequest, context).then((value) {
          print(value);
          var countryData = value as List<CountryData>;
      nationalityMenu = List<CountryData>.from(countryData);
    });
  }

  void performRegister(BuildContext context) {
    if (formKey.currentState!.validate()) {
      RegisterRequest registerRequest = RegisterRequest(
        sFullName: fullNameController.text,
        sEmail: emailAddressController.text,
        sMobileNumber: mobileNumberController.text,
        sUserName: emailAddressController.text,
        sCompanyName: visitorCompanyNameController.text,
        iso3: selectedNationality,
        nDocumentType: int.parse(selectedIdValue ?? ""),
        eidNumber: nationalIdController.text,
        passportNumber: passportNumberController.text,
        sIqama: iqamaController.text,
        sOthersDoc: documentNameController.text,
        sOthersValue: documentNumberController.text,
      );
      registerApiCall(context, registerRequest);
    }
  }

  void registerApiCall(BuildContext context, RegisterRequest registerRequest) async {
    await AuthRepository().apiRegistration(
        registerRequest, context).then((value) {
      // if (value == "Not Found") {
      //   ToastHelper.showError("Incorrect Email or Password");
      // }
    });
  }

  //Getter and Setter
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