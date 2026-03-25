/// بيانات الإملاء المستخرجة من كتاب "قراءتي للصف الأول الابتدائي"
/// وزارة التربية العراقية - الطبعة السادسة عشرة 2023

class DictationLesson {
  final int id;
  final String title;
  final String letter; // الحرف الجديد
  final List<String> words;
  final int pageNumber; // رقم الصفحة بالكتاب

  const DictationLesson({
    required this.id,
    required this.title,
    required this.letter,
    required this.words,
    required this.pageNumber,
  });
}

class DictationData {
  static const List<DictationLesson> lessons = [
    // === دروس الحروف الأساسية ===

    DictationLesson(
      id: 1,
      title: 'حرف الدال',
      letter: 'د',
      words: ['دادا', 'دار', 'دور', 'دود'],
      pageNumber: 21,
    ),
    DictationLesson(
      id: 2,
      title: 'حرف الباء',
      letter: 'ب',
      words: ['بابا', 'باب', 'بان'],
      pageNumber: 26,
    ),
    DictationLesson(
      id: 3,
      title: 'حرف النون',
      letter: 'ن',
      words: ['بان', 'نور', 'نام'],
      pageNumber: 27,
    ),
    DictationLesson(
      id: 4,
      title: 'حرف الميم',
      letter: 'م',
      words: ['ماما', 'نام', 'بابا'],
      pageNumber: 28,
    ),
    DictationLesson(
      id: 5,
      title: 'حرف الياء',
      letter: 'ي',
      words: ['نوري', 'ريم', 'دينا', 'بدري'],
      pageNumber: 31,
    ),
    DictationLesson(
      id: 6,
      title: 'حرف القاف',
      letter: 'ق',
      words: ['بوق', 'نديم', 'قديم', 'بقر', 'بدران', 'قريب'],
      pageNumber: 37,
    ),
    DictationLesson(
      id: 7,
      title: 'حرف الزاي',
      letter: 'ز',
      words: ['وز', 'زينب', 'زيد', 'زيدون', 'زورق'],
      pageNumber: 38,
    ),
    DictationLesson(
      id: 8,
      title: 'مراجعة ١',
      letter: 'مراجعة',
      words: ['مزمار', 'مازن', 'وداد', 'قرد', 'ميزان', 'قدوري', 'نادر', 'بزاز'],
      pageNumber: 41,
    ),
    DictationLesson(
      id: 9,
      title: 'حرف اللام',
      letter: 'ل',
      words: ['نبيل', 'بقال', 'لبن', 'رمان', 'قليل'],
      pageNumber: 46,
    ),
    DictationLesson(
      id: 10,
      title: 'حرف الفاء',
      letter: 'ف',
      words: ['ريف', 'مناف', 'فاروق', 'مفيد', 'بقر'],
      pageNumber: 48,
    ),
    DictationLesson(
      id: 11,
      title: 'حرف الهمزة',
      letter: 'ء',
      words: ['أمين', 'بناء', 'مأمون', 'أديب'],
      pageNumber: 49,
    ),
    DictationLesson(
      id: 12,
      title: 'مراجعة ٢',
      letter: 'مراجعة',
      words: ['أمين', 'نبيل', 'ماء', 'بناء', 'بقال', 'رمان', 'نادر', 'ورق', 'نام', 'باب'],
      pageNumber: 50,
    ),
    DictationLesson(
      id: 13,
      title: 'حرف الطاء',
      letter: 'ط',
      words: ['بط', 'طيور', 'طارق', 'طالب', 'بلبل'],
      pageNumber: 55,
    ),
    DictationLesson(
      id: 14,
      title: 'أنشودة البط - تمرين',
      letter: 'تمرين',
      words: ['بط', 'شط', 'سمكة', 'شبكة'],
      pageNumber: 56,
    ),
    DictationLesson(
      id: 15,
      title: 'حرف التنوين',
      letter: 'تنوين',
      words: ['ورداً', 'قطاراً', 'زورقاً', 'طبقاً'],
      pageNumber: 59,
    ),
    DictationLesson(
      id: 16,
      title: 'ال التعريف',
      letter: 'ال',
      words: ['المطر', 'الولد', 'البرد', 'الورد', 'البط', 'القمر'],
      pageNumber: 61,
    ),
    DictationLesson(
      id: 17,
      title: 'حرف التاء',
      letter: 'ت',
      words: ['نوال', 'بنات', 'نامت', 'تمر', 'زيتون'],
      pageNumber: 63,
    ),
    DictationLesson(
      id: 18,
      title: 'حرف لا',
      letter: 'لا',
      words: ['بلال', 'طلال', 'دلال', 'أولاد', 'أقلام', 'البلاد'],
      pageNumber: 65,
    ),
    DictationLesson(
      id: 19,
      title: 'حرف السين',
      letter: 'س',
      words: ['فراس', 'أنيس', 'ميسون', 'سلام', 'البستان'],
      pageNumber: 67,
    ),
    DictationLesson(
      id: 20,
      title: 'حرف العين',
      letter: 'ع',
      words: ['سالم', 'مزارع', 'بستان', 'بديع', 'يزرع', 'الورد', 'الفلفل'],
      pageNumber: 68,
    ),
    DictationLesson(
      id: 21,
      title: 'حرف الشين',
      letter: 'ش',
      words: ['الفراش', 'شامل', 'شرطي', 'الشارع', 'الشمس'],
      pageNumber: 75,
    ),
    DictationLesson(
      id: 22,
      title: 'حرف الذال',
      letter: 'ذ',
      words: ['أستاذ', 'تلاميذ', 'منذر', 'معاذ', 'عسل', 'لذيذ'],
      pageNumber: 80,
    ),
    DictationLesson(
      id: 23,
      title: 'حرف الكاف',
      letter: 'ك',
      words: ['مالك', 'سماك', 'شباك', 'كتاب', 'مكتوب', 'كامل'],
      pageNumber: 82,
    ),
    DictationLesson(
      id: 24,
      title: 'حرف الهاء',
      letter: 'هـ',
      words: ['مياه', 'نبيه', 'هلال', 'همام', 'سهاد', 'مهدي'],
      pageNumber: 84,
    ),
    DictationLesson(
      id: 25,
      title: 'حرف التاء المربوطة',
      letter: 'ة',
      words: ['ناهدة', 'تلميذة', 'نشيطة', 'المدرسة', 'كرة', 'ساعة'],
      pageNumber: 87,
    ),
    DictationLesson(
      id: 26,
      title: 'حرف الصاد',
      letter: 'ص',
      words: ['وقاص', 'المقص', 'منصور', 'طيارة', 'صلاح', 'فلاح'],
      pageNumber: 90,
    ),
    DictationLesson(
      id: 27,
      title: 'حرف الحاء والغين',
      letter: 'ح/غ',
      words: ['أصباغ', 'هشام', 'رسام', 'غزال', 'غراب', 'حقل', 'القمح'],
      pageNumber: 92,
    ),
    DictationLesson(
      id: 28,
      title: 'حرف الضاد',
      letter: 'ض',
      words: ['حوض', 'السباحة', 'رياض', 'ناهض', 'ضياء', 'الرياضة'],
      pageNumber: 98,
    ),
    DictationLesson(
      id: 29,
      title: 'حرف الجيم',
      letter: 'ج',
      words: ['فرج', 'نساج', 'جميلة', 'بساط', 'جديد'],
      pageNumber: 100,
    ),
    DictationLesson(
      id: 30,
      title: 'حرف الثاء',
      letter: 'ث',
      words: ['محراث', 'حارث', 'ليث', 'ثامر', 'ثريا'],
      pageNumber: 101,
    ),
    DictationLesson(
      id: 31,
      title: 'حرف الخاء',
      letter: 'خ',
      words: ['أفراخ', 'الدجاج', 'البطيخ', 'خيمة', 'نخل', 'خوخ'],
      pageNumber: 102,
    ),
    DictationLesson(
      id: 32,
      title: 'حرف الظاء',
      letter: 'ظ',
      words: ['محفوظ', 'ظافر', 'نظيف', 'النظافة'],
      pageNumber: 105,
    ),
    DictationLesson(
      id: 33,
      title: 'مراجعة شاملة',
      letter: 'مراجعة',
      words: [
        'دار', 'باب', 'نار', 'قمر', 'ورد',
        'طالب', 'فراش', 'أستاذ', 'هلال', 'مقص',
        'جميلة', 'مدرسة', 'أولاد', 'بلاد', 'وطن',
      ],
      pageNumber: 0,
    ),
  ];
}
