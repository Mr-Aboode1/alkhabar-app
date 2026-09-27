import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class Helpers {
  /// مشاركة نص ورابط الخبر عبر التطبيقات أو واتساب
  static Future<void> shareNews({
    required String title,
    required String content,
    String? url,
  }) async {
    final shareText = '''
📰 *الخبر اليقين | مصداقية في لحظة وقوعها*

📌 *$title*

${content.length > 250 ? '${content.substring(0, 250)}...' : content}

🔗 المصدر والتفاصيل الكاملة عبر تطبيق "الخبر اليقين"
${url ?? ''}
''';

    await Share.share(shareText, subject: title);
  }

  /// فتح رابط في المتصفح الخارجي
  static Future<void> launchExternalUrl(String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// الحصول على لون حالة التحقق
  static Color getVerifyStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return AppColors.success;
      case 'urgent':
        return AppColors.danger;
      case 'suspicious':
        return AppColors.danger;
      case 'pending':
      default:
        return AppColors.warning;
    }
  }

  /// النص العربي لحالة التحقق
  static String getVerifyStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'مؤكد وموثوق';
      case 'suspicious':
        return 'غير مؤكد / مشبوه';
      case 'pending':
      default:
        return 'قيد التحقق';
    }
  }
}
