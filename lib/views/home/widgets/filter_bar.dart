import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../controllers/news_controller.dart';

class FilterBarWidget extends StatelessWidget {
  const FilterBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final newsController = Get.find<NewsController>();

    final categories = [
      'الكل',
      'عاجل',
      'سياسي',
      'اقتصادي',
      'خدمات',
      'رياضي',
      'طقس'
    ];
    final regions = [
      'الكل',
      'صنعاء',
      'عدن',
      'تعز',
      'مأرب',
      'الحديدة',
      'حضرموت'
    ];

    const Color cardColor = Color(0xFF1E293B); // اللون الداكن الفرعي للكروت

    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(
        children: [
          // 1. تصنيفات الأخبار (اقتصادي، سياسي...)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Obx(() {
                  final isSelected =
                      newsController.selectedCategory.value == cat;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: cardColor,
                      shadowColor: Colors.transparent,
                      checkmarkColor: Colors.white,
                      side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withOpacity(0.05)),
                      labelStyle: GoogleFonts.cairo(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      onSelected: (val) {
                        if (val) newsController.setCategory(cat);
                      },
                    ),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          // 2. الفرز حسب المحافظات
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: regions.length,
              itemBuilder: (context, index) {
                final reg = regions[index];
                return Obx(() {
                  final isSelected = newsController.selectedRegion.value == reg;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      label: Text(reg),
                      selected: isSelected,
                      showCheckmark: false,
                      backgroundColor: cardColor,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.05),
                      ),
                      labelStyle: GoogleFonts.cairo(
                        color: isSelected ? AppColors.primary : Colors.white38,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        newsController.setRegion(reg);
                      },
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
