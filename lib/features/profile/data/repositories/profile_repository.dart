import '../models/storage_stats_model.dart';

abstract class ProfileRepository {
  Future<StorageStatsModel> getStorageStats();
}
