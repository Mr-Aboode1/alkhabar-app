import 'package:get/get.dart';
import 'news_controller.dart';

class FilterController extends GetxController {
  final RxString selectedCategory = 'الكل'.obs;
  final RxString selectedRegion = 'الكل'.obs;
  final RxString selectedImportance = 'all'.obs;
  final RxString selectedVerifyStatus = 'all'.obs;
  final RxString selectedTimePeriod = 'all'.obs;
  final RxList<String> selectedSourceIds = <String>[].obs;

  void setCategory(String val) => selectedCategory.value = val;
  void setRegion(String val) => selectedRegion.value = val;
  void setImportance(String val) => selectedImportance.value = val;
  void setVerifyStatus(String val) => selectedVerifyStatus.value = val;
  void setTimePeriod(String val) => selectedTimePeriod.value = val;

  void toggleSource(String sourceId) {
    if (selectedSourceIds.contains(sourceId)) {
      selectedSourceIds.remove(sourceId);
    } else {
      selectedSourceIds.add(sourceId);
    }
  }

  void resetFilters() {
    selectedCategory.value = 'الكل';
    selectedRegion.value = 'الكل';
    selectedImportance.value = 'all';
    selectedVerifyStatus.value = 'all';
    selectedTimePeriod.value = 'all';
    selectedSourceIds.clear();
  }

  void applyFilter() {
    final newsController = Get.find<NewsController>();
    newsController.selectedCategory.value = selectedCategory.value;
    newsController.selectedRegion.value = selectedRegion.value;
    newsController.fetchNews(refresh: true);
    Get.back();
  }
}
