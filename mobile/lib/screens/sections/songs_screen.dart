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
                return _SongListItem(song: song);
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

  const _SongListItem({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _SongDetailScreen(song: song),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // رقم الأنشودة
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.songsColor,
                    AppTheme.songsColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.songsColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: song.hasAudio
                    ? const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30,
                      )
                    : const Icon(
                        Icons.music_note_rounded,
                        color: Colors.white,
                        size: 26,
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
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'صفحة ${song.pageNumber}',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.volume_up_rounded,
                      color: AppTheme.successColor,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'صوت',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.songsColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'قريباً',
                  style: TextStyle(
                    color: AppTheme.songsColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_left_rounded,
              color: AppTheme.textLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// شاشة تفاصيل الأنشودة
// ==========================================

class _SongDetailScreen extends StatefulWidget {
  final Song song;

  const _SongDetailScreen({required this.song});

  @override
  State<_SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<_SongDetailScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
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
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    try {
      if (!_isLoaded) {
        await _audioPlayer.setSource(AssetSource(
          widget.song.audioFile.replaceFirst('assets/', ''),
        ));
        _isLoaded = true;
      }
      await _audioPlayer.resume();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في تشغيل الصوت'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    _isLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.song.title),
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
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            decoration: const BoxDecoration(
              color: AppTheme.songsColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.song.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'صفحة ${widget.song.pageNumber} من كتاب القراءة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // نص الأنشودة
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.song.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 2.2,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          // عناصر التحكم بالصوت
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: widget.song.hasAudio
                ? _buildAudioControls()
                : _buildNoAudioMessage(),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // زر إيقاف
        _AudioControlButton(
          icon: Icons.stop_rounded,
          size: 48,
          iconSize: 28,
          color: AppTheme.textSecondary,
          onTap: _stop,
        ),
        const SizedBox(width: 20),
        // زر تشغيل/إيقاف مؤقت
        _AudioControlButton(
          icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 64,
          iconSize: 36,
          color: AppTheme.songsColor,
          filled: true,
          onTap: _isPlaying ? _pause : _play,
        ),
        const SizedBox(width: 20),
        // فراغ للتوازن
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildNoAudioMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.songsColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_rounded,
            color: AppTheme.songsColor,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            'سيتم إضافة الصوت قريباً',
            style: TextStyle(
              color: AppTheme.songsColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _AudioControlButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.color,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : color,
          size: iconSize,
        ),
      ),
    );
  }
}
