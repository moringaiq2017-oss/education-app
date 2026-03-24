import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../config/theme.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;
  final bool showDetails;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.onTap,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: achievement.isUnlocked
              ? Colors.white
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: achievement.isUnlocked
                ? AppTheme.accentColor.withOpacity(0.3)
                : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: achievement.isUnlocked
              ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة
            Stack(
              alignment: Alignment.center,
              children: [
                // دائرة خلفية
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: achievement.isUnlocked
                        ? LinearGradient(
                            colors: [
                              AppTheme.accentColor,
                              AppTheme.accentColor.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey[400]!,
                              Colors.grey[300]!,
                            ],
                          ),
                  ),
                ),
                // الإيموجي
                Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 32,
                    color: achievement.isUnlocked ? null : Colors.black26,
                  ),
                ),
                // قفل للإنجازات المغلقة
                if (!achievement.isUnlocked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 8),
              // العنوان
              Text(
                achievement.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: achievement.isUnlocked
                      ? Colors.black87
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // الوصف
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 11,
                  color: achievement.isUnlocked
                      ? Colors.black54
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // تاريخ الفتح
              if (achievement.isUnlocked && achievement.unlockedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatDate(achievement.unlockedAt!),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'اليوم';
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} أيام';
    } else if (diff.inDays < 30) {
      return 'منذ ${(diff.inDays / 7).floor()} أسابيع';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// شبكة الإنجازات
class AchievementsGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final Function(Achievement)? onTap;

  const AchievementsGrid({
    super.key,
    required this.achievements,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return AchievementBadge(
          achievement: achievements[index],
          showDetails: true,
          onTap: onTap != null ? () => onTap!(achievements[index]) : null,
        );
      },
    );
  }
}
