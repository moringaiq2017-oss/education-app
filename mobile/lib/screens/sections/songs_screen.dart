import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../config/theme.dart';
import '../../data/songs_data.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('الأناشيد'),
        backgroundColor: AppTheme.songsColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // هيدر
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            decoration: const BoxDecoration(
              color: AppTheme.songsColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.music_note_rounded, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'أناشيد القراءة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${SongsData.songs.length} أناشيد من كتاب القراءة للصف الأول',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // القائمة
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: SongsData.songs.length,
              itemBuilder: (context, index) {
                final song = SongsData.songs[index];
                return _SongListItem(song: song, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SongListItem extends StatelessWidget {
  final Song song;
  final int index;

  const _SongListItem({required this.song, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFE66D),
      const Color(0xFF95E1D3),
      const Color(0xFFFC5185),
      const Color(0xFF3FC1C9),
      const Color(0xFFFF9A76),
      const Color(0xFF6C5CE7),
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KaraokeScreen(song: song),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // أيقونة الأنشودة
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: song.hasAudio
                    ? const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32)
                    : Text(
                        '${song.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // المعلومات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'صفحة ${song.pageNumber} • ${song.text.split('\n').length} أبيات',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // حالة الصوت
            if (song.hasAudio)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.headphones_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('أغنية', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'نص فقط',
                  style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_left_rounded, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// شاشة الكاريوكي - عرض الأنشودة مع تمييز الكلمات
// ==========================================

class KaraokeScreen extends StatefulWidget {
  final Song song;

  const KaraokeScreen({super.key, required this.song});

  @override
  State<KaraokeScreen> createState() => _KaraokeScreenState();
}

class _KaraokeScreenState extends State<KaraokeScreen> with TickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int _currentLineIndex = -1;
  int _currentWordIndex = -1;
  late List<String> _lines;
  late List<List<String>> _lineWords;
  Timer? _karaokeTimer;
  late AnimationController _pulseController;

  // توقيتات تقديرية لكل سطر (بالثواني) - للأغنية الأولى
  List<double> _lineTimings = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _lines = widget.song.text.split('\n');
    _lineWords = _lines.map((l) => l.split(' ').where((w) => w.isNotEmpty).toList()).toList();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // توقيتات تقديرية - كل سطر يأخذ وقت متساوي
    // للأغنية الأولى (44 ثانية) مع 8 أسطر = ~5.5 ثانية لكل سطر
    _generateTimings();

    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) {
        setState(() {
          _position = pos;
          _updateKaraokePosition(pos);
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() {
          _duration = dur;
          _generateTimings();
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentLineIndex = -1;
          _currentWordIndex = -1;
          _position = Duration.zero;
        });
      }
    });
  }

  void _generateTimings() {
    if (_lines.isEmpty) return;
    final totalSeconds = _duration.inMilliseconds > 0
        ? _duration.inMilliseconds / 1000.0
        : 44.0; // default for first song

    // بداية بعد 2 ثانية مقدمة
    final intro = 2.0;
    final perLine = (totalSeconds - intro) / _lines.length;
    _lineTimings = List.generate(_lines.length, (i) => intro + (i * perLine));
  }

  void _updateKaraokePosition(Duration pos) {
    final seconds = pos.inMilliseconds / 1000.0;

    // تحديد السطر الحالي
    int lineIdx = -1;
    for (int i = _lineTimings.length - 1; i >= 0; i--) {
      if (seconds >= _lineTimings[i]) {
        lineIdx = i;
        break;
      }
    }

    if (lineIdx >= 0 && lineIdx < _lines.length) {
      _currentLineIndex = lineIdx;

      // تحديد الكلمة الحالية داخل السطر
      final lineStart = _lineTimings[lineIdx];
      final lineEnd = lineIdx < _lineTimings.length - 1
          ? _lineTimings[lineIdx + 1]
          : (_duration.inMilliseconds > 0 ? _duration.inMilliseconds / 1000.0 : 44.0);
      final lineDuration = lineEnd - lineStart;
      final wordCount = _lineWords[lineIdx].length;
      if (wordCount > 0) {
        final perWord = lineDuration / wordCount;
        final elapsed = seconds - lineStart;
        _currentWordIndex = (elapsed / perWord).floor().clamp(0, wordCount - 1);
      }
    }
  }

  Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_position == Duration.zero) {
          await _audioPlayer.play(AssetSource(
            widget.song.audioFile.replaceFirst('assets/', ''),
          ));
        } else {
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ بالصوت: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _restart() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.resume();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _karaokeTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      widget.song.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // رمز الأنشودة
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = _isPlaying ? 1.0 + (_pulseController.value * 0.1) : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFFE91E63)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 40),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              'صفحة ${widget.song.pageNumber} • كتاب القراءة',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
            ),

            const SizedBox(height: 20),

            // نص الأنشودة مع الكاريوكي
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: List.generate(_lines.length, (lineIdx) {
                      final isCurrentLine = lineIdx == _currentLineIndex && _isPlaying;
                      final words = _lineWords[lineIdx];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isCurrentLine
                              ? const Color(0xFF6C63FF).withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: isCurrentLine
                              ? Border.all(
                                  color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 6,
                          children: List.generate(words.length, (wordIdx) {
                            final isCurrentWord = isCurrentLine && wordIdx == _currentWordIndex;
                            final isPastWord = isCurrentLine && wordIdx < _currentWordIndex;
                            final isPastLine = _isPlaying && lineIdx < _currentLineIndex;

                            Color wordColor;
                            if (isCurrentWord) {
                              wordColor = const Color(0xFFFFD700); // ذهبي للكلمة الحالية
                            } else if (isPastWord || isPastLine) {
                              wordColor = const Color(0xFF6C63FF); // بنفسجي للكلمات السابقة
                            } else {
                              wordColor = Colors.white.withValues(alpha: 0.8);
                            }

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: isCurrentWord
                                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
                                  : EdgeInsets.zero,
                              decoration: isCurrentWord
                                  ? BoxDecoration(
                                      color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                                        width: 1.5,
                                      ),
                                    )
                                  : null,
                              child: Text(
                                words[wordIdx],
                                style: TextStyle(
                                  fontSize: isCurrentWord ? 26 : 22,
                                  fontWeight: isCurrentWord ? FontWeight.w900 : FontWeight.w600,
                                  color: wordColor,
                                  height: 1.8,
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // شريط التقدم
            if (widget.song.hasAudio) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF6C63FF),
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                        thumbColor: const Color(0xFFFFD700),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 4,
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: _duration.inMilliseconds > 0
                            ? _position.inMilliseconds / _duration.inMilliseconds
                            : 0.0,
                        onChanged: (v) {
                          final newPos = Duration(
                            milliseconds: (v * _duration.inMilliseconds).round(),
                          );
                          _audioPlayer.seek(newPos);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // أزرار التحكم
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // إعادة
                    GestureDetector(
                      onTap: _restart,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.replay_rounded, color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // تشغيل/إيقاف
                    GestureDetector(
                      onTap: _togglePlay,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFFE91E63)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // إيقاف
                    GestureDetector(
                      onTap: () async {
                        await _audioPlayer.stop();
                        setState(() {
                          _position = Duration.zero;
                          _currentLineIndex = -1;
                          _currentWordIndex = -1;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.stop_rounded, color: Colors.white, size: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // رسالة بدون صوت
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'سيتم إضافة الأغنية قريباً',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
