import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/add_appointment/add_appointment_request.dart';
import 'package:mofa/core/model/add_appointment/add_appointment_response.dart';
import 'package:mofa/core/remote/service/apply_pass_repository.dart';
import 'package:mofa/core/remote/service/search_pass_repository.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/common/widgets/info_section_widget.dart';

class HealthAndSafetyNotifier extends BaseChangeNotifier {
  bool _isChecked = false;
  bool _isUpdate = false;

  List<AddAppointmentRequest>? _addAppointmentRequest;

  final List<DeclarationSection> healthDeclarationsEn = [
    DeclarationSection(
      heading: "A. Health and Wellness",
      items: [
        "Ensure you are in good health and free from any contagious illness before visiting the premises.",
        "Visitors under the influence of alcohol, drugs, or medication that impairs judgment are strictly prohibited from entering the premises.",
        "If you have any specific health concerns or medical conditions that may require assistance during your visit, inform your MOFA host beforehand.",
      ],
    ),
    DeclarationSection(
      heading: "B. Prohibited Items",
      items: [
        "Visitors are strictly prohibited from bringing firearms, knives, ammunition, or any sharp or hazardous items onto MOFA premises.",
        "Alcohol, drugs, and other controlled substances are not allowed within MOFA boundaries.",
        "Personal electronic devices such as USB drives, portable storage devices, or unauthorized laptops must not be connected to MOFA systems.",
        "Unauthorized photography, videography, or audio recording is strictly forbidden without prior written approval.",
      ],
    ),
    DeclarationSection(
      heading: "C. Security and Confidentiality",
      items: [
        "All visitors must present valid identification and follow the security screening process at the main entrance.",
        "Access to restricted areas is permitted only under the supervision of your MOFA host and with prior approval.",
        "Visitors are required to maintain confidentiality and must not disclose, share, or reproduce any information obtained during their visit.",
        "Use of personal devices is limited to designated areas as directed by MOFA staff.",
      ],
    ),
    DeclarationSection(
      heading: "D. Emergency and Safety Procedures",
      items: [
        "In case of an emergency or fire alarm, follow the evacuation instructions provided by your MOFA host or security staff.",
        "Always proceed to the nearest assembly point as indicated by MOFA’s emergency response plan.",
        "Visitors must report any incidents, injuries, or suspicious activities to their MOFA host or security personnel immediately.",
      ],
    ),
    DeclarationSection(
      heading: "E. General Rules of Conduct",
      items: [
        "Visitors are required to remain with their designated MOFA host at all times.",
        "Smoking is permitted only in designated smoking areas outside the building.",
        "Adherence to traffic rules and parking regulations is mandatory within MOFA premises.",
        "Visitors are not allowed to engage in any physical work or handle equipment on the premises.",
        "Appropriate attire must be worn while visiting MOFA offices, reflecting the professional nature of the organization.",
      ],
    ),
  ];

