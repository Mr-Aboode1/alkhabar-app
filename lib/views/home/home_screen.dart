import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../controllers/news_controller.dart';
import '../search/search_screen.dart';
import '../filter/filter_screen.dart';
import '../sources/sources_screen.dart';
import '../statistics/statistics_screen.dart';
import '../settings/settings_screen.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_widget.dart';
import 'widgets/news_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/filter_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final NewsController newsController = Get.find<NewsController>();

  // ألوان التطبيق الموحدة
  final Color cardColor = const Color(0xFF1E293B);
  final Color darkBgColor = const Color(0xFF0F172A);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBgColor, // الخلفية الموحدة للتطبيق
      appBar: _buildDynamicAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNewsFeed(), // الشاشة رقم 0 (الرئيسية)
          const StatisticsScreen(), // الشاشة رقم 1 (الإحصائيات)
          const SourcesScreen(), // الشاشة رقم 2 (المصادر)
          const SettingsScreen(), // الشاشة رقم 3 (الإعدادات)
        ],
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: darkBgColor,
          elevation: 0,
          indicatorColor: AppColors.primary.withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary, size: 24);
            }
            return const IconThemeData(color: Colors.white38, size: 24);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights_rounded),
              label: 'الإحصائيات',
            ),
            NavigationDestination(
              icon: Icon(Icons.feed_outlined),
              selectedIcon: Icon(Icons.feed_rounded),
              label: 'المصادر',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildDynamicAppBar() {
    if (_currentIndex == 0) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.newspaper_rounded,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white70),
            onPressed: () => Get.to(() => const SearchScreen()),
            tooltip: 'بحث',
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.white70),
            onPressed: () => Get.to(() => const FilterScreen()),
            tooltip: 'فلترة متقدمة',
          ),
        ],
      );
    } else {
      String currentTitle = '';
      if (_currentIndex == 1) currentTitle = 'الإحصائيات الإخبارية';
      if (_currentIndex == 2) currentTitle = 'مصادر الأخبار';
      if (_currentIndex == 3) currentTitle = 'إعدادات التطبيق';

      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          currentTitle,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 19, color: Colors.white),
        ),
      );
    }
  }

  // 💡 يمكنك الآن حذف دالة _buildCurrentTab القديمة لأننا استبدلناها بـ IndexedStack مباشرة في الـ body

  Widget _buildNewsFeed() {
    return RefreshIndicator(
      onRefresh: () => newsController.fetchNews(refresh: true),
      color: AppColors.primary,
      child: CustomScrollView(
        controller: newsController.scrollController,
        slivers: [
          const SliverToBoxAdapter(child: QuickActionsWidget()),
          const SliverToBoxAdapter(child: FilterBarWidget()),
          Obx(() {
            if (newsController.isOffline.value) {
              return SliverToBoxAdapter(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.warning.withOpacity(0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppStrings.noInternet,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }),
          Obx(() {
            if (newsController.isLoading.value) {
              return const SliverToBoxAdapter(child: LoadingWidget());
            }

            if (newsController.newsList.isEmpty) {
              return const SliverToBoxAdapter(
                child: EmptyWidget(
                  message: AppStrings.emptyNews,
                  icon: Icons.newspaper_outlined,
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < newsController.newsList.length) {
                    final item = newsController.newsList[index];
                    return NewsCard(news: item);
                  } else if (newsController.isLoadingMore.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }
                  return const SizedBox.shrink();
                },
                childCount: newsController.newsList.length +
                    (newsController.hasMore.value ? 1 : 0),
              ),
            );
          }),
        ],
      ),
    );
  }
}
