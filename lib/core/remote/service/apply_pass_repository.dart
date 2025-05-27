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
import 'package:mofa/core/model/validate_email/validate_email_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_request.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/core/remote/network/app_url.dart';
import 'package:mofa/core/remote/network/base_repository.dart';
import 'package:mofa/core/remote/network/method.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/common/secure_storage.dart';
import 'package:mofa/utils/common/toast_helper.dart';

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
  Future<Object?> apiGetFile(GetFileRequest requestParams, BuildContext context, {bool isUpdate = false}) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: isUpdate ? AppUrl.pathExternalGetFile : AppUrl.pathGetFile,
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

  Future<Object?> apiAddAttachment(BuildContext context,
      {required String id, required String fieldName,
        required String fieldType, File? imageFile,}) async {
    final token = await SecureStorageHelper.getToken();

    // Prepare the multipart image file if available
    MultipartFile? multipartImage;
    if (imageFile != null) {
      final fileName = imageFile.path
          .split('/')
          .last;
      multipartImage = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'), // or dynamically get the type
      );
    }

    // Append fields as per your API
    final formDataMap = {
      'Id': id, // or correct field
      'S_FileType': 'image/jpeg',
      'S_FileFieldName': fieldName,
      'S_FiledFileType': fieldType,
      if (multipartImage != null) 'File': multipartImage,
    };

    // Build FormData
    final formData = FormData.fromMap(formDataMap);

    // Perform the API call
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