  final List<DeclarationSection> healthDeclarationsAr = [
    DeclarationSection(
      heading: "أ. الصحة والسلامة",
      items: [
        "تأكد من أنك بصحة جيدة وخالٍ من أي أمراض معدية قبل زيارة المباني.",
        "يُمنع الزوار الذين تحت تأثير الكحول أو المخدرات أو الأدوية التي تؤثر على الحكم السليم من دخول المبنى.",
        "إذا كنت تعاني من أي مشكلات صحية أو حالات طبية محددة قد تتطلب المساعدة أثناء زيارتك، يرجى إبلاغ مضيف وزارة الخارجية مسبقًا.",
      ],
    ),
    DeclarationSection(
      heading: "ب. المواد المحظورة",
      items: [
        "يُحظر تمامًا إحضار الأسلحة النارية، السكاكين، الذخائر، أو أي أدوات حادة أو خطرة إلى مباني وزارة الخارجية.",
        "يُمنع إدخال الكحول، المخدرات، أو أي مواد محظورة أخرى داخل المباني.",
        "لا يُسمح باستخدام الأجهزة الإلكترونية الشخصية مثل وحدات التخزين المحمولة أو أجهزة الكمبيوتر المحمولة غير المصرح بها للاتصال بأنظمة وزارة الخارجية.",
        "يُحظر تمامًا التصوير الفوتوغرافي أو الفيديو أو التسجيل الصوتي دون موافقة خطية مسبقة.",
      ],
    ),
    DeclarationSection(
      heading: "ج. الأمن والسرية",
      items: [
        "يجب على جميع الزوار تقديم هوية صالحة والخضوع لإجراءات التفتيش الأمني عند المدخل الرئيسي.",
        "يُسمح بالدخول إلى المناطق المحظورة فقط تحت إشراف مضيف وزارة الخارجية وبعد الحصول على الموافقة المسبقة.",
        "يجب على الزوار الحفاظ على السرية وعدم الإفصاح أو مشاركة أو إعادة إنتاج أي معلومات يتم الحصول عليها أثناء الزيارة.",
        "يقتصر استخدام الأجهزة الشخصية على المناطق المخصصة وفقًا لتوجيهات موظفي وزارة الخارجية.",
      ],
    ),
    DeclarationSection(
      heading: "د. إجراءات الطوارئ والسلامة",
      items: [
        "في حالة الطوارئ أو انطلاق إنذار الحريق، اتبع تعليمات الإخلاء المقدمة من مضيف وزارة الخارجية أو موظفي الأمن.",
        "دائمًا توجه إلى أقرب نقطة تجمع وفقًا لخطة الاستجابة للطوارئ الخاصة بوزارة الخارجية.",
        "يجب على الزوار الإبلاغ عن أي حوادث أو إصابات أو أنشطة مشبوهة إلى مضيف وزارة الخارجية أو موظفي الأمن فورًا.",
      ],
    ),
    DeclarationSection(
      heading: "هـ. القواعد العامة للسلوك",
      items: [
        "يُطلب من الزوار البقاء مع مضيف وزارة الخارجية المعين لهم في جميع الأوقات.",
        "يُسمح بالتدخين فقط في المناطق المخصصة خارج المبنى.",
        "الالتزام بقواعد المرور وأنظمة مواقف السيارات إلزامي داخل مباني وزارة الخارجية.",
        "لا يُسمح للزوار بأداء أي أعمال جسدية أو التعامل مع المعدات داخل المباني.",
        "يجب ارتداء ملابس مناسبة تعكس الطابع المهني أثناء زيارة مكاتب وزارة الخارجية.",
      ],
    ),
  ];

  //Functions
  HealthAndSafetyNotifier() {
    getStoredAppointmentData();
  }

  // Update User Verify checkbox state
  void userAcceptDeclarationChecked(BuildContext context, bool? value) {
    isChecked = value!;
  }

