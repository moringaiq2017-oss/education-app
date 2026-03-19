-- ============================================
-- بيانات تجريبية للاختبار
-- Sample Data for Testing
-- ============================================

USE education_app_iraq;

-- ============================================
-- 1. إضافة أطفال تجريبيين
-- ============================================
INSERT INTO children (device_id, name, age, avatar, is_premium) VALUES
('device_001', 'أحمد', 7, 'boy_1', FALSE),
('device_002', 'فاطمة', 8, 'girl_1', TRUE),
('device_003', 'علي', 6, 'boy_2', FALSE),
('device_004', 'مريم', 9, 'girl_2', TRUE),
('device_005', 'حسن', 7, 'boy_3', FALSE);

-- ============================================
-- 2. تسجيل تقدم تجريبي
-- ============================================

-- أحمد: أكمل 5 دروس من المسار الأول
CALL record_lesson_attempt(1, 1, 5, 5, 240, '{"q1":"correct","q2":"correct","q3":"correct","q4":"correct","q5":"correct"}');
CALL record_lesson_attempt(1, 2, 4, 4, 180, '{"q1":"correct","q2":"correct","q3":"wrong","q4":"correct","q5":"correct"}');
CALL record_lesson_attempt(1, 3, 5, 5, 200, '{"q1":"correct","q2":"correct","q3":"correct","q4":"correct","q5":"correct"}');
CALL record_lesson_attempt(1, 4, 3, 3, 220, '{"q1":"correct","q2":"wrong","q3":"correct","q4":"correct","q5":"wrong"}');
CALL record_lesson_attempt(1, 5, 5, 5, 190, '{"q1":"correct","q2":"correct","q3":"correct","q4":"correct","q5":"correct"}');

-- فاطمة: أكملت 15 درس (ممتازة!)
CALL record_lesson_attempt(2, 1, 5, 5, 230, '{}');
CALL record_lesson_attempt(2, 2, 5, 5, 210, '{}');
CALL record_lesson_attempt(2, 3, 5, 5, 200, '{}');
CALL record_lesson_attempt(2, 4, 5, 5, 215, '{}');
CALL record_lesson_attempt(2, 5, 4, 4, 225, '{}');
CALL record_lesson_attempt(2, 6, 5, 5, 195, '{}');
CALL record_lesson_attempt(2, 7, 5, 5, 180, '{}');
CALL record_lesson_attempt(2, 8, 5, 5, 210, '{}');
CALL record_lesson_attempt(2, 9, 4, 4, 220, '{}');
CALL record_lesson_attempt(2, 10, 5, 5, 240, '{}');
CALL record_lesson_attempt(2, 11, 5, 5, 200, '{}');
CALL record_lesson_attempt(2, 12, 5, 5, 190, '{}');
CALL record_lesson_attempt(2, 13, 4, 4, 210, '{}');
CALL record_lesson_attempt(2, 14, 5, 5, 205, '{}');
CALL record_lesson_attempt(2, 15, 5, 5, 195, '{}');

-- علي: بدأ للتو (درس واحد فقط)
CALL record_lesson_attempt(3, 1, 3, 3, 300, '{"q1":"correct","q2":"correct","q3":"wrong","q4":"correct","q5":"wrong"}');

-- مريم: أكملت المسار الأول بالكامل (10 دروس)
CALL record_lesson_attempt(4, 1, 5, 5, 220, '{}');
CALL record_lesson_attempt(4, 2, 5, 5, 200, '{}');
CALL record_lesson_attempt(4, 3, 5, 5, 210, '{}');
CALL record_lesson_attempt(4, 4, 5, 5, 215, '{}');
CALL record_lesson_attempt(4, 5, 5, 5, 190, '{}');
CALL record_lesson_attempt(4, 6, 4, 4, 225, '{}');
CALL record_lesson_attempt(4, 7, 5, 5, 205, '{}');
CALL record_lesson_attempt(4, 8, 5, 5, 195, '{}');
CALL record_lesson_attempt(4, 9, 5, 5, 210, '{}');
CALL record_lesson_attempt(4, 10, 5, 5, 230, '{}');

-- حسن: محاولتان فاشلتان ثم نجح
CALL record_lesson_attempt(5, 1, 2, 2, 250, '{}');
CALL record_lesson_attempt(5, 1, 2, 2, 280, '{}');
CALL record_lesson_attempt(5, 1, 4, 4, 240, '{}');

-- ============================================
-- 3. التحقق من الإنجازات
-- ============================================
CALL check_achievements(1);
CALL check_achievements(2);
CALL check_achievements(3);
CALL check_achievements(4);
CALL check_achievements(5);

-- ============================================
-- 4. إضافة اشتراك لفاطمة (شهري)
-- ============================================
INSERT INTO subscriptions (child_id, plan_type, amount_iqd, starts_at, expires_at, status, payment_method)
VALUES (
    2, 
    'monthly', 
    2000, 
    NOW(), 
    DATE_ADD(NOW(), INTERVAL 30 DAY),
    'active',
    'zaincash'
);

-- تحديث حالة Premium لفاطمة
UPDATE children 
SET is_premium = TRUE, premium_expires_at = DATE_ADD(NOW(), INTERVAL 30 DAY)
WHERE id = 2;

-- ============================================
-- 5. إضافة أحداث تحليلات تجريبية
-- ============================================
INSERT INTO analytics_events (child_id, device_id, event_type, event_data, session_id, app_version, os_version, device_model)
VALUES
(1, 'device_001', 'app_open', '{}', UUID(), '1.0.0', 'Android 12', 'Samsung Galaxy A52'),
(1, 'device_001', 'lesson_start', '{"lesson_id": 1}', UUID(), '1.0.0', 'Android 12', 'Samsung Galaxy A52'),
(1, 'device_001', 'lesson_complete', '{"lesson_id": 1, "score": 5}', UUID(), '1.0.0', 'Android 12', 'Samsung Galaxy A52'),
(2, 'device_002', 'app_open', '{}', UUID(), '1.0.0', 'iOS 16', 'iPhone 13'),
(2, 'device_002', 'lesson_start', '{"lesson_id": 1}', UUID(), '1.0.0', 'iOS 16', 'iPhone 13');

-- ============================================
-- استعلامات تحقق
-- ============================================

-- عرض جميع الأطفال مع تقدمهم
SELECT * FROM v_child_overview;

-- عرض تقدم المسارات
SELECT * FROM v_track_progress WHERE child_id = 1;

-- لوحة الصدارة
SELECT c.name, SUM(cp.stars_earned) AS total_stars
FROM children c
JOIN child_progress cp ON c.id = cp.child_id
GROUP BY c.id
ORDER BY total_stars DESC;

-- إحصائيات اليوم
SELECT c.name, ds.*
FROM daily_stats ds
JOIN children c ON ds.child_id = c.id
WHERE ds.stat_date = CURDATE();
