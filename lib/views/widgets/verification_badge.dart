import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class VerificationBadge extends StatelessWidget {
  final String status;
  final String importance;

  const VerificationBadge({
    super.key,
    required this.status,
    this.importance = 'normal',
  });

  @override
  Widget build(BuildContext context) {
    if (importance == 'urgent') {
      return _buildBadge(
        label: 'عاجل',
        bgColor: AppColors.badgeUrgent,
        icon: Icons.bolt_rounded,
      );
    }

    switch (status.toLowerCase()) {
      case 'verified':
        return _buildBadge(
          label: 'مؤكد',
          bgColor: AppColors.badgeVerified,
          icon: Icons.check_circle_rounded,
        );
      case 'suspicious':
        return _buildBadge(
          label: 'غير مؤكد',
          bgColor: AppColors.danger,
          icon: Icons.warning_amber_rounded,
        );
      case 'pending':
      default:
        return _buildBadge(
          label: 'قيد التحقق',
          bgColor: AppColors.badgePending,
          icon: Icons.hourglass_top_rounded,
        );
    }
  }

  Widget _buildBadge({required String label, required Color bgColor, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