  Future<void> getStoredAppointmentData() async {
    final jsonString = await SecureStorageHelper.getAppointmentData();
    print("jsonString");
    print(jsonString);
    if (jsonString != null && jsonString.isNotEmpty) {
      final jsonData = jsonDecode(jsonString);

      // Case 1: List of AddAppointmentRequest
      if (jsonData is List) {
        print("Parsed as List<AddAppointmentRequest>");
        addAppointmentRequest = jsonData.map((e) => AddAppointmentRequest.fromJson(e)).toList();
      }

      // Case 2: Single AddAppointmentRequest
      else if (jsonData is Map<String, dynamic>) {
        print("Parsed as single AddAppointmentRequest");
        final singleRequest = AddAppointmentRequest.fromJson(jsonData);
        addAppointmentRequest = [singleRequest]; // Wrap it in a list
      }

      // If format is unexpected
      else {
        print("Unexpected JSON format");
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadUploadDataFromStorage() async {
    final jsonString = await SecureStorageHelper.getUploadedImage();
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return [decoded];
      } else if (decoded is List) {
        return decoded.whereType<Map<String, dynamic>>().toList();
      }
    } catch (e) {
      print("Error parsing uploaded image data: $e");
    }

    return [];
  }

  Future<void> _processUploadEntry(
      BuildContext context,
      Map<String, dynamic> jsonMap,
      AddAppointmentResult? appointmentResult, // You can type this if you know the class
      ) async {
    final base64Image = jsonMap["imageUploaded"] as String?;
    final base64Doc = jsonMap["documentUploaded"] as String?;
    final base64Vehicle = jsonMap["vehicleRegistrationUploaded"] as String?;
    final selectedIdType = jsonMap["selectedIdType"] as String?;

    final imageFile = await _decodeBase64File(base64Image, "uploadedImageFile.jpg");
    final docFile = await _decodeBase64File(base64Doc, "uploadedDocumentFile.pdf");
    final vehicleFile = await _decodeBase64File(base64Vehicle, "uploadedVehicleFile.jpg");

    final uploadFutures = <Future<bool>>[];

    final appointmentId = appointmentResult?.id?.toString() ?? "";

    if (await _fileExists(imageFile)) {
      uploadFutures.add(uploadAttachment(context, imageFile!, "S_PhotoUpload", "S_PhotoContentType", appointmentId));
    }

    if (await _fileExists(docFile)) {
      final fileKey = _getDocumentUploadKey(selectedIdType);
      final contentType = _getDocumentContentTypeKey(selectedIdType);
      uploadFutures.add(uploadAttachment(context, docFile!, fileKey, contentType, appointmentId));
    }

    if (await _fileExists(vehicleFile)) {
      uploadFutures.add(uploadAttachment(context, vehicleFile!, "S_VehicleRegistrationFile", "S_VehicleRegistrationContentType", appointmentId));
    }

    final results = await Future.wait(uploadFutures);
    print(results.every((r) => r)
        ? "✅ Upload success for appointment $appointmentId"
        : "⚠️ Partial failure for appointment $appointmentId");
  }

  Future<File?> _decodeBase64File(String? base64Str, String fileName) async {
    if (base64Str == null || base64Str.isEmpty) return null;
    return await base64Str.toFile(fileName: fileName);
  }

  Future<bool> _fileExists(File? file) async {
    return file != null && await file.exists();
  }

  String _getDocumentUploadKey(String? selectedIdType) {
    switch (selectedIdType) {
      case "Passport":
        return "S_PassportFile";
      case "Iqama":
        return "S_IqamaUpload";
      case "Other":
        return "S_OthersUpload";
      default:
        return "S_EIDFile";
    }
  }

  String _getDocumentContentTypeKey(String? selectedIdType) {
    switch (selectedIdType) {
      case "Passport":
        return "S_PassportContentType";
      case "Iqama":
        return "S_IqamaContentType";
      case "Other":
        return "S_OthersContentType";
      default:
        return "S_EIDContentType";
    }
  }

  Future<bool> uploadAttachment(
      BuildContext context,
      File imageFile,
      String fieldName,
      String fieldType,
      String appointmentId,
      ) async {
    try {
      final result = await ApplyPassRepository().apiAddAttachment(
        fieldName: fieldName,
        imageFile: imageFile,
        fieldType: fieldType,
        context,
        id: appointmentId,
      );
      return result == true;
    } catch (e) {
      print("❌ Upload failed: $e");
      return false;
    }
  }

  submitButtonPressed(BuildContext context, VoidCallback onNext) async {
    if (addAppointmentRequest == null || addAppointmentRequest!.isEmpty) {
      print("No appointments to send.");
      return;
    }

    final imageDataList = await _loadUploadDataFromStorage();
    if (imageDataList.length != addAppointmentRequest!.length) {
      print("Mismatch between appointments and image data.");
      return;
    }

    // Build a list of futures
    final futures = <Future<void>>[];

    for (int i = 0; i < addAppointmentRequest!.length; i++) {
      final appointment = addAppointmentRequest![i];
      final imageData = imageDataList[i];

      log(appointment.toString());

      futures.add(() async {
        try {
          final result = isUpdate
              ? await SearchPassRepository().apiUpdateAppointment(
              appointment, context)
              : await ApplyPassRepository().apiAddAppointment(
              appointment, context);
          if (result != null) {
            await _processUploadEntry(context, imageData, result as AddAppointmentResult);
          } else {
            print("❌ Failed to receive result for appointment index $i");
          }
        } catch (e) {
          print("❌ Error processing appointment $i: $e");
        }
      }());
    }

    // Wait for all to complete
    await Future.wait(futures);
    onNext();
  }



  Future<void> apiAddAppointments(BuildContext context) async {
    if (addAppointmentRequest == null || addAppointmentRequest!.isEmpty) {
      print("No appointments to send.");
      return;
    }

    try {
      // Run all API calls in parallel using Future.wait
      await Future.wait(
        addAppointmentRequest!.map((appointment) async {
          try {
            final result = await ApplyPassRepository().apiAddAppointment(
              appointment,
              context,
            );
            print("Appointment added: $result");
          } catch (e) {
            print("Failed to add appointment: $e");
          }
        }),
      );

      print("All API calls completed.");
    } catch (e) {
      print("One or more API calls failed: $e");
    }
  }

  // Use getters instead of fields
  List<DeclarationSection> get englishDeclarations => healthDeclarationsEn;

  List<DeclarationSection> get arabicDeclarations => healthDeclarationsAr;

  //Getter and Setter
  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    if (_isChecked == value) return;
    _isChecked = value;
    notifyListeners();
  }

  List<AddAppointmentRequest>? get addAppointmentRequest => _addAppointmentRequest;

  set addAppointmentRequest(List<AddAppointmentRequest>? value) {
    if (_addAppointmentRequest == value) return;
    _addAppointmentRequest = value;
    notifyListeners();
  }

  bool get isUpdate => _isUpdate;

  set isUpdate(bool value) {
    if (_isUpdate == value) return;
    _isUpdate = value;
    notifyListeners();
  }
}
