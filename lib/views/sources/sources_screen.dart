import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../controllers/source_controller.dart';
import '../widgets/loading_widget.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SourceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.activeSources),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.sources.isEmpty) {
          return const Center(child: Text('لا توجد مصادر مضافة حالياً'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.sources.length,
          itemBuilder: (context, index) {
            final source = controller.sources[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: source.platform == 'telegram'
                            ? AppColors.telegram.withOpacity(0.12)
                            : AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        source.platform == 'telegram'
                            ? Icons.send_rounded
                            : Icons.public_rounded,
                        color: source.platform == 'telegram'
                            ? AppColors.telegram
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            source.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                source.category,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: source.reliability >= 80
                                      ? AppColors.success.withOpacity(0.15)
                                      : AppColors.warning.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'موثوقية ${source.reliability}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: source.reliability >= 80
                                        ? AppColors.success
                                        : Colors.amber.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: source.isFollowing
                            ? AppColors.primary
                            : Colors.transparent,
                        foregroundColor: source.isFollowing
                            ? Colors.white
                            : AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => controller.toggleFollow(source.id),
                      child: Text(
                        source.isFollowing
                            ? AppStrings.followingSource
                            : AppStrings.followSource,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
