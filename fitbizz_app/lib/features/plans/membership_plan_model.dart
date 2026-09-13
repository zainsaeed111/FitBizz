class MembershipPlan {
  final String id;
  String name;
  int durationMonths; // 1 = Monthly, 3 = Quarterly, 6 = Semi-Annual, 12 = Yearly
  double admissionFee;
  double monthlyFee;
  double additionalCharges;
  bool hasTrainerSupport;
  String? trainerSupportNote;
  bool hasMealPlan;
  bool hasMobileApp;
  bool hasLockerAccess;
  bool isMultiBranch;
  String badge;
  bool isDefault;

  MembershipPlan({
    required this.id,
    required this.name,
    this.durationMonths = 1,
    required this.admissionFee,
    required this.monthlyFee,
    this.additionalCharges = 0.0,
    this.hasTrainerSupport = false,
    this.trainerSupportNote,
    this.hasMealPlan = false,
    this.hasMobileApp = true,
    this.hasLockerAccess = true,
    this.isMultiBranch = false,
    this.badge = 'Active',
    this.isDefault = false,
  });

  /// Total upfront fee payable during enrollment
  double get totalEnrollmentFee => admissionFee + (monthlyFee * durationMonths) + additionalCharges;

  /// Recurring renewal fee
  double get renewalFee => (monthlyFee * durationMonths) + additionalCharges;

  String get durationLabel {
    switch (durationMonths) {
      case 3:
        return 'Quarterly (3 Months)';
      case 6:
        return 'Semi-Annual (6 Months)';
      case 12:
        return 'Yearly (12 Months)';
      default:
        return 'Monthly (1 Month)';
    }
  }

  MembershipPlan copyWith({
    String? id,
    String? name,
    int? durationMonths,
    double? admissionFee,
    double? monthlyFee,
    double? additionalCharges,
    bool? hasTrainerSupport,
    String? trainerSupportNote,
    bool? hasMealPlan,
    bool? hasMobileApp,
    bool? hasLockerAccess,
    bool? isMultiBranch,
    String? badge,
    bool? isDefault,
  }) {
    return MembershipPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMonths: durationMonths ?? this.durationMonths,
      admissionFee: admissionFee ?? this.admissionFee,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      additionalCharges: additionalCharges ?? this.additionalCharges,
      hasTrainerSupport: hasTrainerSupport ?? this.hasTrainerSupport,
      trainerSupportNote: trainerSupportNote ?? this.trainerSupportNote,
      hasMealPlan: hasMealPlan ?? this.hasMealPlan,
      hasMobileApp: hasMobileApp ?? this.hasMobileApp,
      hasLockerAccess: hasLockerAccess ?? this.hasLockerAccess,
      isMultiBranch: isMultiBranch ?? this.isMultiBranch,
      badge: badge ?? this.badge,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
