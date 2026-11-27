class StorageStatsModel {
  final String? status;
  final StorageData? data;

  StorageStatsModel({this.status, this.data});

  factory StorageStatsModel.fromJson(Map<String, dynamic> json) {
    return StorageStatsModel(
      status: json['status'],
      data: json['data'] != null ? StorageData.fromJson(json['data']) : null,
    );
  }
}

class StorageData {
  final num? totalQuotaGb;
  final num? usedGb;
  final num? remainingGb;
  final num? usedPercentage;
  final bool? isLimitReached;
  final StorageBreakdown? breakdown;
  final StorageCounts? counts;

  StorageData({
    this.totalQuotaGb,
    this.usedGb,
    this.remainingGb,
    this.usedPercentage,
    this.isLimitReached,
    this.breakdown,
    this.counts,
  });

  factory StorageData.fromJson(Map<String, dynamic> json) {
    return StorageData(
      totalQuotaGb: json['total_quota_gb'] as num?,
      usedGb: json['used_gb'] as num?,
      remainingGb: json['remaining_gb'] as num?,
      usedPercentage: json['used_percentage'] as num?,
      isLimitReached: json['is_limit_reached'],
      breakdown: json['breakdown'] != null ? StorageBreakdown.fromJson(json['breakdown']) : null,
      counts: json['counts'] != null ? StorageCounts.fromJson(json['counts']) : null,
    );
  }
}

class StorageBreakdown {
  final num? photosGb;
  final num? videosGb;

  StorageBreakdown({this.photosGb, this.videosGb});

  factory StorageBreakdown.fromJson(Map<String, dynamic> json) {
    return StorageBreakdown(
      photosGb: json['photos_gb'] as num?,
      videosGb: json['videos_gb'] as num?,
    );
  }
}

class StorageCounts {
  final int? photosCount;
  final int? videosCount;

  StorageCounts({this.photosCount, this.videosCount});

  factory StorageCounts.fromJson(Map<String, dynamic> json) {
    return StorageCounts(
      photosCount: json['photos_count'],
      videosCount: json['videos_count'],
    );
  }
}
