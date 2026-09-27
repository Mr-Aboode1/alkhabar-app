import 'package:flutter/material.dart';

/// المقاسات والأبعاد الثابتة للتطبيق لضمان التناسق البصري
class AppSizes {
  // الحواشي والمسافات (Paddings & Spacing)
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;

  // أقطار الحواف (Border Radius)
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusPill = 30.0;

  // ارتفاعات الصور والبطاقات
  static const double newsCardImageHeight = 180.0;
  static const double newsDetailImageHeight = 260.0;
  static const double avatarSize = 40.0;
  static const double buttonHeight = 48.0;

  // فواصل مسافية مسبقة
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h32 = SizedBox(height: 32);

  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w12 = SizedBox(width: 12);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w24 = SizedBox(width: 24);
}
