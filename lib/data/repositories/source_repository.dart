import 'package:get/get.dart';
import '../models/source_model.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';

class SourceRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final StorageService _storageService = Get.find<StorageService>();

  Future<List<SourceModel>> getActiveSources() async {
    try {
      final data = await _supabaseService.fetchActiveSources();
      final followedList = _storageService.getFollowedSources();

      return data.map((json) {
        final model = SourceModel.fromJson(json);
        return model.copyWith(isFollowing: followedList.contains(model.id));
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
