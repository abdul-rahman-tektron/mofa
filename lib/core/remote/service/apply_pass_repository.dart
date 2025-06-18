import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/add_appointment/add_appointment_request.dart';
import 'package:mofa/core/model/add_appointment/add_appointment_response.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_request.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/duplicate_appointment/duplicate_appointment_request.dart';
import 'package:mofa/core/model/duplicate_appointment/duplicate_appointment_response.dart';
import 'package:mofa/core/model/error/error_response.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/model/get_by_id/get_by_id_response.dart';
import 'package:mofa/core/model/get_file/get_file_request.dart';
import 'package:mofa/core/model/get_file/get_file_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/core/model/search_visitor/search_visitor_request.dart';
import 'package:mofa/core/model/search_visitor/search_visitor_response.dart';
import 'package:mofa/core/model/validate_email/validate_email_response.dart';
import 'package:mofa/core/model/validate_photo/validate_photo_request.dart';
import 'package:mofa/core/model/validate_photo/validate_photo_response.dart';
import 'package:mofa/core/model/validate_photo_config/validate_photo_config_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_request.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/core/model/visiting_hours_config/visiting_hours_config_response.dart';
import 'package:mofa/core/remote/network/app_url.dart';
import 'package:mofa/core/remote/network/base_repository.dart';
import 'package:mofa/core/remote/network/method.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/toast_helper.dart';

class ApplyPassRepository extends BaseRepository {
  ApplyPassRepository._internal();

  static final ApplyPassRepository _singleInstance = ApplyPassRepository._internal();

  factory ApplyPassRepository() => _singleInstance;

  ErrorResponse _errorResponseMessage = ErrorResponse();

  ErrorResponse get errorResponseMessage => _errorResponseMessage;

  set errorResponseMessage(ErrorResponse value) {
    if (value == _errorResponseMessage) return;
    _errorResponseMessage = value;
    notifyListeners();
  }

