import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../statistics/statistics_screen.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildActionChip(
              icon: Icons.currency_exchange_rounded,
              label: 'صرف صنعاء: \$530 / س 140',
              color: Colors.white,
              onTap: () => Get.to(() => const StatisticsScreen()),
            ),
            const SizedBox(width: 8),
            _buildActionChip(
              icon: Icons.trending_up_rounded,
              label: 'صرف عدن: \$502 / س 1910',
              color: Colors.blue,
              onTap: () => Get.to(() => const StatisticsScreen()),
            ),
            const SizedBox(width: 8),
            _buildActionChip(
              icon: Icons.local_gas_station_rounded,
              label: 'الوقود: 9,500 ر.ي',
              color: Colors.amber.shade800,
              onTap: () => _showFuelDialog(context),
            ),
            const SizedBox(width: 8),
            _buildActionChip(
              icon: Icons.alt_route_rounded,
              label: 'طريق هيجة العبد: سالكة',
              color: Colors.teal,
              onTap: () => _showRoadDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFuelDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('أسعار المشتقات النفطية اليوم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              _buildRateRow('بنزين (صنعاء - 20 لتر)', '9,500 ر.ي'),
              _buildRateRow('بنزين (عدن - 20 لتر)', '28,000 ر.ي'),
              _buildRateRow('ديزل (صنعاء - 20 لتر)', '9,500 ر.ي'),
              _buildRateRow('ديزل (عدن - 20 لتر)', '29,000 ر.ي'),
            ],
          ),
        );
      },
    );
  }

  void _showRoadDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('حالة الطرق والمنافذ الرئيسية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              _buildRateRow('طريق صنعاء - مأرب (صرواح)', 'مفتوحة بحذر'),
              _buildRateRow('طريق تعز - الحوبان (الكمب)', 'مفتوحة للمسافرين'),
              _buildRateRow(
                  'طريق هيجة العبد (تعز - عدن)', 'سالكة لشاحنات وسيارات'),
              _buildRateRow('عقبة ثرة (لودر - مكيراس)', 'مغلقة'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRateRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(val,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
        ],
      ),
    );
  }
}
