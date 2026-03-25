import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../config/theme.dart';
import '../../data/songs_data.dart';
import '../../widgets/fun_widgets.dart';

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
                const AnimatedEmoji(emoji: '🎵', size: 52),
                const SizedBox(height: 12),
                const Text('يلّا نغني! 🎶',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                Text('${SongsData.songs.length} أناشيد من كتاب القراءة للصف الأول',
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: SongsData.songs.length,
              itemBuilder: (context, index) => _SongListItem(song: SongsData.songs[index], index: index),
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
      const Color(0xFF6C63FF), const Color(0xFFFF6B6B), const Color(0xFF4ECDC4),
      const Color(0xFFFFE66D), const Color(0xFF95E1D3), const Color(0xFFFC5185),
      const Color(0xFF3FC1C9), const Color(0xFFFF9A76), const Color(0xFF6C5CE7),
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KaraokeScreen(song: song))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, color.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: song.hasAudio
                    ? const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32)
                    : Text('${song.id}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const SizedBox(height: 4),
                  Text('صفحة ${song.pageNumber}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            if (song.hasAudio)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.headphones_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('أغنية', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                child: const Text('نص فقط', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
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
// شاشة الكاريوكي
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
  late AnimationController _pulseController;

  // التتبع الحالي
  int _currentSectionIndex = -1;
  int _currentLineIndex = -1;
  int _currentWordIndex = -1;

  // بيانات مسطحة للعرض (كل الأقسام والأسطر)
  late List<_DisplayItem> _displayItems;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _buildDisplayItems();

    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() { _position = pos; _updatePosition(pos); });
    });
    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _duration = dur);
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() { _isPlaying = false; _currentSectionIndex = -1; _currentLineIndex = -1; _currentWordIndex = -1; _position = Duration.zero; });
    });
  }

  void _buildDisplayItems() {
    _displayItems = [];
    for (int s = 0; s < widget.song.sections.length; s++) {
      final section = widget.song.sections[s];
      // أضف عنوان القسم
      _displayItems.add(_DisplayItem(type: _ItemType.sectionHeader, sectionIndex: s, text: section.labelAr,
        repeatInfo: section.repeatCount > 1 ? 'يُكرر ${section.repeatCount} مرات' : null));
      // أضف أسطر القسم
      for (int l = 0; l < section.lines.length; l++) {
        _displayItems.add(_DisplayItem(type: _ItemType.lyricLine, sectionIndex: s, lineIndex: l, text: section.lines[l]));
      }
    }
  }

  void _updatePosition(Duration pos) {
    if (widget.song.sections.isEmpty) {
      _updateSimplePosition(pos);
      return;
    }

    final seconds = pos.inMilliseconds / 1000.0;

    // تحديد القسم الحالي
    int secIdx = -1;
    for (int i = widget.song.sections.length - 1; i >= 0; i--) {
      if (seconds >= widget.song.sections[i].startTime) {
        secIdx = i;
        break;
      }
    }

    if (secIdx >= 0) {
      final section = widget.song.sections[secIdx];
      _currentSectionIndex = secIdx;

      // تحديد السطر داخل القسم
      final sectionDuration = section.endTime - section.startTime;
      final elapsed = seconds - section.startTime;
      final lineCount = section.lines.length;

      if (lineCount > 0 && sectionDuration > 0) {
        final perLine = sectionDuration / lineCount;
        _currentLineIndex = (elapsed / perLine).floor().clamp(0, lineCount - 1);

        // تحديد الكلمة داخل السطر
        final lineStart = _currentLineIndex * perLine;
        final lineElapsed = elapsed - lineStart;
        final words = section.lines[_currentLineIndex].split(' ').where((w) => w.isNotEmpty).toList();
        if (words.isNotEmpty && perLine > 0) {
          final perWord = perLine / words.length;
          _currentWordIndex = (lineElapsed / perWord).floor().clamp(0, words.length - 1);
        }
      }
    }
  }

  // للأغاني بدون sections
  void _updateSimplePosition(Duration pos) {
    final lines = widget.song.text.split('\n');
    final seconds = pos.inMilliseconds / 1000.0;
    final totalSec = _duration.inMilliseconds > 0 ? _duration.inMilliseconds / 1000.0 : 44.0;
    final perLine = totalSec / lines.length;
    _currentSectionIndex = 0;
    _currentLineIndex = (seconds / perLine).floor().clamp(0, lines.length - 1);
    final lineElapsed = seconds - (_currentLineIndex * perLine);
    final words = lines[_currentLineIndex].split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isNotEmpty && perLine > 0) {
      _currentWordIndex = (lineElapsed / (perLine / words.length)).floor().clamp(0, words.length - 1);
    }
  }

  Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_position == Duration.zero) {
          await _audioPlayer.play(AssetSource(widget.song.audioFile.replaceFirst('assets/', '')));
        } else {
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
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
            // شريط علوي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
                  Expanded(child: Text(widget.song.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // أيقونة متحركة
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = _isPlaying ? 1.0 + (_pulseController.value * 0.1) : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFFE91E63)]),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: const Color(0xFF6C63FF).withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2)],
                    ),
                    child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 36),
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            Text('صفحة ${widget.song.pageNumber} • كتاب القراءة',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
            const SizedBox(height: 16),

            // نص الأنشودة مع الكاريوكي
            Expanded(
              child: widget.song.sections.isNotEmpty ? _buildSectionsView() : _buildSimpleView(),
            ),

            const SizedBox(height: 8),

            // التحكم
            if (widget.song.hasAudio) _buildControls() else _buildNoAudioMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionsView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _displayItems.length,
      itemBuilder: (context, i) {
        final item = _displayItems[i];
        if (item.type == _ItemType.sectionHeader) {
          return _buildSectionHeader(item);
        } else {
          return _buildLyricLine(item);
        }
      },
    );
  }

  Widget _buildSectionHeader(_DisplayItem item) {
    final isActive = _isPlaying && item.sectionIndex == _currentSectionIndex;
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFFE91E63)])
                  : null,
              color: isActive ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: isActive ? null : Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isActive) ...[
                  const Icon(Icons.equalizer_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                ],
                Text(item.text,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      fontSize: 13, fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ),
          if (item.repeatInfo != null) ...[
            const SizedBox(width: 8),
            Text(item.repeatInfo!, style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
          ],
          Expanded(child: Container(margin: const EdgeInsets.only(right: 12), height: 1, color: Colors.white.withValues(alpha: 0.08))),
        ],
      ),
    );
  }

  Widget _buildLyricLine(_DisplayItem item) {
    final isCurrentSection = _isPlaying && item.sectionIndex == _currentSectionIndex;
    final isCurrentLine = isCurrentSection && item.lineIndex == _currentLineIndex;
    final isPastLine = _isPlaying && (item.sectionIndex! < _currentSectionIndex ||
        (item.sectionIndex == _currentSectionIndex && (item.lineIndex ?? 0) < _currentLineIndex));

    final words = item.text.split(' ').where((w) => w.isNotEmpty).toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: isCurrentLine
            ? const Color(0xFF6C63FF).withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isCurrentLine
            ? Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: List.generate(words.length, (wordIdx) {
          final isCurrentWord = isCurrentLine && wordIdx == _currentWordIndex;
          final isPastWord = isCurrentLine && wordIdx < _currentWordIndex;

          Color wordColor;
          double fontSize;
          FontWeight fontWeight;

          if (isCurrentWord) {
            wordColor = const Color(0xFFFFD700);
            fontSize = 26;
            fontWeight = FontWeight.w900;
          } else if (isPastWord || isPastLine) {
            wordColor = const Color(0xFF6C63FF);
            fontSize = 22;
            fontWeight = FontWeight.w600;
          } else {
            wordColor = Colors.white.withValues(alpha: isCurrentSection ? 0.9 : 0.5);
            fontSize = 22;
            fontWeight = FontWeight.w600;
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: isCurrentWord
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
                : EdgeInsets.zero,
            decoration: isCurrentWord
                ? BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.5), width: 1.5),
                    boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: 0.2), blurRadius: 12)],
                  )
                : null,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: wordColor, height: 1.6, fontFamily: 'packages/google_fonts/Cairo'),
              child: Text(words[wordIdx]),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSimpleView() {
    final lines = widget.song.text.split('\n');
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.3)),
        ),
        child: Column(
          children: List.generate(lines.length, (lineIdx) {
            final isCurrentLine = lineIdx == _currentLineIndex && _isPlaying;
            final isPastLine = _isPlaying && lineIdx < _currentLineIndex;
            final words = lines[lineIdx].split(' ').where((w) => w.isNotEmpty).toList();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isCurrentLine ? const Color(0xFF6C63FF).withValues(alpha: 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: isCurrentLine ? Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.4), width: 1.5) : null,
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: List.generate(words.length, (wIdx) {
                  final isCurrent = isCurrentLine && wIdx == _currentWordIndex;
                  final isPast = isCurrentLine && wIdx < _currentWordIndex;
                  return Text(
                    words[wIdx],
                    style: TextStyle(
                      fontSize: isCurrent ? 26 : 22,
                      fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                      color: isCurrent ? const Color(0xFFFFD700) : (isPast || isPastLine ? const Color(0xFF6C63FF) : Colors.white.withValues(alpha: 0.8)),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          // شريط التقدم
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF6C63FF),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: const Color(0xFFFFD700),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 4,
            ),
            child: Slider(
              value: _duration.inMilliseconds > 0 ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0) : 0.0,
              onChanged: (v) => _audioPlayer.seek(Duration(milliseconds: (v * _duration.inMilliseconds).round())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_fmt(_position), style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                // عرض القسم الحالي
                if (_currentSectionIndex >= 0 && _currentSectionIndex < widget.song.sections.length)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.song.sections[_currentSectionIndex].labelAr,
                      style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                Text(_fmt(_duration), style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // الأزرار
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ctrlBtn(Icons.replay_rounded, 48, false, _restart),
              const SizedBox(width: 24),
              _ctrlBtn(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, 68, true, _togglePlay),
              const SizedBox(width: 24),
              _ctrlBtn(Icons.stop_rounded, 48, false, () async {
                await _audioPlayer.stop();
                setState(() { _position = Duration.zero; _currentSectionIndex = -1; _currentLineIndex = -1; _currentWordIndex = -1; });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ctrlBtn(IconData icon, double size, bool primary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          gradient: primary ? const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFFE91E63)]) : null,
          color: primary ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(size * 0.32),
          boxShadow: primary ? [BoxShadow(color: const Color(0xFF6C63FF).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 4))] : null,
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }

  Widget _buildNoAudioMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
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
            Text('سيتم إضافة الأغنية قريباً',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// أنواع عناصر العرض
enum _ItemType { sectionHeader, lyricLine }

class _DisplayItem {
  final _ItemType type;
  final int? sectionIndex;
  final int? lineIndex;
  final String text;
  final String? repeatInfo;

  _DisplayItem({required this.type, this.sectionIndex, this.lineIndex, required this.text, this.repeatInfo});
}
