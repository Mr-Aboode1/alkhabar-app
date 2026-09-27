import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../controllers/filter_controller.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FilterController());

    final categories = ['الكل', 'سياسي', 'اقتصادي', 'رياضي', 'طقس', 'خدمات', 'صحة', 'تعليم'];
    final regions = ['الكل', 'صنعاء', 'عدن', 'تعز', 'مأرب', 'الحديدة', 'حضرموت', 'إب', 'شبوة'];
    final importances = [
      {'val': 'all', 'label': 'كافة الدرجات'},
      {'val': 'urgent', 'label': 'عاجل فقط'},
      {'val': 'important', 'label': 'مهم'},
      {'val': 'normal', 'label': 'عادي'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.advancedFilter),
        actions: [
          TextButton(
            onPressed: controller.resetFilters,
            child: const Text('إعادة ضبط', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. التصنيف
            const Text('التصنيف الإخباري', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                return Obx(() {
                  final isSelected = controller.selectedCategory.value == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                    onSelected: (val) => controller.setCategory(cat),
                  );
                });
              }).toList(),
            ),

            const SizedBox(height: 24),
            // 2. المحافظة
            const Text('المحافظة والمنطقة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: regions.map((reg) {
                return Obx(() {
                  final isSelected = controller.selectedRegion.value == reg;
                  return ChoiceChip(
                    label: Text(reg),
                    selected: isSelected,
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                    onSelected: (val) => controller.setRegion(reg),
                  );
                });
              }).toList(),
            ),

            const SizedBox(height: 24),
            // 3. درجة الأهمية
            const Text(AppStrings.filterByImportance, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: importances.map((imp) {
                return Obx(() {
                  final isSelected = controller.selectedImportance.value == imp['val'];
                  return ChoiceChip(
                    label: Text(imp['label']!),
                    selected: isSelected,
                    selectedColor: AppColors.danger,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                    onSelected: (val) => controller.setImportance(imp['val']!),
                  );
                });
              }).toList(),
            ),

            const SizedBox(height: 36),
            // زر التطبيق
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: controller.applyFilter,
                child: const Text(AppStrings.applyFilter, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