  //api: Location Dropdown
  Future<Object?> apiLocationDropDown(Map requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathLocationDropdown,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      LocationDropdownResponse locationDropdownResponse =
      locationDropdownResponseFromJson(jsonEncode(response?.data));

      return locationDropdownResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Visit Request Dropdown
  Future<Object?> apiVisitRequestDropDown(Map requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathVisitRequestTypeDropdown,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      VisitRequestDropdownResponse visitRequestDropdownResponse =
      visitRequestDropdownResponseFromJson(jsonEncode(response?.data));

      return visitRequestDropdownResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Device Dropdown
  Future<Object?> apiDeviceDropDown(DeviceDropdownRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathDeviceDropdown,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      DeviceDropdownResponse deviceDropdownResponse =
      deviceDropdownResponseFromJson(jsonEncode(response?.data));

      return deviceDropdownResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Device Dropdown
  Future<Object?> apiVisitPurposeDropDown(VisitPurposeDropdownRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathVisitPurposesDropdown,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      VisitPurposeDropdownResponse visitPurposeDropdownResponse =
      visitPurposeDropdownResponseFromJson(jsonEncode(response?.data));

      return visitPurposeDropdownResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Plate Source Dropdown
  Future<Object?> apiPlateSourceDropDown(Map requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathPlateSourceDropdown,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      DeviceDropdownResponse plateSourceDropdownResponse =
      deviceDropdownResponseFromJson(jsonEncode(response?.data));

      return plateSourceDropdownResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Plate Letter Dropdown
  Future<Object?> apiPlateLetterDropDown(Map requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathPlateLetterDropdown,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      DeviceDropdownResponse plateLetterDropdownResponse =
      deviceDropdownResponseFromJson(jsonEncode(response?.data));

      return plateLetterDropdownResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Get by id
  Future<Object?> apiGetById(DeviceDropdownRequest requestParams, BuildContext context, {bool isUpdate = false}) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: isUpdate ? AppUrl.pathGetByIdAppointment : AppUrl.pathGetById,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      try{
        GetByIdResponse getByIdResponse =
        getByIdResponseFromJson(jsonEncode(response?.data));

        return getByIdResponse.result;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Device Dropdown
  Future<Object?> apiGetFile(GetFileRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathExternalGetFile,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      GetFileResponse getFileResponse =
      getFileResponseFromJson(jsonEncode(response?.data));

      return getFileResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Validate Email
  Future<Object?> apiValidateEmail(ForgetPasswordRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathValidateEmail,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      ValidateEmailResponse validateEmailResponse =
      validateEmailResponseFromJson(jsonEncode(response?.data));

      if(validateEmailResponse.status ?? false){
        return true;
      }else {
        if (context.mounted) {
          ToastHelper.showError(
            context.readLang.translate(AppLanguageText.visitingPersonEmailNotFound),
          );
        }
        return false;
      }
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return false;
    }
  }

  //api: Duplicate Appointment
  Future<Object?> apiDuplicateAppointment(DuplicateAppointmentRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathDuplicateAppointment,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      DuplicateAppointmentResponse duplicateAppointmentResponse =
      duplicateAppointmentResponseFromJson(jsonEncode(response?.data));
      if(duplicateAppointmentResponse.status ?? true){
        if (context.mounted) {
          ToastHelper.showError(
            context.readLang.translate(AppLanguageText.appointmentExists),
          );
        }
        return false;
      }else {
        return true;
      }

    } else {
      return false;
    }
  }

  //api: Add Appointment
  Future<Object?> apiAddAppointment(AddAppointmentRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathAddAppointment,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      AddAppointmentResponse addAppointmentResponse =
      addAppointmentResponseFromJson(jsonEncode(response?.data));

      return addAppointmentResponse.result;

    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Visiting Hours Config
  Future<Object?> apiVisitingHoursConfig(Map requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathVisitingHoursConfig,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      VisitingHoursConfigResponse visitingHoursConfigResponse =
      visitingHoursConfigResponseFromJson(jsonEncode(response?.data));

      return visitingHoursConfigResponse.result;

    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Visiting Hours Config
  Future<Object?> apiSearchUser(SearchVisitorRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathSearchUser,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      SearchVisitorResponse searchVisitorResponse =
      searchVisitorResponseFromJson(jsonEncode(response?.data));

      return searchVisitorResponse.result;

    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Validate Photo Config
  Future<Object?> apiValidatePhotoConfig(Map requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathValidatePhotoConfig,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      ValidatePhotoConfigResponse validatePhotoConfigResponse =
      validatePhotoConfigResponseFromJson(jsonEncode(response?.data));

      return validatePhotoConfigResponse.result;

    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Validate Photo
  Future<Object?> apiValidatePhoto(ValidatePhotoRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathValidatePhoto,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );
    ValidatePhotoResponse validatePhotoResponse =
    validatePhotoResponseFromJson(jsonEncode(response?.data));

    if (response?.statusCode == HttpStatus.ok) {


      return validatePhotoResponse.result;

    } else {
      return validatePhotoResponse.result;
    }
  }

  Future<Object?> apiAddAttachment(
      BuildContext context, {
        required String id,
        required String fieldName,
        required String fieldType,
        File? file,
      }) async {
    final token = await SecureStorageHelper.getToken();

    // Get file extension safely
    final filePath = file?.path ?? '';
    final fileExtension = filePath.toLowerCase();

    // Default MIME and MediaType
    String mimeType = 'application/octet-stream';
    MediaType mediaType = MediaType('application', 'octet-stream');

    // Match file extension manually
    print("fileExtension");
    print(fileExtension);
    if (fileExtension.endsWith('.jpg') || fileExtension.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
      mediaType = MediaType('image', 'jpeg');
    } else if (fileExtension.endsWith('.png')) {
      mimeType = 'image/png';
      mediaType = MediaType('image', 'png');
    } else if (fileExtension.endsWith('.pdf')) {
      mimeType = 'application/pdf';
      mediaType = MediaType('application', 'pdf');
    }


    print(mimeType);
    MultipartFile? multipartFile;
    if (file != null) {
      final fileName = file.path.split('/').last;
      multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: mediaType,
      );
    }

    final formDataMap = {
      'Id': id,
      'S_FileType': mimeType,
      'S_FileFieldName': fieldName,
      'S_FiledFileType': fieldType,
      if (multipartFile != null) 'File': multipartFile,
    };

    final formData = FormData.fromMap(formDataMap);

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathAddAttachment,
      body: formData,
      headers: {
        ...buildDefaultHeaderWithToken(token ?? ""),
        'Content-Type': 'multipart/form-data',
      },
    );

    if (response?.statusCode == HttpStatus.ok) {
      AddAppointmentResponse addAppointmentResponse =
      addAppointmentResponseFromJson(jsonEncode(response?.data));
      return addAppointmentResponse;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

}
