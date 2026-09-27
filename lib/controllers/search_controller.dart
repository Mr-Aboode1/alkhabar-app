import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/news_model.dart';
import '../data/repositories/news_repository.dart';
import '../data/services/storage_service.dart';

class AppSearchController extends GetxController {
  final NewsRepository _repo = NewsRepository();
  final StorageService _storageService = Get.find<StorageService>();

  final TextEditingController textController = TextEditingController();
  final RxList<NewsModel> searchResults = <NewsModel>[].obs;
  final RxList<String> searchHistory = <String>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool hasSearched = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    searchHistory.assignAll(_storageService.getSearchHistory());
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;

    isSearching.value = true;
    hasSearched.value = true;
    textController.text = query;

    try {
      await _storageService.addSearchQuery(query);
      loadHistory();
      final results = await _repo.search(query);
      searchResults.assignAll(results);
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    textController.clear();
    searchResults.clear();
    hasSearched.value = false;
  }

  Future<void> clearHistory() async {
    await _storageService.clearSearchHistory();
    searchHistory.clear();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
