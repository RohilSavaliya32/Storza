import '../models/storage_stats_model.dart';
import '../services/profile_api_service.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService _apiService;

  ProfileRepositoryImpl(this._apiService);

  @override
  Future<StorageStatsModel> getStorageStats() async {
    return await _apiService.getStorageStats();
  }
}
