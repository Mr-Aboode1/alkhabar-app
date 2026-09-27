import 'package:get/get.dart';
import '../data/models/source_model.dart';
import '../data/repositories/source_repository.dart';
import '../data/services/storage_service.dart';

class SourceController extends GetxController {
  final SourceRepository _repo = SourceRepository();
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<SourceModel> sources = <SourceModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSources();
  }

  Future<void> loadSources() async {
    isLoading.value = true;
    try {
      final result = await _repo.getActiveSources();
      sources.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFollow(String sourceId) async {
    await _storageService.toggleFollowSource(sourceId);
    final index = sources.indexWhere((s) => s.id == sourceId);
    if (index != -1) {
      sources[index] = sources[index].copyWith(isFollowing: !sources[index].isFollowing);
    }
  }
}
