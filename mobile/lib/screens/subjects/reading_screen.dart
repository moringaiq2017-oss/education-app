import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/reading_topics_data.dart';
import '../../widgets/fun_widgets.dart';
import '../../widgets/apple_decoration.dart';
import '../../widgets/topic_illustration.dart';
import 'topic_detail_screen.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const topics = ReadingTopicsData.topics;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('القراءة'),
        backgroundColor: AppTheme.dictationColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBubbleBackground(
        color: AppTheme.dictationColor,
        child: Column(
          children: [
            // === الهيدر ===
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              decoration: const BoxDecoration(
                color: AppTheme.dictationColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                children: [
                  // تفاحات ديكور
                  const Positioned(
                    top: 5,
                    left: 0,
                    child: AppleDecoration(size: 32, color: Color(0xFFE74C3C)),
                  ),
                  const Positioned(
                    top: 10,
                    right: 20,
                    child: AppleDecoration(size: 24, color: Color(0xFF27AE60)),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const LottieReading(size: 100),
                        const SizedBox(height: 8),
                        Text(
                          'مواضيع كتاب قراءتي 📖',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${topics.length} موضوع من الكتاب',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // === شبكة المواضيع ===
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) => _TopicCard(
                  topic: topics[index],
                  index: index,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// بطاقة الموضوع
// ============================================
class _TopicCard extends StatefulWidget {
  final ReadingTopic topic;
  final int index;
  const _TopicCard({required this.topic, required this.index});

  @override
  State<_TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<_TopicCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + (widget.index * 60)),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => SlideTransition(
        position: _slideIn,
        child: ScaleTransition(scale: _scale, child: child),
      ),
      child: BounceButton(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: topic)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: topic.color.withValues(alpha: 0.15),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // دائرة خلفية
              Positioned(
                top: -15,
                left: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: topic.color.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // تفاحة ديكور صغيرة
              Positioned(
                bottom: 8,
                left: 8,
                child: AppleDecoration(
                  size: 18,
                  color: topic.color.withValues(alpha: 0.6),
                ),
              ),
              // المحتوى
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رقم الموضوع + أيقونة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // رقم الموضوع
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: topic.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${topic.id}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: topic.color,
                              ),
                            ),
                          ),
                        ),
                        // أيقونة الموضوع
                        TopicIllustration(
                          emoji: topic.illustration,
                          color: topic.color,
                          size: 48,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // اسم الموضوع
                    Text(
                      topic.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: topic.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // الحرف ورقم الصفحة
                    Row(
                      children: [
                        if (topic.letter.length <= 2)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: topic.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              topic.letter,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: topic.color,
                              ),
                            ),
                          ),
                        const Spacer(),
                        // عدد الأقسام
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${topic.availableSectionsCount}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (topic.pageNumber > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        'ص ${topic.pageNumber}',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
