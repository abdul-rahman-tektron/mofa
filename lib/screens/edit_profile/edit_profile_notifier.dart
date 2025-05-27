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
    apiGetProfile(context).then((value) {
      apiNationalityDropdown(context);
    },);
  }

  //Get Profile Api call
  Future apiGetProfile(BuildContext context) async {
    await AuthRepository().apiGetProfile({}, context).then((value) {
      getProfileData = value as GetProfileResult;
    },);
  }

  //Nationality dropdown Api call
  Future apiNationalityDropdown(BuildContext context) async {
    await AuthRepository().apiCountryList({}, context).then((value) {
      var countryData = value as List<CountryData>;
      nationalityMenu = List<CountryData>.from(countryData);
      initializeData();
    },);
  }

  void initializeData() {
    fullNameController.text = getProfileData?.sFullName ?? "";
    visitorCompanyController.text = getProfileData?.sCompanyName ?? "";
    nationalityController.text = getProfileData?.iso3 ?? "";
    mobileNumberController.text = getProfileData?.sMobileNumber ?? "";
    emailAddressController.text = getProfileData?.sEmail ?? "";
    // Match the n_DocumentType to idTypeMenu
    final matchedIdType = idTypeMenu.firstWhere(
          (item) => item.value == getProfileData?.nDocumentType,
      orElse: () => DocumentIdModel(labelEn: "", labelAr: "", value: 0),
    );
    selectedIdType = matchedIdType.labelEn;
    selectedIdValue = getProfileData?.nDocumentType.toString();
    idTypeController.text = matchedIdType.labelEn;

    final matchedNationality = nationalityMenu.firstWhere(
          (country) => country.iso3 == getProfileData?.iso3,
      orElse: () => CountryData(name: "", iso3: ""),
    );

    selectedNationality = getProfileData?.iso3;
    nationalityController.text = matchedNationality.name ?? "";
    iqamaController.text = getProfileData?.sIqama ?? "";
    passportNumberController.text = getProfileData?.passportNumber ?? "";
    nationalityIdController.text = getProfileData?.eidNumber ?? "";
    documentNameController.text = getProfileData?.sOthersDoc ?? "";
    documentNumberController.text = getProfileData?.sOthersValue ?? "";
  }

  Future<void> saveData(BuildContext context) async {
    // Set values based on selected ID type
    String? iqama;
    String? eidNumber;
    String? passportNumber;
    String? othersDoc;
    String? othersValue;

    switch (selectedIdType) {
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
      iso3: selectedNationality,
      nDocumentType: int.tryParse(selectedIdValue ?? "") ?? 0,
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

}