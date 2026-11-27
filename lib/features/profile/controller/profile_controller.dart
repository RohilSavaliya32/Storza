import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../data/models/storage_stats_model.dart';
import '../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository;

  ProfileController(this._profileRepository);

  final Rxn<StorageStatsModel> storageStats = Rxn<StorageStatsModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStorageStats();
  }

  Future<void> fetchStorageStats() async {
    try {
      isLoading.value = true;
      final stats = await _profileRepository.getStorageStats();
      storageStats.value = stats;
    } catch (e) {
      // SnackbarUtils.error('Failed to fetch storage stats');
    } finally {
      isLoading.value = false;
    }
  }
}
