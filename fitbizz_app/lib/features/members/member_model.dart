class MemberModel {
  final String id;
  String memberNumber; // e.g. PULSE-2026-1001
  String fullName;
  String phone;
  String? cnic;
  String dob;
  String photoUrl;
  String planId;
  String planName;
  int durationMonths;
  double admissionFee;
  double monthlyFee;
  double totalFeePaid;
  String paymentMode; // CASH, ONLINE, WALLET
  String? paymentRef;
  double? cashTendered;
  double? changeReturned;
  String status; // ACTIVE, EXPIRED, SUSPENDED, FROZEN
  String joinedDate;
  String expiryDate;
  int checkInCount;

  String feeStatus; // PAID, DUE, OVERDUE, PARTIAL
  double dueAmount;

  // Health & Diet Profile (Optional)
  String gender; // Male, Female, Other
  String? bloodGroup; // A+, B+, O+, AB+, etc.
  double? currentWeightKg;
  double? targetWeightKg;
  String? height; // e.g. 5'10"
  String fitnessGoal; // Muscle Building, Fat Loss, Endurance, General Fitness
  String dietaryPreference; // High Protein, Balanced, Keto, Vegetarian
  String? medicalNotes;
  String? emergencyContactName;
  String? emergencyContactPhone;

  MemberModel({
    required this.id,
    required this.memberNumber,
    required this.fullName,
    required this.phone,
    this.cnic,
    required this.dob,
    required this.photoUrl,
    required this.planId,
    required this.planName,
    this.durationMonths = 1,
    required this.admissionFee,
    required this.monthlyFee,
    required this.totalFeePaid,
    required this.paymentMode,
    this.paymentRef,
    this.cashTendered,
    this.changeReturned,
    this.status = 'ACTIVE',
    this.feeStatus = 'PAID',
    this.dueAmount = 0.0,
    required this.joinedDate,
    required this.expiryDate,
    this.checkInCount = 0,
    this.gender = 'Male',
    this.bloodGroup,
    this.currentWeightKg,
    this.targetWeightKg,
    this.height,
    this.fitnessGoal = 'General Fitness',
    this.dietaryPreference = 'Balanced Nutrition',
    this.medicalNotes,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  String get qrPayload => 'FITBIZZ_PASS:tenant-001:$memberNumber:$phone';

  int get daysUntilExpiry {
    try {
      final exp = DateTime.parse(expiryDate);
      final now = DateTime.now();
      return exp.difference(DateTime(now.year, now.month, now.day)).inDays;
    } catch (_) {
      return 30;
    }
  }

  bool get isDueSoon => daysUntilExpiry <= 7 || feeStatus == 'DUE' || feeStatus == 'OVERDUE' || dueAmount > 0;
  bool get isOverdue => daysUntilExpiry < 0 || feeStatus == 'OVERDUE';

  MemberModel copyWith({
    String? id,
    String? memberNumber,
    String? fullName,
    String? phone,
    String? cnic,
    String? dob,
    String? photoUrl,
    String? planId,
    String? planName,
    int? durationMonths,
    double? admissionFee,
    double? monthlyFee,
    double? totalFeePaid,
    String? paymentMode,
    String? paymentRef,
    double? cashTendered,
    double? changeReturned,
    String? status,
    String? feeStatus,
    double? dueAmount,
    String? joinedDate,
    String? expiryDate,
    int? checkInCount,
    String? gender,
    String? bloodGroup,
    double? currentWeightKg,
    double? targetWeightKg,
    String? height,
    String? fitnessGoal,
    String? dietaryPreference,
    String? medicalNotes,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) {
    return MemberModel(
      id: id ?? this.id,
      memberNumber: memberNumber ?? this.memberNumber,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      dob: dob ?? this.dob,
      photoUrl: photoUrl ?? this.photoUrl,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      durationMonths: durationMonths ?? this.durationMonths,
      admissionFee: admissionFee ?? this.admissionFee,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      totalFeePaid: totalFeePaid ?? this.totalFeePaid,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentRef: paymentRef ?? this.paymentRef,
      cashTendered: cashTendered ?? this.cashTendered,
      changeReturned: changeReturned ?? this.changeReturned,
      status: status ?? this.status,
      feeStatus: feeStatus ?? this.feeStatus,
      dueAmount: dueAmount ?? this.dueAmount,
      joinedDate: joinedDate ?? this.joinedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      checkInCount: checkInCount ?? this.checkInCount,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      height: height ?? this.height,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }
}
