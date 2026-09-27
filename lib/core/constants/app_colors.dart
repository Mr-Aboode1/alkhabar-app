import 'package:flutter/material.dart';

/// لوحة الألوان الرسمية لتطبيق "الخبر اليقين"
class AppColors {
  // الألوان الرئيسية
  static const Color primary = Color(0xFF1A3C6E);      // كحلي يماني داكن ملكي
  static const Color primaryLight = Color(0xFF2E5B9A); // أزرق متوسط
  static const Color primaryDark = Color(0xFF0F2546);  // أزرق شديد الدكنة
  static const Color accent = Color(0xFFD4AF37);       // ذهبي أنيق للتأكيدات

  // حالات التحقق والمصداقية
  static const Color success = Color(0xFF28A745);      // أخضر: خبر مؤكد / موثوق
  static const Color danger = Color(0xFFDC3545);       // أحمر: عاجل / تحذير / غير موثوق
  static const Color warning = Color(0xFFFFC107);      // أصفر: قيد التحقق / تنبيه
  static const Color info = Color(0xFF17A2B8);         // سماوي: معلومات وخدمات

  // درجات الخلفية والنصوص (السمة الفاتحة)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // درجات الخلفية والنصوص (السمة الداكنة)
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);

  // ألوان المنصات
  static const Color telegram = Color(0xFF0088CC);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color website = Color(0xFF4A5568);
  static const Color newsAgency = Color(0xFF805AD5);

  // ألوان الشارات
  static const Color badgeUrgent = Color(0xFFDC3545);
  static const Color badgeVerified = Color(0xFF28A745);
  static const Color badgePending = Color(0xFFFFC107);
}
