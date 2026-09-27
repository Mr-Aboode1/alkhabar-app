import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/source_model.dart';

class SourcesListWidget extends StatelessWidget {
  final SourceModel? source;
  final List<SourceModel>? additionalSources;

  const SourcesListWidget({super.key, this.source, this.additionalSources});

  @override
  Widget build(BuildContext context) {
    if (source == null && (additionalSources == null || additionalSources!.isEmpty)) {
      return const SizedBox.shrink();
    }

    final allSources = [
      if (source != null) source!,
      if (additionalSources != null) ...additionalSources!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.publishingSources,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...allSources.map((s) => _buildSourceItem(s)),
      ],
    );
  }

  Widget _buildSourceItem(SourceModel s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            s.platform == 'telegram' ? Icons.send_rounded : Icons.public_rounded,
            color: s.platform == 'telegram' ? AppColors.telegram : AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(s.category, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: s.reliability >= 80 ? AppColors.success.withOpacity(0.15) : AppColors.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'موثوقية ${s.reliability}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: s.reliability >= 80 ? AppColors.success : Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
