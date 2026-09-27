import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/news_model.dart';
import '../data/repositories/news_repository.dart';
import '../data/services/storage_service.dart';

class NewsController extends GetxController {
  final NewsRepository _newsRepo = NewsRepository();
  final StorageService _storageService = Get.find<StorageService>();

  // الحالات التفاعلية
  final RxList<NewsModel> newsList = <NewsModel>[].obs;
  final RxList<NewsModel> breakingNewsList = <NewsModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxBool isOffline = false.obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxString selectedRegion = 'الكل'.obs;

  final ScrollController scrollController = ScrollController();
  int _currentOffset = 0;
  final int _pageSize = 15;

  @override
  void onInit() {
    super.onInit();
    fetchNews(refresh: true);
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && hasMore.value && !isLoading.value) {
        fetchMoreNews();
      }
    }
  }

  /// جلب الأخبار (أولية أو تحديث)
  Future<void> fetchNews({bool refresh = false}) async {
    if (refresh) {
      isLoading.value = true;
      _currentOffset = 0;
      hasMore.value = true;
    }

    try {
      isOffline.value = false;
      final result = await _newsRepo.getNews(
        limit: _pageSize,
        offset: _currentOffset,
        category: selectedCategory.value == 'الكل' ? null : selectedCategory.value,
        region: selectedRegion.value == 'الكل' ? null : selectedRegion.value,
      );

      // تحديث حالة الحفظ
      final enriched = result.map((news) {
        return news.copyWith(isSaved: _storageService.isBookmarked(news.id));
      }).toList();

      if (refresh) {
        newsList.assignAll(enriched);
        breakingNewsList.assignAll(enriched.where((item) => item.importance == 'urgent').take(5).toList());
      } else {
        newsList.addAll(enriched);
      }

      if (result.length < _pageSize) {
        hasMore.value = false;
      }

      _currentOffset += result.length;
    } catch (e) {
      isOffline.value = true;
      final cached = _storageService.getOfflineNews();
      if (cached.isNotEmpty && newsList.isEmpty) {
        newsList.assignAll(cached);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// التحميل اللانهائي
  Future<void> fetchMoreNews() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    try {
      final result = await _newsRepo.getNews(
        limit: _pageSize,
        offset: _currentOffset,
        category: selectedCategory.value == 'الكل' ? null : selectedCategory.value,
        region: selectedRegion.value == 'الكل' ? null : selectedRegion.value,
      );

      if (result.isEmpty || result.length < _pageSize) {
        hasMore.value = false;
      }

      final enriched = result.map((news) {
        return news.copyWith(isSaved: _storageService.isBookmarked(news.id));
      }).toList();

      newsList.addAll(enriched);
      _currentOffset += result.length;
    } catch (_) {
      hasMore.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// تغيير المنطقة
  void setRegion(String region) {
    if (selectedRegion.value != region) {
      selectedRegion.value = region;
      fetchNews(refresh: true);
    }
  }

  /// تغيير التصنيف
  void setCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      fetchNews(refresh: true);
    }
  }

  /// حفظ أو إزالة خبر من المفضلة
  Future<void> toggleSave(NewsModel news) async {
    await _storageService.toggleBookmark(news);
    final index = newsList.indexWhere((item) => item.id == news.id);
    if (index != -1) {
      final updated = newsList[index].copyWith(isSaved: !newsList[index].isSaved);
      newsList[index] = updated;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
