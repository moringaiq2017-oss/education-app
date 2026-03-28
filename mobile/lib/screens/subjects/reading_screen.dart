import 'package:flutter/material.dart';
import '../../data/reading_topics_data.dart';
import '../../widgets/fun_widgets.dart';
import '../../widgets/apple_decoration.dart';
import 'topic_detail_screen.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const topics = ReadingTopicsData.topics;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      body: Stack(
        children: [
          const _SubtleBackgroundDecor(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // الهيدر
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8E94F2), Color(0xFF6B73FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // زر الرجوع
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              // أيقونة الكتاب
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: LottieReading(size: 36),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'كتاب قراءتي',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'الصف الأول الابتدائي • ٣٣ موضوع',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // شبكة المواضيع
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _TopicCard(topic: topics[index]),
                    childCount: topics.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// بطاقة الموضوع
// ============================================
class _TopicCard extends StatelessWidget {
  final ReadingTopic topic;
  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return BounceButton(
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
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // شريط ملون علوي
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: topic.color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
              ),
            ),

            // المحتوى
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  _buildIconContainer(topic),
                  const SizedBox(height: 12),
                  Text(
                    topic.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A4A),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // بادج الحرف
            if (topic.letter.length <= 3)
              Positioned(
                top: 15, right: 10,
                child: Container(
                  height: 32, width: 32,
                  decoration: BoxDecoration(
                    color: topic.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: topic.color, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      topic.letter,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: topic.color),
                    ),
                  ),
                ),
              ),

            // رقم الصفحة
            if (topic.pageNumber > 0)
              Positioned(
                bottom: 12, left: 12,
                child: Text(
                  'ص${topic.pageNumber}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                ),
              ),

            // عدد الأقسام
            Positioned(
              bottom: 10, right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${topic.availableSectionsCount}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF9F43)),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star_rounded, color: Color(0xFFFF9F43), size: 14),
                  ],
                ),
              ),
            ),

            // تفاحة ديكور
            const Positioned(
              top: 25, left: 12,
              child: AppleDecoration(size: 14, color: Color(0xFFE74C3C)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(ReadingTopic topic) {
    return Container(
      height: 70,
      width: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: topic.hasImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(topic.imagePath!, fit: BoxFit.cover),
            )
          : Center(
              child: Text(topic.illustration, style: const TextStyle(fontSize: 36)),
            ),
    );
  }
}

// ============================================
// زخارف خلفية خفيفة
// ============================================
class _SubtleBackgroundDecor extends StatelessWidget {
  const _SubtleBackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 150, left: 20, child: Text('✨', style: TextStyle(fontSize: 24, color: Colors.black.withValues(alpha: 0.06)))),
        Positioned(top: 300, right: 30, child: Text('⭐', style: TextStyle(fontSize: 20, color: Colors.black.withValues(alpha: 0.05)))),
        Positioned(bottom: 200, left: 40, child: Text('☁️', style: TextStyle(fontSize: 30, color: Colors.black.withValues(alpha: 0.05)))),
        Positioned(bottom: 100, right: 20, child: Text('✨', style: TextStyle(fontSize: 18, color: Colors.black.withValues(alpha: 0.06)))),
      ],
    );
  }
}
