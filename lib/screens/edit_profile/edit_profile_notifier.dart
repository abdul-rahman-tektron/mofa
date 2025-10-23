import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/get_profile/get_profile_response.dart';
import 'package:mofa/core/model/update_profile/update_profile_request.dart';
import 'package:mofa/core/remote/service/apply_pass_repository.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/extensions.dart';

class EditProfileNotifier extends BaseChangeNotifier with CommonUtils {

  String? _selectedNationality;
  String? _selectedNationalityCodes;
  String? _selectedIdType = "National ID";
  String? _selectedIdValue;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController visitorCompanyController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController idTypeController = TextEditingController();
  final TextEditingController nationalityIdController = TextEditingController();
  final TextEditingController visaController = TextEditingController();
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final TextEditingController iqamaController = TextEditingController();
  final TextEditingController passportNumberController = TextEditingController();


  GetProfileResult? _getProfileData;

  List<CountryData> _nationalityMenu = [];

  List<DocumentIdModel>? idTypeMenu;

  //Functions
  EditProfileNotifier(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    runWithLoadingVoid(() async {
      await apiDocumentIdDropdown(context);
      await _fetchProfileAndNationality(context);
      _initializeData(context);
    },);
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

  void _initializeData(BuildContext context) {
    final data = _getProfileData;
    fullNameController.text = data?.sFullName ?? "";
    visitorCompanyController.text = data?.sCompanyName ?? "";
    nationalityController.text = data?.iso3 ?? "";
    mobileNumberController.text = data?.sMobileNumber ?? "";
    emailAddressController.text = data?.sEmail ?? "";
    iqamaController.text = data?.sIqama ?? "";
    passportNumberController.text = data?.passportNumber ?? "";
    visaController.text = data?.sVisaNo ?? "";
    nationalityIdController.text = data?.eidNumber ?? "";
    documentNameController.text = data?.sOthersDoc ?? "";
    documentNumberController.text = data?.sOthersValue ?? "";
    dateOfBirthController.text = data?.dtDateOfBirth?.toDisplayDate() ?? "";

    final matchedIdType = idTypeMenu?.firstWhere(
          (item) => item.nDetailedCode == data?.nDocumentType,
      orElse: () => DocumentIdModel(sDescE: "Unknown", sDescA: "", nDetailedCode: 0),
    );
    _selectedIdType = getLocalizedText(currentLang: context.lang, english: matchedIdType?.sDescE ?? "", arabic: matchedIdType?.sDescA ?? "");
    _selectedIdValue = data?.nDocumentType.toString();
    idTypeController.text = getLocalizedText(currentLang: context.lang, english: matchedIdType?.sDescE ?? "", arabic: matchedIdType?.sDescA ?? "");

    final matchedNationality = _nationalityMenu.firstWhere(
          (country) => country.iso3 == data?.iso3,
      orElse: () => CountryData(name: "Unknown", iso3: ""),
    );
    _selectedNationality = data?.iso3;
    _selectedNationalityCodes = matchedNationality.phonecode.toString();
    nationalityController.text = getLocalizedText(currentLang: context.lang, english: matchedNationality.name, arabic: matchedNationality.nameAr);

    notifyListeners();
  }

  Future<void> saveData(BuildContext context) async {
    runWithLoadingVoid(() => saveApiCall(context));
  }

  Future<void> saveApiCall(BuildContext context) async {
    String? iqama;
    String? eidNumber;
    String? passportNumber;
    String? visaNumber;
    String? othersDoc;
    String? othersValue;

    switch (int.tryParse(_selectedIdValue ?? "0") ?? 0) {
      case 2244: // Iqama
        iqama = iqamaController.text;
        break;
      case 24: // National ID
        eidNumber = nationalityIdController.text;
        break;
      case 26: // Passport
        passportNumber = passportNumberController.text;
        break;
      case 2294: // Visa
        visaNumber = visaController.text;
        break;
      case 2245: // Other
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
      sVisaNo: visaNumber,
      passportNumber: passportNumber,
      sOthersDoc: othersDoc,
      sOthersValue: othersValue,
      dtDateOfBirth: dateOfBirthController.text.apiDateFormat(),
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


  @override
  void dispose() {
    fullNameController.dispose();
    visitorCompanyController.dispose();
    nationalityController.dispose();
    mobileNumberController.dispose();
    emailAddressController.dispose();
    dateOfBirthController.dispose();
    idTypeController.dispose();
    nationalityIdController.dispose();
    documentNameController.dispose();
    documentNumberController.dispose();
    iqamaController.dispose();
    passportNumberController.dispose();
    super.dispose();
  }
}