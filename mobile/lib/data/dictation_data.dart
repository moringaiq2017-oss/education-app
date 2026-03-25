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
      title: 'حرف الدال - دادا',
      letter: 'د',
      words: ['دادا', 'دا', 'دار'],
      pageNumber: 21,
    ),
    DictationLesson(
      id: 2,
      title: 'حرف الراء - دار',
      letter: 'ر',
      words: ['دار', 'دادا', 'دور'],
      pageNumber: 22,
    ),
    DictationLesson(
      id: 3,
      title: 'حرف الواو - دور',
      letter: 'و',
      words: ['دور', 'دادا', 'دار', 'دود'],
      pageNumber: 23,
    ),
    DictationLesson(
      id: 4,
      title: 'حرف الباء - بابا',
      letter: 'ب',
      words: ['بابا', 'باب', 'دار', 'دادا'],
      pageNumber: 26,
    ),
    DictationLesson(
      id: 5,
      title: 'حرف النون - نادر',
      letter: 'ن',
      words: ['نار', 'نور', 'نادر', 'بان', 'نبني'],
      pageNumber: 33,
    ),
    DictationLesson(
      id: 6,
      title: 'تدريب الحروف (١)',
      letter: 'تدريب',
      words: ['بريد', 'درب', 'نبني', 'ورد', 'نار', 'وادي'],
      pageNumber: 35,
    ),
    DictationLesson(
      id: 7,
      title: 'حرف الميم - ماما',
      letter: 'م',
      words: ['ماما', 'مريم', 'منير', 'رمان', 'أمين'],
      pageNumber: 37,
    ),
    DictationLesson(
      id: 8,
      title: 'حرف القاف - قمر',
      letter: 'ق',
      words: ['قمر', 'ورق', 'بقال', 'قلب', 'نقل'],
      pageNumber: 42,
    ),
    DictationLesson(
      id: 9,
      title: 'حرف الزاي - زيدان',
      letter: 'ز',
      words: ['زيدان', 'رمان', 'بزار', 'نزل', 'ميزان'],
      pageNumber: 44,
    ),
    DictationLesson(
      id: 10,
      title: 'دب منير',
      letter: 'تدريب',
      words: ['منير', 'ورق', 'مريم', 'زيدان', 'قمر'],
      pageNumber: 45,
    ),
    DictationLesson(
      id: 11,
      title: 'تدريب الحروف (٢)',
      letter: 'تدريب',
      words: ['أمين', 'نبيل', 'ماء', 'بناء', 'بقال', 'رمان', 'نادر', 'ورق', 'نام', 'باب'],
      pageNumber: 50,
    ),

    // === دروس الحروف المتقدمة ===

    DictationLesson(
      id: 12,
      title: 'حرف الطاء - بط وطيور',
      letter: 'ط',
      words: ['بط', 'طيور', 'طارق', 'طالب', 'بلبل', 'طار'],
      pageNumber: 55,
    ),
    DictationLesson(
      id: 13,
      title: 'حرف التنوين - نار وطبق',
      letter: 'تنوين',
      words: ['نار', 'طبق', 'ورد', 'موقد', 'لبن', 'قطن', 'موطن'],
      pageNumber: 60,
    ),
    DictationLesson(
      id: 14,
      title: 'حرف اللام ألف - أولاد',
      letter: 'لا',
      words: ['بلال', 'طلال', 'دلال', 'أولاد', 'أقلام', 'الوطن', 'البلاد'],
      pageNumber: 65,
    ),
    DictationLesson(
      id: 15,
      title: 'حرف الشين - الفراش',
      letter: 'ش',
      words: ['فراش', 'ريش', 'عش', 'بستان', 'طيور', 'يطير', 'يعيش'],
      pageNumber: 75,
    ),
    DictationLesson(
      id: 16,
      title: 'حرف الذال - أستاذ وتلاميذ',
      letter: 'ذ',
      words: ['أستاذ', 'تلاميذ', 'منذر', 'معاذ', 'قدير', 'نشيط', 'عسل', 'لذيذ'],
      pageNumber: 80,
    ),
    DictationLesson(
      id: 17,
      title: 'حرف الهاء - هلال العيد',
      letter: 'هـ',
      words: ['هلال', 'العيد', 'همام', 'سهاد', 'مهدي', 'مبارك', 'سعيد'],
      pageNumber: 85,
    ),
    DictationLesson(
      id: 18,
      title: 'حرف الصاد - طيارة وقاص',
      letter: 'ص',
      words: ['وقاص', 'مقص', 'منصور', 'طيارة', 'صديق', 'صنع', 'قص'],
      pageNumber: 90,
    ),
    DictationLesson(
      id: 19,
      title: 'حرف الجيم - فرج نساج',
      letter: 'ج',
      words: ['فرج', 'نساج', 'جميلة', 'بساط', 'جديد', 'أشجار', 'ورد'],
      pageNumber: 100,
    ),
    DictationLesson(
      id: 20,
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
