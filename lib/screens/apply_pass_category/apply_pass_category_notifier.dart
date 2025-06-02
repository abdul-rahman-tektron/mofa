import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/file_uplaod_helper.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/toast_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyPassCategoryNotifier extends BaseChangeNotifier with CommonFunctions {
  // String
  String? _selectedNationality;
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
    TableColumnConfig(label: 'Comment Type', isMandatory: true),
    TableColumnConfig(label: 'Comment By', isMandatory: true),
    TableColumnConfig(label: 'Comment', isMandatory: true),
    TableColumnConfig(label: 'Comment Date', isVisible: true),
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
  TextEditingController _mofaHostEmailController = TextEditingController();
  TextEditingController _visitStartDateController = TextEditingController();
  TextEditingController _visitEndDateController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  //Device Details
  TextEditingController _deviceTypeController = TextEditingController();
  TextEditingController _deviceModelController = TextEditingController();
  TextEditingController _serialNumberController = TextEditingController();
  TextEditingController _devicePurposeController = TextEditingController();

  //Vehicle Details
  TextEditingController plateTypeController = TextEditingController();
  TextEditingController plateLetter1Controller = TextEditingController();
  TextEditingController plateLetter2Controller = TextEditingController();
  TextEditingController plateLetter3Controller = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();

  //Re-submission Comment
  TextEditingController resubmissionCommentController = TextEditingController();

  LoginTokenUserResponse? _userResponse;

  //Functions
  ApplyPassCategoryNotifier(BuildContext context, ApplyPassCategory applyPassCategory, bool isUpdate, int? id) {
    initialize(context, applyPassCategory, isUpdate, id);
  }

  Future<void> initialize(BuildContext context, ApplyPassCategory category, bool isUpdate, int? id) async {
    applyPassCategory = category.name;
    this.isUpdate = isUpdate;

    final now = DateTime.now();
    final formatter = DateFormat("dd/MM/yyyy ،hh:mm a");

    visitStartDateController.text = formatter.format(now);
    visitEndDateController.text = formatter.format(now.add(Duration(hours: 1)));

    await fetchAllDropdownData(context, id);
    initialDataForMySelf(context, id);
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

  void initialDataForMySelf(BuildContext context, int? id) {
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
      nationalityController.text =
          nationalityMenu
              .firstWhere((item) => item.iso3 == getByIdResult?.user?.iso3, orElse: () => CountryData())
              .name ??
          "";
      selectedNationality = getByIdResult?.user?.iso3 ?? "";
      phoneNumberController.text =
          isUpdate ? getByIdResult?.user?.visitorMobile ?? "" : getByIdResult?.user?.sMobileNumber ?? "";
      emailController.text = isUpdate ? getByIdResult?.user?.visitorEmail ?? "" : getByIdResult?.user?.sEmail ?? "";
      idTypeController.text =
          idTypeMenu
              .firstWhere(
                (item) => item.value == getByIdResult?.user?.nDocumentType,
                orElse: () => DocumentIdModel(labelEn: "", labelAr: "", value: 0),
              )
              .labelEn;
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
      expiryDateController.text = getByIdResult?.user?.dTIqamaExpiry?.toDisplayDateOnly() ?? "";
      vehicleNumberController.text = getByIdResult?.user?.sVehicleNo ?? "";

      selectedPlateType = getByIdResult?.vehicle?.nPlateSource ?? 0;
      plateTypeController.text =
          plateTypeDropdownData
              .firstWhere((item) => item.nDetailedCode == selectedPlateType, orElse: () => DeviceDropdownResult())
              .sDescE ??
          "";
      selectedPlateLetter1 = getByIdResult?.vehicle?.nPlateLetter1 ?? 0;
      plateLetter1Controller.text =
          plateLetterDropdownData
              .firstWhere((item) => item.nDetailedCode == selectedPlateLetter1, orElse: () => DeviceDropdownResult())
              .sDescE ??
          "";
      selectedPlateLetter2 = getByIdResult?.vehicle?.nPlateLetter2 ?? 0;
      plateLetter2Controller.text =
          plateLetterDropdownData
              .firstWhere((item) => item.nDetailedCode == selectedPlateLetter2, orElse: () => DeviceDropdownResult())
              .sDescE ??
          "";
      selectedPlateLetter3 = getByIdResult?.vehicle?.nPlateLetter3 ?? 0;
      plateLetter3Controller.text =
          plateLetterDropdownData
              .firstWhere((item) => item.nDetailedCode == selectedPlateLetter3, orElse: () => DeviceDropdownResult())
              .sDescE ??
          "";
      plateNumberController.text = getByIdResult?.vehicle?.sPlateNumber ?? "";

      //Update Part
      if (isUpdate) {
        apiGetSearchComment(context, id);
        locationController.text = getByIdResult?.user?.sLocationNameEn ?? "";
        visitRequestTypeController.text = getByIdResult?.user?.sVisitorTypeEn ?? "";
        selectedVisitRequest = getByIdResult?.user?.nVisaType.toString() ?? "";
        visitPurposeController.text = getByIdResult?.user?.sPurposeE ?? "";
        selectedVisitPurpose = getByIdResult?.user?.purpose.toString() ?? "";
        mofaHostEmailController.text = getByIdResult?.user?.sVisitingPersonEmail ?? "";
        visitStartDateController.text = getByIdResult?.user?.dtAppointmentStartTime?.toDisplayDateTime() ?? "";
        visitEndDateController.text = getByIdResult?.user?.dtAppointmentEndTime?.toDisplayDateTime() ?? "";
        addMultipleDevicesFromResult(getByIdResult?.devices);
      }
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

  Future<void> apiGetFile(BuildContext context, {required int type}) async {
    try {
      final response = await ApplyPassRepository().apiGetFile(
        GetFileRequest(id: getByIdResult?.user?.nAppointmentId ?? 0, type: type),
        context,
      );

      if (response is! GetFileResult) return;

      final decodedBytes = base64Decode(response.photoFile ?? "");

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
      ToastHelper.showError("Failed to load file.");
    }
  }

  void _showFilePreview(BuildContext context, bool isPdf, Uint8List bytes) {
    if (isPdf) {
      Navigator.pushNamed(context, AppRoutes.pdfViewer, arguments: bytes);
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              content: ClipRRect(borderRadius: BorderRadius.circular(6.0), child: Image.memory(bytes)),
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
      ToastHelper.showError("Failed to load data.");
    }
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
      ToastHelper.showError("Failed to load locations.");
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
      ToastHelper.showError("Failed to load nationalities.");
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
      ToastHelper.showError("Failed to load visit purposes.");
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
      ToastHelper.showError("Failed to load visit request types.");
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
      ToastHelper.showError("Failed to load device types.");
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
      ToastHelper.showError("Failed to load device purpose dropdown.");
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
      ToastHelper.showError("Failed to load plate type dropdown.");
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
      ToastHelper.showError("Failed to load plate letter dropdown.");
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
      ToastHelper.showError("Failed to fetch visiting hours configuration.");
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
      ToastHelper.showError("Failed to validate photo config");
    }
  }

  Future<bool> apiValidatePhoto(BuildContext context) async {
    try {
      final result = await ApplyPassRepository().apiValidatePhoto(
        ValidatePhotoRequest(fullName: visitorNameController.text, photo: await uploadedImageFile?.toBase64()),
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
      debugPrint("Error in apiValidatePhoto: $e");
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
      return result == true;
    } catch (e) {
      print("object crash ${e}");
      return false;
    }
  }

  Future<void> addData() async {
    final expiryDate = expiryDateController.text.toDateTime().toString();

    // Assign expiry based on ID type
    final Map<String, String?> expiryMap = {'National ID': null, 'Iqama': null, 'Passport': null, 'Other': null};
    expiryMap[selectedIdType ?? ''] = expiryDate;

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
      devices: addedDevices,
      nLocationId: selectedLocationId,
      nVisitType: int.tryParse(selectedVisitRequest ?? "") ?? 0,
      purpose: int.tryParse(selectedVisitPurpose ?? "") ?? 0,
      remarks: noteController.text,
      sVisitingPersonEmail: mofaHostEmailController.text,
      haveEid: user?.haveEid ?? 0,
      havePassport: user?.havePassport ?? 0,
      haveIqama: user?.haveIqama ?? 0,
      havePhoto: user?.havePhoto ?? 0,
      haveVehicleRegistration: user?.haveVehicleRegistration ?? 0,
      haveOthers: user?.haveOthers ?? 0,
      userId: userId,
      nExternalRegistrationId: userId,
      nCreatedByExternal: userId,
      lastAppointmentId: user?.nAppointmentId ?? 0,
      nSelfPass: user?.nSelfPass ?? (applyPassCategory == ApplyPassCategory.myself.name ? 1 : 2),
      nVisitCreatedFrom: 2,
      nVisitUpdatedFrom: 2,
      resubmissionComments: resubmissionCommentController.text,
      nPlateSource: selectedPlateType,
      nPlateLetter1: selectedPlateLetter1,
      nPlateLetter2: selectedPlateLetter2,
      nPlateLetter3: selectedPlateLetter3,
      sPlateNumber: plateNumberController.text,
    );

    // Build image upload data
    final imageDataFile = {
      "imageUploaded": await uploadedImageFile?.toBase64(),
      "documentUploaded": await uploadedDocumentFile?.toBase64(),
      "vehicleRegistrationUploaded": await uploadedVehicleRegistrationFile?.toBase64(),
      "selectedIdType": selectedIdType,
    };

    debugPrint("Appointment Data: ${jsonEncode(appointmentData.toJson())}");

    // Persist locally
    await SecureStorageHelper.setAppointmentData(jsonEncode(appointmentData.toJson()));
    await SecureStorageHelper.setUploadedImage(jsonEncode(imageDataFile));
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

  void cancelEditing() {
    editDeviceIndex = null;
    isEditingDevice = false;
    showDeviceFields = false;

    deviceTypeController.clear();
    deviceModelController.clear();
    serialNumberController.clear();
    devicePurposeController.clear();
  }

  void saveDevice() {
    if (deviceTypeController.text.isEmpty ||
        deviceModelController.text.isEmpty ||
        serialNumberController.text.isEmpty ||
        devicePurposeController.text.isEmpty) {
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

    cancelEditing(); // reset form
    notifyListeners();
  }

  void addMultipleDevicesFromResult(List<DeviceResult>? results) {
    if (results == null) return;

    final deviceModels =
        results.map((r) {
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
    if (isValid) {
      await addData();
      onNext();
    }
  }

  bool get isFormActionAllowed {
    final status = getByIdResult?.user?.sApprovalStatusEn;
    return isEnable || !nonEditableStatuses.contains(status);
  }

  Future<bool> validation(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.fillAllInformation));
      return false;
    }

    if (!_isPhotoValid(context) || !_isDocumentValid(context)) {
      return false;
    }

    if (!_isVisitTimeWithinApiRange(context)) {
      return false;
    }

    if (isValidatePhotoFromFR) {
      return await apiValidatePhoto(context);
    }

    if (!await _isEmailValid(context)) {
      return false;
    }

    if (!_isExpiryAfterVisitEnd(context)) {
      return false;
    }

    if (!isUpdate && !await _hasNoDuplicates(context)) {
      return false;
    }

    return true;
  }

  bool _isPhotoValid(BuildContext context) {
    final user = getByIdResult?.user;
    final isValid = (user?.havePhoto ?? 0) == 1 || uploadedImageFile != null;
    if (!isValid) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.fillAllInformation));
    }
    return isValid;
  }

  bool _isDocumentValid(BuildContext context) {
    final user = getByIdResult?.user;
    final isValid =
        ((user?.haveIqama ?? 0) == 1 ||
            (user?.havePassport ?? 0) == 1 ||
            (user?.haveEid ?? 0) == 1 ||
            (user?.haveOthers ?? 0) == 1) ||
        uploadedDocumentFile != null;
    if (!isValid) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.fillAllInformation));
    }
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
      final dateFormatWithTime = DateFormat("dd/MM/yyyy '،'hh:mm a");
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
      return false;
    }
  }

  Future<bool> _hasNoDuplicates(BuildContext context) async {
    return await apiDuplicateAppointment(context);
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
