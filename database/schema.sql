-- ============================================
-- قاعدة بيانات تطبيق تعليم الأطفال العراقيين
-- Database Schema for Iraqi Children Education App
-- Version: 1.0
-- Date: 19 March 2026
-- ============================================

-- إنشاء قاعدة البيانات
CREATE DATABASE IF NOT EXISTS education_app_iraq
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE education_app_iraq;

-- ============================================
-- 1. جدول الأطفال (Children/Users)
-- ============================================
CREATE TABLE children (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(255) UNIQUE NOT NULL COMMENT 'Device unique identifier',
    name VARCHAR(100) NOT NULL COMMENT 'اسم الطفل',
    age TINYINT UNSIGNED COMMENT 'العمر (6-9)',
    avatar VARCHAR(50) DEFAULT 'default' COMMENT 'Avatar name',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_premium BOOLEAN DEFAULT FALSE COMMENT 'هل مشترك؟',
    premium_expires_at TIMESTAMP NULL COMMENT 'انتهاء الاشتراك',
    INDEX idx_device_id (device_id),
    INDEX idx_last_active (last_active_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. جدول المسارات التعليمية (Tracks)
-- ============================================
CREATE TABLE tracks (
    id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name_ar VARCHAR(100) NOT NULL COMMENT 'اسم المسار بالعربي',
    name_en VARCHAR(100) NOT NULL COMMENT 'Track name in English',
    description TEXT COMMENT 'الوصف',
    icon VARCHAR(50) COMMENT 'اسم الأيقونة',
    color VARCHAR(7) DEFAULT '#4A90E2' COMMENT 'لون المسار (hex)',
    display_order TINYINT UNSIGNED NOT NULL COMMENT 'ترتيب العرض',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- إدخال المسارات الثلاثة
INSERT INTO tracks (id, name_ar, name_en, icon, color, display_order) VALUES
(1, 'اللغة العربية', 'Arabic Language', 'book', '#4A90E2', 1),
(2, 'الرياضيات', 'Mathematics', 'calculator', '#7ED321', 2),
(3, 'العلوم والحياة', 'Science & Life', 'flask', '#F5A623', 3);

-- ============================================
-- 3. جدول الدروس (Lessons)
-- ============================================
CREATE TABLE lessons (
    id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    track_id TINYINT UNSIGNED NOT NULL,
    lesson_number TINYINT UNSIGNED NOT NULL COMMENT 'رقم الدرس داخل المسار (1-10)',
    title_ar VARCHAR(200) NOT NULL COMMENT 'عنوان الدرس',
    title_en VARCHAR(200) NOT NULL,
    description TEXT COMMENT 'وصف قصير',
    duration_seconds SMALLINT UNSIGNED DEFAULT 360 COMMENT 'المدة المتوقعة (ثواني)',
    
    -- المحتوى (JSON أو مرجع لملفات)
    content_json JSON COMMENT 'بيانات المحتوى التفاعلي',
    
    -- الملفات
    audio_file VARCHAR(255) COMMENT 'ملف الصوت الرئيسي',
    video_file VARCHAR(255) COMMENT 'فيديو (اختياري)',
    
    -- الأسئلة
    questions_json JSON COMMENT 'أسئلة الاختبار (5 أسئلة)',
    
    -- متطلبات
    is_free BOOLEAN DEFAULT TRUE COMMENT 'هل مجاني؟',
    requires_lesson_id SMALLINT UNSIGNED NULL COMMENT 'يتطلب إكمال درس سابق',
    
    display_order SMALLINT UNSIGNED NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE,
    FOREIGN KEY (requires_lesson_id) REFERENCES lessons(id) ON DELETE SET NULL,
    UNIQUE KEY unique_track_lesson (track_id, lesson_number),
    INDEX idx_track_order (track_id, display_order),
    INDEX idx_free (is_free)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- إدخال الدروس (30 درس)
-- المسار 1: اللغة العربية (10 دروس)
INSERT INTO lessons (track_id, lesson_number, title_ar, title_en, is_free, display_order) VALUES
(1, 1, 'الحروف ونطقها الصحيح', 'Letters and Pronunciation', TRUE, 1),
(1, 2, 'تكوين كلمات من 3 حروف', 'Forming 3-Letter Words', TRUE, 2),
(1, 3, 'قراءة جمل بسيطة', 'Reading Simple Sentences', TRUE, 3),
(1, 4, 'الحركات (فتحة، ضمة، كسرة)', 'Vowel Marks', FALSE, 4),
(1, 5, 'المد (بالألف، الواو، الياء)', 'Long Vowels', FALSE, 5),
(1, 6, 'أل التعريف', 'Definite Article (Al)', FALSE, 6),
(1, 7, 'المفرد والجمع', 'Singular and Plural', FALSE, 7),
(1, 8, 'الضمائر (أنا، أنت، هو، هي)', 'Pronouns', FALSE, 8),
(1, 9, 'كلمات متضادة', 'Opposites', FALSE, 9),
(1, 10, 'قصة قصيرة تفاعلية', 'Interactive Short Story', FALSE, 10);

-- المسار 2: الرياضيات (10 دروس)
INSERT INTO lessons (track_id, lesson_number, title_ar, title_en, is_free, display_order) VALUES
(2, 1, 'الأرقام 1-20', 'Numbers 1-20', TRUE, 11),
(2, 2, 'العد التصاعدي والتنازلي', 'Counting Up and Down', TRUE, 12),
(2, 3, 'المقارنة (أكبر/أصغر/يساوي)', 'Comparison', TRUE, 13),
(2, 4, 'الجمع حتى 20', 'Addition up to 20', FALSE, 14),
(2, 5, 'الطرح حتى 20', 'Subtraction up to 20', FALSE, 15),
(2, 6, 'الأشكال الهندسية', 'Geometric Shapes', FALSE, 16),
(2, 7, 'الألوان والحجم', 'Colors and Sizes', FALSE, 17),
(2, 8, 'النقود البسيطة', 'Simple Currency', FALSE, 18),
(2, 9, 'الوقت (الساعة الكاملة)', 'Time (Full Hours)', FALSE, 19),
(2, 10, 'تحدي رياضيات (لعبة)', 'Math Challenge Game', FALSE, 20);

-- المسار 3: العلوم والحياة (10 دروس)
INSERT INTO lessons (track_id, lesson_number, title_ar, title_en, is_free, display_order) VALUES
(3, 1, 'أعضاء الجسم ووظائفها', 'Body Parts and Functions', TRUE, 21),
(3, 2, 'الطعام الصحي وغير الصحي', 'Healthy vs Unhealthy Food', TRUE, 22),
(3, 3, 'النظافة الشخصية', 'Personal Hygiene', TRUE, 23),
(3, 4, 'الفصول الأربعة', 'Four Seasons', FALSE, 24),
(3, 5, 'الحيوانات الأليفة والبرية', 'Domestic and Wild Animals', FALSE, 25),
(3, 6, 'النباتات', 'Plants', FALSE, 26),
(3, 7, 'المهن', 'Professions', FALSE, 27),
(3, 8, 'إشارات المرور والأمان', 'Traffic Signs and Safety', FALSE, 28),
(3, 9, 'العائلة', 'Family', FALSE, 29),
(3, 10, 'أيام الأسبوع والأشهر', 'Days and Months', FALSE, 30);

-- ============================================
-- 4. جدول تقدم الطفل (Child Progress)
-- ============================================
CREATE TABLE child_progress (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    child_id INT UNSIGNED NOT NULL,
    lesson_id SMALLINT UNSIGNED NOT NULL,
    
    -- الحالة
    status ENUM('not_started', 'in_progress', 'completed', 'mastered') DEFAULT 'not_started',
    
    -- الدرجات
    best_score TINYINT UNSIGNED DEFAULT 0 COMMENT 'أفضل درجة (من 5)',
    attempts_count SMALLINT UNSIGNED DEFAULT 0 COMMENT 'عدد المحاولات',
    
    -- الوقت
    total_time_seconds INT UNSIGNED DEFAULT 0 COMMENT 'إجمالي الوقت المستغرق',
    
    -- النجوم
    stars_earned TINYINT UNSIGNED DEFAULT 0 COMMENT 'النجوم المكتسبة (0-3)',
    
    -- التواريخ
    started_at TIMESTAMP NULL COMMENT 'بداية الدرس',
    completed_at TIMESTAMP NULL COMMENT 'تاريخ الإكمال',
    last_attempt_at TIMESTAMP NULL COMMENT 'آخر محاولة',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_child_lesson (child_id, lesson_id),
    INDEX idx_child_status (child_id, status),
    INDEX idx_completed (completed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 5. جدول محاولات الدروس (Lesson Attempts)
-- ============================================
CREATE TABLE lesson_attempts (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    child_id INT UNSIGNED NOT NULL,
    lesson_id SMALLINT UNSIGNED NOT NULL,
    
    -- النتيجة
    score TINYINT UNSIGNED NOT NULL COMMENT 'الدرجة (من 5)',
    correct_answers TINYINT UNSIGNED NOT NULL,
    total_questions TINYINT UNSIGNED NOT NULL DEFAULT 5,
    
    -- الوقت
    duration_seconds SMALLINT UNSIGNED COMMENT 'مدة المحاولة',
    
    -- التفاصيل
    answers_json JSON COMMENT 'إجابات الطفل (تفصيلي)',
    
    -- التاريخ
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    INDEX idx_child_lesson (child_id, lesson_id),
    INDEX idx_attempted (attempted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 6. جدول الإنجازات/الأوسمة (Achievements)
-- ============================================
CREATE TABLE achievements (
    id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL COMMENT 'رمز الإنجاز',
    name_ar VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    description_ar TEXT,
    description_en TEXT,
    icon VARCHAR(50) COMMENT 'اسم الأيقونة',
    
    -- الشروط
    condition_type ENUM('lesson_complete', 'track_complete', 'score_perfect', 'streak', 'total_lessons') NOT NULL,
    condition_value INT COMMENT 'قيمة الشرط',
    
    display_order SMALLINT UNSIGNED,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- إدخال الإنجازات الأساسية
INSERT INTO achievements (code, name_ar, name_en, icon, condition_type, condition_value, display_order) VALUES
('first_lesson', 'أول درس', 'First Lesson', 'star', 'total_lessons', 1, 1),
('arabic_master', 'ماهر اللغة', 'Arabic Master', 'book_gold', 'track_complete', 1, 2),
('math_genius', 'عبقري الرياضيات', 'Math Genius', 'calculator_gold', 'track_complete', 2, 3),
('science_explorer', 'مكتشف العلوم', 'Science Explorer', 'flask_gold', 'track_complete', 3, 4),
('perfect_score', 'الدرجة الكاملة', 'Perfect Score', 'trophy', 'score_perfect', 1, 5),
('10_lessons', 'متعلم نشيط', 'Active Learner', 'flame', 'total_lessons', 10, 6),
('all_complete', 'بطل المعرفة', 'Knowledge Champion', 'crown', 'total_lessons', 30, 7);

-- ============================================
-- 7. جدول إنجازات الطفل (Child Achievements)
-- ============================================
CREATE TABLE child_achievements (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    child_id INT UNSIGNED NOT NULL,
    achievement_id SMALLINT UNSIGNED NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE,
    UNIQUE KEY unique_child_achievement (child_id, achievement_id),
    INDEX idx_child_earned (child_id, earned_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 8. جدول الإحصائيات اليومية (Daily Stats)
-- ============================================
CREATE TABLE daily_stats (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    child_id INT UNSIGNED NOT NULL,
    stat_date DATE NOT NULL,
    
    -- النشاط
    lessons_completed TINYINT UNSIGNED DEFAULT 0,
    lessons_attempted TINYINT UNSIGNED DEFAULT 0,
    total_time_seconds INT UNSIGNED DEFAULT 0,
    
    -- الأداء
    total_score SMALLINT UNSIGNED DEFAULT 0,
    correct_answers SMALLINT UNSIGNED DEFAULT 0,
    total_questions SMALLINT UNSIGNED DEFAULT 0,
    
    -- الإنجازات
    achievements_earned TINYINT UNSIGNED DEFAULT 0,
    stars_earned TINYINT UNSIGNED DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE,
    UNIQUE KEY unique_child_date (child_id, stat_date),
    INDEX idx_date (stat_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 9. جدول الاشتراكات (Subscriptions) - للمستقبل
-- ============================================
CREATE TABLE subscriptions (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    child_id INT UNSIGNED NOT NULL,
    
    -- نوع الاشتراك
    plan_type ENUM('monthly', 'one_time') NOT NULL,
    amount_iqd INT UNSIGNED NOT NULL COMMENT 'المبلغ بالدينار العراقي',
    
    -- التواريخ
    starts_at TIMESTAMP NOT NULL,
    expires_at TIMESTAMP NULL,
    
    -- الحالة
    status ENUM('active', 'expired', 'cancelled') DEFAULT 'active',
    
    -- معلومات الدفع
    payment_method VARCHAR(50) COMMENT 'طريقة الدفع',
    transaction_id VARCHAR(255) COMMENT 'معرّف المعاملة',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cancelled_at TIMESTAMP NULL,
    
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE,
    INDEX idx_child_status (child_id, status),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 10. جدول التحليلات/التتبع (Analytics Events)
-- ============================================
CREATE TABLE analytics_events (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    child_id INT UNSIGNED NULL,
    device_id VARCHAR(255) NOT NULL,
    
    -- نوع الحدث
    event_type VARCHAR(50) NOT NULL COMMENT 'app_open, lesson_start, lesson_complete, etc.',
    event_data JSON COMMENT 'بيانات إضافية',
    
    -- الجلسة
    session_id VARCHAR(36) COMMENT 'UUID للجلسة',
    
    -- معلومات الجهاز
    app_version VARCHAR(20),
    os_version VARCHAR(50),
    device_model VARCHAR(100),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE SET NULL,
    INDEX idx_event_type (event_type, created_at),
    INDEX idx_child_events (child_id, created_at),
    INDEX idx_session (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Views (عروض مفيدة)
-- ============================================

-- عرض: إحصائيات الطفل الشاملة
CREATE VIEW v_child_overview AS
SELECT 
    c.id AS child_id,
    c.name,
    c.age,
    c.is_premium,
    COUNT(DISTINCT cp.lesson_id) AS lessons_completed,
    SUM(cp.stars_earned) AS total_stars,
    COUNT(DISTINCT ca.achievement_id) AS achievements_count,
    MAX(cp.completed_at) AS last_lesson_date
FROM children c
LEFT JOIN child_progress cp ON c.id = cp.child_id AND cp.status = 'completed'
LEFT JOIN child_achievements ca ON c.id = ca.child_id
GROUP BY c.id;

-- عرض: تقدم المسار لكل طفل
CREATE VIEW v_track_progress AS
SELECT 
    c.id AS child_id,
    c.name AS child_name,
    t.id AS track_id,
    t.name_ar AS track_name,
    COUNT(DISTINCT l.id) AS total_lessons,
    COUNT(DISTINCT CASE WHEN cp.status = 'completed' THEN cp.lesson_id END) AS completed_lessons,
    ROUND(
        (COUNT(DISTINCT CASE WHEN cp.status = 'completed' THEN cp.lesson_id END) / COUNT(DISTINCT l.id)) * 100,
        2
    ) AS completion_percentage
FROM children c
CROSS JOIN tracks t
LEFT JOIN lessons l ON t.id = l.track_id AND l.is_active = TRUE
LEFT JOIN child_progress cp ON c.id = cp.child_id AND l.id = cp.lesson_id
GROUP BY c.id, t.id;

-- ============================================
-- Stored Procedures (إجراءات مخزّنة)
-- ============================================

DELIMITER //

-- إجراء: تسجيل محاولة درس وتحديث التقدم
CREATE PROCEDURE record_lesson_attempt(
    IN p_child_id INT UNSIGNED,
    IN p_lesson_id SMALLINT UNSIGNED,
    IN p_score TINYINT UNSIGNED,
    IN p_correct_answers TINYINT UNSIGNED,
    IN p_duration_seconds SMALLINT UNSIGNED,
    IN p_answers_json JSON
)
BEGIN
    DECLARE v_current_best_score TINYINT UNSIGNED DEFAULT 0;
    DECLARE v_stars TINYINT UNSIGNED DEFAULT 0;
    DECLARE v_new_status VARCHAR(20);
    
    -- تسجيل المحاولة
    INSERT INTO lesson_attempts (
        child_id, lesson_id, score, correct_answers, 
        total_questions, duration_seconds, answers_json
    ) VALUES (
        p_child_id, p_lesson_id, p_score, p_correct_answers,
        5, p_duration_seconds, p_answers_json
    );
    
    -- حساب النجوم (5/5=3★, 4/5=2★, 3/5=1★, <3=0★)
    SET v_stars = CASE
        WHEN p_score >= 5 THEN 3
        WHEN p_score >= 4 THEN 2
        WHEN p_score >= 3 THEN 1
        ELSE 0
    END;
    
    -- تحديد الحالة
    SET v_new_status = CASE
        WHEN p_score >= 5 THEN 'mastered'
        WHEN p_score >= 3 THEN 'completed'
        ELSE 'in_progress'
    END;
    
    -- الحصول على أفضل درجة حالية
    SELECT COALESCE(best_score, 0) INTO v_current_best_score
    FROM child_progress
    WHERE child_id = p_child_id AND lesson_id = p_lesson_id;
    
    -- تحديث أو إدخال التقدم
    INSERT INTO child_progress (
        child_id, lesson_id, status, best_score, 
        attempts_count, total_time_seconds, stars_earned,
        started_at, completed_at, last_attempt_at
    ) VALUES (
        p_child_id, p_lesson_id, v_new_status, p_score,
        1, p_duration_seconds, v_stars,
        NOW(), 
        IF(p_score >= 3, NOW(), NULL),
        NOW()
    )
    ON DUPLICATE KEY UPDATE
        status = IF(p_score > best_score, v_new_status, status),
        best_score = GREATEST(best_score, p_score),
        attempts_count = attempts_count + 1,
        total_time_seconds = total_time_seconds + p_duration_seconds,
        stars_earned = IF(p_score > best_score, v_stars, stars_earned),
        completed_at = IF(p_score >= 3 AND completed_at IS NULL, NOW(), completed_at),
        last_attempt_at = NOW();
        
    -- تحديث الإحصائيات اليومية
    INSERT INTO daily_stats (
        child_id, stat_date, lessons_attempted, lessons_completed,
        total_time_seconds, total_score, correct_answers, total_questions,
        stars_earned
    ) VALUES (
        p_child_id, CURDATE(), 1, IF(p_score >= 3, 1, 0),
        p_duration_seconds, p_score, p_correct_answers, 5,
        v_stars
    )
    ON DUPLICATE KEY UPDATE
        lessons_attempted = lessons_attempted + 1,
        lessons_completed = lessons_completed + IF(p_score >= 3, 1, 0),
        total_time_seconds = total_time_seconds + p_duration_seconds,
        total_score = total_score + p_score,
        correct_answers = correct_answers + p_correct_answers,
        total_questions = total_questions + 5,
        stars_earned = stars_earned + v_stars;
END //

-- إجراء: التحقق من الإنجازات وإضافتها
CREATE PROCEDURE check_achievements(IN p_child_id INT UNSIGNED)
BEGIN
    DECLARE v_total_completed INT;
    DECLARE v_track_1_complete BOOLEAN;
    DECLARE v_track_2_complete BOOLEAN;
    DECLARE v_track_3_complete BOOLEAN;
    
    -- عدد الدروس المكتملة
    SELECT COUNT(*) INTO v_total_completed
    FROM child_progress
    WHERE child_id = p_child_id AND status IN ('completed', 'mastered');
    
    -- إنجاز: أول درس
    IF v_total_completed >= 1 THEN
        INSERT IGNORE INTO child_achievements (child_id, achievement_id)
        SELECT p_child_id, id FROM achievements WHERE code = 'first_lesson';
    END IF;
    
    -- إنجاز: 10 دروس
    IF v_total_completed >= 10 THEN
        INSERT IGNORE INTO child_achievements (child_id, achievement_id)
        SELECT p_child_id, id FROM achievements WHERE code = '10_lessons';
    END IF;
    
    -- إنجاز: إكمال جميع الدروس
    IF v_total_completed >= 30 THEN
        INSERT IGNORE INTO child_achievements (child_id, achievement_id)
        SELECT p_child_id, id FROM achievements WHERE code = 'all_complete';
    END IF;
    
    -- (يمكن إضافة المزيد من الشروط)
END //

DELIMITER ;

-- ============================================
-- Sample Queries (استعلامات مثالية)
-- ============================================

-- 1. الحصول على تقدم طفل معين
-- SELECT * FROM v_child_overview WHERE child_id = 1;

-- 2. دروس الطفل (التالي للعب)
-- SELECT l.* 
-- FROM lessons l
-- LEFT JOIN child_progress cp ON l.id = cp.lesson_id AND cp.child_id = 1
-- WHERE (l.is_free = TRUE OR EXISTS(
--     SELECT 1 FROM children WHERE id = 1 AND is_premium = TRUE
-- ))
-- AND (cp.status IS NULL OR cp.status != 'mastered')
-- ORDER BY l.display_order
-- LIMIT 1;

-- 3. لوحة الصدارة (Top 10 أطفال بأكثر نجوم)
-- SELECT c.name, SUM(cp.stars_earned) AS total_stars
-- FROM children c
-- JOIN child_progress cp ON c.id = cp.child_id
-- GROUP BY c.id
-- ORDER BY total_stars DESC
-- LIMIT 10;

-- 4. إحصائيات اليوم لطفل
-- SELECT * FROM daily_stats WHERE child_id = 1 AND stat_date = CURDATE();

-- ============================================
-- النهاية
-- ============================================
