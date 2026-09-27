import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/source_model.dart';

class SourceBadge extends StatelessWidget {
  final SourceModel source;

  const SourceBadge({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            source.platform == 'telegram' ? Icons.send_rounded : Icons.public_rounded,
            size: 12,
            color: source.platform == 'telegram' ? AppColors.telegram : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            source.name,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
