/// بيانات الأناشيد المستخرجة من كتاب "قراءتي للصف الأول الابتدائي"
/// وزارة التربية العراقية - الطبعة السادسة عشرة 2023

class Song {
  final int id;
  final String title;
  final String text; // النص الكامل
  final int pageNumber; // رقم الصفحة بالكتاب
  final String audioFile; // مسار ملف الصوت
  final bool hasAudio; // هل الصوت متوفر حالياً

  const Song({
    required this.id,
    required this.title,
    required this.text,
    required this.pageNumber,
    required this.audioFile,
    required this.hasAudio,
  });
}

class SongsData {
  static const List<Song> songs = [
    Song(
      id: 1,
      title: 'دعاء',
      text: 'أدعوكَ يا إلهي\n'
          'يسّرْ عليَّ درسي\n'
          'واحفظْ أبي وأمّي\n'
          'يا واسعَ العطاءِ\n'
          'يا رافعَ السماءِ\n'
          'بالجدِّ والذكاءِ\n'
          'وكلَّ أصدقائي\n'
          'ربِّ استجبْ دعائي',
      pageNumber: 30,
      audioFile: 'assets/audio/song_01_duaa.mp3',
      hasAudio: true,
    ),
    Song(
      id: 2,
      title: 'مدرستي',
      text: 'يا مدرستي\n'
          'فيكِ أقضي\n'
          'معَ إخواني\n'
          'بينَ الدرسِ\n'
          'هذا صفّي\n'
          'أقرأُ فيها\n'
          'كلَّ الوقتِ\n'
          'معَ أصحابي\n'
          'والألعابِ\n'
          'هذي كتبي\n'
          'بعدَ اللعبِ',
      pageNumber: 40,
      audioFile: 'assets/audio/song_02_madrasti.mp3',
      hasAudio: false,
    ),
    Song(
      id: 3,
      title: 'أصحابي',
      text: 'أهلاً أهلاً\n'
          'أهلاً أهلاً\n'
          'يا أصحابي\n'
          'بالأحبابِ\n'
          'كلُّ صديقٍ\n'
          'لي أرعاهُ\n'
          'أبداً أبداً\n'
          'لا أنساهُ\n'
          'نحنُ جميعاً\n'
          'جندُ الوطنِ\n'
          'عشتِ بلادي\n'
          'طولَ الزمنِ',
      pageNumber: 51,
      audioFile: 'assets/audio/song_03_ashabi.mp3',
      hasAudio: false,
    ),
    Song(
      id: 4,
      title: 'أنشودة البط',
      text: 'يا بطُّ يا بطُّ\n'
          'قُلْ للسمكةِ\n'
          'ميلي عنها\n'
          'وعلى الجُرفِ\n'
          'اسبحْ بالشطِّ\n'
          'أنتِ الشبكةُ\n'
          'تنجي منها\n'
          'خُفّي خُفّي',
      pageNumber: 56,
      audioFile: 'assets/audio/song_04_bat.mp3',
      hasAudio: false,
    ),
    Song(
      id: 5,
      title: 'حروفنا الجميلة',
      text: 'قراءتي\n'
          'ألفٌ باءٌ\n'
          'تاءٌ ثاءٌ\n'
          'هيّا نقرأ\n'
          'ألفُ أبني\n'
          'بيدي بيدي\n'
          'أبني بلدي\n'
          'كلُّ حروفي\n'
          'أتعلّمُها\n'
          'باءُ بلدي\n'
          'تأتي بعدُ\n'
          'وأنا أشدو',
      pageNumber: 70,
      audioFile: 'assets/audio/song_05_horouf.mp3',
      hasAudio: false,
    ),
    Song(
      id: 6,
      title: 'نشيد النور',
      text: 'نشيدُ النورِ في شفتي\n'
          'تعيشُ تعيشُ مدرستي\n'
          'أحبُّ معلمي الغالي\n'
          'أحبُّكِ يا معلمتي\n'
          'علّمي أرى وطني\n'
          'أرى الدنيا بمدرستي',
      pageNumber: 73,
      audioFile: 'assets/audio/song_06_noor.mp3',
      hasAudio: false,
    ),
    Song(
      id: 7,
      title: 'طيارتي',
      text: 'طيارتي أحبُّها\n'
          'من ورقٍ أصنعُها\n'
          'طيارتي سريعةٌ\n'
          'خيوطُها رقيقةٌ\n'
          'أسحبُها فترتفعُ\n'
          'وفي الهواءِ تندفعُ\n'
          'برأسِها تميلُ\n'
          'وذيلُها طويلُ\n'
          'تطيرُ فوقَ رأسي\n'
          'بعدَ انتهاءِ الدرسِ',
      pageNumber: 91,
      audioFile: 'assets/audio/song_07_tayarati.mp3',
      hasAudio: false,
    ),
    Song(
      id: 8,
      title: 'أنا فتى',
      text: 'أنا فتىً نظيفٌ\n'
          'معلمي مثلُ أبي\n'
          'وإنّني أمينٌ\n'
          'أحبُّكَ مدرستي\n'
          'ومنظري لطيفٌ\n'
          'وأصدقائي كتبي\n'
          'وخُلُقي رصينٌ\n'
          'أنتَ وكلُّ إخوتي',
      pageNumber: 106,
      audioFile: 'assets/audio/song_08_fata.mp3',
      hasAudio: false,
    ),
    Song(
      id: 9,
      title: 'شكراً لله',
      text: 'اللهُ ربُّنا\n'
          'اللهُ خالقُنا\n'
          'خلقَ الشمسَ والقمرَ\n'
          'وخلقَ الطيرَ والشجرَ\n'
          'أنعمَ علينا بالماءِ والهواءِ\n'
          'وأنعمَ علينا بالصحةِ والغذاءِ\n'
          'حمداً للهِ.. شكراً للهِ',
      pageNumber: 110,
      audioFile: 'assets/audio/song_09_shukr.mp3',
      hasAudio: false,
    ),
  ];
}
