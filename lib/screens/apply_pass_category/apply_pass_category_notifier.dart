import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/add_appointment/add_appointment_request.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_request.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/duplicate_appointment/duplicate_appointment_request.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/model/get_by_id/get_by_id_response.dart';
import 'package:mofa/core/model/get_file/get_file_request.dart';
import 'package:mofa/core/model/get_file/get_file_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/core/model/login/login_response.dart';
import 'package:mofa/core/model/search_comment/search_comment_request.dart';
import 'package:mofa/core/model/search_comment/search_comment_response.dart';
import 'package:mofa/core/model/search_visitor/search_visitor_request.dart';
import 'package:mofa/core/model/search_visitor/search_visitor_response.dart';
import 'package:mofa/core/model/validate_photo/validate_photo_request.dart';
import 'package:mofa/core/model/validate_photo/validate_photo_response.dart';
import 'package:mofa/core/model/validate_photo_config/validate_photo_config_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_request.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/core/model/visiting_hours_config/visiting_hours_config_response.dart';
import 'package:mofa/core/remote/service/apply_pass_repository.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/core/remote/service/search_pass_repository.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/model/token_user_response.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/screens/search_pass/search_pass_screen.dart';
import 'package:mofa/screens/stepper_handler/stepper_handler_notifier.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/file_uplaod_helper.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/toast_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyPassCategoryNotifier extends BaseChangeNotifier with CommonFunctions, CommonUtils {
  // String
  String? _selectedNationality;
  String? _selectedNationalityCodes;
  String? _selectedIdType = "National ID";
  String? _selectedIdValue;
  String? _selectedVisitRequest;
  String? _selectedVisitPurpose;

  //int
  int? _editDeviceIndex;
  int? _selectedLocationId;
  int? _selectedDeviceType;
  int? _selectedDevicePurpose;
  int? _selectedPlateLetter1;
  int? _selectedPlateLetter2;
  int? _selectedPlateLetter3;
  int? _selectedPlateType;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  int _havePhoto = 0;
  int _haveDocument = 0;
  int _haveVehicleRegistration = 0;
  int _appointmentId = 0;
  int _lastAppointmentId = 0;
  final int _pageSize = 10;

  // bool
  bool _isChecked = false;
  bool _isUpdate = false;
  bool _isCheckedDevice = true;
  bool _isCheckedVehicle = true;
  bool _showDeviceFields = true;
  bool _isEditingDevice = false;
  bool _photoUploadValidation = false;
  bool _documentUploadValidation = false;
  bool _isEnable = true;
  bool _isValidatePhotoFromFR = false;
  bool _isPhotoLoading = false;
  bool _isDocumentLoading = false;
  bool _isTransportDocumentLoading = false;
  bool _searchExpanded = false;

  //File
  File? _uploadedImageFile;
  File? _uploadedDocumentFile;
  File? _uploadedVehicleRegistrationFile;

  Uint8List? _uploadedImageBytes;
  Uint8List? _uploadedDocumentBytes;
  Uint8List? _uploadedVehicleImageBytes;

  TimeOfDay? _apiVisitStartTime;
  TimeOfDay? _apiVisitEndTime;

  final ScrollController scrollbarController = ScrollController();

  // List
  List<CountryData> _nationalityMenu = [];
  List<LocationDropdownResult> _locationDropdownData = [];
  List<VisitRequestDropdownResult> _visitRequestTypesDropdownData = [];
  List<DeviceDropdownResult> _deviceTypeDropdownData = [];
  List<DeviceDropdownResult> _devicePurposeDropdownData = [];
  List<VisitPurposeDropdownResult> _visitPurposeDropdownData = [];
  List<DeviceModel> _addedDevices = [];
  List<DeviceDropdownResult> _plateLetterDropdownData = [];
  List<DeviceDropdownResult> _plateTypeDropdownData = [];

  List<SearchCommentData> _searchCommentData = [];

  List<TableColumnConfig> columnConfigs = [
    TableColumnConfig(labelKey: 'Comment Type', labelAr: 'نوع التعليق', isMandatory: true),
    TableColumnConfig(labelKey: 'Comment By', labelAr: 'التعليق بواسطة', isMandatory: true),
    TableColumnConfig(labelKey: 'Comment', labelAr: 'تعليق', isMandatory: true),
    TableColumnConfig(labelKey: 'Comment Date', labelAr: 'تاريخ التعليق', isVisible: true),
  ];


  final List<DocumentIdModel> idTypeMenu = [
    DocumentIdModel(labelEn: "Iqama", labelAr: "الإقامة", value: 2244),
    DocumentIdModel(labelEn: "National ID", labelAr: "الهوية_الوطنية", value: 24),
    DocumentIdModel(labelEn: "Passport", labelAr: "جواز_السفر", value: 26),
    DocumentIdModel(labelEn: "Other", labelAr: "أخرى", value: 2245),
  ];

  final nonEditableStatuses = ["Approved", "Expired", "Cancelled", "Rejected"];

  GetByIdResult? _getByIdResult;
  String? _applyPassCategory;

  final ValueNotifier<bool> searchExpandedNotifier = ValueNotifier(false);

  // key
  final formKey = GlobalKey<FormState>();

  // Data Controller
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
  TextEditingController visitPurposeOtherController = TextEditingController();
  TextEditingController _mofaHostEmailController = TextEditingController();
  TextEditingController _visitStartDateController = TextEditingController();
  TextEditingController _visitEndDateController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  //Device Details
  TextEditingController _deviceTypeController = TextEditingController();
  TextEditingController deviceTypeOtherController = TextEditingController();
  TextEditingController _deviceModelController = TextEditingController();
  TextEditingController _serialNumberController = TextEditingController();
  TextEditingController _devicePurposeController = TextEditingController();
  TextEditingController devicePurposeOtherController = TextEditingController();

  //Vehicle Details
  TextEditingController plateTypeController = TextEditingController();
  TextEditingController plateLetter1Controller = TextEditingController();
  TextEditingController plateLetter2Controller = TextEditingController();
  TextEditingController plateLetter3Controller = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();

  //Re-submission Comment
  TextEditingController resubmissionCommentController = TextEditingController();

  //Search Field
  TextEditingController iqamaSearchController = TextEditingController();
  TextEditingController nationalityIdSearchController = TextEditingController();
  TextEditingController passportSearchController = TextEditingController();
  TextEditingController emailSearchController = TextEditingController();
  TextEditingController phoneNumberSearchController = TextEditingController();

  LoginTokenUserResponse? _userResponse;

  Future<void> initialize(BuildContext context, ApplyPassCategory category, bool isUpdate, int? id) async {
    applyPassCategory = category.name;
    this.isUpdate = isUpdate;

    final now = DateTime.now();
    final formatter = DateFormat("dd/MM/yyyy, hh:mm a");

    visitStartDateController.text = formatter.format(now);
    visitEndDateController.text = formatter.format(now.add(Duration(hours: 1)));

    await fetchAllDropdownData(context, id);
    initialDataForMySelf(context, id);
    initializePreviousData(context, id);
  }

  Future<void> fetchAllDropdownData(BuildContext context, int? id) async {
    final userJson = await SecureStorageHelper.getUser();
    if (userJson == null || userJson.isEmpty) {
      debugPrint("No user data found in secure storage");
      return;
    }

    userResponse = LoginTokenUserResponse.fromJson(jsonDecode(userJson));

    try {
      await Future.wait([
        if (applyPassCategory == ApplyPassCategory.myself.name || isUpdate) apiGetById(context, userResponse!, id),
        apiLocationDropdown(context),
        apiNationalityDropdown(context),
        apiVisitRequestDropdown(context),
        apiVisitPurposeDropdown(context),
        apiDeviceTypeDropdown(context),
        apiDevicePurposeDropdown(context),
        apiPlateSourceDropdown(context),
        apiPlateLetterDropdown(context),
        apiVisitingHoursConfig(context),
        apiValidatePhotoConfig(context),
      ]);
    } catch (e) {
      debugPrint('Dropdown fetch error: $e');
    }
  }

  void initialDataForMySelf(BuildContext context, int? id) async {
    if (applyPassCategory == ApplyPassCategory.myself.name || isUpdate) {
      if (isUpdate) {
        final approvalStatus = getByIdResult?.user?.sApprovalStatusEn ?? "";

        if (approvalStatus == 'Rejected' ||
            approvalStatus == 'Cancelled' ||
            approvalStatus == 'Expired' ||
            approvalStatus == 'Approved') {
          isEnable = false;
        } else if (approvalStatus == 'Pending' || approvalStatus == 'Request Info') {
          evaluateEditableStatus(getByIdResult?.user);
        }
      }
      visitorNameController.text =
          isUpdate ? getByIdResult?.user?.sVisitorNameEn ?? "" : getByIdResult?.user?.sFullName ?? "";
      companyNameController.text =
          isUpdate ? getByIdResult?.user?.sSponsor ?? "" : getByIdResult?.user?.sCompanyName ?? "";

      final nationalityData = nationalityMenu
          .firstWhere((item) => item.iso3 == getByIdResult?.user?.iso3, orElse: () => CountryData());
      nationalityController.text =
          getLocalizedText(currentLang: context.lang, arabic: nationalityData.nameAr, english: nationalityData.name);

      selectedNationality = getByIdResult?.user?.iso3 ?? "";
      selectedNationalityCodes = nationalityData.phonecode.toString() ?? "";
      phoneNumberController.text =
          isUpdate ? getByIdResult?.user?.visitorMobile ?? "" : getByIdResult?.user?.sMobileNumber ?? "";
      emailController.text = isUpdate ? getByIdResult?.user?.visitorEmail ?? "" : getByIdResult?.user?.sEmail ?? "";

      idTypeController.text = (() {
        final item = idTypeMenu.firstWhere(
              (item) => item.value == getByIdResult?.user?.nDocumentType,
          orElse: () => DocumentIdModel(labelEn: "", labelAr: "", value: 0),
        );
        return context.lang == LanguageCode.ar.name ? item.labelAr : item.labelEn;
      })();

      selectedIdValue = getByIdResult?.user?.nDocumentType.toString() ?? "";
      selectedIdType = idTypeController.text ?? "";

      iqamaController.text =
          (getByIdResult?.user?.sIqama?.isNotEmpty ?? false) ? decryptAES(getByIdResult!.user!.sIqama!) : "";
      passportNumberController.text =
          (getByIdResult?.user?.passportNumber?.isNotEmpty ?? false)
              ? decryptAES(getByIdResult!.user!.passportNumber!)
              : "";

      nationalityIdController.text =
          (getByIdResult?.user?.eidNumber?.isNotEmpty ?? false) ? decryptAES(getByIdResult!.user!.eidNumber!) : "";

      documentNameController.text =
          (getByIdResult?.user?.sOthersDoc?.isNotEmpty ?? false) ? decryptAES(getByIdResult!.user!.sOthersDoc!) : "";

      documentNumberController.text =
          (getByIdResult?.user?.sOthersValue?.isNotEmpty ?? false)
              ? decryptAES(getByIdResult!.user!.sOthersValue!)
              : "";
      expiryDateController.text = (getByIdResult?.user?.dTIqamaExpiry
          ?.trim()
          .isNotEmpty == true
          ? getByIdResult?.user?.dTIqamaExpiry!
          : getByIdResult?.user?.dtPassportExpiryDate
          ?.trim()
          .isNotEmpty == true
          ? getByIdResult?.user?.dtPassportExpiryDate!
          : getByIdResult?.user?.dtEidExpiryDate
          ?.trim()
          .isNotEmpty == true
          ? getByIdResult?.user?.dtEidExpiryDate!
          : getByIdResult?.user?.dTOthersExpiry?.trim() ?? '').toString().toDisplayDateOnly() ?? "";

      vehicleNumberController.text = getByIdResult?.user?.sVehicleNo ?? "";

      if(getByIdResult?.vehicle == null) isCheckedVehicle = false;

      if(getByIdResult?.vehicle != null) {
        selectedPlateType = getByIdResult?.vehicle?.nPlateSource ?? 0;
        plateTypeController.text = (() {
          final item = plateTypeDropdownData.firstWhere(
                (item) => item.nDetailedCode == selectedPlateType,
            orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
          );
          return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
        })();
        selectedPlateLetter1 = getByIdResult?.vehicle?.nPlateLetter1 ?? 0;
        plateLetter1Controller.text = (() {
          final item = plateLetterDropdownData.firstWhere(
                (item) => item.nDetailedCode == selectedPlateLetter1,
            orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
          );
          return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
        })();
        selectedPlateLetter2 = getByIdResult?.vehicle?.nPlateLetter2 ?? 0;
        plateLetter2Controller.text = (() {
          final item = plateLetterDropdownData.firstWhere(
                (item) => item.nDetailedCode == selectedPlateLetter2,
            orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
          );
          return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
        })();
        selectedPlateLetter3 = getByIdResult?.vehicle?.nPlateLetter3 ?? 0;
        plateLetter3Controller.text = (() {
          final item = plateLetterDropdownData.firstWhere(
                (item) => item.nDetailedCode == selectedPlateLetter3,
            orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
          );
          return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
        })();
        plateNumberController.text = getByIdResult?.vehicle?.sPlateNumber ?? "";
      }

      // fetchRequiredFiles(context);
      apiGetFile(context, type: 1);
      //Update Part
      if (isUpdate) {
        apiGetSearchComment(context, id);
        selectedLocationId = getByIdResult?.user?.nLocationId;
        locationController.text = (() {
          final item = locationDropdownData.firstWhere(
                (item) => item.nLocationId == getByIdResult?.user?.nLocationId,
            orElse: () => LocationDropdownResult(),
          );
          return context.lang == LanguageCode.ar.name
              ? (item.sLocationNameAr ?? "")
              : (item.sLocationNameEn ?? "");
        })();

        visitRequestTypeController.text = (() {
          final item = visitRequestTypesDropdownData.firstWhere(
                (item) => item.nDetailedCode == getByIdResult?.user?.nVisitType,
            orElse: () => VisitRequestDropdownResult(),
          );
          return context.lang == LanguageCode.ar.name
              ? (item.sDescA ?? "")
              : (item.sDescE ?? "");
        })();

        selectedVisitRequest = getByIdResult?.user?.nVisitType?.toString() ?? "";

        visitPurposeController.text = (() {
          final item = visitPurposeDropdownData.firstWhere(
                (item) => item.nPurposeId == getByIdResult?.user?.purpose,
            orElse: () => VisitPurposeDropdownResult(),
          );
          return context.lang == LanguageCode.ar.name
              ? (item.sPurposeAr ?? "")
              : (item.sPurposeEn ?? "");
        })();

        selectedVisitPurpose = getByIdResult?.user?.purpose.toString() ?? "";
        if(getByIdResult?.user?.purpose == 60) visitPurposeOtherController.text = getByIdResult?.user?.purposeOtherValue ?? "";

        mofaHostEmailController.text = getByIdResult?.user?.sVisitingPersonEmail ?? "";
        visitStartDateController.text = getByIdResult?.user?.dtAppointmentStartTime?.toDisplayDateTime() ?? "";
        visitEndDateController.text = getByIdResult?.user?.dtAppointmentEndTime?.toDisplayDateTime() ?? "";
        noteController.text = getByIdResult?.user?.sRemarks ?? "";
        addMultipleDevicesFromResult(getByIdResult?.devices);
      }
    }
  }

  void initializePreviousData(BuildContext context, int? id) async {
    final jsonString = await SecureStorageHelper.getAppointmentData();
    final jsonImageString = await SecureStorageHelper.getUploadedImage();
    print("Stored appointment JSON string: $jsonString");

    if (jsonString != null && jsonString.isNotEmpty) {
      final userData = AddAppointmentRequest.fromJson(jsonDecode(jsonString));
      visitorNameController.text = userData.fullName ?? "";
      companyNameController.text = userData.sponsor ?? "";
      nationalityController.text =
          nationalityMenu
              .firstWhere((item) => item.iso3 == userData.nationality, orElse: () => CountryData())
              .name ??
              "";
      selectedNationality = userData.nationality ?? "";
      selectedNationalityCodes =  nationalityMenu
          .firstWhere((item) => item.iso3 == userData.nationality, orElse: () => CountryData())
          .phonecode.toString() ?? "";
      phoneNumberController.text =
          userData.mobileNo ?? "";
      emailController.text = userData.email ?? "";
      idTypeController.text = (() {
        final item = idTypeMenu.firstWhere(
              (item) => item.value == userData.idType,
          orElse: () => DocumentIdModel(labelEn: "", labelAr: "", value: 0),
        );
        return context.lang == LanguageCode.ar.name ? item.labelAr : item.labelEn;
      })();

      selectedIdValue = userData.idType?.toString() ?? "";
      selectedIdType = idTypeController.text ?? "";
      iqamaController.text = userData.sIqama ?? "";
      passportNumberController.text = userData.passportNumber ?? "";

      nationalityIdController.text = userData.eidNumber ?? "";

      documentNameController.text = userData.sOthersDoc ?? "";

      documentNumberController.text = userData.sOthersValue ?? "";

      final expiryDate = switch (IdTypeExtension.fromInt(userData.idType)) {
        IdType.nationalId => userData.dtEidExpiryDate,
        IdType.passport => userData.dtPassportExpiryDate,
        IdType.iqama => userData.dtIqamaExpiry,
        IdType.other => userData.dtOthersExpiry,
        _ => null,
      };

      expiryDateController.text = expiryDate?.toDisplayDate() ?? "";

      vehicleNumberController.text = userData.sVehicleNo ?? "";

      selectedPlateType = userData.nPlateSource ?? 0;
      plateTypeController.text = (() {
        final item = plateTypeDropdownData.firstWhere(
              (item) => item.nDetailedCode == selectedPlateType,
          orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
        );
        return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
      })();
      selectedPlateLetter1 = userData.nPlateLetter1 ?? 0;
      plateLetter1Controller.text = (() {
        final item = plateLetterDropdownData.firstWhere(
              (item) => item.nDetailedCode == selectedPlateLetter1,
          orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
        );
        return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
      })();
      selectedPlateLetter2 = userData.nPlateLetter2 ?? 0;
      plateLetter2Controller.text = (() {
        final item = plateLetterDropdownData.firstWhere(
              (item) => item.nDetailedCode == selectedPlateLetter2,
          orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
        );
        return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
      })();
      selectedPlateLetter3 = userData.nPlateLetter3 ?? 0;
      plateLetter3Controller.text = (() {
        final item = plateLetterDropdownData.firstWhere(
              (item) => item.nDetailedCode == selectedPlateLetter3,
          orElse: () => DeviceDropdownResult(sDescE: "", sDescA: ""),
        );
        return context.lang == LanguageCode.ar.name ? item.sDescA ?? "" : item.sDescE ?? "";
      })();

      plateNumberController.text = userData.sPlateNumber ?? "";

      selectedLocationId = userData.nLocationId;
      locationController.text = (() {
        final item = locationDropdownData.firstWhere(
              (item) => item.nLocationId == userData.nLocationId,
          orElse: () => LocationDropdownResult(),
        );
        return context.lang == LanguageCode.ar.name
            ? (item.sLocationNameAr ?? "")
            : (item.sLocationNameEn ?? "");
      })();

      visitRequestTypeController.text = (() {
        final item = visitRequestTypesDropdownData.firstWhere(
              (item) => item.nDetailedCode == userData.nVisitType,
          orElse: () => VisitRequestDropdownResult(),
        );
        return context.lang == LanguageCode.ar.name
            ? (item.sDescA ?? "")
            : (item.sDescE ?? "");
      })();

        selectedVisitRequest = userData.nVisitType?.toString() ?? "";

      visitPurposeController.text = (() {
        final item = visitPurposeDropdownData.firstWhere(
              (item) => item.nPurposeId == userData.purpose,
          orElse: () => VisitPurposeDropdownResult(),
        );
        return context.lang == LanguageCode.ar.name
            ? (item.sPurposeAr ?? "")
            : (item.sPurposeEn ?? "");
      })();

        selectedVisitPurpose = userData.purpose.toString() ?? "";
      if(userData.purpose == 60) visitPurposeOtherController.text = userData.purposeOtherValue ?? "";

      mofaHostEmailController.text = userData.sVisitingPersonEmail ?? "";
        visitStartDateController.text = userData.dtAppointmentStartTime.toString().toDisplayDateTimeString() ?? "";
        visitEndDateController.text = userData.dtAppointmentEndTime.toString().toDisplayDateTimeString() ?? "";
      noteController.text = userData.remarks ?? "";
      final deviceResults = convertDeviceModelsToResults(userData.devices ?? []);
      addMultipleDevicesFromResult(deviceResults);
    }

    if (jsonImageString != null && jsonImageString.isNotEmpty) {
      final imageMap = jsonDecode(jsonImageString);

      print("imageMap = $imageMap");

      // Read and cast raw byte lists safely
      final dynamic rawImageData = imageMap['imageUploaded'];
      final dynamic rawDocumentData = imageMap['documentUploaded'];
      final dynamic rawVehicleData = imageMap['vehicleRegistrationUploaded'];
      final String? selectedIdType = imageMap['selectedIdType'];

      // Convert to Uint8List only if it's actually a list
      final Uint8List? imageBytes = rawImageData is List ? Uint8List.fromList(rawImageData.cast<int>()) : null;
      final Uint8List? documentBytes = rawDocumentData is List ? Uint8List.fromList(rawDocumentData.cast<int>()) : null;
      final Uint8List? vehicleBytes = rawVehicleData is List ? Uint8List.fromList(rawVehicleData.cast<int>()) : null;

      // Set to your state
      uploadedImageBytes = imageBytes;
      uploadedDocumentBytes = documentBytes;
      uploadedVehicleImageBytes = vehicleBytes;
    }

  }

  List<DeviceResult> convertDeviceModelsToResults(List<DeviceModel> models) {
    return models.map((model) {
      return DeviceResult(
        appointmentDeviceId: model.appointmentDeviceId,
        appointmentId: null, // Provide if needed
        deviceType: model.deviceType,
        deviceTypeOthersValue: model.deviceTypeOthersValue,
        deviceModel: model.deviceModel,
        serialNumber: model.serialNumber,
        devicePurpose: model.devicePurpose,
        devicePurposeOthersValue: model.devicePurposeOthersValue,
        approvalStatus: model.approvalStatus,
        currentApprovalStatus: null, // Provide if needed
        comment: null,
      );
    }).toList();
  }

  void fetchRequiredFiles(BuildContext context) {
    final user = getByIdResult?.user;

    final Set<int> typesToFetch = {};

    // File type 1: Photo
    if (user?.havePhoto == 1) typesToFetch.add(1);

    // File type 4: Vehicle registration
    if (user?.haveVehicleRegistration == 1) typesToFetch.add(4);

    // ID-based types
    final idType = selectedIdType; // e.g. "National ID", "Passport", etc.

    // Your idTypeMenu list (make sure this is accessible here)
    final List<DocumentIdModel> idTypeMenu = [
      DocumentIdModel(labelEn: "Iqama", labelAr: "الإقامة", value: 2244),
      DocumentIdModel(labelEn: "National ID", labelAr: "الهوية_الوطنية", value: 24),
      DocumentIdModel(labelEn: "Passport", labelAr: "جواز_السفر", value: 26),
      DocumentIdModel(labelEn: "Other", labelAr: "أخرى", value: 2245),
    ];

    // Map from idTypeMenu.value to typesToFetch code
    final fetchCodeMap = {
      24: 2,    // National ID → 2
      26: 3,    // Passport → 3
      2244: 5,  // Iqama → 5
      2245: 6,  // Other → 6
    };

    // Find matching item by English label (idType)
    final matchingItem = idTypeMenu.firstWhere(
          (item) => item.labelEn == idType,
      orElse: () => DocumentIdModel(labelEn: "", labelAr: "", value: 0),
    );

    if (matchingItem.value != 0) {
      final code = fetchCodeMap[matchingItem.value];
      if (code != null) {
        typesToFetch.add(code);
      }
    }

    // Now call the API for each required type
    for (final type in typesToFetch) {
      apiGetFile(context, type: type);
    }
  }


  void evaluateEditableStatus(GetByIdUser? details) {
    final currentOrder = details?.nCurrentApproverOrderNo ?? -1;
    final isMoreInfoRequired = details?.nIsHostRequiredMoreInfo == 1;

    if (currentOrder > 1) {
      isEnable = isMoreInfoRequired; // true if 1, false if 0
    } else {
      isEnable = true; // always editable for currentOrder <= 1
    }
  }

  int _getFileType(String idType) {
    switch (idType) {
      case "National ID":
        return 2;
      case "Passport":
        return 3;
      case "Iqama":
        return 5;
      case "Other":
        return 6;
      default:
        return 4;
    }
  }

  Future<void> apiGetFile(BuildContext context, {required int type}) async {
    try {
      final response = await ApplyPassRepository().apiGetFile(
        GetFileRequest(id: getByIdResult?.user?.nAppointmentId ?? appointmentId, type: type),
        context,
      );

      if (response is! GetFileResult) return;

      final decodedBytes = base64Decode(response.photoFile ?? "");

      print(type);
      if (type == 1) {
        uploadedImageBytes = decodedBytes;
        return;
      }

      final isPdf = response.contentType == "application/pdf";

      if (type == 4) {
        uploadedVehicleImageBytes = decodedBytes;
        _showFilePreview(context, isPdf, uploadedVehicleImageBytes!);
      } else {
        uploadedDocumentBytes = decodedBytes;
        _showFilePreview(context, isPdf, uploadedDocumentBytes!);
      }
    } catch (e) {
      debugPrint("Error in apiGetFile: $e");
    }
  }

  Future<void> localGetFile(BuildContext context, {required int type}) async {
    try {
      if (type == 4) {
        _showFilePreview(context, false, uploadedVehicleImageBytes!);
      } else {
        _showFilePreview(context, false, uploadedDocumentBytes!);
      }
    } catch (e) {
      debugPrint("Error in localGetFile: $e");
    }
  }

  void _showFilePreview(BuildContext context, bool isPdf, Uint8List bytes) {
    if (isPdf) {
      Navigator.pushNamed(context, AppRoutes.pdfViewer, arguments: bytes);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) =>
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(LucideIcons.x))),
                  5.verticalSpace,
                  ClipRRect(borderRadius: BorderRadius.circular(6.0), child: Image.memory(bytes)),
                ],
              ),
            ),
      );
    }
  }

  Future<void> apiGetSearchComment(BuildContext context, int? id, {int? page}) async {
    final response = await SearchPassRepository().apiSearchComment(
      SearchCommentRequest(
        encryptedId: id.toString() ?? "",
        nCommentType: 20,
        nRoleId: 0,
        pageNumber: page ?? 1,
        pageSize: 10,
        search: "",
      ),
      context,
    );

    final result = response as SearchCommentResult;
    searchCommentData = List<SearchCommentData>.from(result.data ?? []);
    _totalPages = result.pagination?.pages ?? 1;
    _totalCount = result.pagination?.count ?? 0;

    notifyListeners();
  }

  Future<void> apiGetById(BuildContext context, LoginTokenUserResponse user, int? id) async {
    try {
      final encryptedId = encryptAES(isUpdate ? id.toString() : user.userId.toString());

      final result = await ApplyPassRepository().apiGetById(
        DeviceDropdownRequest(encryptedId: encryptedId),
        context,
        isUpdate: isUpdate,
      );

      if (result is GetByIdResult) {
        getByIdResult = result;
      } else {
        debugPrint("Unexpected result type in apiGetById");
      }
    } catch (e) {
      debugPrint("Error in apiGetById: $e");

    }
  }



  Future<void> apiSearchVisitor(BuildContext context) async {
    try {
      // Check if all fields are empty
      final isAllFieldsEmpty = emailSearchController.text.trim().isEmpty &&
          nationalityIdSearchController.text.trim().isEmpty &&
          iqamaSearchController.text.trim().isEmpty &&
          phoneNumberSearchController.text.trim().isEmpty &&
          passportSearchController.text.trim().isEmpty;

      if (isAllFieldsEmpty) {
        // Show a message or just return silently
        debugPrint("Search fields are all empty. Aborting API call.");
        return;
      }

      final result = await ApplyPassRepository().apiSearchUser(
        SearchVisitorRequest(
          nEmployeeId: int.parse(userResponse?.userId ?? "0"),
          nHostId: 0,
          nUserId: int.parse(userResponse?.userId ?? "0"),
          sEmail: emailSearchController.text,
          sId: nationalityIdSearchController.text,
          sIqama: iqamaSearchController.text,
          sNumber: phoneNumberSearchController.text,
          sPassportNumber: passportSearchController.text
        ),
        context,
      );

      if (result is SearchVisitorResult) {
        if (result.appointment == null) {
          ToastHelper.showError(context.readLang.translate(AppLanguageText.visitorNotFound));
          return;
        }

        clearSearchField();
        searchExpandedNotifier.value = false;
        setSearchVisitorData(context, result);
      } else {
        debugPrint("Unexpected result type in Search apiGetById");
      }
    } catch (e) {
      debugPrint("Error in Search apiGetById: $e");

    }
  }

  void setSearchVisitorData(BuildContext context, SearchVisitorResult searchResult) {

      visitorNameController.text = searchResult.appointment?.sVisitorNameEn ?? "";
      companyNameController.text = searchResult.appointment?.sSponsor ?? "" ;

      final nationalityData = nationalityMenu
          .firstWhere((item) => item.iso3 == searchResult.appointment?.nationality, orElse: () => CountryData());
      nationalityController.text =
          getLocalizedText(currentLang: context.lang, arabic: nationalityData.nameAr, english: nationalityData.name);

      selectedNationality = searchResult.appointment?.nationality ?? "";
      selectedNationalityCodes = nationalityData.phonecode.toString();
      phoneNumberController.text = searchResult.appointment?.sMobileNo ?? "";
      emailController.text = searchResult.appointment?.sEmail ?? "";

      idTypeController.text = (() {
        final item = idTypeMenu.firstWhere(
              (item) => item.value == searchResult.appointment?.nDocumentType,
          orElse: () => DocumentIdModel(labelEn: "", labelAr: "", value: 0),
        );
        return context.lang == LanguageCode.ar.name ? item.labelAr : item.labelEn;
      })();

      selectedIdValue = searchResult.appointment?.nDocumentType.toString() ?? "";
      selectedIdType = idTypeController.text ?? "";

      iqamaController.text = searchResult.appointment?.sIqama ?? "";
      passportNumberController.text = searchResult.appointment?.passportNumber ?? "";

      nationalityIdController.text = searchResult.appointment?.eidNumber ?? "";

      documentNameController.text = searchResult.appointment?.sOthersDoc ?? "";

      documentNumberController.text = searchResult.appointment?.sOthersValue ?? "";

      expiryDateController.text = (
          searchResult.appointment?.dtIqamaExpiry?.trim().isNotEmpty == true
              ? searchResult.appointment!.dtIqamaExpiry
              : searchResult.appointment?.dtPassportExpiryDate?.trim().isNotEmpty == true
              ? searchResult.appointment!.dtPassportExpiryDate
              : searchResult.appointment?.dtEidExpiryDate?.trim().isNotEmpty == true
              ? searchResult.appointment!.dtEidExpiryDate
              : searchResult.appointment?.dtOthersExpiry?.trim()
      )?.toString().toDisplayDateOnly() ?? '';

      vehicleNumberController.text = searchResult.appointment!.sVehicleNo ?? "";

      if(searchResult.vehicle == null) isCheckedVehicle = false;

      if(searchResult.vehicle != null) {
        selectedPlateType = searchResult.vehicle?.nPlateSource ?? 0;
        plateTypeController.text =
            plateTypeDropdownData
                .firstWhere((item) => item.nDetailedCode == selectedPlateType, orElse: () => DeviceDropdownResult())
                .sDescE ??
                "";
        selectedPlateLetter1 = searchResult.vehicle?.nPlateLetter1 ?? 0;
        plateLetter1Controller.text =
            plateLetterDropdownData
                .firstWhere((item) => item.nDetailedCode == selectedPlateLetter1, orElse: () => DeviceDropdownResult())
                .sDescE ??
                "";
        selectedPlateLetter2 = searchResult.vehicle?.nPlateLetter2 ?? 0;
        plateLetter2Controller.text =
            plateLetterDropdownData
                .firstWhere((item) => item.nDetailedCode == selectedPlateLetter2, orElse: () => DeviceDropdownResult())
                .sDescE ??
                "";
        selectedPlateLetter3 = searchResult.vehicle?.nPlateLetter3 ?? 0;
        plateLetter3Controller.text =
            plateLetterDropdownData
                .firstWhere((item) => item.nDetailedCode == selectedPlateLetter3, orElse: () => DeviceDropdownResult())
                .sDescE ??
                "";
        plateNumberController.text = searchResult.vehicle?.sPlateNumber ?? "";
      }

      appointmentId = searchResult.appointment?.nAppointmentId ?? 0;
      lastAppointmentId = searchResult.appointment?.nAppointmentId ?? 0;

      havePhoto = searchResult.appointment?.havePhoto ?? 0;
      haveDocument = (searchResult.appointment?.havePassport == 1 ||
          searchResult.appointment?.haveIqama == 1 ||
          searchResult.appointment?.haveEid == 1 ||
          searchResult.appointment?.haveOthers == 1) ? 1 : 0;
      haveVehicleRegistration = searchResult.appointment?.haveVehicleRegistration ?? 0;

      if (searchResult.appointment?.havePhoto == 1) {
        apiGetFile(context, type: 1);
      }

       notifyListeners();

  }


  // Location dropdown
  Future<void> apiLocationDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiLocationDropDown({}, context);
      if (result is List<LocationDropdownResult>) {
        locationDropdownData = result;
      } else {
        debugPrint("Unexpected result type in apiLocationDropdown");
      }
    } catch (e) {
      debugPrint("Error in apiLocationDropdown: $e");
    }
  }

  // Nationality dropdown
  Future<void> apiNationalityDropdown(BuildContext context) async {
    try {
      final result = await AuthRepository().apiCountryList({}, context);
      if (result is List<CountryData>) {
        nationalityMenu = result;
      } else {
        debugPrint("Unexpected result type in apiNationalityDropdown");
      }
    } catch (e) {
      debugPrint("Error in apiNationalityDropdown: $e");
    }
  }

  // Visit Purpose dropdown
  Future<void> apiVisitPurposeDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiVisitPurposeDropDown(
        VisitPurposeDropdownRequest(encryptedVisitRequestTypeId: ""),
        context,
      );
      if (result is List<VisitPurposeDropdownResult>) {
        visitPurposeDropdownData = result;
      } else {
        debugPrint("Unexpected result type in apiVisitPurposeDropdown");
      }
    } catch (e) {
      debugPrint("Error in apiVisitPurposeDropdown: $e");
    }
  }

  // Visit Request dropdown
  Future<void> apiVisitRequestDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiVisitRequestDropDown({}, context);
      if (result is List<VisitRequestDropdownResult>) {
        visitRequestTypesDropdownData = result;

        visitRequestTypesDropdownData.removeWhere((item) => item.nDetailedCode == 2191);
      } else {
        debugPrint("Unexpected result type in apiVisitRequestDropdown");
      }
    } catch (e) {
      debugPrint("Error in apiVisitRequestDropdown: $e");
    }
  }

  // Device Type dropdown
  Future<void> apiDeviceTypeDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiDeviceDropDown(
        DeviceDropdownRequest(encryptedId: encryptAES("1036")),
        context,
      );
      if (result is List<DeviceDropdownResult>) {
        deviceTypeDropdownData = result;
      } else {
        debugPrint("Unexpected result type in apiDeviceTypeDropdown");
      }
    } catch (e) {
      debugPrint("Error in apiDeviceTypeDropdown: $e");
    }
  }

  //Device Purpose dropdown Api call
  Future<void> apiDevicePurposeDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiDeviceDropDown(
        DeviceDropdownRequest(encryptedId: encryptAES("1037")),
        context,
      );

      if (result is List<DeviceDropdownResult>) {
        devicePurposeDropdownData = result;
      } else {
        debugPrint("Unexpected result type from apiDeviceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiDevicePurposeDropdown: $e");
    }
  }

  //Plate Source dropdown Api call
  Future<void> apiPlateSourceDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiPlateSourceDropDown({}, context);

      if (result is List<DeviceDropdownResult>) {
        plateTypeDropdownData = result;
      } else {
        debugPrint("Unexpected result type from apiPlateSourceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiPlateSourceDropdown: $e");
    }
  }

  //Plate Source dropdown Api call
  Future<void> apiPlateLetterDropdown(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiPlateLetterDropDown({}, context);

      if (result is List<DeviceDropdownResult>) {
        plateLetterDropdownData = result;
      } else {
        debugPrint("Unexpected result type from apiPlateLetterDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiPlateLetterDropdown: $e");
    }
  }

  Future<void> apiVisitingHoursConfig(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiVisitingHoursConfig({}, context);
      if (result is VisitingHoursConfigResult) {
        apiVisitStartTime = CommonUtils.parseTimeStringToTimeOfDay(result.visitorsStartTime ?? "");
        apiVisitEndTime = CommonUtils.parseTimeStringToTimeOfDay(result.visitorsEndTime ?? "");
      } else {
        debugPrint("Unexpected result type from apiVisitingHoursConfig");
      }
    } catch (e) {
      debugPrint("Error in apiVisitingHoursConfig: $e");
    }
  }

  Future<void> apiValidatePhotoConfig(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiValidatePhotoConfig({}, context);
      if (result is ValidatePhotoConfigResult) {
        isValidatePhotoFromFR = result.isValidatePhotoFromFr ?? false;
      } else {
        debugPrint("Unexpected result type from apiValidatePhotoConfig");
      }
    } catch (e) {
      debugPrint("Error in apiValidatePhotoConfig: $e");
    }
  }

  Future<bool> apiValidatePhoto(BuildContext context) async {
    try {
      // Decide which image to send: file or bytes
      String? base64Image;
      if (uploadedImageFile != null) {
        base64Image = await uploadedImageFile!.toBase64();
      } else if (uploadedImageBytes != null) {
        base64Image = base64Encode(uploadedImageBytes!);
      }

      if (base64Image == null) {
        _showUnexpectedError();
        return false;
      }

      final result = await ApplyPassRepository().apiValidatePhoto(
        ValidatePhotoRequest(
          fullName: visitorNameController.text,
          photo: base64Image,
        ),
        context,
      );

      if (result is! ValidatePhotoResult) {
        _showUnexpectedError();
        return false;
      }

      if (result.isPhotoValid == true) {
        return true;
      }

      // Photo is invalid, handle errors
      if (result.photoErrors != null && result.photoErrors!.isNotEmpty) {
        _handlePhotoErrors(result.photoErrors!, context);
      } else {
        _showUnexpectedError();
      }

      return false;
    } catch (e) {
      _showUnexpectedError();
      return false;
    }
  }

  void _handlePhotoErrors(List<dynamic> errors, BuildContext context) {
    for (var error in errors) {
      final errorCode = error["errorCode"] ?? -1;
      final message = _getErrorMessageByCode(errorCode, context);
      if (message != null) {
        ToastHelper.showError(message);
      }
    }
  }

  void _showUnexpectedError() {
    ToastHelper.showError("Unexpected result");
  }

  String? _getErrorMessageByCode(int errorCode, BuildContext context) {
    final lang = context.readLang;

    const errorCodeToMessageKey = {
      0: AppLanguageText.photoValidationFailed,
      1: AppLanguageText.errorValidatingPhoto,
      2: AppLanguageText.photoSizeIncorrect,
      3: AppLanguageText.photoTooSmall,
      4: AppLanguageText.photoResolutionNotSupported,
      17: AppLanguageText.noPhotoUploaded,
      18: AppLanguageText.noFaceDetectedPhoto,
      19: AppLanguageText.multipleFacesDetected,
      20: AppLanguageText.faceTooSmallPhoto,
      21: AppLanguageText.photoTooBright,
      22: AppLanguageText.photoTooDark,
      23: AppLanguageText.faceTooBlurry,
      24: AppLanguageText.faceNotProperlyAligned,
      33: AppLanguageText.photoAlreadyUsed,
      34: AppLanguageText.photoFaceAlreadyExists,
      36: AppLanguageText.faceAlreadyRegisteredSameName,
    };

    final messageKey = errorCodeToMessageKey[errorCode];
    if (messageKey != null) {
      return lang.translate(messageKey);
    }
    return null;
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
          nExternalRegistrationId: getByIdResult?.user?.nExternalRegistrationId ?? 0,
          nLocationId: selectedLocationId.toString(),
          sEidNumber: encryptAES(nationalityIdController.text),
          sIqama: encryptAES(iqamaController.text),
          sOthersValue: encryptAES(documentNumberController.text),
          sPassportNumber: encryptAES(passportNumberController.text),
        ),
        context,
      );
      if(result == true) {
        ToastHelper.showError(
          context.readLang.translate(AppLanguageText.appointmentExists),
        );
      }
      return result == true;
    } catch (e) {
      print("object crash ${e}");
      return false;
    }
  }

  Future<void> addData() async {
   try {
      final expiryDate = expiryDateController.text.toDateTime().toString();

      // Assign expiry based on ID type
      final Map<String, String?> expiryMap = {'National ID': null, 'Iqama': null, 'Passport': null, 'Other': null};
      expiryMap[selectedIdType ?? ''] = expiryDate;

      // Assign expiry based on ID type
      final Map<String, int?> expiryImageMap = {'National ID': 0, 'Iqama': 0, 'Passport': 0, 'Other': 0};
      expiryImageMap[selectedIdType ?? ''] = haveDocument;

      final user = getByIdResult?.user;
      final userId = int.tryParse(userResponse?.userId ?? "0") ?? 0;

      final appointmentData = AddAppointmentRequest(
        fullName: visitorNameController.text,
        sponsor: companyNameController.text,
        nationality: selectedNationality,
        mobileNo: phoneNumberController.text,
        email: emailController.text,
        idType: int.tryParse(selectedIdValue ?? "") ?? 0,
        sIqama: encryptAES(iqamaController.text),
        passportNumber: encryptAES(passportNumberController.text),
        sOthersDoc: encryptAES(documentNameController.text),
        eidNumber: encryptAES(nationalityIdController.text),
        sOthersValue: encryptAES(documentNumberController.text),
        dtEidExpiryDate: expiryMap['National ID'],
        dtIqamaExpiry: expiryMap['Iqama'],
        dtPassportExpiryDate: expiryMap['Passport'],
        dtOthersExpiry: expiryMap['Other'],
        dtAppointmentStartTime: visitStartDateController.text.toDateTime(),
        dtAppointmentEndTime: visitEndDateController.text.toDateTime(),
        sVehicleNo: vehicleNumberController.text,
        devices: isCheckedDevice ? addedDevices : null,
        nLocationId: selectedLocationId,
        nVisitType: int.tryParse(selectedVisitRequest ?? "") ?? 0,
        purpose: int.tryParse(selectedVisitPurpose ?? "") ?? 0,
        purposeOtherValue: visitPurposeOtherController.text,
        remarks: noteController.text,
        sVisitingPersonEmail: mofaHostEmailController.text,
        haveEid: user?.haveEid ?? expiryImageMap['National ID'],
        havePassport: user?.havePassport ?? expiryImageMap['Passport'],
        haveIqama: user?.haveIqama ?? expiryImageMap['Iqama'],
        havePhoto: user?.havePhoto ?? havePhoto,
        haveVehicleRegistration: user?.haveVehicleRegistration ?? haveVehicleRegistration,
        haveOthers: user?.haveOthers ?? expiryImageMap['Other'],
        userId: userId,
        nExternalRegistrationId: userId,
        nAppointmentId: isUpdate ? user?.nAppointmentId ?? 0 : 0,
        nCreatedByExternal: userId,
        lastAppointmentId: user?.nAppointmentId ?? lastAppointmentId,
        nSelfPass: user?.nSelfPass ?? (applyPassCategory == ApplyPassCategory.myself.name ? 1 : 2),
        nVisitCreatedFrom: 2,
        nVisitUpdatedFrom: 2,
        resubmissionComments: resubmissionCommentController.text,
        nPlateSource:  isCheckedVehicle ? selectedPlateType : null,
        nPlateLetter1: isCheckedVehicle ? selectedPlateLetter1 : null,
        nPlateLetter2: isCheckedVehicle ? selectedPlateLetter2 : null,
        nPlateLetter3: isCheckedVehicle ? selectedPlateLetter3 : null,
        sPlateNumber: isCheckedVehicle ? plateNumberController.text : null,
      );

      // Build image upload data
      final imageDataFile = {
        "imageUploaded": uploadedImageFile == null ? uploadedImageBytes : await uploadedImageFile?.toBase64(),
        "documentUploaded": uploadedDocumentFile == null ? uploadedDocumentBytes : await uploadedDocumentFile
            ?.toBase64(),
        "vehicleRegistrationUploaded": uploadedVehicleRegistrationFile == null
            ? uploadedVehicleImageBytes
            : await uploadedVehicleRegistrationFile?.toBase64(),
        "selectedIdType": selectedIdType,
      };

      debugPrint("Appointment Data: ${jsonEncode(appointmentData.toJson())}");

      // Persist locally
      await SecureStorageHelper.setAppointmentData(jsonEncode(appointmentData.toJson()));
      await SecureStorageHelper.setUploadedImage(jsonEncode(imageDataFile));
    } catch (e) {
     print("e value");
     print(e);
   }

  }

  Future<AddAppointmentRequest?> getStoredAppointmentData() async {
    try {
      final jsonString = await SecureStorageHelper.getAppointmentData();

      if (jsonString?.isNotEmpty ?? false) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString!);
        return AddAppointmentRequest.fromJson(jsonMap);
      }
    } catch (e, stackTrace) {
      debugPrint('Error decoding appointment data: $e\n$stackTrace');
    }

    return null;
  }

  void goToPreviousPage(BuildContext context, int? id) {
    if (_currentPage > 1) {
      _currentPage--;
      apiGetSearchComment(context, id);
    }
  }

  void goToNextPage(BuildContext context, int? id) {
    if (_currentPage < _totalPages) {
      _currentPage++;
      apiGetSearchComment(context, id);
    }
  }

  // Update User Verify checkbox state
  void userVerifyChecked(BuildContext context, bool? value) {
    isChecked = value!;
  }

  // Update User Verify checkbox state
  void deviceDetailChecked(BuildContext context, bool? value) {
    isCheckedDevice = value!;
  }

  void vehicleDetailChecked(bool? value) {
    isCheckedVehicle = value!;
  }

  Future<void> uploadImage({bool fromCamera = false, bool cropAfterPick = true}) async {
    final image = await FileUploadHelper.pickImage(fromCamera: fromCamera, cropAfterPick: cropAfterPick);

    if (image != null) {
      uploadedImageFile = image;
      photoUploadValidation = false;
      notifyListeners();
    }
  }

  Future<void> uploadVehicleRegistrationImage() async {
    await _uploadFile(fileSetter: (file) => uploadedVehicleRegistrationFile = file);
  }

  Future<void> uploadDocument() async {
    await _uploadFile(
      fileSetter: (file) {
        uploadedDocumentFile = file;
        documentUploadValidation = false;
      },
    );
  }

  /// 🔁 Reusable internal helper method
  Future<void> _uploadFile({
    required void Function(File) fileSetter,
    List<String> allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
  }) async {
    final file = await FileUploadHelper.pickDocument(allowedExtensions: allowedExtensions);
    if (file != null) {
      fileSetter(file);
      notifyListeners();
    }
  }

  Future<void> launchPrivacyUrl() async {
    if (!await launchUrl(Uri.parse(AppStrings.privacyPolicyUrl))) {
      throw Exception('Could not launch ${AppStrings.privacyPolicyUrl}');
    }
  }

  void clearUploadedImage() {
    _uploadedImageFile = null;
    notifyListeners();
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
    deviceTypeOtherController.clear();
    devicePurposeOtherController.clear();
  }

  void removeDevice(int index) {
    // Check if the item being deleted is currently being edited
    if (isEditingDevice && editDeviceIndex == index) {
      // The edited device is being deleted
      cancelEditing(); // Clear and hide fields
    } else if (isEditingDevice && editDeviceIndex != null && index < editDeviceIndex!) {
      // If deleting an item *before* the one being edited, shift the edit index
      editDeviceIndex = editDeviceIndex! - 1;
    }

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
    deviceTypeOtherController.text = device.deviceTypeOthersValue ?? "";
    devicePurposeOtherController.text = device.devicePurposeOthersValue ?? "";
  }

  void cancelEditing() {
    editDeviceIndex = null;
    isEditingDevice = false;
    showDeviceFields = false;

    selectedDeviceType = null;
    selectedDevicePurpose = null;

    deviceTypeController.clear();
    deviceModelController.clear();
    serialNumberController.clear();
    devicePurposeController.clear();
    deviceTypeOtherController.clear();
    devicePurposeOtherController.clear();
  }

  void clearSearchField() {

    iqamaSearchController.clear();
    nationalityIdSearchController.clear();
    passportSearchController.clear();
    emailSearchController.clear();
    phoneNumberSearchController.clear();
  }

  void saveDevice() {
    final isDeviceTypeOther = selectedDeviceType == 2250;
    final isDevicePurposeOther = selectedDevicePurpose == 2254;

    // Validate fields
    if (deviceTypeController.text.isEmpty ||
        deviceModelController.text.isEmpty ||
        serialNumberController.text.isEmpty ||
        devicePurposeController.text.isEmpty ||
        (isDeviceTypeOther && deviceTypeOtherController.text.isEmpty) ||
        (isDevicePurposeOther && devicePurposeOtherController.text.isEmpty)) {
      return;
    }

    final newDevice = DeviceModel(
      deviceTypeString: deviceTypeController.text,
      deviceType: selectedDeviceType,
      deviceModel: deviceModelController.text,
      serialNumber: serialNumberController.text,
      devicePurposeString: devicePurposeController.text,
      devicePurpose: selectedDevicePurpose,
      deviceTypeOthersValue: isDeviceTypeOther ? deviceTypeOtherController.text : null,
      devicePurposeOthersValue: isDevicePurposeOther ? devicePurposeOtherController.text : null,
    );

    if (isEditingDevice && editDeviceIndex != null) {
      addedDevices[editDeviceIndex!] = newDevice; // update
    } else {
      addedDevices.add(newDevice); // add new
    }

    showDeviceFields = false;

    cancelEditing(); // reset form
    notifyListeners();
  }

  void addMultipleDevicesFromResult(List<DeviceResult>? results) {
    if (results == null) {
      isCheckedDevice = false;
      return;
    }

    final deviceModels =
    results.map((r) {
      // selectedDevicePurpose = r.devicePurpose;
      // selectedDeviceType = r.deviceType;

      return DeviceModel(
        appointmentDeviceId: r.appointmentDeviceId ?? 0,
        deviceType: r.deviceType,
        deviceTypeString: _getDeviceTypeString(r.deviceType),
        deviceTypeOthersValue: r.deviceTypeOthersValue ?? "",
        deviceModel: r.deviceModel ?? "",
        serialNumber: r.serialNumber ?? "",
        devicePurpose: r.devicePurpose,
        devicePurposeString: _getDevicePurposeString(r.devicePurpose),
        devicePurposeOthersValue: r.devicePurposeOthersValue ?? "",
        approvalStatus: r.approvalStatus ?? 50,
      );
    }).toList();

    addedDevices.addAll(deviceModels);
    showDeviceFields = false;

    if(addedDevices.isEmpty) {
      isCheckedDevice = false;
    }
    notifyListeners();
  }

  String _getDeviceTypeString(int? type) {
    switch (type) {
      case 2246:
        return "Laptop";
      case 2247:
        return "Phone";
      case 2248:
        return "Tablet";
      case 2249:
        return "USB Drive";
      default:
        return "Other";
    }
  }

  String _getDevicePurposeString(int? purpose) {
    switch (purpose) {
      case 2251:
        return "Presentation";
      case 2252:
        return "Data Collection";
      case 2253:
        return "General Use";
      case 2254:
        return "Other";
      default:
        return "";
    }
  }

  Future<void> nextButton(BuildContext context, VoidCallback onNext) async {
    final isValid = await validation(context);

    runWithLoadingVoid(() async {
      if (isValid) {
        await addData();
        onNext();
      }
    },);
  }

  bool isPhotoFileValid(BuildContext context) {

    final hasPhoto = uploadedImageBytes != null || uploadedImageFile != null;
    final hasDocument = uploadedDocumentBytes != null || uploadedDocumentFile != null;

    if (!hasPhoto || !hasDocument) {
      photoUploadValidation = uploadedImageFile == null;
      documentUploadValidation = uploadedDocumentFile == null;
      return false;
    }

    return true;
  }

  bool isDevicePartiallyFilled() {
    final isDeviceTypeOther = selectedDeviceType == 2250;
    final isPurposeOther = selectedDevicePurpose == 2254;

    final isDeviceTypeEmpty = deviceTypeController.text.trim().isEmpty;
    final isDeviceTypeOtherEmpty = isDeviceTypeOther && deviceTypeOtherController.text.trim().isEmpty;

    final isModelEmpty = deviceModelController.text.trim().isEmpty;
    final isSerialEmpty = serialNumberController.text.trim().isEmpty;

    final isPurposeEmpty = devicePurposeController.text.trim().isEmpty;
    final isPurposeOtherEmpty = isPurposeOther && devicePurposeOtherController.text.trim().isEmpty;

    final allEmpty = isDeviceTypeEmpty &&
        (!isDeviceTypeOther || isDeviceTypeOtherEmpty) &&
        isModelEmpty &&
        isSerialEmpty &&
        isPurposeEmpty &&
        (!isPurposeOther || isPurposeOtherEmpty);

    final allFilled = !isDeviceTypeEmpty &&
        (!isDeviceTypeOther || !isDeviceTypeOtherEmpty) &&
        !isModelEmpty &&
        !isSerialEmpty &&
        !isPurposeEmpty &&
        (!isPurposeOther || !isPurposeOtherEmpty);

    return !allEmpty && !allFilled; // return true if partially filled
  }



  bool get isFormActionAllowed {
    final status = getByIdResult?.user?.sApprovalStatusEn;
    return isEnable || !nonEditableStatuses.contains(status);
  }

  Future<bool> validation(BuildContext context) async {

    final isFormValid = formKey.currentState!.validate();
    final isPhotoValid = _isPhotoValid(context);
    final isDocumentValid = _isDocumentValid(context);

    final allValid = isFormValid && isPhotoValid && isDocumentValid;

    if (!allValid) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.fillAllInformation));
      return false;
    }

    if(isCheckedDevice && addedDevices.isEmpty) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.kindlyAddADevice));
      return false;
    }


    if (!_isVisitTimeWithinApiRange(context)) {
      return false;
    }

    print("isValidatePhotoFromFR not Yet done: $isValidatePhotoFromFR");

    if (isValidatePhotoFromFR) {
      return await apiValidatePhoto(context);
    }
    print("isValidatePhotoFromFR: $isValidatePhotoFromFR");

    if (!await _isEmailValid(context)) {
      return false;
    }
    print("isValidateEmail: came");

    if (!_isExpiryAfterVisitEnd(context)) {
      return false;
    }

    if (!isUpdate && await _hasNoDuplicates(context)) {
      return false;
    }

    return true;
  }

  bool _isPhotoValid(BuildContext context) {
    final user = getByIdResult?.user;

    final hasApiPhoto = (user?.havePhoto ?? 0) == 1 || havePhoto == 1;
    final hasLocalPhoto = uploadedImageBytes != null || uploadedImageFile != null;

    final isValid = hasApiPhoto || hasLocalPhoto;

    return isValid;
  }


  bool _isDocumentValid(BuildContext context) {
    final user = getByIdResult?.user;

    final hasApiDocument = ((user?.haveIqama ?? 0) == 1 ||
        (user?.havePassport ?? 0) == 1 ||
        (user?.haveEid ?? 0) == 1 ||
        (user?.haveOthers ?? 0) == 1) || haveDocument == 1;

    final hasLocalDocument = uploadedDocumentBytes != null || uploadedDocumentFile != null;

    final isValid = hasApiDocument || hasLocalDocument;
    return isValid;
  }


  bool _isVisitTimeWithinApiRange(BuildContext context) {
    final visitStart = CommonUtils.parseFullDateStringToTimeOfDay(visitStartDateController.text);
    final visitEnd = CommonUtils.parseFullDateStringToTimeOfDay(visitEndDateController.text);

    if (apiVisitStartTime != null && apiVisitEndTime != null && visitStart != null && visitEnd != null) {
      final isVisitStartValid = !CommonUtils.isBeforeTimeOfDay(visitStart, apiVisitStartTime!);
      final isVisitEndValid = !CommonUtils.isAfterTimeOfDay(visitEnd, apiVisitEndTime!);

      if (!isVisitStartValid || !isVisitEndValid) {
        final startTimeFormatted = apiVisitStartTime!.format(context);
        final endTimeFormatted = apiVisitEndTime!.format(context);

        ToastHelper.showError("Visit time should be between $startTimeFormatted - $endTimeFormatted");
        return false;
      }
    }

    return true;
  }

  Future<bool> _isEmailValid(BuildContext context) async {
    return await apiValidateEmail(context);
  }

  bool _isExpiryAfterVisitEnd(BuildContext context) {
    try {
      print("Expiry Date: ${expiryDateController.text}");
      print("Visit End Date: ${visitEndDateController.text}");
      final dateFormatWithTime = DateFormat("dd/MM/yyyy, hh:mm a");
      final dateFormatWithoutTime = DateFormat("dd/MM/yyyy");

      final expiryDate = dateFormatWithoutTime.parse(expiryDateController.text);
      final visitEndDate = dateFormatWithTime.parse(visitEndDateController.text);

      if (expiryDate.isBefore(visitEndDate)) {
        ToastHelper.showError(context.readLang.translate(AppLanguageText.expireVisitError));
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Date parsing error: $e");
      debugPrint("Date parsing error: $e");
      return false;
    }
  }

  Future<bool> _hasNoDuplicates(BuildContext context) async {
    return await apiDuplicateAppointment(context);
  }

  Future<void> runWithViewAttachmentPhotoLoader(Future<void> Function() task) async {
    isPhotoLoading = true;
    notifyListeners();

    try {
      await task();
    } finally {
      isPhotoLoading = false;
      notifyListeners();
    }
  }

  Future<void> runWithViewAttachmentDocumentLoader(Future<void> Function() task) async {
    isDocumentLoading = true;
    notifyListeners();

    try {
      await task();
    } finally {
      isDocumentLoading = false;
      notifyListeners();
    }
  }

  Future<void> runWithViewAttachmentTransportLoader(Future<void> Function() task) async {
    isTransportDocumentLoading = true;
    notifyListeners();

    try {
      await task();
    } finally {
      isTransportDocumentLoading = false;
      notifyListeners();
    }
  }

  void notifyDataListeners() {
    notifyListeners();
  }

  //Getter and Setter
  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    if (_isChecked == value) return;
    _isChecked = value;
    notifyListeners();
  }

  bool get isUpdate => _isUpdate;

  set isUpdate(bool value) {
    if (_isUpdate == value) return;
    _isUpdate = value;
    notifyListeners();
  }

  bool get isCheckedDevice => _isCheckedDevice;

  set isCheckedDevice(bool value) {
    if (_isCheckedDevice == value) return;
    _isCheckedDevice = value;
    notifyListeners();
  }

  bool get isCheckedVehicle => _isCheckedVehicle;

  set isCheckedVehicle(bool value) {
    if (_isCheckedVehicle == value) return;
    _isCheckedVehicle = value;
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

  TextEditingController get expiryDateController => _expiryDateController;

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

  File? get uploadedImageFile => _uploadedImageFile;

  set uploadedImageFile(File? value) {
    if (_uploadedImageFile == value) return;
    _uploadedImageFile = value;
    notifyListeners();
  }

  File? get uploadedDocumentFile => _uploadedDocumentFile;

  set uploadedDocumentFile(File? value) {
    if (_uploadedDocumentFile == value) return;
    _uploadedDocumentFile = value;
    notifyListeners();
  }

  File? get uploadedVehicleRegistrationFile => _uploadedVehicleRegistrationFile;

  set uploadedVehicleRegistrationFile(File? value) {
    if (_uploadedVehicleRegistrationFile == value) return;
    _uploadedVehicleRegistrationFile = value;
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

  List<DeviceDropdownResult> get plateLetterDropdownData => _plateLetterDropdownData;

  set plateLetterDropdownData(List<DeviceDropdownResult> value) {
    if (_plateLetterDropdownData == value) return;
    _plateLetterDropdownData = value;
    notifyListeners();
  }

  List<DeviceDropdownResult> get plateTypeDropdownData => _plateTypeDropdownData;

  set plateTypeDropdownData(List<DeviceDropdownResult> value) {
    if (_plateTypeDropdownData == value) return;
    _plateTypeDropdownData = value;
    notifyListeners();
  }

  List<VisitPurposeDropdownResult> get visitPurposeDropdownData => _visitPurposeDropdownData;

  set visitPurposeDropdownData(List<VisitPurposeDropdownResult> value) {
    if (_visitPurposeDropdownData == value) return;
    _visitPurposeDropdownData = value;
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

  // Device Type Controller
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

  List<SearchCommentData> get searchCommentData => _searchCommentData;

  set searchCommentData(List<SearchCommentData> value) {
    if (_searchCommentData == value) return;
    _searchCommentData = value;
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

  GetByIdResult? get getByIdResult => _getByIdResult;

  set getByIdResult(GetByIdResult? value) {
    if (_getByIdResult == value) return;
    _getByIdResult = value;
    notifyListeners();
  }

  String? get applyPassCategory => _applyPassCategory;

  set applyPassCategory(String? value) {
    if (_applyPassCategory == value) return;
    _applyPassCategory = value;
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

  int? get selectedLocationId => _selectedLocationId;

  set selectedLocationId(int? value) {
    if (_selectedLocationId == value) return;
    _selectedLocationId = value;
    notifyListeners();
  }

  TimeOfDay? get apiVisitStartTime => _apiVisitStartTime;

  set apiVisitStartTime(TimeOfDay? value) {
    if (_apiVisitStartTime == value) return;
    _apiVisitStartTime = value;
    notifyListeners();
  }

  TimeOfDay? get apiVisitEndTime => _apiVisitEndTime;

  set apiVisitEndTime(TimeOfDay? value) {
    if (_apiVisitEndTime == value) return;
    _apiVisitEndTime = value;
    notifyListeners();
  }

  LoginTokenUserResponse? get userResponse => _userResponse;

  set userResponse(LoginTokenUserResponse? value) {
    if (_userResponse == value) return;
    _userResponse = value;
    notifyListeners();
  }

  int? get selectedDeviceType => _selectedDeviceType;

  set selectedDeviceType(int? value) {
    if (_selectedDeviceType == value) return;
    _selectedDeviceType = value;
    notifyListeners();
  }

  bool get isValidatePhotoFromFR => _isValidatePhotoFromFR;

  set isValidatePhotoFromFR(bool value) {
    if (_isValidatePhotoFromFR == value) return;
    _isValidatePhotoFromFR = value;
    notifyListeners();
  }

  bool get isPhotoLoading => _isPhotoLoading;

  set isPhotoLoading(bool value) {
    if (_isPhotoLoading == value) return;
    _isPhotoLoading = value;
    notifyListeners();
  }

  bool get isDocumentLoading => _isDocumentLoading;

  set isDocumentLoading(bool value) {
    if (_isDocumentLoading == value) return;
    _isDocumentLoading = value;
    notifyListeners();
  }

  bool get isTransportDocumentLoading => _isTransportDocumentLoading;

  set isTransportDocumentLoading(bool value) {
    if (_isTransportDocumentLoading == value) return;
    _isTransportDocumentLoading = value;
    notifyListeners();
  }

  bool get searchExpanded => _searchExpanded;

  set searchExpanded(bool value) {
    if (_searchExpanded == value) return;
    _searchExpanded = value;
    notifyListeners();
  }

  int get currentPage => _currentPage;

  set currentPage(int value) {
    if (_currentPage == value) return;
    _currentPage = value;
    notifyListeners();
  }

  int get totalPages => _totalPages;

  int get totalCount => _totalCount;

  int? get selectedDevicePurpose => _selectedDevicePurpose;

  set selectedDevicePurpose(int? value) {
    if (_selectedDevicePurpose == value) return;
    _selectedDevicePurpose = value;
    notifyListeners();
  }

  int? get selectedPlateLetter1 => _selectedPlateLetter1;

  set selectedPlateLetter1(int? value) {
    if (_selectedPlateLetter1 == value) return;
    _selectedPlateLetter1 = value;
    notifyListeners();
  }

  int get havePhoto => _havePhoto;

  set havePhoto(int value) {
    if (_havePhoto == value) return;
    _havePhoto = value;
    notifyListeners();
  }

  int get haveDocument => _haveDocument;

  set haveDocument(int value) {
    if (_haveDocument == value) return;
    _haveDocument = value;
    notifyListeners();
  }

  int get haveVehicleRegistration => _haveVehicleRegistration;

  set haveVehicleRegistration(int value) {
    if (_haveVehicleRegistration == value) return;
    _haveVehicleRegistration = value;
    notifyListeners();
  }

  int get appointmentId => _appointmentId;

  set appointmentId(int value) {
    if (_appointmentId == value) return;
    _appointmentId = value;
    notifyListeners();
  }

  int get lastAppointmentId => _lastAppointmentId;

  set lastAppointmentId(int value) {
    if (_lastAppointmentId == value) return;
    _lastAppointmentId = value;
    notifyListeners();
  }

  int? get selectedPlateLetter2 => _selectedPlateLetter2;

  set selectedPlateLetter2(int? value) {
    if (_selectedPlateLetter2 == value) return;
    _selectedPlateLetter2 = value;
    notifyListeners();
  }

  int? get selectedPlateLetter3 => _selectedPlateLetter3;

  set selectedPlateLetter3(int? value) {
    if (_selectedPlateLetter3 == value) return;
    _selectedPlateLetter3 = value;
    notifyListeners();
  }

  int? get selectedPlateType => _selectedPlateType;

  set selectedPlateType(int? value) {
    if (_selectedPlateType == value) return;
    _selectedPlateType = value;
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

  bool get isEnable => _isEnable;

  set isEnable(bool value) {
    if (_isEnable == value) return;
    _isEnable = value;
    notifyListeners();
  }
}
