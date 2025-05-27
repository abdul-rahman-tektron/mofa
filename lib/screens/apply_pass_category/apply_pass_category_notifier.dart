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
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_request.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/core/remote/service/apply_pass_repository.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/core/remote/service/search_pass_repository.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/model/token_user_response.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/screens/search_pass/search_pass_screen.dart';
import 'package:mofa/utils/common/app_routes.dart';
import 'package:mofa/utils/common/encrypt.dart';
import 'package:mofa/utils/common/enum_values.dart';
import 'package:mofa/utils/common/extensions.dart';
import 'package:mofa/utils/common/file_uplaod_helper.dart';
import 'package:mofa/utils/common/secure_storage.dart';
import 'package:mofa/utils/common/toast_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyPassCategoryNotifier extends BaseChangeNotifier{

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
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _pageSize = 10;

  // bool
  bool _isChecked = false;
  bool _isUpdate = false;
  bool _isCheckedDevice = true;
  bool _showDeviceFields = true;
  bool _isEditingDevice = false;
  bool _photoUploadValidation = false;
  bool _documentUploadValidation = false;
  bool _isEnable = true;

  //File
  File? _uploadedImageFile;
  File? _uploadedDocumentFile;
  File? _uploadedVehicleRegistrationFile;

  Uint8List? _uploadedImageBytes;
  Uint8List? _uploadedDocumentBytes;
  Uint8List? _uploadedVehicleImageBytes;

  final ScrollController scrollbarController = ScrollController();

  // List
  List<CountryData> _nationalityMenu = [];
  List<LocationDropdownResult> _locationDropdownData = [];
  List<VisitRequestDropdownResult> _visitRequestTypesDropdownData = [];
  List<DeviceDropdownResult> _deviceTypeDropdownData = [];
  List<DeviceDropdownResult> _devicePurposeDropdownData = [];
  List<VisitPurposeDropdownResult> _visitPurposeDropdownData = [];
  List<DeviceModel> _addedDevices = [];

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

  //Re-submission Comment
  TextEditingController resubmissionCommentController = TextEditingController();

  //Functions
  ApplyPassCategoryNotifier(BuildContext context, ApplyPassCategory applyPassCategory, bool isUpdate, int? id) {
    initialize(context, applyPassCategory, isUpdate, id);
  }

  Future<void> initialize(BuildContext context, ApplyPassCategory category, bool isUpdate, int? id) async {
    applyPassCategory = category.name;
    final DateTime now = DateTime.now();
    this.isUpdate = isUpdate;

// Format: 21/05/2025 ،09:57 AM
    final DateFormat formatter = DateFormat("dd/MM/yyyy ،hh:mm a");

// Set visit start
    visitStartDateController.text = formatter.format(now);

// Add 1 hour and set visit end
    final DateTime oneHourLater = now.add(Duration(hours: 1));
    visitEndDateController.text = formatter.format(oneHourLater);
    await fetchAllDropdownData(context, id);
    initialDataForMySelf(context, id);
  }

  Future<void> fetchAllDropdownData(BuildContext context, int? id) async {
    final user = LoginTokenUserResponse.fromJson(jsonDecode(await SecureStorageHelper.getUser() ?? ""));

    try {
      await Future.wait([
        if(applyPassCategory == ApplyPassCategory.myself.name || isUpdate) apiGetById(context, user, id),
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

  void initialDataForMySelf(BuildContext context, int? id) {
    if(applyPassCategory == ApplyPassCategory.myself.name || isUpdate) {
      if (isUpdate) {

        final approvalStatus = getByIdResult?.user?.sApprovalStatusEn ?? "";

        if (approvalStatus == 'Rejected' || approvalStatus == 'Cancelled' || approvalStatus == 'Expired' || approvalStatus == 'Approved') {
          isEnable = false;
        } else if(approvalStatus == 'Pending' || approvalStatus == 'Request Info') {
          evaluateEditableStatus(getByIdResult?.user);
        }
      }
      visitorNameController.text = isUpdate ? getByIdResult?.user?.sVisitorNameEn ?? "" : getByIdResult?.user?.sFullName ?? "";
      companyNameController.text = isUpdate ? getByIdResult?.user?.sSponsor ?? "" : getByIdResult?.user?.sCompanyName ?? "";
      nationalityController.text = getByIdResult?.user?.sNationalityEn ?? "";
      phoneNumberController.text = isUpdate ? getByIdResult?.user?.visitorMobile ?? "" : getByIdResult?.user?.sMobileNumber ?? "";
      emailController.text = isUpdate ? getByIdResult?.user?.visitorEmail ?? "" :getByIdResult?.user?.sEmail ?? "";
      idTypeController.text = getByIdResult?.user?.dTypeEn ?? "";
      selectedIdValue = getByIdResult?.user?.nDocumentType.toString() ?? "";
      selectedIdType = getByIdResult?.user?.dTypeEn ?? "";
      iqamaController.text = (getByIdResult?.user?.sIqama?.isNotEmpty ?? false)
          ? decryptAES(getByIdResult!.user!.sIqama!)
          : "";
      passportNumberController.text =
      (getByIdResult?.user?.passportNumber?.isNotEmpty ?? false)
          ? decryptAES(getByIdResult!.user!.passportNumber!)
          : "";

      nationalityIdController.text =
      (getByIdResult?.user?.eidNumber?.isNotEmpty ?? false)
          ? decryptAES(getByIdResult!.user!.eidNumber!)
          : "";

      documentNameController.text =
      (getByIdResult?.user?.sOthersDoc?.isNotEmpty ?? false)
          ? decryptAES(getByIdResult!.user!.sOthersDoc!)
          : "";

      documentNumberController.text =
      (getByIdResult?.user?.sOthersValue?.isNotEmpty ?? false)
          ? decryptAES(getByIdResult!.user!.sOthersValue!)
          : "";
      expiryDateController.text =
          getByIdResult?.user?.dTIqamaExpiry?.toDisplayDateOnly() ?? "";
      vehicleNumberController.text = getByIdResult?.user?.sVehicleNo ?? "";

      //Update Part
      if(isUpdate) {
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

  Future apiGetFile(BuildContext context, {required int type}) async {
    await ApplyPassRepository().apiGetFile(
      GetFileRequest(id: getByIdResult?.user?.nAppointmentId ?? 0, type: type),
      context,
      isUpdate: isUpdate,
    ).then((value) {
      if (type == 1) {
        uploadedImageBytes =
            base64Decode((value as GetFileResult).photoFile ?? "");
      } else if (type == 4) {
        uploadedVehicleImageBytes =
            base64Decode((value as GetFileResult).photoFile ?? "");
        if((value).contentType == "application/pdf") {
          Navigator.pushNamed(context, AppRoutes.pdfViewer, arguments: uploadedVehicleImageBytes ?? "");
        } else {
          showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.w, vertical: 5.h),
                  content: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.memory(
                        uploadedVehicleImageBytes!),
                  ),
                ),
          );
        }
      } else {
        uploadedDocumentBytes =
            base64Decode((value as GetFileResult).photoFile ?? "");
        if((value).contentType == "application/pdf") {
          Navigator.pushNamed(context, AppRoutes.pdfViewer, arguments: uploadedDocumentBytes ?? "");
        } else {
          showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 5.w, vertical: 5.h),
                  content: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.memory(
                        uploadedDocumentBytes!),
                  ),
                ),
          );
        }
      }
    },);
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


  //GetById Api Call
  Future apiGetById(BuildContext context, LoginTokenUserResponse user, int? id) async {
    await ApplyPassRepository().apiGetById(
        DeviceDropdownRequest(encryptedId: encryptAES(isUpdate ? id.toString() : user.userId.toString())), context, isUpdate: isUpdate).then((value) {
      getByIdResult = value as GetByIdResult;
    },);
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

  void addData() async {
    String? eidExpiry, iqamaExpiry, passportExpiry, othersExpiry;

    final expiryDate = expiryDateController.text.toDateTime().toString();

    switch (selectedIdType) {
      case 'National ID':
        eidExpiry = expiryDate;
        break;
      case 'Iqama':
        iqamaExpiry = expiryDate;
        break;
      case 'Passport':
        passportExpiry = expiryDate;
        break;
      case 'Other':
        othersExpiry = expiryDate;
        break;
    }

    final appointmentData = AddAppointmentRequest(
      fullName: visitorNameController.text,
      sponsor: companyNameController.text,
      nationality: nationalityController.text,
      mobileNo: phoneNumberController.text,
      email: emailController.text,
      idType: int.parse(selectedIdValue ?? ""),
      sIqama: encryptAES(iqamaController.text),
      passportNumber: encryptAES(passportNumberController.text),
      sOthersDoc: encryptAES(documentNameController.text),
      eidNumber: encryptAES(nationalityIdController.text),
      sOthersValue: encryptAES(documentNumberController.text),
      dtEidExpiryDate: eidExpiry,
      dtIqamaExpiry: iqamaExpiry,
      dtPassportExpiryDate: passportExpiry,
      dtOthersExpiry: othersExpiry,
      dtAppointmentStartTime: visitStartDateController.text.toDateTime(),
      dtAppointmentEndTime: visitEndDateController.text.toDateTime(),
      sVehicleNo: vehicleNumberController.text,
      devices: addedDevices,
      nLocationId: selectedLocationId,
      nVisitType: int.parse(selectedVisitRequest ?? ""),
      purpose: int.parse(selectedVisitPurpose ?? ""),
      remarks: noteController.text,
      sVisitingPersonEmail: mofaHostEmailController.text,
      haveEid: getByIdResult?.user?.haveEid ?? 0,
      havePassport: getByIdResult?.user?.havePassport ?? 0,
      haveIqama: getByIdResult?.user?.haveIqama ?? 0,
      havePhoto: getByIdResult?.user?.havePhoto ?? 0,
      haveVehicleRegistration: getByIdResult?.user?.haveVehicleRegistration ??
          0,
      haveOthers: getByIdResult?.user?.haveOthers ?? 0,
      lastAppointmentId: getByIdResult?.user?.nAppointmentId ?? 0,
      nSelfPass: getByIdResult?.user?.nSelfPass ??
          ((applyPassCategory == ApplyPassCategory.myself.name) ? 1 : 2),
      nVisitCreatedFrom: 2,
      nVisitUpdatedFrom: 2,
      resubmissionComments: resubmissionCommentController.text,
    );

    log("appointmentData.toString()");
    log(jsonEncode(appointmentData));

    final imageDataFile = {
      "imageUploaded": await uploadedImageFile?.toBase64(),
      "documentUploaded": await uploadedDocumentFile?.toBase64(),
      "vehicleRegistrationUploaded": await uploadedVehicleRegistrationFile?.toBase64(),
      "selectedIdType": selectedIdType,
    };

    final jsonString = jsonEncode(appointmentData.toJson());
    await SecureStorageHelper.setAppointmentData(jsonString);

    final jsonImageString = jsonEncode(imageDataFile);
    await SecureStorageHelper.setUploadedImage(jsonImageString);
  }

  Future<AddAppointmentRequest?> getStoredAppointmentData() async {
    final jsonString = await SecureStorageHelper.getAppointmentData();
    if (jsonString != null && jsonString.isNotEmpty) {
      final jsonMap = jsonDecode(jsonString);
      return AddAppointmentRequest.fromJson(jsonMap);
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
    File? doc = await FileUploadHelper.pickDocument(
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (doc != null) {
      uploadedVehicleRegistrationFile = doc;
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

    final deviceModels = results.map((r) {
      var deviceType = r.deviceType == 2246 ? "Laptop" : r.deviceType == 2247 ? "Phone" : r.deviceType == 2248 ? "Tablet" : r.deviceType == 2249 ? "USB Drive" : "Other";
      var devicePurpose = r.devicePurpose == 2251 ? "Presentation" : r.devicePurpose == 2252 ? "Data Collection" : r.devicePurpose == 2253 ? "General Use" : r.devicePurpose == 2254 ? "Other" : "";
      return DeviceModel(
        appointmentDeviceId: r.appointmentDeviceId ?? 0,
        deviceType: r.deviceType,
        deviceTypeString: deviceType,
        deviceTypeOthersValue: r.deviceTypeOthersValue ?? "",
        deviceModel: r.deviceModel ?? "",
        serialNumber: r.serialNumber ?? "",
        devicePurpose: r.devicePurpose,
        devicePurposeString: devicePurpose,
        devicePurposeOthersValue: r.devicePurposeOthersValue ?? "",
        approvalStatus: r.approvalStatus ?? 50,
      );
    } ).toList();

    addedDevices.addAll(deviceModels);
    showDeviceFields = false;
    notifyListeners();
  }

  Future<void> nextButton(BuildContext context, VoidCallback onNext) async {
    final isValid = await validation(context);
    if (isValid) {
      addData();
      onNext();
    }
  }

  bool get isFormActionAllowed {
    final status = getByIdResult?.user?.sApprovalStatusEn;
    return isEnable || !nonEditableStatuses.contains(status);
  }

  Future<bool> validation(BuildContext context) async {
    bool formValid = formKey.currentState!.validate();

    final user = getByIdResult?.user;

    photoUploadValidation = !(
        (user?.havePhoto ?? 0) == 1 ||  // User already has photo on server
            uploadedImageFile != null        // Or user uploaded locally
    );

    documentUploadValidation = !(
        ((user?.haveIqama ?? 0) == 1 ||
            (user?.havePassport ?? 0) == 1 ||
            (user?.haveEid ?? 0) == 1 ||
            (user?.haveOthers ?? 0) == 1) ||
            uploadedDocumentFile != null
    );

    if (!formValid) {
      ToastHelper.showError(context.readLang.translate(AppLanguageText.fillAllInformation));
    }

    if (!formValid || photoUploadValidation || documentUploadValidation) {
      return false;
    }

    // Local validations passed, now call APIs
    final isEmailValid = await apiValidateEmail(context);
    if (!isEmailValid) return false;

    final dateFormatWithTime = DateFormat("dd/MM/yyyy '،'hh:mm a");
    final dateFormatWithoutTime = DateFormat("dd/MM/yyyy");

    try {
      final expiryDate = dateFormatWithoutTime.parse(expiryDateController.text);
      final visitEndDate = dateFormatWithTime.parse(visitEndDateController.text);

      // Check if expiry date is before visit end date (date-only vs date-time)
      if (expiryDate.isBefore(visitEndDate)) {
        ToastHelper.showError(context.readLang.translate(AppLanguageText.expireVisitError));
        return false;
      }
    } catch (e) {
      debugPrint("Date parsing error: $e");
      return false;
    }

    if(!isUpdate) {
      final hasNoDuplicates = await apiDuplicateAppointment(context);
      if (!hasNoDuplicates) return false;
    }

    return true;
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

  int? get selectedDeviceType => _selectedDeviceType;

  set selectedDeviceType(int? value) {
    if (_selectedDeviceType == value) return;
    _selectedDeviceType = value;
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