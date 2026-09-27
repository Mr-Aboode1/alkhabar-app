import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

// الاستيرادات الخاصة بمشروعك
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/helpers.dart';
import '../../controllers/news_controller.dart';
import '../../data/models/news_model.dart';

// الودجت الفرعية
import '../widgets/verification_badge.dart';
import 'widgets/sources_list.dart';
import 'widgets/similar_news.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final newsController = Get.find<NewsController>();
    debugPrint('🖼️ [IMAGE URL CHECK]: ${news.imageUrl}');

    // تعريف الألوان الداكنة الموحدة
    const Color darkBgColor = Color(0xFF0F172A); // Slate 900
    const Color cardColor = Color(0xFF1E293B); // Slate 800

    return Scaffold(
      backgroundColor: darkBgColor,
      body: CustomScrollView(
        slivers: [
          // 1. الشريط العلوي المرن مع الصورة وأزرار التفاعل
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: darkBgColor,
            elevation: 0,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black38,
                child: Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 18),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              // زر المشاركة
              _buildAppBarAction(
                icon: Icons.share_rounded,
                onTap: () =>
                    Helpers.shareNews(title: news.title, content: news.content),
              ),
              // زر الحفظ (تفاعلي مع GetX)
              Obx(() {
                final isSaved = newsController.newsList
                        .firstWhereOrNull((item) => item.id == news.id)
                        ?.isSaved ??
                    news.isSaved;
                return _buildAppBarAction(
                  icon: isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  iconColor: isSaved ? AppColors.accent : Colors.white,
                  onTap: () => newsController.toggleSave(news),
                );
              }),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: news.id,
                child: news.imageUrl != null && news.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: news.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: cardColor),
                        errorWidget: (context, url, error) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
          ),

          // 2. محتوى الخبر وجميع العناصر الوظيفية
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شارة التحقق + المنطقة + الوقت النسبي
                  Row(
                    children: [
                      VerificationBadge(
                        status: news.verifyStatus,
                        importance: news.importance,
                      ),
                      const SizedBox(width: 10),
                      _buildSimpleBadge(news.region, const Color(0xFF6366F1)),
                      const Spacer(),
                      Text(
                        DateFormatter.formatTime(
                            news.publishedAt?.toIso8601String()),
                        style: GoogleFonts.cairo(
                            color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // العنوان الرئيسي
                  Text(
                    news.title,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // معلومات النشر والمشاهدات
                  Row(
                    children: [
                      Icon(Icons.calendar_month_rounded,
                          size: 14, color: Colors.white38),
                      const SizedBox(width: 6),
                      Text(
                        DateFormatter.formatFullDate(
                            news.publishedAt?.toIso8601String()),
                        style: GoogleFonts.cairo(
                            color: Colors.white38, fontSize: 11),
                      ),
                      const Spacer(),
                      Icon(Icons.visibility_rounded,
                          size: 14, color: Colors.white38),
                      const SizedBox(width: 4),
                      Text(
                        '${news.viewsCount} مشاهدة',
                        style: GoogleFonts.cairo(
                            color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),

                  Divider(color: Colors.white.withOpacity(0.05), height: 40),

                  // نص المحتوى الكامل
                  Text(
                    news.content,
                    style: GoogleFonts.cairo(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 15,
                      height: 1.9,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // زر المشاركة عبر واتساب (تصميم متناسق)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.share_rounded),
                      label: Text(
                        AppStrings.shareViaWhatsApp,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Helpers.shareNews(
                          title: news.title, content: news.content),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // قائمة المصادر
                  SourcesListWidget(
                    source: news.source,
                    additionalSources: news.additionalSources,
                  ),

                  const SizedBox(height: 35),

                  // أخبار مشابهة
                  SimilarNewsWidget(
                    category: news.category,
                    region: news.region,
                    currentNewsId: news.id,
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ودجت بناء أزرار الـ AppBar الشفافة
  Widget _buildAppBarAction(
      {required IconData icon, required VoidCallback onTap, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CircleAvatar(
        backgroundColor: Colors.black38,
        child: IconButton(
          icon: Icon(icon, color: iconColor ?? Colors.white, size: 20),
          onPressed: onTap,
        ),
      ),
    );
  }

  // ودجت الوسم البسيط للمحافظة
  Widget _buildSimpleBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ودجت يظهر في حال عدم وجود صورة
  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF1E293B),
      child: const Center(
        child: Icon(Icons.newspaper_rounded, color: Colors.white12, size: 80),
      ),
    );
  }
}
