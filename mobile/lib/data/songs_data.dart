/// بيانات الأناشيد المستخرجة من كتاب "قراءتي للصف الأول الابتدائي"
/// وزارة التربية العراقية - الطبعة السادسة عشرة 2023

/// قسم من الأغنية (مقدمة، كورس، مقطع، خاتمة)
class SongSection {
  final String label; // مثل: Intro, Chorus, Verse 1, Outro
  final String labelAr; // مثل: مقدمة, كورس, المقطع الأول, خاتمة
  final List<String> lines;
  final double startTime; // بداية القسم بالثواني
  final double endTime;
  final int repeatCount; // عدد التكرار (للكورس)

  const SongSection({
    required this.label,
    required this.labelAr,
    required this.lines,
    required this.startTime,
    required this.endTime,
    this.repeatCount = 1,
  });
}

class Song {
  final int id;
  final String title;
  final String text; // النص الكامل (للعرض البسيط)
  final List<SongSection> sections; // أقسام الأغنية مع التوقيت
  final int pageNumber;
  final String audioFile;
  final bool hasAudio;

  const Song({
    required this.id,
    required this.title,
    required this.text,
    this.sections = const [],
    required this.pageNumber,
    required this.audioFile,
    required this.hasAudio,
  });
}

class SongsData {
  static const List<Song> songs = [
    Song(
      id: 1,
      title: 'دُعَاء',
      text: 'أَدْعُوكَ يَا إِلَهِي\n'
          'يَا رَافِعَ السَّمَاءِ\n'
          'يَسِّرْ عَلَيَّ دَرْسِي\n'
          'بِالْجِدِّ وَالذَّكَاءِ\n'
          'اِحْفَظْ أَبِي وَأُمِّي\n'
          'وَكُلَّ أَصْدِقَائِي\n'
          'يَا وَاسِعَ الْعَطَاءِ\n'
          'رَبِّ اسْتَجِبْ دُعَائِي',
      sections: [
        // المقدمة - بطيئة حرف حرف
        SongSection(
          label: 'Intro',
          labelAr: 'مقدمة',
          lines: [
            'أَدْ-عُو-كَ يَا إِلَا-هِي',
            'يَا رَا-فِعَ السَّ-مَا-ءِ',
          ],
          startTime: 0.0,
          endTime: 7.0,
        ),
        // الكورس - يتكرر 3 مرات
        SongSection(
          label: 'Chorus',
          labelAr: 'كورس',
          lines: [
            'أَدْعُوكَ يَا إِلَهِي',
            'يَا رَافِعَ السَّمَاءِ',
            'يَسِّرْ عَلَيَّ دَرْسِي',
            'بِالْجِدِّ وَالذَّكَاءِ',
          ],
          startTime: 7.0,
          endTime: 22.0,
          repeatCount: 3,
        ),
        // المقطع الأول
        SongSection(
          label: 'Verse 1',
          labelAr: 'المقطع الأول',
          lines: [
            'اِحْفَظْ أَبِي وَأُمِّي',
            'وَكُلَّ أَصْدِقَائِي',
            'يَا وَاسِعَ الْعَطَاءِ',
            'رَبِّ اسْتَجِبْ دُعَائِي',
          ],
          startTime: 22.0,
          endTime: 30.0,
        ),
        // الكورس مرة ثانية
        SongSection(
          label: 'Chorus',
          labelAr: 'كورس',
          lines: [
            'أَدْعُوكَ يَا إِلَهِي',
            'يَا رَافِعَ السَّمَاءِ',
            'يَسِّرْ عَلَيَّ دَرْسِي',
            'بِالْجِدِّ وَالذَّكَاءِ',
          ],
          startTime: 30.0,
          endTime: 40.0,
          repeatCount: 3,
        ),
        // الخاتمة
        SongSection(
          label: 'Outro',
          labelAr: 'خاتمة',
          lines: [
            'يَا وَاسِعَ الْعَطَاءِ',
            'رَبِّ اسْتَجِبْ دُعَائِي',
          ],
          startTime: 40.0,
          endTime: 44.0,
        ),
      ],
      pageNumber: 30,
      audioFile: 'assets/audio/song_01_duaa.mp3',
      hasAudio: true,
    ),
    Song(
      id: 2,
      title: 'مَدْرَسَتِي',
      text: 'يَا مَدْرَسَتِي\n'
          'فِيكِ أَقْضِي\n'
          'مَعَ إِخْوَانِي\n'
          'بَيْنَ الدَّرْسِ\n'
          'هَذَا صَفِّي\n'
          'أَقْرَأُ فِيهَا\n'
          'كُلَّ الْوَقْتِ\n'
          'مَعَ أَصْحَابِي\n'
          'وَالْأَلْعَابِ\n'
          'هَذِي كُتُبِي\n'
          'بَعْدَ اللَّعِبِ',
      pageNumber: 40,
      audioFile: 'assets/audio/song_02_madrasti.mp3',
      hasAudio: false,
    ),
    Song(
      id: 3,
      title: 'أَصْحَابِي',
      text: 'أَهْلاً أَهْلاً\n'
          'أَهْلاً أَهْلاً\n'
          'يَا أَصْحَابِي\n'
          'بِالْأَحْبَابِ\n'
          'كُلُّ صَدِيقٍ\n'
          'لِي أَرْعَاهُ\n'
          'أَبَداً أَبَداً\n'
          'لَا أَنْسَاهُ\n'
          'نَحْنُ جَمِيعاً\n'
          'جُنْدُ الْوَطَنِ\n'
          'عِشْتِ بِلَادِي\n'
          'طُولَ الزَّمَنِ',
      pageNumber: 51,
      audioFile: 'assets/audio/song_03_ashabi.mp3',
      hasAudio: false,
    ),
    Song(
      id: 4,
      title: 'أُنْشُودَةُ الْبَطِّ',
      text: 'يَا بَطُّ يَا بَطُّ\n'
          'اسْبَحْ بِالشَّطِّ\n'
          'قُلْ لِلسَّمَكَةِ\n'
          'أَنْتِ الشَّبَكَةُ\n'
          'مِيلِي عَنْهَا\n'
          'تَنْجِي مِنْهَا\n'
          'وَعَلَى الْجُرْفِ\n'
          'خُفِّي خُفِّي',
      pageNumber: 56,
      audioFile: 'assets/audio/song_04_bat.mp3',
      hasAudio: false,
    ),
    Song(
      id: 5,
      title: 'حُرُوفُنَا الْجَمِيلَةُ',
      text: 'قِرَاءَتِي\n'
          'أَلِفٌ بَاءٌ\n'
          'تَاءٌ ثَاءٌ\n'
          'هَيَّا نَقْرَأ\n'
          'أَلِفُ أَبْنِي\n'
          'بِيَدِي بِيَدِي\n'
          'أَبْنِي بَلَدِي\n'
          'كُلُّ حُرُوفِي\n'
          'أَتَعَلَّمُهَا\n'
          'بَاءُ بَلَدِي\n'
          'تَأْتِي بَعْدُ\n'
          'وَأَنَا أَشْدُو',
      pageNumber: 70,
      audioFile: 'assets/audio/song_05_horouf.mp3',
      hasAudio: false,
    ),
    Song(
      id: 6,
      title: 'نَشِيدُ النُّورِ',
      text: 'نَشِيدُ النُّورِ فِي شَفَتِي\n'
          'تَعِيشُ تَعِيشُ مَدْرَسَتِي\n'
          'أُحِبُّ مُعَلِّمِي الْغَالِي\n'
          'أُحِبُّكِ يَا مُعَلِّمَتِي\n'
          'عَلَّمْنِي أَرَى وَطَنِي\n'
          'أَرَى الدُّنْيَا بِمَدْرَسَتِي',
      pageNumber: 73,
      audioFile: 'assets/audio/song_06_noor.mp3',
      hasAudio: false,
    ),
    Song(
      id: 7,
      title: 'طَيَّارَتِي',
      text: 'طَيَّارَتِي أُحِبُّهَا\n'
          'مِنْ وَرَقٍ أَصْنَعُهَا\n'
          'طَيَّارَتِي سَرِيعَةٌ\n'
          'خُيُوطُهَا رَقِيقَةٌ\n'
          'أَسْحَبُهَا فَتَرْتَفِعُ\n'
          'وَفِي الْهَوَاءِ تَنْدَفِعُ\n'
          'بِرَأْسِهَا تَمِيلُ\n'
          'وَذَيْلُهَا طَوِيلُ\n'
          'تَطِيرُ فَوْقَ رَأْسِي\n'
          'بَعْدَ انْتِهَاءِ الدَّرْسِ',
      pageNumber: 91,
      audioFile: 'assets/audio/song_07_tayarati.mp3',
      hasAudio: false,
    ),
    Song(
      id: 8,
      title: 'أَنَا فَتَى',
      text: 'أَنَا فَتَىً نَظِيفٌ\n'
          'وَمَنْظَرِي لَطِيفٌ\n'
          'مُعَلِّمِي مِثْلُ أَبِي\n'
          'وَأَصْدِقَائِي كُتُبِي\n'
          'وَإِنَّنِي أَمِينٌ\n'
          'وَخُلُقِي رَصِينٌ\n'
          'أُحِبُّكَ مَدْرَسَتِي\n'
          'أَنْتَ وَكُلُّ إِخْوَتِي',
      pageNumber: 106,
      audioFile: 'assets/audio/song_08_fata.mp3',
      hasAudio: false,
    ),
    Song(
      id: 9,
      title: 'شُكْراً لِلَّهِ',
      text: 'اللَّهُ رَبُّنَا\n'
          'اللَّهُ خَالِقُنَا\n'
          'خَلَقَ الشَّمْسَ وَالْقَمَرَ\n'
          'وَخَلَقَ الطَّيْرَ وَالشَّجَرَ\n'
          'أَنْعَمَ عَلَيْنَا بِالْمَاءِ وَالْهَوَاءِ\n'
          'وَأَنْعَمَ عَلَيْنَا بِالصِّحَّةِ وَالْغِذَاءِ\n'
          'حَمْداً لِلَّهِ.. شُكْراً لِلَّهِ',
      pageNumber: 110,
      audioFile: 'assets/audio/song_09_shukr.mp3',
      hasAudio: false,
    ),
  ];
}
