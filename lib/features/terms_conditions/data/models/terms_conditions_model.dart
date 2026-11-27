class TermsConditionsModel {
  final String? status;
  final TermsConditionsData? data;

  TermsConditionsModel({this.status, this.data});

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionsModel(
      status: json['status'],
      data: json['data'] != null ? TermsConditionsData.fromJson(json['data']) : null,
    );
  }
}

class TermsConditionsData {
  final String? title;
  final String? appName;
  final String? companyName;
  final String? contactEmail;
  final String? effectiveDate;
  final List<TermsConditionsSection>? sections;

  TermsConditionsData({
    this.title,
    this.appName,
    this.companyName,
    this.contactEmail,
    this.effectiveDate,
    this.sections,
  });

  factory TermsConditionsData.fromJson(Map<String, dynamic> json) {
    return TermsConditionsData(
      title: json['title'],
      appName: json['app_name'],
      companyName: json['company_name'],
      contactEmail: json['contact_email'],
      effectiveDate: json['effective_date'],
      sections: (json['sections'] as List?)
          ?.map((e) => TermsConditionsSection.fromJson(e))
          .toList(),
    );
  }
}

class TermsConditionsSection {
  final String? heading;
  final String? content;

  TermsConditionsSection({this.heading, this.content});

  factory TermsConditionsSection.fromJson(Map<String, dynamic> json) {
    return TermsConditionsSection(
      heading: json['heading'],
      content: json['content'],
    );
  }
}
