class PlanResponseModel {
  final String? status;
  final String? message;
  final List<PlanModel>? data;

  PlanResponseModel({this.status, this.message, this.data});

  factory PlanResponseModel.fromJson(Map<String, dynamic> json) {
    return PlanResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => PlanModel.fromJson(i)).toList()
          : null,
    );
  }
}

class PlanModel {
  final String planId;
  final String? name;
  final String? description;
  final int? storageGb;
  final String? period;
  final int? interval;
  final String? currency;
  final int? amount;
  final String? displayPrice;
  final bool? isPopular;
  final List<String>? features;

  PlanModel({
    required this.planId,
    this.name,
    this.description,
    this.storageGb,
    this.period,
    this.interval,
    this.currency,
    this.amount,
    this.displayPrice,
    this.isPopular,
    this.features,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      planId: (json['plan_id'] ?? json['id'] ?? json['_id'] ?? '').toString(),
      name: json['name'],
      description: json['description'],
      storageGb: json['storage_gb'],
      period: json['period'],
      interval: json['interval'],
      currency: json['currency'],
      amount: json['amount'],
      displayPrice: json['display_price'],
      isPopular: json['is_popular'],
      features: json['features'] != null ? List<String>.from(json['features']) : null,
    );
  }
}
