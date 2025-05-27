import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/add_appointment/add_appointment_request.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_request.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/duplicate_appointment/duplicate_appointment_request.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/model/get_file/get_file_request.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_request.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/core/remote/service/apply_pass_repository.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/model/device/device_model.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/file_uplaod_helper.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/toast_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyPassGroupNotifier extends BaseChangeNotifier {

  // key
  final formKey = GlobalKey<FormState>();

  // bool
  bool _isChecked = false;
  bool _isCheckedDevice = true;
  bool _showDeviceFields = true;
  bool _isEditingDevice = false;
  bool _showVisitorsFields = true;
  bool _isEditingVisitors = false;
  bool _photoUploadValidation = false;
  bool _documentUploadValidation = false;

  //Files
  File? _uploadedImageFile;
  File? _uploadedDocumentFile;
  File? _uploadedVehicleRegistrationFile;

  Uint8List? _uploadedImageBytes;
  Uint8List? _uploadedDocumentBytes;
  Uint8List? _uploadedVehicleImageBytes;

  // int
  int? _selectedLocationId;
  int? _editDeviceIndex;
  int? _editVisitorsIndex;
  int? _selectedDeviceType;
  int? _selectedDevicePurpose;


  //String
  String? _selectedVisitRequest;
  String? _selectedVisitPurpose;
  String? _selectedNationality;
  String? _selectedIdType = "National ID";
  String? _selectedIdValue;
  String? _applyPassCategory;

  // Data Controller
  //Visitor Detail
  TextEditingController _visitorNameController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _nationalityIdController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _idTypeController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _documentNameController = TextEditingController();
  TextEditingController _documentNumberController = TextEditingController();
  TextEditingController _iqamaController = TextEditingController();
  TextEditingController _passportNumberController = TextEditingController();

  //Visit Detail
  TextEditingController _locationController = TextEditingController();
  TextEditingController _visitRequestTypeController = TextEditingController();
  TextEditingController _visitPurposeController = TextEditingController();
  TextEditingController _mofaHostEmailController = TextEditingController();
  TextEditingController _visitStartDateController = TextEditingController();
  TextEditingController _visitEndDateController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  //Device Details
  TextEditingController _deviceTypeController = TextEditingController();
  TextEditingController _deviceModelController = TextEditingController();
  TextEditingController _serialNumberController = TextEditingController();
  TextEditingController _devicePurposeController = TextEditingController();

  //List
  List<LocationDropdownResult> _locationDropdownData = [];
  List<VisitRequestDropdownResult> _visitRequestTypesDropdownData = [];
  List<VisitPurposeDropdownResult> _visitPurposeDropdownData = [];
  List<CountryData> _nationalityMenu = [];
  List<DeviceDropdownResult> _deviceTypeDropdownData = [];
  List<DeviceDropdownResult> _devicePurposeDropdownData = [];
  List<DeviceModel> _addedDevices = [];
  List<VisitorDetailModel> _addedVisitors = [];
  List<Map> _imageList = [];

  final List<DocumentIdModel> idTypeMenu = [
    DocumentIdModel(labelEn: "Iqama", labelAr: "الإقامة", value: 2244),
    DocumentIdModel(labelEn: "National ID", labelAr: "الهوية_الوطنية", value: 24),
    DocumentIdModel(labelEn: "Passport", labelAr: "جواز_السفر", value: 26),
    DocumentIdModel(labelEn: "Other", labelAr: "أخرى", value: 2245),
  ];

  ApplyPassGroupNotifier(BuildContext context,ApplyPassCategory category) {
    initialize(context, category);
  }

  Future<void> initialize(BuildContext context, ApplyPassCategory category) async {
    applyPassCategory = category.name;
    final DateTime now = DateTime.now();

// Format: 21/05/2025 ،09:57 AM
    final DateFormat formatter = DateFormat("dd/MM/yyyy ،hh:mm a");

// Set visit start
    visitStartDateController.text = formatter.format(now);

// Add 1 hour and set visit end
    final DateTime oneHourLater = now.add(Duration(hours: 1));
    visitEndDateController.text = formatter.format(oneHourLater);
    await fetchAllDropdownData(context);
  }

  Future<void> fetchAllDropdownData(BuildContext context) async {
    try {
      await Future.wait([
        apiLocationDropdown(context),
        apiNationalityDropdown(context),
        apiVisitRequestDropdown(context),
        apiVisitPurposeDropdown(context),
        apiDeviceTypeDropdown(context),
        apiDevicePurposeDropdown(context),
      ]);
      // notifyListeners(); // if any UI depends on dropdowns
    } catch (e) {
      // Handle exceptions if needed
      debugPrint('Dropdown fetch error: $e');
    }
  }

  //location dropdown Api call
  Future apiLocationDropdown(BuildContext context) async {
    await ApplyPassRepository().apiLocationDropDown({}, context).then((value) {
      var locationData = value as List<LocationDropdownResult>;
      locationDropdownData = List<LocationDropdownResult>.from(locationData);
    },);
  }

  //Nationality dropdown Api call
  Future apiNationalityDropdown(BuildContext context) async {
    await AuthRepository().apiCountryList({}, context).then((value) {
      var countryData = value as List<CountryData>;
      nationalityMenu = List<CountryData>.from(countryData);
    },);
  }

  //Visit Purpose dropdown Api call
  Future apiVisitPurposeDropdown(BuildContext context) async {
    await ApplyPassRepository().apiVisitPurposeDropDown(VisitPurposeDropdownRequest(encryptedVisitRequestTypeId: ""), context).then((value) {
      var visitPurposeData = value as List<VisitPurposeDropdownResult>;
      visitPurposeDropdownData = List<VisitPurposeDropdownResult>.from(visitPurposeData);
    },);
  }

  //Visit Request dropdown Api call
  Future apiVisitRequestDropdown(BuildContext context) async {
    await ApplyPassRepository().apiVisitRequestDropDown({}, context).then((value) {
      var visitRequestData = value as List<VisitRequestDropdownResult>;
      visitRequestTypesDropdownData = List<VisitRequestDropdownResult>.from(visitRequestData);
    },);
  }

  //Device Type dropdown Api call
  Future apiDeviceTypeDropdown(BuildContext context) async {
    await ApplyPassRepository().apiDeviceDropDown(DeviceDropdownRequest(encryptedId: encryptAES("1036")), context).then((value) {
      var deviceTypeData = value as List<DeviceDropdownResult>;
      deviceTypeDropdownData = List<DeviceDropdownResult>.from(deviceTypeData);
    },);
  }

  //Device Purpose dropdown Api call
  Future apiDevicePurposeDropdown(BuildContext context) async {
    await ApplyPassRepository().apiDeviceDropDown(DeviceDropdownRequest(encryptedId: encryptAES("1037")), context).then((value) {
      var devicePurposeData = value as List<DeviceDropdownResult>;
      devicePurposeDropdownData = List<DeviceDropdownResult>.from(devicePurposeData);
    },);
  }

  // Update User Verify checkbox state
  void userVerifyChecked(BuildContext context, bool? value) {
    isChecked = value!;
  }

  // Update User Verify checkbox state
  void deviceDetailChecked(BuildContext context, bool? value) {
    isCheckedDevice = value!;
  }

  Future<void> launchPrivacyUrl() async {
    if (!await launchUrl(Uri.parse(AppStrings.privacyPolicyUrl))) {
      throw Exception('Could not launch ${AppStrings.privacyPolicyUrl}');
    }
  }

  void showDeviceFieldsAgain() {
    showDeviceFields = true;
    notifyListeners();
  }

  void clearDeviceFields() {
    deviceTypeController.clear();
    deviceModelController.clear();
    serialNumberController.clear();
    devicePurposeController.clear();
  }

  void removeDevice(int index) {
    addedDevices.removeAt(index);
    notifyListeners();
  }

  void startEditingDevice(int index) {
    editDeviceIndex = index;
    isEditingDevice = true;
    showDeviceFields = true;

    final device = _addedDevices[index];
    deviceTypeController.text = device.deviceTypeString ?? "";
    deviceModelController.text = device.deviceModel ?? "";
    serialNumberController.text = device.serialNumber ?? "";
    devicePurposeController.text = device.devicePurposeString ?? "";
  }

  void cancelDeviceEditing() {
    editDeviceIndex = null;
    isEditingDevice = false;
    showDeviceFields = false;

    deviceTypeController.clear();
    deviceModelController.clear();
    serialNumberController.clear();
    devicePurposeController.clear();
  }

  void saveDevice() {
    if(deviceTypeController.text.isEmpty || deviceModelController.text.isEmpty || serialNumberController.text.isEmpty || devicePurposeController.text.isEmpty) {
      return;
    }
    final newDevice = DeviceModel(
      deviceTypeString: deviceTypeController.text,
      deviceType: selectedDeviceType,
      deviceModel: deviceModelController.text,
      serialNumber: serialNumberController.text,
      devicePurposeString: devicePurposeController.text,
      devicePurpose: selectedDevicePurpose,
    );

    if (isEditingDevice && editDeviceIndex != null) {
      addedDevices[editDeviceIndex!] = newDevice; // update
    } else {
      addedDevices.add(newDevice); // add new
    }

    showDeviceFields = false;

    cancelDeviceEditing(); // reset form
    notifyListeners();
  }

  void showVisitorsFieldsAgain() {
    showVisitorsFields = true;
    notifyListeners();
  }

  void clearVisitorsFields() {
    visitorNameController.clear();
    companyNameController.clear();
    phoneNumberController.clear();
    emailController.clear();
    nationalityController.clear();
    emailController.clear();
    nationalityIdController.clear();
    iqamaController.clear();
    passportNumberController.clear();
    documentNameController.clear();
    documentNumberController.clear();
    expiryDateController.clear();
    vehicleNumberController.clear();

    uploadedImageFile = null;
    uploadedDocumentFile = null;
    uploadedVehicleRegistrationFile = null;
  }

  void removeVisitors(int index) {
    addedVisitors.removeAt(index);
    notifyListeners();
  }

  void startEditingVisitors(int index) {
    editVisitorsIndex = index;
    isEditingVisitors = true;
    showVisitorsFields = true;

    final visitors = addedVisitors[index];
    visitorNameController.text = visitors.visitorName;
    companyNameController.text = visitors.companyName;
    phoneNumberController.text = visitors.mobileNumber;
    emailController.text = visitors.email;
    nationalityController.text = visitors.nationality;
    emailController.text = visitors.email;
    nationalityIdController.text = visitors.documentId;
    iqamaController.text = visitors.documentId;
    passportNumberController.text = visitors.documentId;
    documentNameController.text = visitors.documentId;
    documentNumberController.text = visitors.documentId;
    expiryDateController.text = visitors.expiryDate;
    vehicleNumberController.text = visitors.vehicleNumber;
  }

  void cancelVisitorsEditing() {
    editVisitorsIndex = null;
    isEditingVisitors = false;
    showVisitorsFields = false;

    clearVisitorsFields();
  }

  void saveVisitors(BuildContext context) async {
    if( visitorNameController.text.isEmpty || companyNameController.text.isEmpty || phoneNumberController.text.isEmpty || emailController.text.isEmpty ||
        nationalityController.text.isEmpty || emailController.text.isEmpty || iqamaController.text.isEmpty ||
        expiryDateController.text.isEmpty ) {
          return ;
        }

    final dateFormatWithTime = DateFormat("dd/MM/yyyy '،'hh:mm a");
    final dateFormatWithoutTime = DateFormat("dd/MM/yyyy");

    try {
      final expiryDate = dateFormatWithoutTime.parse(expiryDateController.text);
      final visitEndDate = dateFormatWithTime.parse(visitEndDateController.text);

      // Check if expiry date is before visit end date (date-only vs date-time)
      if (expiryDate.isBefore(visitEndDate)) {
        ToastHelper.showError(context.readLang.translate(AppLanguageText.expireVisitError));
        return;
      }
    } catch (e) {
      debugPrint("Date parsing error: $e");
      return;
    }

    final newVisitors = VisitorDetailModel(
        visitorName: visitorNameController.text,
        companyName: companyNameController.text,
        mobileNumber: phoneNumberController.text,
        email: emailController.text,
        nationality: nationalityController.text,
        idType: idTypeController.text,
        documentId: iqamaController.text,
        expiryDate: expiryDateController.text,
        vehicleNumber: vehicleNumberController.text,
        uploadedPhoto: await uploadedImageFile?.toBase64() ?? "",
        uploadedDocumentId: await uploadedDocumentFile?.toBase64() ?? "",
        uploadedVehicleRegistration: await uploadedVehicleRegistrationFile
            ?.toBase64() ?? "");

    imageList.add({
      "imageUploaded": await uploadedImageFile?.toBase64(),
      "documentUploaded": await uploadedDocumentFile?.toBase64(),
      "vehicleRegistrationUploaded": await uploadedVehicleRegistrationFile?.toBase64(),
      "selectedIdType": selectedIdType,
    });

    if (isEditingVisitors && editVisitorsIndex != null) {
      addedVisitors[editVisitorsIndex!] = newVisitors; // update
    } else {
      addedVisitors.add(newVisitors); // add new
    }

    showVisitorsFields = false;

    cancelVisitorsEditing(); // reset form
    notifyListeners();
  }

  Future<void> nextButton(BuildContext context, VoidCallback onNext) async {
    final isValid = await validation(context);
    if (isValid) {
      addData();
      onNext();
    }
  }

  Future<bool> validation(BuildContext context) async {
    bool formValid = formKey.currentState!.validate();

    photoUploadValidation = (uploadedImageFile == null) ;
    documentUploadValidation = uploadedDocumentFile == null;

    if (!formValid) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.fillAllInformation));
    }

    // If any local validation fails, return false here without calling APIs
    if (addedVisitors.isEmpty) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.kindlyAddVisitor));
    }

    // Local validations passed, now call APIs
    final isEmailValid = await apiValidateEmail(context);
    if (!isEmailValid) return false;

    final hasNoDuplicates = await apiDuplicateAppointment(context);
    if (!hasNoDuplicates) return false;

    return true;
  }


  Future<bool> apiValidateEmail(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiValidateEmail(
        ForgetPasswordRequest(sEmail: mofaHostEmailController.text),
        context,
      );
      return result == true;
    } catch (e) {
      // Optional: log or handle exception
      return false;
    }
  }


  Future<bool> apiDuplicateAppointment(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiDuplicateAppointment(
        DuplicateAppointmentRequest(
          dFromDate: visitStartDateController.text.toDateTime().toString(),
          dToDate: visitEndDateController.text.toDateTime().toString(),
          nExternalRegistrationId: 0,
          nLocationId: selectedLocationId.toString(),
          sEidNumber: encryptAES(nationalityIdController.text),
          sIqama: encryptAES(iqamaController.text),
          sOthersValue: encryptAES(documentNumberController.text),
          sPassportNumber: encryptAES(passportNumberController.text),
        ),
        context,
      );
      return result == true;
    } catch (e) {
      print("object crash ${e}");
      return false;
    }
  }

  void addData() async {

    List<AddAppointmentRequest> appointmentDataList = [];


    for (var visitor in addedVisitors) {
      String? eidExpiry, iqamaExpiry, passportExpiry, othersExpiry;
      String? eidNumber, sIqama, passportNumber, sOthersDoc, sOthersValue;

      final expiryDate = visitor.expiryDate.toDateTime().toString();
      final idTypeInt = int.tryParse(visitor.idType) ?? 0;
      final encryptedDocId = encryptAES(visitor.documentId);

      // Set the appropriate expiry and encrypted document ID
      switch (idTypeInt) {
        case 24: // National ID
          eidExpiry = expiryDate;
          eidNumber = encryptedDocId;
          break;
        case 2244: // Iqama
          iqamaExpiry = expiryDate;
          sIqama = encryptedDocId;
          break;
        case 26: // Passport
          passportExpiry = expiryDate;
          passportNumber = encryptedDocId;
          break;
        case 2245: // Other
          othersExpiry = expiryDate;
          sOthersDoc = encryptedDocId;
          sOthersValue = encryptedDocId;
          break;
      }

      final appointmentData = AddAppointmentRequest(
        fullName: visitor.visitorName,
        sponsor: visitor.companyName,
        nationality: visitor.nationality,
        mobileNo: visitor.mobileNumber,
        email: visitor.email,
        idType: idTypeInt,
        sIqama: sIqama,
        passportNumber: passportNumber,
        sOthersDoc: sOthersDoc,
        eidNumber: eidNumber,
        sOthersValue: sOthersValue,
        dtEidExpiryDate: eidExpiry,
        dtIqamaExpiry: iqamaExpiry,
        dtPassportExpiryDate: passportExpiry,
        dtOthersExpiry: othersExpiry,
        dtAppointmentStartTime: visitStartDateController.text.toDateTime(),
        dtAppointmentEndTime: visitEndDateController.text.toDateTime(),
        sVehicleNo: visitor.vehicleNumber,
        devices: addedDevices,
        nLocationId: selectedLocationId,
        nVisitType: int.tryParse(selectedVisitRequest ?? "") ?? 0,
        purpose: int.tryParse(selectedVisitPurpose ?? "") ?? 0,
        remarks: noteController.text,
        sVisitingPersonEmail: mofaHostEmailController.text,
        haveEid: 0,
        havePassport: 0,
        haveIqama: 0,
        havePhoto: 0,
        haveVehicleRegistration: 0,
        haveOthers: 0,
        lastAppointmentId: 1,
        nSelfPass: 3,
      );

      appointmentDataList.add(appointmentData);
    }

    // Save the list as JSON string (example)
    final jsonString = jsonEncode(appointmentDataList.map((e) => e.toJson()).toList());
    await SecureStorageHelper.setAppointmentData(jsonString);

    // Save the list as Image string (example)
    final jsonImageString = jsonEncode(imageList.map((e) => e).toList());
    await SecureStorageHelper.setUploadedImage(jsonImageString);
  }

  Future<void> uploadImage({bool fromCamera = false, bool cropAfterPick = true}) async {
    File? image = await FileUploadHelper.pickImage(
      fromCamera: fromCamera,
      cropAfterPick: cropAfterPick,
    );
    if (image != null) {
      uploadedImageFile = image;
      photoUploadValidation = false;
      notifyListeners();
    }
  }

  Future<void> uploadVehicleRegistrationImage({bool fromCamera = false, bool cropAfterPick = true}) async {
    File? image = await FileUploadHelper.pickImage(
      fromCamera: fromCamera,
      cropAfterPick: cropAfterPick,
    );
    if (image != null) {
      uploadedVehicleRegistrationFile = image;
      notifyListeners();
    }
  }

  Future<void> uploadDocument() async {
    File? doc = await FileUploadHelper.pickDocument(
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (doc != null) {
      uploadedDocumentFile = doc;
      documentUploadValidation = false;
      notifyListeners();
    }
  }

  void notifyDataListeners() {
    notifyListeners();
  }

  //Getter Setter
  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    if (_isChecked == value) return;
    _isChecked = value;
    notifyListeners();
  }

  TextEditingController get locationController => _locationController;

  set locationController(TextEditingController value) {
    if (_locationController == value) return;
    _locationController = value;
    notifyListeners();
  }

  TextEditingController get visitRequestTypeController => _visitRequestTypeController;

  set visitRequestTypeController(TextEditingController value) {
    if (_visitRequestTypeController == value) return;
    _visitRequestTypeController = value;
    notifyListeners();
  }

  TextEditingController get visitPurposeController => _visitPurposeController;

  set visitPurposeController(TextEditingController value) {
    if (_visitPurposeController == value) return;
    _visitPurposeController = value;
    notifyListeners();
  }

  TextEditingController get mofaHostEmailController => _mofaHostEmailController;

  set mofaHostEmailController(TextEditingController value) {
    if (_mofaHostEmailController == value) return;
    _mofaHostEmailController = value;
    notifyListeners();
  }

  TextEditingController get visitStartDateController => _visitStartDateController;

  set visitStartDateController(TextEditingController value) {
    if (_visitStartDateController == value) return;
    _visitStartDateController = value;
    notifyListeners();
  }

  TextEditingController get visitEndDateController => _visitEndDateController;

  set visitEndDateController(TextEditingController value) {
    if (_visitEndDateController == value) return;
    _visitEndDateController = value;
    notifyListeners();
  }

  TextEditingController get noteController => _noteController;

  set noteController(TextEditingController value) {
    if (_noteController == value) return;
    _noteController = value;
    notifyListeners();
  }

  bool get isCheckedDevice => _isCheckedDevice;

  set isCheckedDevice(bool value) {
    if (_isCheckedDevice == value) return;
    _isCheckedDevice = value;
    notifyListeners();
  }

  List<LocationDropdownResult> get locationDropdownData => _locationDropdownData;

  set locationDropdownData(List<LocationDropdownResult> value) {
    if (_locationDropdownData == value) return;
    _locationDropdownData = value;
    notifyListeners();
  }

  List<VisitRequestDropdownResult> get visitRequestTypesDropdownData => _visitRequestTypesDropdownData;

  set visitRequestTypesDropdownData(List<VisitRequestDropdownResult> value) {
    if (_visitRequestTypesDropdownData == value) return;
    _visitRequestTypesDropdownData = value;
    notifyListeners();
  }

  int? get selectedLocationId => _selectedLocationId;

  set selectedLocationId(int? value) {
    if (_selectedLocationId == value) return;
    _selectedLocationId = value;
    notifyListeners();
  }

  String? get selectedVisitRequest => _selectedVisitRequest;

  set selectedVisitRequest(String? value) {
    if (_selectedVisitRequest == value) return;
    _selectedVisitRequest = value;
    notifyListeners();
  }

  String? get selectedVisitPurpose => _selectedVisitPurpose;

  set selectedVisitPurpose(String? value) {
    if (_selectedVisitPurpose == value) return;
    _selectedVisitPurpose = value;
    notifyListeners();
  }

  List<VisitPurposeDropdownResult> get visitPurposeDropdownData => _visitPurposeDropdownData;

  set visitPurposeDropdownData(List<VisitPurposeDropdownResult> value) {
    if (_visitPurposeDropdownData == value) return;
    _visitPurposeDropdownData = value;
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

  List<DeviceDropdownResult> get deviceTypeDropdownData => _deviceTypeDropdownData;

  set deviceTypeDropdownData(List<DeviceDropdownResult> value) {
    if (_deviceTypeDropdownData == value) return;
    _deviceTypeDropdownData = value;
    notifyListeners();
  }

  List<DeviceDropdownResult> get devicePurposeDropdownData => _devicePurposeDropdownData;

  set devicePurposeDropdownData(List<DeviceDropdownResult> value) {
    if (_devicePurposeDropdownData == value) return;
    _devicePurposeDropdownData = value;
    notifyListeners();
  }

  String? get applyPassCategory => _applyPassCategory;

  set applyPassCategory(String? value) {
    if (_applyPassCategory == value) return;
    _applyPassCategory = value;
    notifyListeners();
  }

  TextEditingController get deviceTypeController => _deviceTypeController;

  set deviceTypeController(TextEditingController value) {
    if (_deviceTypeController == value) return;
    _deviceTypeController = value;
    notifyListeners();
  }

// Device Model Controller
  TextEditingController get deviceModelController => _deviceModelController;

  set deviceModelController(TextEditingController value) {
    if (_deviceModelController == value) return;
    _deviceModelController = value;
    notifyListeners();
  }

// Serial Number Controller
  TextEditingController get serialNumberController => _serialNumberController;

  set serialNumberController(TextEditingController value) {
    if (_serialNumberController == value) return;
    _serialNumberController = value;
    notifyListeners();
  }

// Device Purpose Controller
  TextEditingController get devicePurposeController => _devicePurposeController;

  set devicePurposeController(TextEditingController value) {
    if (_devicePurposeController == value) return;
    _devicePurposeController = value;
    notifyListeners();
  }

  List<DeviceModel> get addedDevices => _addedDevices;

  set addedDevices(List<DeviceModel> value) {
    if (_addedDevices == value) return;
    _addedDevices = value;
    notifyListeners();
  }

  List<VisitorDetailModel> get addedVisitors => _addedVisitors;

  set addedVisitors(List<VisitorDetailModel> value) {
    if (_addedVisitors == value) return;
    _addedVisitors = value;
    notifyListeners();
  }

  List<Map> get imageList => _imageList;

  set imageList(List<Map> value) {
    if (_imageList == value) return;
    _imageList = value;
    notifyListeners();
  }

  bool get showDeviceFields => _showDeviceFields;

  set showDeviceFields(bool value) {
    if (_showDeviceFields == value) return;
    _showDeviceFields = value;
    notifyListeners();
  }

  int? get editDeviceIndex => _editDeviceIndex;

  set editDeviceIndex(int? value) {
    if (_editDeviceIndex == value) return;
    _editDeviceIndex = value;
    notifyListeners();
  }

  bool get isEditingDevice => _isEditingDevice;

  set isEditingDevice(bool value) {
    if (_isEditingDevice == value) return;
    _isEditingDevice = value;
    notifyListeners();
  }

  bool get showVisitorsFields => _showVisitorsFields;

  set showVisitorsFields(bool value) {
    if (_showVisitorsFields == value) return;
    _showVisitorsFields = value;
    notifyListeners();
  }

  int? get editVisitorsIndex => _editVisitorsIndex;

  set editVisitorsIndex(int? value) {
    if (_editVisitorsIndex == value) return;
    _editVisitorsIndex = value;
    notifyListeners();
  }

  int? get selectedDeviceType => _selectedDeviceType;

  set selectedDeviceType(int? value) {
    if (_selectedDeviceType == value) return;
    _selectedDeviceType = value;
    notifyListeners();
  }

  int? get selectedDevicePurpose => _selectedDevicePurpose;

  set selectedDevicePurpose(int? value) {
    if (_selectedDevicePurpose == value) return;
    _selectedDevicePurpose = value;
    notifyListeners();
  }

  bool get isEditingVisitors => _isEditingVisitors;

  set isEditingVisitors(bool value) {
    if (_isEditingVisitors == value) return;
    _isEditingVisitors = value;
    notifyListeners();
  }

  Uint8List? get uploadedImageBytes => _uploadedImageBytes;

  set uploadedImageBytes(Uint8List? value) {
    if (_uploadedImageBytes == value) return;
    _uploadedImageBytes = value;
    notifyListeners();
  }

  Uint8List? get uploadedVehicleImageBytes => _uploadedVehicleImageBytes;

  set uploadedVehicleImageBytes(Uint8List? value) {
    if (_uploadedVehicleImageBytes == value) return;
    _uploadedVehicleImageBytes = value;
    notifyListeners();
  }

  Uint8List? get uploadedDocumentBytes => _uploadedDocumentBytes;

  set uploadedDocumentBytes(Uint8List? value) {
    if (_uploadedDocumentBytes == value) return;
    _uploadedDocumentBytes = value;
    notifyListeners();
  }

  File? get uploadedImageFile => _uploadedImageFile;

  set uploadedImageFile(File? value) {
    if(_uploadedImageFile == value) return;
    _uploadedImageFile = value;
    notifyListeners();
  }

  File? get uploadedDocumentFile => _uploadedDocumentFile;

  set uploadedDocumentFile(File? value) {
    if(_uploadedDocumentFile == value) return;
    _uploadedDocumentFile = value;
    notifyListeners();
  }

  File? get uploadedVehicleRegistrationFile => _uploadedVehicleRegistrationFile;

  set uploadedVehicleRegistrationFile(File? value) {
    if(_uploadedVehicleRegistrationFile == value) return;
    _uploadedVehicleRegistrationFile = value;
    notifyListeners();
  }

  TextEditingController get visitorNameController => _visitorNameController;

  set visitorNameController(TextEditingController value) {
    if (_visitorNameController == value) return;
    _visitorNameController = value;
    notifyListeners();
  }

  TextEditingController get companyNameController => _companyNameController;

  set companyNameController(TextEditingController value) {
    if (_companyNameController == value) return;
    _companyNameController = value;
    notifyListeners();
  }

  TextEditingController get nationalityController => _nationalityController;

  set nationalityController(TextEditingController value) {
    if (_nationalityController == value) return;
    _nationalityController = value;
    notifyListeners();
  }

  TextEditingController get phoneNumberController => _phoneNumberController;

  set phoneNumberController(TextEditingController value) {
    if (_phoneNumberController == value) return;
    _phoneNumberController = value;
    notifyListeners();
  }

  TextEditingController get nationalityIdController => _nationalityIdController;

  set nationalityIdController(TextEditingController value) {
    if (_nationalityIdController == value) return;
    _nationalityIdController = value;
    notifyListeners();
  }

  TextEditingController get emailController => _emailController;

  set emailController(TextEditingController value) {
    if (_emailController == value) return;
    _emailController = value;
    notifyListeners();
  }

  TextEditingController get idTypeController => _idTypeController;

  set idTypeController(TextEditingController value) {
    if (_idTypeController == value) return;
    _idTypeController = value;
    notifyListeners();
  }

  TextEditingController get expiryDateController =>
      _expiryDateController;

  set expiryDateController(TextEditingController value) {
    if (_expiryDateController == value) return;
    _expiryDateController = value;
    notifyListeners();
  }

  TextEditingController get vehicleNumberController => _vehicleNumberController;

  set vehicleNumberController(TextEditingController value) {
    if (_vehicleNumberController == value) return;
    _vehicleNumberController = value;
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

  bool get photoUploadValidation => _photoUploadValidation;

  set photoUploadValidation(bool value) {
    if (_photoUploadValidation == value) return;
    _photoUploadValidation = value;
    notifyListeners();
  }

  bool get documentUploadValidation => _documentUploadValidation;

  set documentUploadValidation(bool value) {
    if (_documentUploadValidation == value) return;
    _documentUploadValidation = value;
    notifyListeners();
  }
}