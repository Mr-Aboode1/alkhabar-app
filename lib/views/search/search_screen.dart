import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../controllers/search_controller.dart';
import '../home/widgets/news_card.dart';
import '../widgets/empty_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppSearchController());

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: controller.clearSearch,
            ),
          ),
          onSubmitted: controller.performSearch,
        ),
      ),
      body: Obx(() {
        if (controller.isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // إذا لم يبحث بعد، اعرض سجل البحث
        if (!controller.hasSearched.value) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('عمليات البحث السابقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton(
                      onPressed: controller.clearHistory,
                      child: const Text('مسح الكل', style: TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.searchHistory.map((query) {
                    return ActionChip(
                      avatar: const Icon(Icons.history_rounded, size: 16),
                      label: Text(query),
                      onPressed: () => controller.performSearch(query),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        // عرض نتائج البحث
        if (controller.searchResults.isEmpty) {
          return const EmptyWidget(
            message: 'لم يتم العثور على أي نتائج مطابقة',
            icon: Icons.search_off_rounded,
          );
        }

        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final news = controller.searchResults[index];
            return NewsCard(news: news);
          },
        );
      }),
    );
  }
}
