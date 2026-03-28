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
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              _buildBackgroundDecorations(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _TopicCard(topic: topics[index]),
                        childCount: topics.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 32, left: 20, right: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          boxShadow: [
            BoxShadow(color: Color(0x40E91E63), offset: Offset(0, 8), blurRadius: 16),
          ],
        ),
        child: Column(
          children: [
            // زر الرجوع + العنوان
            Row(
              children: [
                Builder(
                  builder: (ctx) => GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'كتاب قراءتي 📖',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // التفاصيل + Lottie
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصف الأول الابتدائي',
                      style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '٣٣ موضوع من الكتاب',
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(width: 80, height: 80, child: LottieReading(size: 80)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(top: 100, left: 30, child: Icon(Icons.star_rounded, color: Colors.amber.withValues(alpha: 0.25), size: 40)),
        Positioned(top: 300, right: 20, child: Icon(Icons.circle, color: Colors.blue.withValues(alpha: 0.15), size: 20)),
        Positioned(top: 500, left: 50, child: Icon(Icons.star_rounded, color: Colors.pink.withValues(alpha: 0.15), size: 30)),
        Positioned(bottom: 100, right: 40, child: Icon(Icons.change_history_rounded, color: Colors.green.withValues(alpha: 0.15), size: 35)),
        Positioned(top: 700, left: 20, child: Icon(Icons.favorite_rounded, color: Colors.red.withValues(alpha: 0.12), size: 24)),
        Positioned(top: 900, right: 60, child: Icon(Icons.auto_awesome, color: Colors.purple.withValues(alpha: 0.15), size: 28)),
      ],
    );
  }
}

// ============================================
// بطاقة الموضوع - تصميم طفولي
// ============================================
class _TopicCard extends StatefulWidget {
  final ReadingTopic topic;
  const _TopicCard({required this.topic});

  @override
  State<_TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<_TopicCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    Future.delayed(Duration(milliseconds: 80 * (widget.topic.id % 10)), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;

    return ScaleTransition(
      scale: _scale,
      child: BounceButton(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: topic)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: topic.color.withValues(alpha: 0.25),
                offset: const Offset(0, 8),
                blurRadius: 12,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // شريط ملون علوي
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: topic.color,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                  ),

                  // منطقة الصورة
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [topic.color.withValues(alpha: 0.12), Colors.transparent],
                          radius: 0.7,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // تفاحات ديكور
                          Positioned(
                            top: 6,
                            right: 10,
                            child: AppleDecoration(size: 16, color: Colors.red.shade400),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 12,
                            child: AppleDecoration(size: 14, color: const Color(0xFF27AE60)),
                          ),
                          // الصورة أو الإيموجي
                          if (topic.hasImage)
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: topic.color.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  topic.imagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _emojiCircle(topic),
                                ),
                              ),
                            )
                          else
                            _emojiCircle(topic),
                        ],
                      ),
                    ),
                  ),

                  // النص
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          topic.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4A4A4A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (topic.pageNumber > 0)
                              Text(
                                'ص${topic.pageNumber}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade500,
                                ),
                              )
                            else
                              const SizedBox(),
                            // بادج عدد الأقسام
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: topic.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_rounded, size: 13, color: topic.color),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${topic.availableSectionsCount}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: topic.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // بادج الحرف
              if (topic.letter.length <= 2)
                Positioned(
                  top: -6,
                  right: 8,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: topic.color, width: 2.5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        topic.letter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: topic.color,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emojiCircle(ReadingTopic topic) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: topic.color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Text(topic.illustration, style: const TextStyle(fontSize: 36)),
    );
  }
}
