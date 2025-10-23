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
import 'package:path_provider/path_provider.dart';

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
  HealthAndSafetyNotifier(bool isUpdate) {
    this.isUpdate = isUpdate;
    getStoredAppointmentData();
  }

  // Update User Verify checkbox state
  void userAcceptDeclarationChecked(BuildContext context, bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  Future<void> getStoredAppointmentData() async {
    try {
      final jsonString = await SecureStorageHelper.getAppointmentData();
      print("Stored appointment JSON string: $jsonString");

      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonData = jsonDecode(jsonString);

        if (jsonData is List) {
          addAppointmentRequest = jsonData
              .map<AddAppointmentRequest>((e) {
            final req = AddAppointmentRequest.fromJson(e);

            // Convert all expiry dates to ISO 8601
            req.dtVisaExpiry = _convertToIso(req.dtVisaExpiry);
            req.dtEidExpiryDate = _convertToIso(req.dtEidExpiryDate);
            req.dtPassportExpiryDate = _convertToIso(req.dtPassportExpiryDate);
            req.dtIqamaExpiry = _convertToIso(req.dtIqamaExpiry);
            req.dtOthersExpiry = _convertToIso(req.dtOthersExpiry);

            return req;
          }).toList();
        } else if (jsonData is Map<String, dynamic>) {
          addAppointmentRequest = [AddAppointmentRequest.fromJson(jsonData)];
        } else {
        }
      }
    } catch (e) {
      print("Error retrieving appointment data: $e");
    }
  }

  String? _convertToIso(String? date) {
    if (date == null || date.isEmpty) return null;

    try {
      // Try parsing "dd/MM/yyyy" or "yyyy-MM-dd" formats
      DateTime parsedDate;

      if (date.contains("/")) {
        final parts = date.split("/");
        parsedDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else {
        parsedDate = DateTime.parse(date);
      }

      return parsedDate.toIso8601String();
    } catch (e) {
      return null; // fallback
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
      AddAppointmentResult? appointmentResult,
      ) async {
    print("📦 Upload entry received: $jsonMap");

    final imageData = jsonMap["imageUploaded"];
    final docData = jsonMap["documentUploaded"];
    final vehicleData = jsonMap["vehicleRegistrationUploaded"];
    final selectedIdValue = jsonMap["selectedIdValue"] as String?;

    print("📷 imageUploaded: ${imageData != null ? 'available' : 'null'}");
    print("📄 documentUploaded: ${docData != null ? 'available' : 'null'}");
    print("🚗 vehicleRegistrationUploaded: ${vehicleData != null ? 'available' : 'null'}");

    final imageFile = await _decodeBase64File(imageData, "uploadedImageFile");
    final docFile = await _decodeBase64File(docData, "uploadedDocumentFile");
    final vehicleFile = await _decodeBase64File(vehicleData, "uploadedVehicleFile");

    final appointmentId = appointmentResult?.id?.toString() ?? "";
    print("📋 Appointment ID: $appointmentId");

    final uploadFutures = <Future<bool>>[];

    if (await _fileExists(imageFile)) {
      print("📤 Uploading image file...");
      uploadFutures.add(uploadAttachment(
        context,
        imageFile!,
        "S_PhotoUpload",
        "S_PhotoContentType",
        appointmentId,
      ));
    } else {
      print("⚠️ Image file not ready or doesn't exist");
    }

    if (await _fileExists(docFile)) {
      final fileKey = _getDocumentUploadKey(int.tryParse(selectedIdValue ?? "0") ?? 0);
      final contentType = _getDocumentContentTypeKey(int.tryParse(selectedIdValue ?? "0") ?? 0);
      print("📤 Uploading document file with key: $fileKey");
      uploadFutures.add(uploadAttachment(
        context,
        docFile!,
        fileKey,
        contentType,
        appointmentId,
      ));
    } else {
      print("⚠️ Document file not ready or doesn't exist");
    }

    if (await _fileExists(vehicleFile)) {
      print("📤 Uploading vehicle file...");
      uploadFutures.add(uploadAttachment(
        context,
        vehicleFile!,
        "S_VehicleRegistrationFile",
        "S_VehicleRegistrationContentType",
        appointmentId,
      ));
    } else {
      print("⚠️ Vehicle file not ready or doesn't exist");
    }

    final results = await Future.wait(uploadFutures);
    print(results.every((r) => r)
        ? "✅ Upload success for appointment $appointmentId"
        : "⚠️ Partial failure for appointment $appointmentId");
  }



  Future<File?> _decodeBase64File(dynamic data, String baseFileNameWithoutExtension) async {
    if (data == null) {
      print("⚠️ Null file data for $baseFileNameWithoutExtension");
      return null;
    }

    try {
      List<int> bytes;
      String extension = 'bin';

      if (data is String) {
        // Handle base64 string
        extension = _detectFileExtension(data);
        bytes = base64Decode(data.split(',').last); // Handles "data:image/jpeg;base64,..." and plain base64
      } else if (data is List<dynamic>) {
        // Handle List<int> from json decode
        bytes = data.cast<int>();
        extension = _detectBinaryFileExtension(bytes);
      } else {
        print("❌ Unsupported file data type for $baseFileNameWithoutExtension: ${data.runtimeType}");
        return null;
      }

      final fileName = "$baseFileNameWithoutExtension.$extension";
      final file = File('${(await getTemporaryDirectory()).path}/$fileName');
      await file.writeAsBytes(bytes);
      print("✅ File written: ${file.path}");
      return file;
    } catch (e) {
      print("❌ Error decoding file for $baseFileNameWithoutExtension: $e");
      return null;
    }
  }

  String _detectBinaryFileExtension(List<int> bytes) {
    if (bytes.length < 4) return 'bin';

    final header = bytes.take(4).toList();

    if (header[0] == 0xFF && header[1] == 0xD8) return 'jpg'; // JPEG
    if (header[0] == 0x89 && header[1] == 0x50) return 'png'; // PNG
    if (header[0] == 0x25 && header[1] == 0x50) return 'pdf'; // PDF

    return 'bin';
  }

  String _detectFileExtension(String base64Data) {
    if (base64Data.startsWith('data:image/png') || base64Data.startsWith('iVBOR')) {
      return 'png';
    } else if (base64Data.startsWith('data:image/jpeg') || base64Data.startsWith('/9j/')) {
      return 'jpg';
    } else if (base64Data.startsWith('data:image/jpg')) {
      return 'jpg';
    } else if (base64Data.startsWith('data:application/pdf') || base64Data.startsWith('JVBERi0')) {
      return 'pdf';
    } else {
      return 'bin'; // Fallback if unrecognized
    }
  }

  Future<bool> _fileExists(File? file) async {
    return file != null && await file.exists();
  }

  String _getDocumentUploadKey(int? idType) {
    switch (idType) {
      case 26: // PASSPORT
        return "S_PassportFile";
      case 2244: // IQAMA
        return "S_IqamaUpload";
      case 2294: // VISA
        return "S_VisaFile";
      case 2245: // OTHER
        return "S_OthersUpload";
      case 24: // NATIONAL_ID / EID
      default:
        return "S_EIDFile";
    }
  }

  String _getDocumentContentTypeKey(int? idType) {
    switch (idType) {
      case 26: // PASSPORT
        return "S_PassportContentType";
      case 2244: // IQAMA
        return "S_IqamaContentType";
      case 2294: // VISA
        return "S_VisaContentType";
      case 2245: // OTHER
        return "S_OthersContentType";
      case 24: // NATIONAL_ID / EID
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
      print("🚀 Uploading $fieldName with contentType: $fieldType for ID: $appointmentId");
      final result = await ApplyPassRepository().apiAddAttachment(
        fieldName: fieldName,
        file: imageFile,
        fieldType: fieldType,
        context,
        id: appointmentId,
      );
      print("✅ Upload result for $fieldName: $result");
      return result == true;
    } catch (e) {
      print("❌ Upload failed for $fieldName: $e");
      return false;
    }
  }


  Future<void> _processSingleAppointment(
      BuildContext context,
      AddAppointmentRequest appointment,
      Map<String, dynamic> imageData,
      int index,
      ) async {
    try {
      print("🔄 Starting appointment process for index $index");
      print("📝 isUpdate: $isUpdate");

      final result = isUpdate
          ? await SearchPassRepository().apiUpdateAppointment(appointment, context)
          : await ApplyPassRepository().apiAddAppointment(appointment, context);

      print("✅ Received result: $result");

      if (result is AddAppointmentResult) {
        print("🔧 Processing upload entry...");
        await _processUploadEntry(context, imageData, result);
      } else {
        print("❌ Failed to receive valid result for appointment index $index");
      }
    } catch (e) {
      print("❌ Error processing appointment $index: $e");
    }
  }

  Future<void> submitButtonPressed(BuildContext context, VoidCallback onNext) async {
    runWithLoadingVoid(() async {
      if (addAppointmentRequest == null || addAppointmentRequest!.isEmpty) {
        print("No appointments to send.");
        return;
      }

      final imageDataList = await _loadUploadDataFromStorage();

      if (imageDataList.length != addAppointmentRequest!.length) {
        print("Mismatch between appointments and image data.");
        return;
      }

      final futures = <Future<void>>[];

      for (var i = 0; i < addAppointmentRequest!.length; i++) {
        futures.add(_processSingleAppointment(context, addAppointmentRequest![i], imageDataList[i], i));
      }

      await Future.wait(futures);
      onNext();
    },);
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
