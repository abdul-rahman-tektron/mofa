import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/get_profile/get_profile_response.dart';
import 'package:mofa/core/model/update_profile/update_profile_request.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/model/document/document_id_model.dart';

class EditProfileNotifier extends BaseChangeNotifier {

  String? _selectedNationality;
  String? _selectedIdType = "National ID";
  String? _selectedIdValue;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController visitorCompanyController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController idTypeController = TextEditingController();
  final TextEditingController nationalityIdController = TextEditingController();
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final TextEditingController iqamaController = TextEditingController();
  final TextEditingController passportNumberController = TextEditingController();


  GetProfileResult? _getProfileData;

  List<CountryData> _nationalityMenu = [];

  final List<DocumentIdModel> idTypeMenu = [
    DocumentIdModel(labelEn: "Iqama", labelAr: "الإقامة", value: 2244),
    DocumentIdModel(labelEn: "National ID", labelAr: "الهوية_الوطنية", value: 24),
    DocumentIdModel(labelEn: "Passport", labelAr: "جواز_السفر", value: 26),
    DocumentIdModel(labelEn: "Other", labelAr: "أخرى", value: 2245),
  ];

  //Functions
  EditProfileNotifier(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    await _fetchProfileAndNationality(context);
    _initializeData();
  }

  Future<void> _fetchProfileAndNationality(BuildContext context) async {
    try {
      final profileResult = await AuthRepository().apiGetProfile({}, context);
      final countryList = await AuthRepository().apiCountryList({}, context);

      _getProfileData = profileResult as GetProfileResult;
      _nationalityMenu = List<CountryData>.from(countryList as List<CountryData>);
      notifyListeners();
    } catch (e) {
      // handle error
    }
  }

  void _initializeData() {
    final data = _getProfileData;
    fullNameController.text = data?.sFullName ?? "";
    visitorCompanyController.text = data?.sCompanyName ?? "";
    nationalityController.text = data?.iso3 ?? "";
    mobileNumberController.text = data?.sMobileNumber ?? "";
    emailAddressController.text = data?.sEmail ?? "";
    iqamaController.text = data?.sIqama ?? "";
    passportNumberController.text = data?.passportNumber ?? "";
    nationalityIdController.text = data?.eidNumber ?? "";
    documentNameController.text = data?.sOthersDoc ?? "";
    documentNumberController.text = data?.sOthersValue ?? "";

    final matchedIdType = idTypeMenu.firstWhere(
          (item) => item.value == data?.nDocumentType,
      orElse: () => DocumentIdModel(labelEn: "Unknown", labelAr: "", value: 0),
    );
    _selectedIdType = matchedIdType.labelEn;
    _selectedIdValue = data?.nDocumentType.toString();
    idTypeController.text = matchedIdType.labelEn;

    final matchedNationality = _nationalityMenu.firstWhere(
          (country) => country.iso3 == data?.iso3,
      orElse: () => CountryData(name: "Unknown", iso3: ""),
    );
    _selectedNationality = data?.iso3;
    nationalityController.text = matchedNationality.name ?? "";

    notifyListeners();
  }

  Future<void> saveData(BuildContext context) async {
    String? iqama;
    String? eidNumber;
    String? passportNumber;
    String? othersDoc;
    String? othersValue;

    switch (_selectedIdType) {
      case "Iqama":
        iqama = iqamaController.text;
        break;
      case "National ID":
        eidNumber = nationalityIdController.text;
        break;
      case "Passport":
        passportNumber = passportNumberController.text;
        break;
      case "Other":
        othersDoc = documentNameController.text;
        othersValue = documentNumberController.text;
        break;
    }

    final updateProfileRequest = UpdateProfileRequest(
      sFullName: fullNameController.text,
      sEmail: emailAddressController.text,
      sMobileNumber: mobileNumberController.text,
      sUserName: emailAddressController.text,
      sCompanyName: visitorCompanyController.text,
      iso3: _selectedNationality,
      nDocumentType: int.tryParse(_selectedIdValue ?? "") ?? 0,
      sIqama: iqama,
      eidNumber: eidNumber,
      passportNumber: passportNumber,
      sOthersDoc: othersDoc,
      sOthersValue: othersValue,
    );

    await AuthRepository().apiUpdateProfile(updateProfileRequest, context);
  }


  //Getter And Setter
  GetProfileResult? get getProfileData => _getProfileData;

  set getProfileData(GetProfileResult? value) {
    if (_getProfileData == value) return;
    _getProfileData = value;
    notifyListeners();
  }

  List<CountryData> get nationalityMenu => _nationalityMenu;

  set nationalityMenu(List<CountryData> value) {
    if (_nationalityMenu == value) return;
    _nationalityMenu = value;
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


  @override
  void dispose() {
    fullNameController.dispose();
    visitorCompanyController.dispose();
    nationalityController.dispose();
    mobileNumberController.dispose();
    emailAddressController.dispose();
    idTypeController.dispose();
    nationalityIdController.dispose();
    documentNameController.dispose();
    documentNumberController.dispose();
    iqamaController.dispose();
    passportNumberController.dispose();
    super.dispose();
  }
}