import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/news_model.dart';
import '../../news_detail/news_detail_screen.dart';
import '../../widgets/verification_badge.dart';
import '../../widgets/source_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;
  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF1E293B); // Slate 800

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // ✅ عند النقر على المنشور: الانتقال إلى صفحة تفاصيل الخبر وتمرير البيانات الحالية
        onTap: () => Get.to(() => NewsDetailScreen(news: news)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. عرض صورة المنشور الحقيقية بشكل دائري الأطراف
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: news.imageUrl != null && news.imageUrl!.trim().isNotEmpty
                    ? Image.network(
                        news.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        // مؤشر تحميل أثناء تنزيل الصورة
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.white.withOpacity(0.05),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        },
                        // واجهة بديلة في حال فشل تحميل الصورة أو كان الرابط غير صالح
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(), // واجهة بديلة في حال عدم وجود صورة بالأساس
              ),
              const SizedBox(width: 14),

              // 2. تفاصيل النص (العنوان، الملخص، والمنطقة)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان الرئيسي
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // ملخص أو مقتطف من المحتوى
                    Text(
                      news.summary ?? news.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // وسم المدينة أو المحافظة والتصنيف أسفل الكرت
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            news.region,
                            style: GoogleFonts.cairo(
                              color: const Color(0xFF818CF8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          news.category,
                          style: GoogleFonts.cairo(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ودجتPlaceholder يظهر عندما لا يحتوي الخبر على صورة لمنع ظهور مساحات بيضاء أو أخطاء كراش
  Widget _buildImagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.white.withOpacity(0.05),
      child: const Icon(
        Icons.newspaper_rounded,
        color: Colors.white24,
        size: 32,
      ),
    );
  }
}
