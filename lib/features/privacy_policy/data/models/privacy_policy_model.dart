class PrivacyPolicyModel {
  final String? status;
  final PrivacyPolicyData? data;

  PrivacyPolicyModel({this.status, this.data});

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      status: json['status'],
      data: json['data'] != null ? PrivacyPolicyData.fromJson(json['data']) : null,
    );
  }
}

class PrivacyPolicyData {
  final String? title;
  final String? appName;
  final String? companyName;
  final String? contactEmail;
  final String? effectiveDate;
  final List<PrivacyPolicySection>? sections;

  PrivacyPolicyData({
    this.title,
    this.appName,
    this.companyName,
    this.contactEmail,
    this.effectiveDate,
    this.sections,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyData(
      title: json['title'],
      appName: json['app_name'],
      companyName: json['company_name'],
      contactEmail: json['contact_email'],
      effectiveDate: json['effective_date'],
      sections: (json['sections'] as List?)
          ?.map((e) => PrivacyPolicySection.fromJson(e))
          .toList(),
    );
  }
}

class PrivacyPolicySection {
  final String? heading;
  final String? content;

  PrivacyPolicySection({this.heading, this.content});

  factory PrivacyPolicySection.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicySection(
      heading: json['heading'],
      content: json['content'],
    );
  }
}
