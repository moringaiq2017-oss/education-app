/// بيانات المحفوظات المستخرجة من كتاب "قراءتي للصف الأول الابتدائي"
/// وزارة التربية العراقية - الطبعة السادسة عشرة 2023

class MemorizationLesson {
  final int id;
  final String title;
  final String text; // النص الكامل
  final List<String> words; // الكلمات المفردة
  final int pageNumber; // رقم الصفحة بالكتاب
  final int difficulty; // مستوى الصعوبة 1-3

  const MemorizationLesson({
    required this.id,
    required this.title,
    required this.text,
    required this.words,
    required this.pageNumber,
    required this.difficulty,
  });
}

class ConversationTopic {
  final int id;
  final String title;
  final int pageNumber;

  const ConversationTopic({
    required this.id,
    required this.title,
    required this.pageNumber,
  });
}

class MemorizationData {
  static const List<MemorizationLesson> lessons = [
    MemorizationLesson(
      id: 1,
      title: 'دادا',
      text: 'دادا دادا - دار دادا - دور دادا - دود دار',
      words: ['دادا', 'دادا', 'دار', 'دادا', 'دور', 'دادا', 'دود', 'دار'],
      pageNumber: 21,
      difficulty: 1,
    ),
    MemorizationLesson(
      id: 2,
      title: 'بابا',
      text: 'بابا بابا - باب دار - دادا بان',
      words: ['بابا', 'بابا', 'باب', 'دار', 'دادا', 'بان'],
      pageNumber: 26,
      difficulty: 1,
    ),
    MemorizationLesson(
      id: 3,
      title: 'ماما',
      text: 'دادا نام - ماما ماما - نور نور: دادا نام - بان بان: بابا ما نام',
      words: [
        'دادا', 'نام', 'ماما', 'ماما', 'نور', 'نور',
        'دادا', 'نام', 'بان', 'بان', 'بابا', 'ما', 'نام',
      ],
      pageNumber: 28,
      difficulty: 1,
    ),
    MemorizationLesson(
      id: 4,
      title: 'دار نوري',
      text:
          'بابا بابا: دار نوري - باب دار نوري - ماما ماما: دار ريم - دار دينا',
      words: [
        'بابا', 'بابا', 'دار', 'نوري', 'باب', 'دار', 'نوري',
        'ماما', 'ماما', 'دار', 'ريم', 'دار', 'دينا',
      ],
      pageNumber: 31,
      difficulty: 1,
    ),
    MemorizationLesson(
      id: 5,
      title: 'دادا رباب',
      text: 'نمير نام - بدري ما نام - دادا نور، دادا ريم: نبني دار بان',
      words: [
        'نمير', 'نام', 'بدري', 'ما', 'نام',
        'دادا', 'نور', 'دادا', 'ريم', 'نبني', 'دار', 'بان',
      ],
      pageNumber: 33,
      difficulty: 1,
    ),
    MemorizationLesson(
      id: 6,
      title: 'بوق نديم',
      text: 'بوق نديم قديم - نديم يقود بقر بدران - بقر بدران قريب',
      words: [
        'بوق', 'نديم', 'قديم', 'نديم', 'يقود',
        'بقر', 'بدران', 'بقر', 'بدران', 'قريب',
      ],
      pageNumber: 37,
      difficulty: 2,
    ),
    MemorizationLesson(
      id: 7,
      title: 'وز',
      text:
          'دادا زينب: وز وز - زيد زيد: زورق زيدون قريب - نزور دار زيدون',
      words: [
        'دادا', 'زينب', 'وز', 'وز', 'زيد', 'زيد',
        'زورق', 'زيدون', 'قريب', 'نزور', 'دار', 'زيدون',
      ],
      pageNumber: 38,
      difficulty: 2,
    ),
    MemorizationLesson(
      id: 8,
      title: 'مزمار مازن',
      text:
          'مزمار مازن قديم - قرد مازن يدور - يا وداد يا وداد: قردي يدور - مزماري قديم',
      words: [
        'مزمار', 'مازن', 'قديم', 'قرد', 'مازن', 'يدور',
        'يا', 'وداد', 'يا', 'وداد', 'قردي', 'يدور', 'مزماري', 'قديم',
      ],
      pageNumber: 41,
      difficulty: 2,
    ),
    MemorizationLesson(
      id: 9,
      title: 'نبيل بقال',
      text:
          'نبيل يقول: لدينا لبن - لدينا رمان - قلنا يا نبيل: رمان ولبن قليل',
      words: [
        'نبيل', 'يقول', 'لدينا', 'لبن', 'لدينا', 'رمان',
        'قلنا', 'يا', 'نبيل', 'رمان', 'ولبن', 'قليل',
      ],
      pageNumber: 46,
      difficulty: 2,
    ),
    MemorizationLesson(
      id: 10,
      title: 'ريف مناف',
      text:
          'فاروق يقول: يا مفيد - نزور ريف مناف - في ريف مناف بقر - في ريف مناف وز',
      words: [
        'فاروق', 'يقول', 'يا', 'مفيد', 'نزور', 'ريف', 'مناف',
        'في', 'ريف', 'مناف', 'بقر', 'في', 'ريف', 'مناف', 'وز',
      ],
      pageNumber: 48,
      difficulty: 2,
    ),
    MemorizationLesson(
      id: 11,
      title: 'أمين بناء',
      text:
          'أمين أبو مأمون بناء - مأمون يقول: نبني دارنا - ونبني دار أديب',
      words: [
        'أمين', 'أبو', 'مأمون', 'بناء', 'مأمون', 'يقول',
        'نبني', 'دارنا', 'ونبني', 'دار', 'أديب',
      ],
      pageNumber: 49,
      difficulty: 3,
    ),
    MemorizationLesson(
      id: 12,
      title: 'دب منير',
      text: 'دب منير من ورق - دب مريم من ورق - قم يا منير نزور زيدان',
      words: [
        'دب', 'منير', 'من', 'ورق', 'دب', 'مريم', 'من', 'ورق',
        'قم', 'يا', 'منير', 'نزور', 'زيدان',
      ],
      pageNumber: 45,
      difficulty: 3,
    ),
  ];

  /// مواضيع المحادثة والتعبير
  static const List<ConversationTopic> conversationTopics = [
    ConversationTopic(id: 1, title: 'الأسرة', pageNumber: 36),
    ConversationTopic(id: 2, title: 'أصحاب الأعمال', pageNumber: 52),
    ConversationTopic(id: 3, title: 'النخلة', pageNumber: 64),
    ConversationTopic(id: 4, title: 'الجيران', pageNumber: 74),
    ConversationTopic(id: 5, title: 'المعلمون', pageNumber: 81),
    ConversationTopic(id: 6, title: 'آداب الطعام', pageNumber: 95),
  ];
}
