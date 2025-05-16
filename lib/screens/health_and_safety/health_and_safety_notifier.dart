import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/utils/common/widgets/info_section_widget.dart';

class HealthAndSafetyNotifier extends BaseChangeNotifier{

  bool _isChecked = false;

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
  // Update User Verify checkbox state
  void userAcceptDeclarationChecked(BuildContext context, bool? value) {
    isChecked = value!;
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
}