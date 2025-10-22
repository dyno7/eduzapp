class Scholarship {
  final String scholarshipName;
  final String eligibility;
  final String benefits;
  final String applicationPortal;

  Scholarship({
    required this.scholarshipName,
    required this.eligibility,
    required this.benefits,
    required this.applicationPortal,
  });

  factory Scholarship.fromMap(Map<String, dynamic> map) {
    return Scholarship(
      scholarshipName: map['scholarship_name'] ?? '',
      eligibility: map['eligibility'] ?? '',
      benefits: map['benefits'] ?? '',
      applicationPortal: map['application_portal'] ?? '',
    );
  }
}