class MembershipPlan {
  final String id;
  String name;
  int durationMonths; // 1, 3, 6, 12 or any custom integer
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
      case 1:
        return 'Monthly (1 Month)';
      case 3:
        return 'Quarterly (3 Months)';
      case 6:
        return 'Semi-Annual (6 Months)';
      case 12:
        return 'Yearly (12 Months)';
      default:
        return '$durationMonths Months (Custom Duration)';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationMonths': durationMonths,
      'durationDays': durationMonths * 30,
      'admissionFee': admissionFee,
      'monthlyFee': monthlyFee,
      'additionalCharges': additionalCharges,
      'price': totalEnrollmentFee,
      'currency': 'PKR',
      'hasTrainerSupport': hasTrainerSupport,
      'trainerSupportNote': trainerSupportNote,
      'hasMealPlan': hasMealPlan,
      'hasMobileApp': hasMobileApp,
      'hasLockerAccess': hasLockerAccess,
      'isMultiBranch': isMultiBranch,
      'badge': badge,
      'isDefault': isDefault,
      'status': 'ACTIVE',
    };
  }

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id']?.toString() ?? 'plan_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name']?.toString() ?? 'Custom Plan',
      durationMonths: (json['durationMonths'] as num?)?.toInt() ?? 1,
      admissionFee: (json['admissionFee'] as num?)?.toDouble() ?? 0.0,
      monthlyFee: (json['monthlyFee'] as num?)?.toDouble() ?? 0.0,
      additionalCharges: (json['additionalCharges'] as num?)?.toDouble() ?? 0.0,
      hasTrainerSupport: json['hasTrainerSupport'] == true,
      trainerSupportNote: json['trainerSupportNote']?.toString(),
      hasMealPlan: json['hasMealPlan'] == true,
      hasMobileApp: json['hasMobileApp'] != false,
      hasLockerAccess: json['hasLockerAccess'] != false,
      isMultiBranch: json['isMultiBranch'] == true,
      badge: json['badge']?.toString() ?? 'Active',
      isDefault: json['isDefault'] == true,
    );
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
